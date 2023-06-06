using System.Collections.Immutable;

namespace Barotrauma;

public record PluginInfo(
    string ModName, 
    string Version, 
    ImmutableArray<string> Dependencies);
