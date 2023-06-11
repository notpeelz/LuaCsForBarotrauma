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

    #endregion

    #region PUBLIC_API

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
}
