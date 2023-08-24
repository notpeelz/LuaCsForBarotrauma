﻿using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.Loader;
using System.Threading;
using Barotrauma;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.Emit;

// ReSharper disable EventNeverSubscribedTo.Global
// ReSharper disable InconsistentNaming

namespace Barotrauma;

/// <summary>
/// Provides functionality for the loading, unloading and management of plugins implementing IAssemblyPlugin.
/// All plugins are loaded into their own AssemblyLoadContext along with their dependencies.
/// WARNING: [BLOCKING] functions perform Write Locks and will cause performance issues when used in parallel.
/// </summary>
public static class AssemblyManager
{
    #region ExternalAPI

    /// <summary>
    /// Called after a plugin has been loaded (OnLoadComplete executed on the plugin). 
    /// </summary>
    public static event Action<IAssemblyPlugin> OnPluginLoaded;

    /// <summary>
    /// Called right before a plugin is about to be unloaded. Use this to cleanup any interop you have with the plugin.
    /// </summary>
    public static event Action<IAssemblyPlugin> OnPluginUnloading; 
    /// <summary>
    /// Called when an assembly is loaded.
    /// </summary>
    public static event Action<Assembly> OnAssemblyLoaded;
    
    /// <summary>
    /// Called when an assembly is marked for unloading, before unloading begins. You should use this to cleanup
    /// any references that you have to this assembly.
    /// </summary>
    public static event Action<Assembly> OnAssemblyUnloading; 
    
    /// <summary>
    /// Called whenever an exception is thrown. First arg is a formatted message, Second arg is the Exception.
    /// </summary>
    public static event Action<string, Exception> OnException;

    /// <summary>
    /// For unloading issue debugging. Called whenever FileAssemblyContextLoader [load context] is unloaded. 
    /// </summary>
    public static event Action<string> OnACLUnload; 
    
    #if DEBUG

    /// <summary>
    /// [DEBUG ONLY]
    /// Returns a list of the current unloading ACLs. 
    /// </summary>
    public static ImmutableList<WeakReference<AssemblyContextLoader>> StillUnloadingACLs
    {
        get
        {
            OpsLockUnloaded.EnterReadLock();
            try
            {
                return UnloadingACLs.ToImmutableList();
            }
            finally
            {
                OpsLockUnloaded.ExitReadLock();
            }
        }
    }

    #endif
    

    // ReSharper disable once MemberCanBePrivate.Global
    /// <summary>
    /// Checks if there are any AssemblyLoadContexts still in the process of unloading.
    /// </summary>
    public static bool IsCurrentlyUnloading
    {
        get
        {
            OpsLockUnloaded.EnterReadLock();
            try
            {
                return UnloadingACLs.Any();
            }
            catch (Exception)
            {
                return false;
            }
            finally
            {
                OpsLockUnloaded.ExitReadLock();
            }
        }
    }

    /// <summary>
    /// Whether or not loaded assemblies have their plugins instantiated.
    /// </summary>
    public static bool PluginsLoaded { get; private set; }

    /// <summary>
    /// [BLOCKING]
    /// Loads an assembly from the given file path and searches it for IAssemblyPlugin classes.
    /// NOTE: if [instancePlugins] is false, all plugins will have to be reloaded for the plugins to be instanced later.
    /// If [PluginsLoaded] is false, no loading will be allowed to take place.
    /// </summary>
    /// <param name="absFilePath">Absolute path to the assembly.</param>
    /// <param name="instancePlugins">Whether or not an IAssemblyPlugin types should be instanced,</param>
    /// <returns>Loading Operation Success Status.</returns>
    public static AssemblyLoadingSuccessState LoadAssembly(string absFilePath, bool instancePlugins = false)
    {
        AssemblyLoadingSuccessState alss = LoadAssembliesAndPluginTypesFromLocation(absFilePath, out var loadedAcl);
        if (alss == AssemblyLoadingSuccessState.Success && PluginsLoaded && instancePlugins)
        {
            if (loadedAcl is null)
                return AssemblyLoadingSuccessState.ACLLoadFailure;
            OpsLockLoaded.EnterWriteLock();
            try
            {
                foreach (Type type in loadedAcl.PluginTypes)
                {
                    IAssemblyPlugin plugin = (IAssemblyPlugin)Activator.CreateInstance(type);
                    if (plugin is null)
                        return AssemblyLoadingSuccessState.PluginInstanceFailure;
                    plugin.Initialize();
                    loadedAcl.LoadedPlugins.Add(plugin);
                }

                foreach (IAssemblyPlugin plugin in loadedAcl.LoadedPlugins)
                {
                    plugin.OnLoadCompleted();
                }
            }
            finally
            {
                OpsLockLoaded.ExitWriteLock();
            }
        }
        return alss;
    }

    /// <summary>
    /// [BLOCKING]
    /// Deactivates the given plugin.
    /// WARNING: The plugin cannot be reloaded with reloading ALL plugins! This is because there isn't any guarantee
    /// that the object instance has been unloaded due to strong references other plugins might have to it.
    /// </summary>
    /// <param name="plugin"></param>
    [MethodImpl(MethodImplOptions.Synchronized | MethodImplOptions.NoInlining)]
    public static void UnloadPlugin(IAssemblyPlugin plugin)
    {
        OpsLockLoaded.EnterWriteLock();
        try
        {
            LoadedACL acl = null;
            foreach (KeyValuePair<string, LoadedACL> loadedAcl in LoadedACLs)
            {
                if (loadedAcl.Value.LoadedPlugins.Contains(plugin))
                {
                    acl = loadedAcl.Value;
                    break;
                }
            }

            plugin.Dispose();
            acl?.LoadedPlugins.Remove(plugin);
        }
        finally
        {
            OpsLockLoaded.ExitWriteLock();
        }
    }
    
    /// <summary>
    /// Allows iteration over all non-interface types in all loaded assemblies in the AsmMgr that are assignable to the given type (IsAssignableFrom).
    /// </summary>
    /// <typeparam name="T">The type to compare against</typeparam>
    /// <returns>An Enumerator for matching types.</returns>
    public static IEnumerable<Type> GetSubTypesInLoadedAssemblies<T>()
    {
        Type targetType = typeof(T);
        
        foreach (var type in typeof(AssemblyManager).Assembly.GetSafeTypes().Where(t => targetType.IsAssignableFrom(t) && !t.IsInterface))   
        {
            yield return type;
        }

        OpsLockLoaded.EnterReadLock();
        try
        {
            foreach (KeyValuePair<string, LoadedACL> loadedAcl in LoadedACLs)
            {
                if (loadedAcl.Value.Acl is not null)
                {
                    foreach (Assembly aclAssembly in loadedAcl.Value.Acl.Assemblies)
                    {
                        foreach (var type in aclAssembly.GetSafeTypes()
                                     .Where(t => targetType.IsAssignableFrom(t) && !t.IsInterface))
                        {
                            yield return type;
                        }
                    }
                }
            }
        }
        finally
        {
            OpsLockLoaded.ExitReadLock();
        }
    }
    
    /// <summary>
    /// Allows iteration over all non-interface types in all loaded assemblies in the AsmMgr who's names contain the string.
    /// </summary>
    /// <param name="name">The string name of the type to search for</param>
    /// <returns>An Enumerator for matching types.</returns>
    public static IEnumerable<Type> GetMatchingTypesInLoadedAssemblies(string name)
    {
        foreach (var type in typeof(AssemblyManager).Assembly.GetSafeTypes().Where(t => t.Name.Equals(name) && !t.IsInterface))   
        {
            yield return type;
        }

        OpsLockLoaded.EnterReadLock();
        try
        {
            foreach (KeyValuePair<string,LoadedACL> loadedAcl in LoadedACLs)
            {
                if (loadedAcl.Value.Acl is not null)
                {
                    foreach (Assembly aclAssembly in loadedAcl.Value.Acl.Assemblies)
                    {
                        foreach (var type in aclAssembly.GetSafeTypes().Where(t => t.Name.Equals(name) && !t.IsInterface))
                        {
                            yield return type;
                        }
                    }
                }
            }
        }
        finally
        {
            OpsLockLoaded.ExitReadLock();
        }
    }

    /// <summary>
    /// Allows iteration over all types (including interfaces) in all loaded assemblies managed by the AsmMgr.
    /// </summary>
    /// <returns>An Enumerator for iteration.</returns>
    public static IEnumerable<Type> GetAllTypesInLoadedAssemblies()
    {
        foreach (var type in typeof(AssemblyManager).Assembly.GetSafeTypes())   
        {
            yield return type;
        }

        OpsLockLoaded.EnterReadLock();
        try
        {
            foreach (KeyValuePair<string,LoadedACL> loadedAcl in LoadedACLs)
            {
                if (loadedAcl.Value.Acl is not null)
                {
                    foreach (Assembly aclAssembly in loadedAcl.Value.Acl.Assemblies)
                    {
                        foreach (var type in aclAssembly.GetSafeTypes())
                        {
                            yield return type;
                        }
                    }
                }
            }
        }
        finally
        {
            OpsLockLoaded.ExitReadLock();
        }
    }

    /// <summary>
    /// Allows iteration over the list of loaded plugins.
    /// </summary>
    /// <returns>Enumerator for a collection of active plugins as Tuple (Plugin Info, Plugin Instance)</returns>
    public static IEnumerable<(PluginInfo, IAssemblyPlugin)> GetActivePlugins()
    {
        OpsLockLoaded.EnterReadLock();
        try
        {
            foreach (KeyValuePair<string,LoadedACL> loadedAcl in LoadedACLs)
            {
                foreach (IAssemblyPlugin plugin in loadedAcl.Value.LoadedPlugins)
                {
                    yield return (plugin.GetPluginInfo(), plugin);
                }
            }
        }
        finally
        {
            OpsLockLoaded.ExitReadLock();
        }
    }
    
    /// <summary>
    /// Gets all types in the given assembly. Handles invalid type scenarios.
    /// </summary>
    /// <param name="assembly">The assembly to scan</param>
    /// <returns>An enumerable collection of types.</returns>
    public static IEnumerable<Type> GetSafeTypes(this Assembly assembly)
    {
        // Based on https://github.com/Qkrisi/ktanemodkit/blob/master/Assets/Scripts/ReflectionHelper.cs#L53-L67

        try
        {
            return assembly.GetTypes();
        }
        catch (ReflectionTypeLoadException re)
        {
            OnException?.Invoke($"AssemblyPatcher::GetSafeType() | Could not load types from reflection.", re);
            try
            {
                return re.Types.Where(x => x != null)!;
            }
            catch (InvalidOperationException ioe)   
            {
                //This will happen if the assemblies are being unloaded while the above line is being executed.
                OnException?.Invoke($"AssemblyPatcher::GetSafeType() | Assembly was modified/unloaded. Cannot continue", ioe);
                return new List<Type>();
            }
        }
        catch (Exception e)
        {
            OnException?.Invoke($"AssemblyPatcher::GetSafeType() | General Exception. See exception obj. details.", e);
            return new List<Type>();
        }
    }

    #endregion

    #region InternalAPI

    internal static AssemblyLoadingSuccessState LoadAssembliesAndPluginTypesFromSources(SyntaxTree sources, string[] dependenciesFilePaths = null)
    {
        throw new NotImplementedException();
    }

    internal static AssemblyLoadingSuccessState LoadAssembliesAndPluginTypesFromMemoryAndLocations(
        IEnumerable<string> filePaths,
        [NotNull] string compiledAssemblyName,
        [NotNull] IEnumerable<SyntaxTree> syntaxTree,
        [NotNull] IEnumerable<MetadataReference> externalMetadataReferences,
        [NotNull] CSharpCompilationOptions compilationOptions,
        out LoadedACL loadedAcl)
    {
        throw new NotImplementedException();
    }

    internal static AssemblyLoadingSuccessState LoadAssembliesAndPluginTypesFromLocation(string filePath,
        out LoadedACL loadedAcl)
    {
        loadedAcl = null;
        string vAssemblyName = Path.GetFileName(filePath);

        OpsLockLoaded.EnterReadLock();
        try
        {
            // Check if the assembly is already loaded in an ACL, most likely due to it being a dependency.
            foreach (var loadedAlc in LoadedACLs)
            {
                if (loadedAlc.Value.Acl is not null)
                {
                    foreach (Assembly ass in loadedAlc.Value.Acl.Assemblies)
                    {
                        if (ass.FullName?.ToLower().Contains(vAssemblyName.ToLower()) ?? false)
                        {
                            return AssemblyLoadingSuccessState.AlreadyLoaded;
                        }
                    }
                }
            }
        }
        finally
        {
            OpsLockLoaded.ExitReadLock();
        }

        OpsLockLoaded.EnterWriteLock();
        try
        {
            try
            {
                FileAssemblyContextLoader acl = new FileAssemblyContextLoader(filePath);
                acl.LoadFromAssemblyName(new AssemblyName(Path.GetFileNameWithoutExtension(filePath)));
                LoadedACL lc = new LoadedACL(
                    filePath,
                    new List<Type>(), //types that impl IAssemblyPlugin  
                    new List<IAssemblyPlugin>(), //loaded plugins from this assembly, none right now
                    acl);

                foreach (Assembly aclAssembly in acl.Assemblies)
                {
                    OnAssemblyLoaded?.Invoke(aclAssembly);
                    var r = GetPluginTypesFromAssembly<IAssemblyPlugin>(aclAssembly);
                    if (r is not null)
                        lc.PluginTypes?.AddRange(r);
                }

                LoadedACLs.Add(filePath, lc);
                loadedAcl = lc;
                return AssemblyLoadingSuccessState.Success;

            }
            catch (ArgumentNullException ane)
            {
                OnException?.Invoke($"AssemblyManager::LoadAssembliesAndPluginTypesFromLocation() | EXCEPTION<ArgNull>.",
                    ane);
                return AssemblyLoadingSuccessState.BadFilePath;
            }
            catch (ArgumentException ae)
            {
                OnException?.Invoke($"AssemblyManager::LoadAssembliesAndPluginTypesFromLocation() | EXCEPTION<Argument>.",
                    ae);
                return AssemblyLoadingSuccessState.BadFilePath;
            }
            catch (FileLoadException fle)
            {
                OnException?.Invoke($"AssemblyManager::LoadAssembliesAndPluginTypesFromLocation() | EXCEPTION<FileLoad>.",
                    fle);
                return AssemblyLoadingSuccessState.CannotLoadFile;
            }
            catch (FileNotFoundException fne)
            {
                OnException?.Invoke(
                    $"AssemblyManager::LoadAssembliesAndPluginTypesFromLocation() | EXCEPTION<FileNotFound>.", fne);
                return AssemblyLoadingSuccessState.NoAssemblyFound;
            }
            catch (BadImageFormatException bfe)
            {
                OnException?.Invoke(
                    $"AssemblyManager::LoadAssembliesAndPluginTypesFromLocation() | EXCEPTION<BadAssemblyFile>.", bfe);
                return AssemblyLoadingSuccessState.InvalidAssembly;
            }
        }
        finally
        {
            OpsLockLoaded.ExitWriteLock();
        }
    }

    [MethodImpl(MethodImplOptions.NoInlining)]
    internal static bool LoadPlugins(out List<PluginInfo> pInfo)
    {
        pInfo = new();

        if (PluginsLoaded)
            UnloadPlugins();
        
        OpsLockLoaded.EnterWriteLock();
        try
        {
            if (IsCurrentlyUnloading)
                return false;

            foreach (var loadedAcl in LoadedACLs)
            {
                foreach (Type type in loadedAcl.Value.PluginTypes)
                {
                    try
                    {
                        IAssemblyPlugin plugin = (IAssemblyPlugin)Activator.CreateInstance(type);
                        if (plugin is not null)
                        {
                            plugin.Initialize();
                            pInfo.Add(plugin.GetPluginInfo());
                            loadedAcl.Value.LoadedPlugins.Add(plugin);
                        }
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e);
                        throw;
                    }
                }

                foreach (IAssemblyPlugin plugin in loadedAcl.Value.LoadedPlugins)
                {
                    plugin.OnLoadCompleted();
                    OnPluginLoaded?.Invoke(plugin);
                }
            }

            PluginsLoaded = true;
        }
        finally
        {
            OpsLockLoaded.ExitWriteLock();
        }

        return true;
    }

    /// <summary>
    /// Unloads all active plugins.
    /// </summary>
    /// <returns></returns>
    [MethodImpl(MethodImplOptions.NoInlining)]
    internal static bool UnloadPlugins()
    {
        OpsLockLoaded.EnterWriteLock();
        try
        {
            if (IsCurrentlyUnloading)
                return false;

            foreach (KeyValuePair<string, LoadedACL> loadedAcl in LoadedACLs)
            {
                foreach (IAssemblyPlugin plugin in loadedAcl.Value.LoadedPlugins)
                {
                    OnPluginUnloading?.Invoke(plugin);
                    plugin.Dispose();
                }

                loadedAcl.Value.LoadedPlugins.Clear();
            }

            PluginsLoaded = false;
        }
        finally
        {
            OpsLockLoaded.ExitWriteLock();
        }

        return true;
    }

    [MethodImpl(MethodImplOptions.NoInlining)]
    internal static bool ReloadAllPlugins(ref List<PluginInfo> pluginInfo)
    {
        if (!UnloadPlugins())
            return false;
        return LoadPlugins(out pluginInfo);
    }

    [MethodImpl(MethodImplOptions.NoInlining | MethodImplOptions.Synchronized)]
    internal static void BeginDispose()
    {
        OpsLockLoaded.EnterWriteLock();
        OpsLockUnloaded.EnterWriteLock();
        try
        {
            foreach (KeyValuePair<string, LoadedACL> loadedAcl in LoadedACLs)
            {
                foreach (IAssemblyPlugin plugin in loadedAcl.Value.LoadedPlugins)
                {
                    OnPluginUnloading?.Invoke(plugin);
                    plugin.Dispose();
                }

                PluginsLoaded = false;
                loadedAcl.Value.LoadedPlugins.Clear();
                loadedAcl.Value.PluginTypes.Clear();
                if (loadedAcl.Value.Acl is not null)
                {
                    foreach (Assembly assembly in loadedAcl.Value.Acl.Assemblies)
                    {
                        OnAssemblyUnloading?.Invoke(assembly);
                    }
                    
                    UnloadingACLs.Add(new WeakReference<AssemblyContextLoader>(loadedAcl.Value.Acl, true));
                    loadedAcl.Value.Acl.Unload();
                    OnACLUnload?.Invoke(loadedAcl.Value.Acl.Name ?? string.Empty);
                }
            }

            LoadedACLs.Clear();
        }
        finally
        {
            OpsLockUnloaded.ExitWriteLock();
            OpsLockLoaded.ExitWriteLock();
        }
    }

    [MethodImpl(MethodImplOptions.NoInlining)]
    internal static bool FinalizeDispose()
    {
        bool isUnloaded;
        OpsLockUnloaded.EnterUpgradeableReadLock();
        try
        {
            List<WeakReference<AssemblyContextLoader>> toRemove = new();
            foreach (WeakReference<AssemblyContextLoader> weakReference in UnloadingACLs)
            {
                if (!weakReference.TryGetTarget(out _))
                {
                    toRemove.Add(weakReference);
                }
            }

            if (toRemove.Any())
            {
                OpsLockUnloaded.EnterWriteLock();
                try
                {
                    foreach (WeakReference<AssemblyContextLoader> reference in toRemove)
                    {
                        UnloadingACLs.Remove(reference);
                    }
                }
                finally
                {
                    OpsLockUnloaded.ExitWriteLock();
                }
            }
            isUnloaded = !UnloadingACLs.Any();
        }
        finally
        {
            OpsLockUnloaded.ExitUpgradeableReadLock();
        }

        return isUnloaded;
    }


    
    #endregion

    #region Data

    private static readonly Dictionary<string, LoadedACL> LoadedACLs = new();
    private static readonly List<WeakReference<AssemblyContextLoader>> UnloadingACLs= new();
    private static readonly ReaderWriterLockSlim OpsLockLoaded = new ReaderWriterLockSlim();
    private static readonly ReaderWriterLockSlim OpsLockUnloaded = new ReaderWriterLockSlim();

    #endregion

    #region FunctionsData

    private static List<Type> GetPluginTypesFromAssembly<T>(Assembly assembly)
    {
        try
        {
            return assembly.GetSafeTypes().Where(t => typeof(T).IsAssignableFrom(t)).ToList();
        }
        catch (Exception e)
        {
            OnException?.Invoke($"AssemblyManager::GetPluginTypesFromAssembly() | ERROR: AssemblyName: {assembly.FullName}.", e);
            return null;
        }
    }
    
    #endregion

    #region TypeDefs

    public abstract class AssemblyContextLoader : AssemblyLoadContext
    {
        protected bool IsResolving;   //this is to avoid circular dependency lookup.
        // public
        // ReSharper disable MemberCanBePrivate.Global
        public Assembly CompiledAssembly { get; private set; }
        public byte[] CompiledAssemblyImage { get; private set; }
        public bool IsReady { get; private set; }
        // ReSharper restore MemberCanBePrivate.Global 
        // internal
        private readonly Dictionary<string, AssemblyDependencyResolver> _dependencyResolvers = new();       // path-folder, resolver
        
        
        protected AssemblyContextLoader() : base(isCollectible: true)
        {
            
        }

        [MethodImpl(MethodImplOptions.NoInlining)]
        [SuppressMessage("ReSharper", "ConditionIsAlwaysTrueOrFalseAccordingToNullableAPIContract")]
        protected override Assembly Load(AssemblyName assemblyName)
        {
            if (IsResolving)
                return null;    //circular resolution fast exit.

            try
            {
                IsResolving = true;

                // resolve self collection
                Assembly ass = this.Assemblies.FirstOrDefault(a =>
                    a.FullName is not null && a.FullName.Equals(assemblyName.FullName), null);

                if (ass is not null)
                    return ass;
                
                try
                {
                    // TODO: Remove, replaced by memory load contexts
                    ass = GameMain.LuaCs.CsScriptLoader.LoadFromAssemblyName(assemblyName);
                    if (ass is not null)
                        return ass;
                }
                catch
                {
                    // LoadFromAssemblyName throws if it fails.
                }
                
                //try resolve against other loaded alcs
                foreach (var loadedAcL in LoadedACLs)
                {
                    if (loadedAcL.Value.Acl is null) continue;
                    
                    try
                    {
                        ass = loadedAcL.Value.Acl.LoadFromAssemblyName(assemblyName);
                        if (ass is not null)
                            return ass;
                    }
                    catch
                    {
                        // LoadFromAssemblyName throws if it fails.
                    }
                }

                ass = AssemblyLoadContext.Default.LoadFromAssemblyName(assemblyName);
                if (ass is not null)
                    return ass;
            }
            finally
            {
                IsResolving = false;
            }
            
            return null;
        }
    }
    

    public class MemoryFileAssemblyContextLoader : AssemblyContextLoader
    {
        // public
        // ReSharper disable MemberCanBePrivate.Global
        public Assembly CompiledAssembly { get; private set; }
        public byte[] CompiledAssemblyImage { get; private set; }
        public bool IsReady { get; private set; }
        // ReSharper restore MemberCanBePrivate.Global 
        // internal
        private readonly Dictionary<string, AssemblyDependencyResolver> _dependencyResolvers = new();       // path-folder, resolver

        public MemoryFileAssemblyContextLoader()
        {
            
        }
        

        private void LoadFromFiles([NotNull] string[] assemblyFilePaths)
        {
            foreach (string filepath in assemblyFilePaths)
            {
                if (filepath.IsNullOrWhiteSpace())
                    continue;

                string sanitizedFilePath = System.IO.Path.GetFullPath(filepath).CleanUpPath();
                string directoryKey = System.IO.Path.GetDirectoryName(sanitizedFilePath);

                if (!_dependencyResolvers.ContainsKey(directoryKey) || _dependencyResolvers[directoryKey] is null)
                {
                    _dependencyResolvers[directoryKey] = new AssemblyDependencyResolver(sanitizedFilePath); // supply the first assembly to be loaded
                }
                
                try
                {
                    LoadFromAssemblyPath(filepath.CleanUpPath());
                }
                catch (Exception e)
                {
#if SERVER
                    LuaCsLogger.LogError($"Unable to load dependency assembly file at {path} for the assembly named {CompiledAssembly?.FullName}. | Data: {e.Message} | InnerException: {e.InnerException}");
#elif CLIENT
                         LuaCsLogger.ShowErrorOverlay($"Unable to load dependency assembly file at {filepath} for the assembly named {CompiledAssembly?.FullName}. | Data: {e.Message} | InnerException: {e.InnerException}");
#endif
                    IsReady = false;
                }
            }
        }

        private void CompileAndLoadAssembly([NotNull] MemoryStream memoryCompilation)
        {
            memoryCompilation.Seek(0, SeekOrigin.Begin);   // reset
            try
            {
                CompiledAssembly = LoadFromStream(memoryCompilation);
                CompiledAssemblyImage = memoryCompilation.ToArray();
            }
            catch (Exception e)
            {
#if SERVER
                LuaCsLogger.LogError($"Unable to load memory assembly from stream. | Data: {e.Message} | InnerException: {e.InnerException}");
#elif CLIENT
                 LuaCsLogger.ShowErrorOverlay($"Unable to load memory assembly from stream. | Data: {e.Message} | InnerException: {e.InnerException}");
#endif
                IsReady = false;
            }
        }
        
        protected override Assembly Load(AssemblyName assemblyName)
        {
            if (IsResolving)
                return null;

            // check self, can be called on load
            if (this.CompiledAssembly is not null
                && this.CompiledAssembly.FullName is not null
                && this.CompiledAssembly.FullName.Equals(assemblyName.FullName))
            {
                return CompiledAssembly;
            }

            foreach (KeyValuePair<string,AssemblyDependencyResolver> pair in _dependencyResolvers)
            {
                var ass = pair.Value.ResolveAssemblyToPath(assemblyName);
                if (ass is null)
                    continue;
                IsResolving = false;
                LoadFromAssemblyPath(ass);
            }

            return base.Load(assemblyName);
        }

        private new void Unload()
        {
            CompiledAssembly = null;
            CompiledAssemblyImage = null;
            IsReady = false;
            base.Unload();
        }
    }
    
    // ReSharper disable once NotAccessedPositionalProperty.Global
    public record LoadedACL(string FilePath, 
        List<Type> PluginTypes, 
        List<IAssemblyPlugin> LoadedPlugins,
        AssemblyContextLoader Acl);

    public enum AssemblyLoadingSuccessState
    {
        ACLLoadFailure,
        AlreadyLoaded,
        BadFilePath,
        CannotLoadFile,
        InvalidAssembly,
        NoAssemblyFound,
        PluginInstanceFailure,
        Success
    }

    #endregion
}
