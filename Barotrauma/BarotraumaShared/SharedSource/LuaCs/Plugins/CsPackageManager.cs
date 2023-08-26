using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.IO;
using System.Xml.Serialization;
using System.Linq;
using System.Reflection;
using System.Text;
using Barotrauma.Extensions;
using Barotrauma.Steam;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using MonoMod.Utils;

namespace Barotrauma;

public class CsPackageManager : IDisposable
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

    private readonly List<ContentPackage> _currentPackagesByLoadOrder = new();
    private readonly Dictionary<ContentPackage, ImmutableList<ContentPackage>> _packagesDependencies = new();
    private readonly Dictionary<ContentPackage, Guid> _loadedCompiledPackageAssemblies = new();
    private readonly Dictionary<Guid, List<IAssemblyPlugin>> _loadedPlugins = new ();
    private readonly Dictionary<ContentPackage, RunConfig> _packageRunConfigs = new();


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
        if (!IsLoaded)
            return;
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
        
        // clear lists after cleaning up
        _packagesDependencies.Clear();
        _loadedCompiledPackageAssemblies.Clear();
        _packageRunConfigs.Clear();
        _loadedPlugins.Clear();
        
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
        if (!TryBuildDependenciesMap(cpToRun, out var packDeps))
        {
            ModUtils.Logging.PrintMessage($"{nameof(CsPackageManager)}: Unable to create reliable dependencies map.");
        }
        _packagesDependencies.AddRange(packDeps);
        _currentPackagesByLoadOrder.Clear();

        // build load order
        if (OrderAndFilterPackagesByDependencies(
                _packagesDependencies,
                out var readyToLoad,
                out var cannotLoadPackages,
                null))
        {
            _currentPackagesByLoadOrder.AddRange(readyToLoad);
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
            _currentPackagesByLoadOrder.AddRange(_packagesDependencies.Select( p=> p.Key));
            ModUtils.Logging.PrintError($"{nameof(CsPackageManager)}: Unable to create a reliable load order. Defaulting to unordered loading!");
        }
        
        // get assemblies' filepaths from packages
        var assembliesToLoad = _currentPackagesByLoadOrder
            .Select(cp => new KeyValuePair<ContentPackage, ImmutableList<string>>(
                cp,
                TryScanPackagesForAssemblies(cp, out var list) ? list : null));

        // get scripts' filepaths from packages
        var scriptsToLoad = _currentPackagesByLoadOrder
            .Select(cp => new KeyValuePair<ContentPackage, ImmutableList<string>>(
                cp,
                TryScanPackageForScripts(cp, out var list) ? list : null));

        // load assemblies


        // compile scripts to assemblies


        // search for plugins


        // begin plugin execution


        bool ShouldRunPackage(ContentPackage package, RunConfig config)
        {
            throw new NotImplementedException();
        }
    }

    #endregion

    #region INTERNALS

    private static bool TryScanPackageForScripts(ContentPackage package, out ImmutableList<string> scriptFilePaths)
    {
        throw new NotImplementedException();
    }

    private static bool TryScanPackagesForAssemblies(ContentPackage package, out ImmutableList<string> assemblyFilePaths)
    {
        throw new NotImplementedException();
    }

    private static RunConfig GetRunConfigForPackage(ContentPackage package)
    {
        throw new NotImplementedException();
    }
    
    
    private static SyntaxTree GetPackageScriptImports() => BaseAssemblyImports;

    private IEnumerable<ContentPackage> BuildPackagesList()
    {
        throw new NotImplementedException();
    }


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

    #endregion
}
