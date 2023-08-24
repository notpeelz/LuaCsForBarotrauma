using System;
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

namespace Barotrauma;

public class MemoryFileAssemblyContextLoader : AssemblyLoadContext
{
    // public
    // ReSharper disable MemberCanBePrivate.Global
    public Assembly CompiledAssembly { get; private set; } = null;
    public byte[] CompiledAssemblyImage { get; private set; } = null;
    // ReSharper restore MemberCanBePrivate.Global 
    // internal
    private readonly Dictionary<string, AssemblyDependencyResolver> _dependencyResolvers = new();       // path-folder, resolver
    protected bool IsResolving;   //this is to avoid circular dependency lookup.
    
    public MemoryFileAssemblyContextLoader()
    {
        
    }
    

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assemblyFilePaths"></param>
    public void LoadFromFiles([NotNull] string[] assemblyFilePaths)
    {
        foreach (string filepath in assemblyFilePaths)
        {
            // path verification
            if (filepath.IsNullOrWhiteSpace())
                continue;
            string sanitizedFilePath = System.IO.Path.GetFullPath(filepath).CleanUpPath();
            string directoryKey = System.IO.Path.GetDirectoryName(sanitizedFilePath);

            // setup dep resolver if not available
            if (!_dependencyResolvers.ContainsKey(directoryKey) || _dependencyResolvers[directoryKey] is null)
            {
                _dependencyResolvers[directoryKey] = new AssemblyDependencyResolver(sanitizedFilePath); // supply the first assembly to be loaded
            }
            
            // try loading the assemblies
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
            }
        }
    }


    public bool CompileAndLoadScriptAssembly(
        [NotNull] string assemblyName,
        [NotNull] IEnumerable<SyntaxTree> syntaxTrees,
        IEnumerable<MetadataReference> externMetadataReferences,
        [NotNull] CSharpCompilationOptions compilationOptions,
        out string compilationMessages,
        out Assembly compiledAssembly)
    {
        compilationMessages = "";
        compiledAssembly = null;

        // verifications
        if (assemblyName.IsNullOrWhiteSpace())
            throw new ArgumentNullException(
                $"{nameof(MemoryFileAssemblyContextLoader)}::{nameof(CompileAndLoadScriptAssembly)}() | The supplied assembly name is null!");

        if (syntaxTrees is null)
            throw new ArgumentNullException(
                $"{nameof(MemoryFileAssemblyContextLoader)}::{nameof(CompileAndLoadScriptAssembly)}() | The supplied syntax tree is null!");
        
        // add external references
        List<MetadataReference> metadataReferences = new();
        if (externMetadataReferences is not null)
            metadataReferences.AddRange(externMetadataReferences);

        // build metadata refs from global where not an in-memory compiled assembly.
        metadataReferences.AddRange(AppDomain.CurrentDomain.GetAssemblies()
            .Where(a => !(a.IsDynamic || string.IsNullOrEmpty(a.Location) || a.Location.Contains("xunit")))
            .Select(a => MetadataReference.CreateFromFile(a.Location) as MetadataReference)
            .ToList());
            
        // build metadata refs from in-memory images
        foreach (var loadedAcl in AssemblyManager.GetAllLoadedACLs())
        {
            if (loadedAcl.Acl.CompiledAssemblyImage is null || loadedAcl.Acl.CompiledAssemblyImage.Length == 0)
                continue;
            metadataReferences.Add(MetadataReference.CreateFromImage(loadedAcl.Acl.CompiledAssemblyImage));
        }
        
        // Change inaccessible options to allow public access to restricted members
        var topLevelBinderFlagsProperty = typeof(CSharpCompilationOptions).GetProperty("TopLevelBinderFlags", BindingFlags.Instance | BindingFlags.NonPublic);
        topLevelBinderFlagsProperty?.SetValue(compilationOptions, (uint)1 << 22);
        
        // begin compilation 
        using var memoryCompilation = new MemoryStream();
        // compile, emit
        var result = CSharpCompilation.Create(assemblyName, syntaxTrees, metadataReferences, compilationOptions).Emit(memoryCompilation);
        // check for errors
        if (!result.Success)
        {
            IEnumerable<Diagnostic> failures = result.Diagnostics.Where(d => d.IsWarningAsError || d.Severity == DiagnosticSeverity.Error);
            foreach (Diagnostic diagnostic in failures)
            {
                compilationMessages += $"\n{diagnostic}";
            }

            return false;
        }

        memoryCompilation.Seek(0, SeekOrigin.Begin);   // reset
        try
        {
            CompiledAssembly = LoadFromStream(memoryCompilation);
            CompiledAssemblyImage = memoryCompilation.ToArray();
            compilationMessages = "success";
            compiledAssembly = CompiledAssembly;
        }
        catch (Exception e)
        {
#if SERVER
                LuaCsLogger.LogError($"Unable to load memory assembly from stream. | Data: {e.Message} | InnerException: {e.InnerException}");
#elif CLIENT
            LuaCsLogger.ShowErrorOverlay($"Unable to load memory assembly from stream. | Data: {e.Message} | InnerException: {e.InnerException}");
#endif
            return false;
        }

        return true;
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

            foreach (KeyValuePair<string,AssemblyDependencyResolver> pair in _dependencyResolvers)
            {
                var asspath = pair.Value.ResolveAssemblyToPath(assemblyName);
                if (asspath is null)
                    continue;
                ass = LoadFromAssemblyPath(asspath);
                if (ass is not null)
                    return ass;
            }

            //try resolve against other loaded alcs
            foreach (var loadedAcL in AssemblyManager.GetAllLoadedACLs())
            {
                if (loadedAcL.Acl is null) continue;
                
                try
                {
                    ass = loadedAcL.Acl.LoadFromAssemblyName(assemblyName);
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
    

    private new void Unload()
    {
        CompiledAssembly = null;
        CompiledAssemblyImage = null;
        base.Unload();
    }
}
