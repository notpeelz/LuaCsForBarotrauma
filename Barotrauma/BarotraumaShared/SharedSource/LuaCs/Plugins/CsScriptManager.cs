using System;
using System.Collections.Generic;
using System.IO;
using System.Xml.Serialization;
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


        throw new NotImplementedException();
    }

    public static SyntaxTree GetPackageScriptImports() => AssemblyImports;

    public static bool GetOrCreateRunConfig(ContentPackage package, out RunConfig config)
    {
        string filepath = System.IO.Path.Combine(package.Path, "CSharp", "RunConfig.xml");
        if (ModUtils.IO.IOActionResultState.Success == ModUtils.IO.GetOrCreateFileText(
                filepath, out string fileText, () =>
                {
                    using (StringWriter sw = new StringWriter())
                    {
                        XmlSerializer s = new XmlSerializer(typeof(RunConfig));
                        RunConfig r = new()
                        {
                            Client = "Standard",
                            Server = "Standard",
                            Dependencies = new RunConfig.Dependency[]{}
                        };
                        s.Serialize(sw, r);
                        return sw.ToString();
                    }
                }))
        {
            XmlSerializer s = new XmlSerializer(typeof(RunConfig));
            try
            {
                using (TextReader tr = new StringReader(fileText))
                {
                    config = (RunConfig)s.Deserialize(tr);
                }
                // Sanitization
                config.Client = SanitizeRun(config.Client);
                config.Server = SanitizeRun(config.Server);
                if (config.Dependencies is null)
                {
                    config.Dependencies = new RunConfig.Dependency[] { };
                }

                static string SanitizeRun(string str) =>
                    str switch
                    {
                        null => "Standard",
                        "" => "Standard",
                        _ => str[0].ToString().ToUpper() + str.Substring(1).ToLower()
                    };
            }
            catch(InvalidOperationException ioe)
            {
                ModUtils.Logging.PrintError($"Error while parsing run config for {package.Name}, using defaults.");
#if DEBUG
                ModUtils.Logging.PrintError($"Exception: {ioe.Message}. Details: {ioe.InnerException?.Message}");
#endif
                config = new RunConfig()
                {
                    Client = "Standard",
                    Server = "Standard",
                    Dependencies = new RunConfig.Dependency[] { }
                };
            }
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

    #endregion
}
