using System;
using System.Collections;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.IO;
using System.Xml.Serialization;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading;
using Barotrauma.Steam;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using MonoMod.Utils;

namespace Barotrauma;

public sealed class CsPackageManager : IDisposable
{
    #region PRIVATE_FUNCDATA

    private static readonly CSharpParseOptions ScriptParseOptions = CSharpParseOptions.Default
        .WithPreprocessorSymbols(new[]
        {
#if SERVER
            "SERVER"
#elif CLIENT
            "CLIENT"
#else
            "UNDEFINED"
#endif
#if DEBUG
            ,"DEBUG"
#endif
        });

#if WINDOWS
    private static readonly string PLATFORM_TARGET = "Windows";
#elif OSX
    private static readonly string PLATFORM_TARGET = "OSX";
#elif LINUX
    private static readonly string PLATFORM_TARGET = "Linux";
#endif

#if CLIENT
    private static readonly string ARCHITECTURE_TARGET = "Client";
#elif SERVER
    private static readonly string ARCHITECTURE_TARGET = "Server";
#endif

    private static readonly CSharpCompilationOptions CompilationOptions = new CSharpCompilationOptions(OutputKind.DynamicallyLinkedLibrary)
        .WithMetadataImportOptions(MetadataImportOptions.All)
#if DEBUG
        .WithOptimizationLevel(OptimizationLevel.Debug)
#else
        .WithOptimizationLevel(OptimizationLevel.Release)
#endif
        .WithAllowUnsafe(true);
    
    private static readonly SyntaxTree BaseAssemblyImports = CSharpSyntaxTree.ParseText(
        new StringBuilder()
            .AppendLine("using System.Reflection;")
            .AppendLine("using Barotrauma;")
            .AppendLine("using Luatrauma;")
            .AppendLine("[assembly: IgnoresAccessChecksTo(\"Barotrauma\")]")
            .AppendLine("[assembly: IgnoresAccessChecksTo(\"DedicatedServer\")]")
            .ToString(),
        ScriptParseOptions);

    private static readonly string SCRIPT_FILE_REGEX = "*.cs";
    private static readonly string ASSEMBLY_FILE_REGEX = "*.dll";

    private readonly float _assemblyUnloadTimeoutSeconds = 10f;
    private readonly List<ContentPackage> _currentPackagesByLoadOrder = new();
    private readonly Dictionary<ContentPackage, ImmutableList<ContentPackage>> _packagesDependencies = new();
    private readonly Dictionary<ContentPackage, Guid> _loadedCompiledPackageAssemblies = new();
    private readonly Dictionary<Guid, List<IAssemblyPlugin>> _loadedPlugins = new ();
    private readonly Dictionary<Guid, ImmutableList<Type>> _pluginTypes = new(); // where Type : IAssemblyPlugin
    private readonly Dictionary<ContentPackage, RunConfig> _packageRunConfigs = new();
    private readonly AssemblyManager _assemblyManager;
    private bool _pluginsLoaded = false;
    private DateTime _assemblyUnloadStartTime;


    #endregion

    #region PUBLIC_API
    
    public bool IsLoaded { get; private set; }
    public IEnumerable<ContentPackage> GetCurrentPackagesByLoadOrder() => _currentPackagesByLoadOrder;

    /// <summary>
    /// Called when clean up is being performed. Use when relying on or making use of references from this manager.
    /// </summary>
    public event Action OnDispose; 

    public void Dispose()
    {
        // send events for cleanup
        OnDispose?.Invoke();
        // cleanup events
        if (OnDispose is not null)
        {
            foreach (Delegate del in OnDispose.GetInvocationList())
            {
                OnDispose -= (del as System.Action);
            }
        }
        
        // cleanup plugins and assemblies
        UnloadPlugins();

        // try cleaning up the assemblies
        _pluginTypes.Clear();   // remove assembly references
        _loadedPlugins.Clear();

        _assemblyUnloadStartTime = DateTime.Now;
        // we can't wait forever or app dies but we can try to be graceful
        while (!_assemblyManager.TryBeginDispose())
        {
            if (_assemblyUnloadStartTime.AddSeconds(_assemblyUnloadTimeoutSeconds) > DateTime.Now)
            {
                break;
            }
        }
        
        _assemblyUnloadStartTime = DateTime.Now;
        while (!_assemblyManager.FinalizeDispose())
        {
            if (_assemblyUnloadStartTime.AddSeconds(_assemblyUnloadTimeoutSeconds) > DateTime.Now)
            {
                break;
            }
        }


        // clear lists after cleaning up
        _packagesDependencies.Clear();
        _loadedCompiledPackageAssemblies.Clear();
        _packageRunConfigs.Clear();
        _currentPackagesByLoadOrder.Clear();

        IsLoaded = false;
        throw new NotImplementedException();
    }

    public AssemblyLoadingSuccessState BeginPackageLoading()
    {
        if (IsLoaded)
        {
            LuaCsLogger.LogError($"{nameof(CsPackageManager)}::{nameof(BeginPackageLoading)}() | Attempted to load packages when already loaded!");
            return AssemblyLoadingSuccessState.AlreadyLoaded;
        }
        
        _assemblyManager.OnAssemblyLoaded += AssemblyManagerOnAssemblyLoaded;
        _assemblyManager.OnAssemblyUnloading += AssemblyManagerOnAssemblyUnloading;

        // get packages
        IEnumerable<ContentPackage> packages = BuildPackagesList();

        // check and load config
        _packageRunConfigs.AddRange(packages
            .Select(p => new KeyValuePair<ContentPackage, RunConfig>(p, GetRunConfigForPackage(p)))
            .ToDictionary(p => p.Key, p=> p.Value));

        // filter not to be loaded
        var cpToRun = _packageRunConfigs
            .Where(kvp => ShouldRunPackage(kvp.Key, kvp.Value))
            .Select(kvp => kvp.Key)
            .ToImmutableList();

        // build dependencies map
        bool reliableMap = TryBuildDependenciesMap(cpToRun, out var packDeps);
        if (!reliableMap)
        {
            ModUtils.Logging.PrintMessage($"{nameof(CsPackageManager)}: Unable to create reliable dependencies map.");
        }
        _packagesDependencies.AddRange(packDeps);

        List<ContentPackage> packagesToLoadInOrder = new();

        // build load order
        if (reliableMap && OrderAndFilterPackagesByDependencies(
                _packagesDependencies,
                out var readyToLoad,
                out var cannotLoadPackages,
                null))
        {
            packagesToLoadInOrder.AddRange(readyToLoad);
            if (cannotLoadPackages is not null)
            {
                ModUtils.Logging.PrintError($"{nameof(CsPackageManager)}: Unable to load the following mods due to dependency errors:");
                foreach (var pair in cannotLoadPackages)
                {
                    ModUtils.Logging.PrintError($"Package: {pair.Key.Name} | Reason: {pair.Value}");
                }
            }
        }
        else
        {
            // use unsorted list on failure and send error message.
            packagesToLoadInOrder.AddRange(_packagesDependencies.Select( p=> p.Key));
            ModUtils.Logging.PrintError($"{nameof(CsPackageManager)}: Unable to create a reliable load order. Defaulting to unordered loading!");
        }
        
        // get assemblies and scripts' filepaths from packages
        var toLoad = packagesToLoadInOrder
            .Select(cp => new KeyValuePair<ContentPackage, LoadableData>(
                cp,
                new LoadableData(
                    TryScanPackagesForAssemblies(cp, out var list1) ? list1 : null,
                    TryScanPackageForScripts(cp, out var list2) ? list2 : null)))
            .ToImmutableDictionary();
        
        HashSet<ContentPackage> badPackages = new();
        foreach (var pair in toLoad)
        {
            // check if unloadable
            if (badPackages.Contains(pair.Key))
                continue;

            // try load binary assemblies
            var id = Guid.Empty;    // id for the ACL for this package defined by AssemblyManager.
            AssemblyLoadingSuccessState successState = AssemblyLoadingSuccessState.NoAssemblyFound;
            if (pair.Value.AssembliesFilePaths is not null || pair.Value.AssembliesFilePaths.Any())
            {
                successState = _assemblyManager.LoadAssembliesFromLocations(pair.Value.AssembliesFilePaths, ref id);
                // error
                if (successState is not AssemblyLoadingSuccessState.Success)
                {
                    ModUtils.Logging.PrintError($"{nameof(CsPackageManager)}: Unable to load the binary assemblies for package {pair.Key.Name}. Error: {successState.ToString()}");
                    UpdatePackagesToDisable(ref badPackages, pair.Key, _packagesDependencies);
                    continue;
                }
            }
            
            // try compile scripts to assemblies
            if (pair.Value.ScriptsFilePaths is not null && pair.Value.ScriptsFilePaths.Any())
            {
                List<SyntaxTree> syntaxTrees = new();
            
                syntaxTrees.Add(GetPackageScriptImports());
                bool abortPackage = false;
                // load scripts data from files
                foreach (string scriptPath in pair.Value.ScriptsFilePaths)
                {
                    var state = ModUtils.IO.GetOrCreateFileText(scriptPath, out string fileText);
                    // could not load file data
                    if (state is not ModUtils.IO.IOActionResultState.Success)
                    {
                        ModUtils.Logging.PrintError($"{nameof(CsPackageManager)}: Unable to load the script files for package {pair.Key.Name}. Error: {state.ToString()}");
                        UpdatePackagesToDisable(ref badPackages, pair.Key, _packagesDependencies);
                        abortPackage = true;
                        break;
                    }

                    try
                    {
                        CancellationToken token = new();
                        syntaxTrees.Add(SyntaxFactory.ParseSyntaxTree(fileText, ScriptParseOptions, scriptPath, Encoding.Default, token));
                        // cancel if parsing failed
                        if (token.IsCancellationRequested)
                        {
                            ModUtils.Logging.PrintError($"{nameof(CsPackageManager)}: Unable to load the script files for package {pair.Key.Name}. Error: Syntax Parse Error.");
                            UpdatePackagesToDisable(ref badPackages, pair.Key, _packagesDependencies);
                            abortPackage = true;
                            break;
                        }
                    }
                    catch (Exception e)
                    {
                        // unknown error
                        ModUtils.Logging.PrintError($"{nameof(CsPackageManager)}: Unable to load the script files for package {pair.Key.Name}. Error: {e.Message}");
                        UpdatePackagesToDisable(ref badPackages, pair.Key, _packagesDependencies);
                        abortPackage = true;
                        break;
                    }
                
                }
                if (abortPackage)
                    continue;
            
                // try compile
                successState = _assemblyManager.LoadAssemblyFromMemory(
                    pair.Key.Name.Replace(" ",""), 
                    syntaxTrees, 
                    null, 
                    CompilationOptions, 
                    ref id);

                if (successState is not AssemblyLoadingSuccessState.Success)
                {
                    ModUtils.Logging.PrintError($"{nameof(CsPackageManager)}: Unable to compile script assembly for package {pair.Key.Name}. Error: {successState.ToString()}");
                    UpdatePackagesToDisable(ref badPackages, pair.Key, _packagesDependencies);
                    continue;
                }
            }

            // something was loaded, add to index
            if (id != Guid.Empty)
            {
                _loadedCompiledPackageAssemblies.Add(pair.Key, id);
            }
        }

        // update loaded packages to exclude bad packages
        _currentPackagesByLoadOrder.AddRange(toLoad
            .Where(p => !badPackages.Contains(p.Key))
            .Select(p => p.Key));

        // build list of plugins
        foreach (var pair in _loadedCompiledPackageAssemblies)
        {
            if (_assemblyManager.TryGetSubTypesFromACL<IAssemblyPlugin>(pair.Value, out var types))
            {
                _pluginTypes[pair.Value] = types.ToImmutableList();
            }
        }
        
        // instantiate and load
        LoadPlugins(true);


        bool ShouldRunPackage(ContentPackage package, RunConfig config)
        {
            if (config.AutoGenerated)
                return false;
#if CLIENT
            return config.Client.Trim().ToLowerInvariant().Contains("forced")
                   || (config.Client.Trim().ToLowerInvariant().Contains("standard") &&
                       ContentPackageManager.EnabledPackages.All.Contains(package));
#elif SERVER
            return config.Server.Trim().ToLowerInvariant().Contains("forced")
                   || (config.Server.Trim().ToLowerInvariant().Contains("standard") &&
                       ContentPackageManager.EnabledPackages.All.Contains(package));
#endif
        }

        void UpdatePackagesToDisable(ref HashSet<ContentPackage> list, 
            ContentPackage newDisabledPackage, 
            IEnumerable<KeyValuePair<ContentPackage, ImmutableList<ContentPackage>>> dependenciesMap)
        {
            list.Add(newDisabledPackage);
            foreach (var package in dependenciesMap)
            {
                if (package.Value.Contains(newDisabledPackage))
                    list.Add(newDisabledPackage);
            }
        }

        return AssemblyLoadingSuccessState.Success;
    }

    #endregion

    #region INTERNALS
    
    private void AssemblyManagerOnAssemblyUnloading(Assembly assembly)
    {
        ReflectionUtils.RemoveAssemblyFromCache(assembly);
    }

    private void AssemblyManagerOnAssemblyLoaded(Assembly assembly)
    {
        ReflectionUtils.AddNonAbstractAssemblyTypes(assembly);
    }
    
    internal CsPackageManager([NotNull] AssemblyManager assemblyManager)
    {
        this._assemblyManager = assemblyManager;
    }

    private static bool TryScanPackageForScripts(ContentPackage package, out ImmutableList<string> scriptFilePaths)
    {
        string path = System.IO.Path.Combine(package.Path, "CSharp");
        
        if (!Directory.Exists(path))
        {
            scriptFilePaths = ImmutableList<string>.Empty;
            return false;
        }

        scriptFilePaths = System.IO.Directory.GetFiles(System.IO.Path.Combine(path, "Shared"), SCRIPT_FILE_REGEX)
            .Concat(System.IO.Directory.GetFiles(System.IO.Path.Combine(path, ARCHITECTURE_TARGET), SCRIPT_FILE_REGEX))
            .ToImmutableList();
        return scriptFilePaths.Any();
    }

    private static bool TryScanPackagesForAssemblies(ContentPackage package, out ImmutableList<string> assemblyFilePaths)
    {
        string path = System.IO.Path.Combine(package.Path, "bin");
        
        if (!Directory.Exists(path))
        {
            assemblyFilePaths = ImmutableList<string>.Empty;
            return false;
        }

        assemblyFilePaths = System.IO.Directory.GetFiles(System.IO.Path.Combine(path, ARCHITECTURE_TARGET, PLATFORM_TARGET), ASSEMBLY_FILE_REGEX)
            .ToImmutableList();
        return assemblyFilePaths.Any();
    }

    private static RunConfig GetRunConfigForPackage(ContentPackage package)
    {
        if (!ModUtils.IO.GetOrCreateRunConfig(package, out var config))
            config.AutoGenerated = true;
        return config;
    }
    
    private IEnumerable<ContentPackage> BuildPackagesList()
    {
        return ContentPackageManager.AllPackages.Concat(ContentPackageManager.EnabledPackages.All);
    }
    
    private void LoadPlugins(bool force = false)
    {
        if (_pluginsLoaded)
        {
            if (force)
                UnloadPlugins();
            else
            {
                ModUtils.Logging.PrintError($"{nameof(CsPackageManager)}: Attempted to load plugins when they were already loaded!");
                return;
            }
        }
        
        foreach (var pair in _pluginTypes)
        {
            // instantiate
            foreach (Type type in pair.Value)
            {
                if (!_loadedPlugins.ContainsKey(pair.Key))
                    _loadedPlugins.Add(pair.Key, new());
                else if (_loadedPlugins[pair.Key] is null)
                    _loadedPlugins[pair.Key] = new();
                _loadedPlugins[pair.Key].Add((IAssemblyPlugin)Activator.CreateInstance(type));
            }

            // bootstrap
            foreach (var plugin in _loadedPlugins[pair.Key])
            {
                plugin.Initialize();
            }
        }

        // post load
        foreach (var contentPlugins in _loadedPlugins)
        {
            foreach (var plugin in contentPlugins.Value)
            {
                plugin.OnLoadCompleted();
            }
        }

        _pluginsLoaded = true;
    }

    private void UnloadPlugins()
    {
        foreach (var contentPlugins in _loadedPlugins)
        {
            foreach (var plugin in contentPlugins.Value)
            {
                plugin.Dispose();
            }
            contentPlugins.Value.Clear();
        }
        
        _loadedPlugins.Clear();

        _pluginsLoaded = false;
    }
    
    
    
    private static SyntaxTree GetPackageScriptImports() => BaseAssemblyImports;

    


    /// <summary>
    /// Builds a list of ContentPackage dependencies for each of the packages in the list. Note: All dependencies must be included in the provided list of packages.
    /// </summary>
    /// <param name="packages">List of packages to check</param>
    /// <param name="dependenciesMap">Dependencies by package</param>
    /// <returns>True if all dependencies were found.</returns>
    private static bool TryBuildDependenciesMap(ImmutableList<ContentPackage> packages, out Dictionary<ContentPackage, List<ContentPackage>> dependenciesMap)
    {
        bool reliableMap = true;    // all deps were found.
        dependenciesMap = new();
        foreach (var package in packages)
        {
            dependenciesMap.Add(package, new());
            if (ModUtils.IO.GetOrCreateRunConfig(package, out var config))
            {
                if (config.Dependencies is null)
                    continue;
            
                foreach (RunConfig.Dependency dependency in config.Dependencies)
                {
                    ContentPackage dep = packages.FirstOrDefault(p => 
                        (dependency.SteamWorkshopId != 0 && p.TryExtractSteamWorkshopId(out var steamWorkshopId) && steamWorkshopId.Value == dependency.SteamWorkshopId) 
                        || (!dependency.PackageName.IsNullOrWhiteSpace() && p.Name.Contains(dependency.PackageName)), null);

                    if (dep is not null)
                    {
                        dependenciesMap[package].Add(dep);
                    }
                    else
                    {
                        ModUtils.Logging.PrintError($"Warning! The ContentPackage {package.Name} lists a dependency of (STEAMID: {dependency.SteamWorkshopId}, PackageName: {dependency.PackageName}) but it could not be found in the to-be-loaded CSharp packages list!");
                        reliableMap = false;
                    }
                }    
            }
            else
            {
                ModUtils.Logging.PrintMessage($"Warning! Could not retrieve RunConfig for ContentPackage {package.Name}!");
            }
        }
        
        return reliableMap;
    }
    
    /// <summary>
    /// Given a table of packages and dependent packages, will sort them by dependency loading order along with packages
    /// that cannot be loaded due to errors or failing the predicate checks.
    /// </summary>
    /// <param name="packages">A dictionary/map with key as the package and the elements as it's dependencies.</param>
    /// <param name="readyToLoad">List of packages that are ready to load and in the correct order.</param>
    /// <param name="cannotLoadPackages">Packages with errors or cyclic dependencies. Element is error message. Null if empty.</param>
    /// <param name="packageChecksPredicate">Optional: Allows for a custom checks to be performed on each package.
    /// Returns a bool indicating if the package is ready to load.</param>
    /// <returns>Whether or not the process produces a usable list.</returns>
    private static bool OrderAndFilterPackagesByDependencies(
        Dictionary<ContentPackage, ImmutableList<ContentPackage>> packages,
        out IEnumerable<ContentPackage> readyToLoad,
        out IEnumerable<KeyValuePair<ContentPackage, string>> cannotLoadPackages,
        Func<ContentPackage, bool> packageChecksPredicate = null)
    {
        HashSet<ContentPackage> completedPackages = new();
        List<ContentPackage> readyPackages = new();
        Dictionary<ContentPackage, string> unableToLoad = new();
        HashSet<ContentPackage> currentNodeChain = new();

        readyToLoad = readyPackages;

        try
        {
            foreach (var toProcessPack in packages)
            {
                ProcessPackage(toProcessPack.Key, toProcessPack.Value);
            }

            PackageProcRet ProcessPackage(ContentPackage packageToProcess, IEnumerable<ContentPackage> dependencies)
            {
                //cyclic handling
                if (unableToLoad.ContainsKey(packageToProcess))
                {
                    return PackageProcRet.BadPackage;
                }

                // already processed
                if (completedPackages.Contains(packageToProcess))
                {
                    return PackageProcRet.AlreadyCompleted;
                }

                // cyclic check
                if (currentNodeChain.Contains(packageToProcess))
                {
                    StringBuilder sb = new();
                    sb.AppendLine("Error: Cyclic Dependency. ")
                        .Append(
                            "The following ContentPackages rely on eachother in a way that makes it impossible to know which to load first! ")
                        .Append(
                            "Note: the package listed twice shows where the cycle starts/ends and is not necessarily the problematic package.");
                    int i = 0;
                    foreach (var package in currentNodeChain)
                    {
                        i++;
                        sb.AppendLine($"{i}. {package.Name}");
                    }

                    sb.AppendLine($"{i}. {packageToProcess.Name}");
                    unableToLoad.Add(packageToProcess, sb.ToString());
                    completedPackages.Add(packageToProcess);
                    return PackageProcRet.BadPackage;
                }

                if (packageChecksPredicate is not null && !packageChecksPredicate.Invoke(packageToProcess))
                {
                    unableToLoad.Add(packageToProcess, $"Unable to load package {packageToProcess.Name} due to failing checks.");
                    completedPackages.Add(packageToProcess);
                    return PackageProcRet.BadPackage;
                }

                currentNodeChain.Add(packageToProcess);

                foreach (ContentPackage dependency in dependencies)
                {
                    // The mod lists a dependent that was not found during the discovery phase.
                    if (!packages.ContainsKey(dependency))
                    {
                        // search to see if it's enabled
                        if (!ContentPackageManager.EnabledPackages.All.Contains(dependency))
                        {
                            // present warning but allow loading anyways, better to let the user just disable the package if it's really an issue.
                            ModUtils.Logging.PrintError(
                                $"Warning: the ContentPackage of {packageToProcess.Name} requires the Dependency {dependency.Name} but this package wasn't found in the enabled mods list!");
                        }

                        continue;
                    }

                    var ret = ProcessPackage(dependency, packages[dependency]);

                    if (ret is PackageProcRet.BadPackage)
                    {
                        if (!unableToLoad.ContainsKey(packageToProcess))
                        {
                            unableToLoad.Add(packageToProcess, $"Error: Dependency failure. Failed to load {dependency.Name}");
                        }
                        currentNodeChain.Remove(packageToProcess);
                        if (!completedPackages.Contains(packageToProcess))
                        {
                            completedPackages.Add(packageToProcess);
                        }
                        return PackageProcRet.BadPackage;
                    }
                }
                
                currentNodeChain.Remove(packageToProcess);
                completedPackages.Add(packageToProcess);
                readyPackages.Add(packageToProcess); 
                return PackageProcRet.Completed;
            }
        }
        catch (Exception e)
        {
            ModUtils.Logging.PrintError($"Error while generating dependency loading order! Exception: {e.Message}");
#if DEBUG
            ModUtils.Logging.PrintError($"Stack Trace: {e.StackTrace}");
#endif
            cannotLoadPackages = unableToLoad.Any() ? unableToLoad : null;
            return false;
        }
        cannotLoadPackages = unableToLoad.Any() ? unableToLoad : null;
        return true;
    }

    private enum PackageProcRet : byte
    {
        AlreadyCompleted,
        Completed,
        BadPackage
    }

    private record LoadableData(ImmutableList<string> AssembliesFilePaths, ImmutableList<string> ScriptsFilePaths);

    #endregion
}
