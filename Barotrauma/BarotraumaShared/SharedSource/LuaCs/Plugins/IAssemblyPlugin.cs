using System;

namespace Barotrauma;

public interface IAssemblyPlugin : IDisposable
{
    /// <summary>
    /// Called on plugin start, use this for basic/core loading that does not rely on any other modded content.
    /// </summary>
    void Initialize();
    
    /// <summary>
    /// Called once all plugins have been loaded. if you have integrations with any other mod, put that code here.
    /// </summary>
    void OnLoadCompleted();
    
    /// <summary>
    /// Gets plugin info and dependencies (not yet implemented).
    /// </summary>
    /// <returns></returns>
    PluginInfo GetPluginInfo();
}
