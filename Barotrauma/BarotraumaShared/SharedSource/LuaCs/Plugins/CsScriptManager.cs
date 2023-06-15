using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using FarseerPhysics.Common;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;

namespace Barotrauma;

public class CsScriptManager
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
    
    private static readonly SyntaxTree AssemblyImports = CSharpSyntaxTree.ParseText(
        new StringBuilder()
            .AppendLine("using System.Reflection;")
            .AppendLine("using Barotrauma;")
            .AppendLine("using Luatrauma;")
            .AppendLine("[assembly: IgnoresAccessChecksTo(\"Barotrauma\")")
            .AppendLine("[assembly: IgnoresAccessChecksTo(\"DedicatedServer\")")
            .ToString(),
        ScriptParseOptions);

    private readonly List<ContentPackage> _currentPackagesByLoadOrder = new();
    private readonly Dictionary<ContentPackage, List<ContentPackage>> _packagesDependencies = new();

    #endregion

    #region PUBLIC_API
    public IEnumerable<ContentPackage> GetCurrentPackagesByLoadOrder() => _currentPackagesByLoadOrder;

    #region HELPER_FUNCS

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public static IEnumerable<MetadataReference> GenerateMetadataReferencesFromAssemblies()
    {
        return AppDomain.CurrentDomain.GetAssemblies()
            .Where(a => !(a.IsDynamic || string.IsNullOrEmpty(a.Location) || a.Location.Contains("xunit")))
            .Select(a => MetadataReference.CreateFromFile(a.Location) as MetadataReference)
            .ToList();
    }


    /// <summary>
    /// 
    /// </summary>
    /// <param name="package"></param>
    /// <returns></returns>
    /// <exception cref="NotImplementedException"></exception>
    public static IEnumerable<SyntaxTree> GeneratePackageScriptAssemblyInfo(ContentPackage package)
    {
        List<SyntaxTree> syntaxTree = new();
        syntaxTree.Add(GetPackageScriptImports());
        
        throw new NotImplementedException();
    }


    public static IEnumerable<SyntaxTree> GeneratePackageScriptTree(ContentPackage package)
    {
        var syntaxTree = new List<SyntaxTree>();
        syntaxTree.AddRange(GeneratePackageScriptAssemblyInfo(package));
        
    }

    public static SyntaxTree GetPackageScriptImports() => AssemblyImports;

    public static bool GetOrCreateRunConfig(ContentPackage package, out RunConfig config)
    {
        string filepath = System.IO.Path.Combine(package.Path, "CSharp", "RunConfig.xml");
        if (ModUtils.IO.IOActionResultState.Success == ModUtils.IO.GetOrCreateFileText(
                filepath, out string fileText, () =>
                {
                    throw new NotImplementedException();
                }))
        {
            
        }

        throw new NotImplementedException();
    }

    #endregion

    #endregion

    #region INTERNALS

    private bool BuildDependenciesList()
    {
        throw new NotImplementedException();
    }
    
    /// <summary>
    /// 
    /// </summary>
    /// <param name="packages">A dictionary/map with key as the package and the elements as it's dependencies.</param>
    /// <param name="readyToLoad"></param>
    /// <param name="cannotLoadPackages">Packages with errors or cyclic dependencies.</param>
    /// <returns>Whether or not the process produces a usable list.</returns>
    private static bool OrderAndFilterPackagesByDependencies(
        Dictionary<ContentPackage, IEnumerable<ContentPackage>> packages, 
        out IEnumerable<ContentPackage> readyToLoad, 
        out IEnumerable<KeyValuePair<ContentPackage, string>> cannotLoadPackages)
    {
        HashSet<ContentPackage> completedPackages = new();
        List<ContentPackage> readyPackages = new();
        Dictionary<ContentPackage, string> unableToLoad = new();
        HashSet<ContentPackage> currentNodeChain = new();

        readyToLoad = readyPackages;
        cannotLoadPackages = unableToLoad;

        foreach (var toProcessPack in packages)
        {   
            ProcessPackage(toProcessPack.Key, toProcessPack.Value);
        }

        PackageProcRet ProcessPackage(ContentPackage packageToProcess, IEnumerable<ContentPackage> dependencies)
        {
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
                    .Append("The following ContentPackages rely on eachother in a way that makes it impossible to know which to load first! ")
                    .Append("Note: the package listed twice shows where the cycle starts/ends and is not necessarily the problematic package.");
                int i = 0;
                foreach (var package in currentNodeChain)
                {
                    i++;
                    sb.AppendLine($"{i}. {package.Name}");
                }
                sb.AppendLine($"{i}. {packageToProcess.Name}");
                unableToLoad.Add(packageToProcess, sb.ToString());
                return PackageProcRet.Cyclic;
            }

            currentNodeChain.Add(packageToProcess);
            
            foreach (ContentPackage dependency in dependencies)
            {
                if (!packages.ContainsKey(dependency))
                {
                    // search to see if it's enabled
                    if (!ContentPackageManager.EnabledPackages.All.Contains(dependency))
                    {
                        ModUtils.Logging.PrintError($"Warning: the ContentPackage of {packageToProcess.Name} requires the Dependency {dependency.Name} but this package wasn't found in the enabled mods list!");
                    }
                    continue;
                }

                var ret = ProcessPackage(dependency, packages[dependency]);

                switch (ret)
                {
                    case PackageProcRet.Cyclic:
                        // TODO: Continue.
                }
            }

            currentNodeChain.Remove(packageToProcess);
            completedPackages.Add(packageToProcess);
            
            return PackageProcRet.Completed;
        }
    
        private enum PackageProcRet : byte
        {
            Cyclic = 0,
            AlreadyCompleted,
            Completed,
            BadPackage
        }    
    }
    
    

    #endregion
}
