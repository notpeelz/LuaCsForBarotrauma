using System;
using System.Xml.Serialization;

namespace Barotrauma;

[Serializable]
public sealed class RunConfig
{
    /// <summary>
    /// How should scripts be run on the server.
    /// </summary>
    [XmlElement(ElementName = "Server")]
    public string Server { get; set; }
    
    /// <summary>
    /// How should scripts be run on the client. 
    /// </summary>
    [XmlElement(ElementName = "Client")]
    public string Client { get; set; }
    
    /// <summary>
    /// List of dependencies by either Steam Workshop ID or by Partial Inclusive Name (ie. "ModDep" will match a mod named "A ModDependency").
    /// PIN Dependency checks if ContentPackage names contains the dependency string.
    /// </summary>
    [XmlArrayItem(ElementName = "Dependency", IsNullable = true, Type = typeof(Dependency))]
    [XmlArray]
    public Dependency[] Dependencies { get; set; }


    [Serializable]
    public sealed class Dependency
    {
        /// <summary>
        /// Steam Workshop ID of the dependency.
        /// </summary>
        [XmlElement(ElementName = "SteamWorkshopId")]
        public ulong SteamWorkshopId { get; set; }
        
        /// <summary>
        /// Package Name of the dependency. Not needed if SteamWorkshopId is set.
        /// </summary>
        [XmlElement(ElementName = "PackageName")]
        public string PackageName { get; set; }
    }

    public RunConfig Sanitize()
    {
        Client = SanitizeRunSetting(Client);
        Server = SanitizeRunSetting(Server);
        if (Dependencies is null)
        {
            Dependencies = new RunConfig.Dependency[] { };
        }

        static string SanitizeRunSetting(string str) =>
            str switch
            {
                null => "Standard",
                "" => "Standard",
                _ => str[0].ToString().ToUpper() + str.Substring(1).ToLower()
            };

        return this;
    }
    
}
