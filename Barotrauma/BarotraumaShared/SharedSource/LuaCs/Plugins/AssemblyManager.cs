using System;
using System.Collections.Concurrent;
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
public partial class AssemblyManager
{
    #region ExternalAPI
    
    /// <summary>
    /// Called when an assembly is loaded.
    /// </summary>
    public event Action<Assembly> OnAssemblyLoaded;
    
    /// <summary>
    /// Called when an assembly is marked for unloading, before unloading begins. You should use this to cleanup
    /// any references that you have to this assembly.
    /// </summary>
    public event Action<Assembly> OnAssemblyUnloading; 
    
    /// <summary>
    /// Called whenever an exception is thrown. First arg is a formatted message, Second arg is the Exception.
    /// </summary>
    public event Action<string, Exception> OnException;

    /// <summary>
    /// For unloading issue debugging. Called whenever MemoryFileAssemblyContextLoader [load context] is unloaded. 
    /// </summary>
    public event Action<Guid> OnACLUnload; 
    
    #if DEBUG

    /// <summary>
    /// [DEBUG ONLY]
    /// Returns a list of the current unloading ACLs. 
    /// </summary>
    public ImmutableList<WeakReference<MemoryFileAssemblyContextLoader>> StillUnloadingACLs
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
    public bool IsCurrentlyUnloading
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
    /// Allows iteration over all non-interface types in all loaded assemblies in the AsmMgr that are assignable to the given type (IsAssignableFrom).
    /// </summary>
    /// <typeparam name="T">The type to compare against</typeparam>
    /// <returns>An Enumerator for matching types.</returns>
    public IEnumerable<Type> GetSubTypesInLoadedAssemblies<T>()
    {
        Type targetType = typeof(T);

        OpsLockLoaded.EnterReadLock();
        try
        {
            return AssemblyLoadContext.Default.Assemblies
                .SelectMany(a => a.GetSafeTypes())
                .Where(t => targetType.IsAssignableFrom(t) && !t.IsInterface)
                .Concat(LoadedACLs
                    .SelectMany(kvp => kvp.Value.GetAssembliesTypes()
                        .Where(t => targetType.IsAssignableFrom(t) && !t.IsInterface)))
                .ToImmutableList();
        }
        finally
        {
            OpsLockLoaded.ExitReadLock();
        }
    }

    /// <summary>
    /// Tries to get types assignable to type from the ACL given the Guid.
    /// </summary>
    /// <param name="id"></param>
    /// <param name="types"></param>
    /// <typeparam name="T"></typeparam>
    /// <returns></returns>
    public bool TryGetSubTypesFromACL<T>(Guid id, out IEnumerable<Type> types)
    {
        Type targetType = typeof(T);

        if (TryGetACL(id, out var acl))
        {
            types = acl.GetAssembliesTypes()
                .Where(t => targetType.IsAssignableFrom(t) && !t.IsInterface);
            return true;
        }

        types = null;
        return false;
    }
    
    /// <summary>
    /// Tries to get types from the ACL given the Guid.
    /// </summary>
    /// <param name="id"></param>
    /// <param name="types"></param>
    /// <typeparam name="T"></typeparam>
    /// <returns></returns>
    public bool TryGetSubTypesFromACL(Guid id, out IEnumerable<Type> types)
    {
        if (TryGetACL(id, out var acl))
        {
            types = acl.GetAssembliesTypes();
            return true;
        }

        types = null;
        return false;
    }


    /// <summary>
    /// Allows iteration over all non-interface types in all loaded assemblies in the AsmMgr who's names contain the string.
    /// </summary>
    /// <param name="name">The string name of the type to search for, search uses EndsWith()</param>
    /// <returns>An Enumerator for matching types.</returns>
    public IEnumerable<Type> GetTypesByName(string name)
    {
        OpsLockLoaded.EnterReadLock();
        try
        {
            return AssemblyLoadContext.Default.Assemblies
                .SelectMany(a => a.GetSafeTypes())
                .Where(t => t.Name.EndsWith(name) && !t.IsInterface)
                .Concat(LoadedACLs
                    .SelectMany(kvp => kvp.Value.GetAssembliesTypes()
                        .Where(t => t.Name.EndsWith(name) && !t.IsInterface)))
                .ToImmutableList();
        }
        finally
        {
            OpsLockLoaded.ExitReadLock();
        }
    }

    /// <summary>
    /// Allows iteration over all types (including interfaces) in all loaded assemblies managed by the AsmMgr.
    /// Warning: High usage may result in performance issues.
    /// </summary>
    /// <returns>An Enumerator for iteration.</returns>
    public IEnumerable<Type> GetAllTypesInLoadedAssemblies()
    {
        OpsLockLoaded.EnterReadLock();
        try
        {
            return AssemblyLoadContext.Default.Assemblies
                .SelectMany(a => a.GetSafeTypes())
                .Concat(LoadedACLs
                    .SelectMany(kvp => kvp.Value.GetAssembliesTypes()))
                .ToImmutableList();
        }
        finally
        {
            OpsLockLoaded.ExitReadLock();
        }
    }

    public IEnumerable<LoadedACL> GetAllLoadedACLs()
    {
        try
        {
            OpsLockLoaded.EnterReadLock();
            return LoadedACLs.Select(kvp => kvp.Value).ToImmutableList();
        }
        finally
        {
            OpsLockLoaded.ExitReadLock();
        }
        
    }

    #endregion

    #region InternalAPI

    /// <summary>
    /// Used by content package and plugin management to stop unloading of a given ACL until all plugins have gracefully closed.
    /// </summary>
    public event System.Func<LoadedACL, bool> IsReadyToUnloadACL;

    public AssemblyLoadingSuccessState LoadAssemblyFromMemory([NotNull] string compiledAssemblyName,
        [NotNull] IEnumerable<SyntaxTree> syntaxTree,
        IEnumerable<MetadataReference> externalMetadataReferences,
        [NotNull] CSharpCompilationOptions compilationOptions,
        ref Guid id)
    {
        // validation
        if (compiledAssemblyName.IsNullOrWhiteSpace())
            return AssemblyLoadingSuccessState.BadName;
        
        if (!GetOrCreateACL(id, out var acl))
            return AssemblyLoadingSuccessState.ACLLoadFailure;

        id = acl.Id;    // pass on true id returned
        
        // this acl is already hosting an in-memory assembly
        if (acl.Acl.CompiledAssembly is not null)
            return AssemblyLoadingSuccessState.AlreadyLoaded;

        // compile
        var state = acl.Acl.CompileAndLoadScriptAssembly(compiledAssemblyName, syntaxTree, externalMetadataReferences,
            compilationOptions, out var messages);
        
        // get types
        if (state is AssemblyLoadingSuccessState.Success)
        {
            acl.SafeRebuildTypesList();
            OnAssemblyLoaded?.Invoke(acl.Acl.CompiledAssembly);
        }

        return state;
    }

    
    public AssemblyLoadingSuccessState LoadAssembliesFromLocations([NotNull] IEnumerable<string> filePaths,
        ref Guid id)
    {

        if (filePaths is null)
        {
            throw new ArgumentNullException(
                $"{nameof(AssemblyManager)}::{nameof(LoadAssembliesFromLocations)}() | file paths supplied is null!");
        }
        
        ImmutableList<string> assemblyFilePaths = filePaths.ToImmutableList();  // copy the list before loading

        if (!assemblyFilePaths.Any())
        {
            return AssemblyLoadingSuccessState.NoAssemblyFound;
        }
        
        if (GetOrCreateACL(id, out var loadedAcl))
        {
            var state = loadedAcl.Acl.LoadFromFiles(assemblyFilePaths);
            // if failure, we dispose of the acl
            if (state != AssemblyLoadingSuccessState.Success)
            {
                DisposeACL(loadedAcl.Id);
                return state;
            }
            // build types list
            loadedAcl.SafeRebuildTypesList();
            foreach (Assembly assembly in loadedAcl.Acl.Assemblies)
            {
                OnAssemblyLoaded?.Invoke(assembly);
            }
            return state;
        }

        return AssemblyLoadingSuccessState.ACLLoadFailure;
    }


    [MethodImpl(MethodImplOptions.NoInlining | MethodImplOptions.Synchronized)]
    public bool TryBeginDispose()
    {
        try
        {
            OpsLockLoaded.EnterWriteLock();
            OpsLockUnloaded.EnterWriteLock();
            
            foreach (KeyValuePair<Guid, LoadedACL> loadedAcl in LoadedACLs)
            {
                if (loadedAcl.Value.Acl is not null)
                {
                    foreach (Delegate del in IsReadyToUnloadACL.GetInvocationList())
                    {
                        if (del is System.Func<LoadedACL, bool> { } func)
                        {
                            if (!func.Invoke(loadedAcl.Value))
                                return false; // Not ready, exit
                        }
                    }

                    foreach (Assembly assembly in loadedAcl.Value.Acl.Assemblies)
                    {
                        OnAssemblyUnloading?.Invoke(assembly);
                    }

                    UnloadingACLs.Add(new WeakReference<MemoryFileAssemblyContextLoader>(loadedAcl.Value.Acl, true));
                    loadedAcl.Value.Acl.Unload();
                    OnACLUnload?.Invoke(loadedAcl.Value.Id);
                }
            }

            LoadedACLs.Clear();
            return true;
        }
        catch
        {
            // should never happen
            return false;
        }
        finally
        {
            OpsLockUnloaded.ExitWriteLock();
            OpsLockLoaded.ExitWriteLock();
        }
    }


    [MethodImpl(MethodImplOptions.NoInlining)]
    public bool FinalizeDispose()
    {
        bool isUnloaded;
        OpsLockUnloaded.EnterUpgradeableReadLock();
        try
        {
            List<WeakReference<MemoryFileAssemblyContextLoader>> toRemove = new();
            foreach (WeakReference<MemoryFileAssemblyContextLoader> weakReference in UnloadingACLs)
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
                    foreach (WeakReference<MemoryFileAssemblyContextLoader> reference in toRemove)
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
    
    
    // acl crud

    /// <summary>
    /// Gets or creates an AssemblyCtxLoader for the given ID. Creates if the ID is empty or no ACL can be found.
    /// [IMPORTANT] After calling this method, the id you use should be taken from the acl container (acl.Id). 
    /// </summary>
    /// <param name="id"></param>
    /// <param name="acl"></param>
    /// <returns>Should only return false if an error occurs.</returns>
    [MethodImpl(MethodImplOptions.NoInlining)]
    private bool GetOrCreateACL(Guid id, out LoadedACL acl)
    {
        OpsLockLoaded.EnterUpgradeableReadLock();
        try
        {
            if (id.Equals(Guid.Empty) || !LoadedACLs.ContainsKey(id) || LoadedACLs[id] is null)
            {
                OpsLockLoaded.EnterWriteLock();
                try
                {
                    id = Guid.NewGuid();
                    acl = new LoadedACL(id, this);
                    LoadedACLs[id] = acl;
                    return true;
                }
                finally
                {
                    OpsLockLoaded.ExitWriteLock();
                }
            }
            else
            {
                acl = LoadedACLs[id];
                return true;
            }

        }
        catch
        {
            // should never happen but in-case
            acl = null;
            return false;
        }
        finally
        {
            OpsLockLoaded.ExitUpgradeableReadLock();
        }
    }

    /// <summary>
    /// Tries to retrieve the LoadedACL with the given ID or null if none is found.
    /// </summary>
    /// <param name="id">GUID of the ACL.</param>
    /// <param name="acl">The found ACL or null if none was found.</param>
    /// <returns>Whether or not an ACL was found.</returns>
    [MethodImpl(MethodImplOptions.NoInlining)]
    private bool TryGetACL(Guid id, out LoadedACL acl)
    {
        acl = null;
        OpsLockLoaded.EnterReadLock();
        try
        {
            if (id.Equals(Guid.Empty) || !LoadedACLs.ContainsKey(id))
                return false;
            acl = LoadedACLs[id];
            return true;
        }
        finally
        {
            OpsLockLoaded.ExitReadLock();
        }
    }

    [MethodImpl(MethodImplOptions.NoInlining)]
    private bool DisposeACL(Guid id)
    {
        OpsLockLoaded.EnterWriteLock();
        OpsLockUnloaded.EnterWriteLock();
        try
        {
            if (id.Equals(Guid.Empty) || !LoadedACLs.ContainsKey(id) || LoadedACLs[id] is null)
            {
                return false; // nothing to dispose of
            }

            var acl = LoadedACLs[id];

            foreach (Assembly assembly in acl.Acl.Assemblies)
            {
                OnAssemblyUnloading?.Invoke(assembly);
            }

            UnloadingACLs.Add(new WeakReference<MemoryFileAssemblyContextLoader>(acl.Acl, true));
            acl.Acl.Unload();
            OnACLUnload?.Invoke(acl.Id);

            return true;
        }
        catch
        {
            // should never happen
            return false;
        }
        finally
        {
            OpsLockLoaded.ExitWriteLock();
            OpsLockUnloaded.ExitWriteLock();
        }
    }
    
    #endregion

    #region Data

    private readonly ConcurrentDictionary<Guid, LoadedACL> LoadedACLs = new();
    private readonly List<WeakReference<MemoryFileAssemblyContextLoader>> UnloadingACLs= new();
    private readonly ReaderWriterLockSlim OpsLockLoaded = new ReaderWriterLockSlim();
    private readonly ReaderWriterLockSlim OpsLockUnloaded = new ReaderWriterLockSlim();

    #endregion

    #region TypeDefs
    

    public sealed class LoadedACL
    {
        public readonly Guid Id;
        private readonly List<Type> AssembliesTypes;
        public readonly MemoryFileAssemblyContextLoader Acl;
        private readonly AssemblyManager _manager;

        internal LoadedACL(Guid id, AssemblyManager manager)
        {
            this.Id = id;
            this.Acl = new(manager);
            this.AssembliesTypes = new();
            this._manager = manager;
        }
        public IEnumerable<Type> GetAssembliesTypes() => AssembliesTypes;
        
        /// <summary>
        /// Rebuild the list of types from assemblies loaded in the AsmCtxLoader.
        /// </summary>
        internal void SafeRebuildTypesList()
        {
            // Do not allow any unloading to occur while rebuilding this list.
            _manager.OpsLockLoaded.EnterReadLock();
            try
            {
                AssembliesTypes.Clear();
                foreach (Assembly assembly in Acl.Assemblies.ToImmutableList())
                {
                    AssembliesTypes.AddRange(assembly.GetSafeTypes());
                }
            }
            finally
            {
                _manager.OpsLockLoaded.ExitReadLock();
            }
        }
    }

    #endregion
}

public static class AssemblyExtensions
{
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
            try
            {
                return re.Types.Where(x => x != null)!;
            }
            catch (InvalidOperationException ioe)   
            {
                return new List<Type>();
            }
        }
        catch (Exception e)
        {
            return new List<Type>();
        }
    }
}
