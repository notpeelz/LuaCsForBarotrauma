using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.CompilerServices;
using Path = System.IO.Path;

namespace Barotrauma;

public static class PluginHelper
{
    public static readonly string PluginAsmFileSuffix = "*.plugin.dll";
    private static readonly object _OpsLock = new object();
    public static bool IsInit { get; private set; } = false;
    
    public static List<string> FindAssembliesFilePaths(string rootPath)
    {
        if (!Directory.Exists(rootPath))
        {
            return new List<string>();
        }
        return Directory.GetFiles(rootPath, PluginAsmFileSuffix, SearchOption.TopDirectoryOnly).ToList();
    }

    public static List<string> GetAllAssemblyPathsInPackages(ApplicationMode mode, TargetPlatform platform)
    {
        if (!IsInit)
            InitHooks();
        LuaCsSetup.PrintCsMessage($"MCM: Scanning packages...");
        List<ContentPackage> scannedPackages = new();
        List<string> dllPaths = new();
        // Sometimes ALL packages doesn't include packages downloaded from the server. So we need to search twice.
        foreach (ContentPackage package in 
                 ContentPackageManager.AllPackages.Concat(ContentPackageManager.EnabledPackages.All))
        {
            if (scannedPackages.Contains(package))
                continue;
            scannedPackages.Add(package);
            try
            { 
                string baseStandardSearchPath = Path.GetFullPath(
                    Path.Combine(
                        Path.GetDirectoryName(package.Path)!,
                        GetApplicationModSubDir(mode),
                        "Standard")
                );
                
                // Add always load packages
                dllPaths.AddRange(FindAssembliesFilePaths(GetPath(package.Path, true, true)));
                dllPaths.AddRange(FindAssembliesFilePaths(GetPath(package.Path, true, false)));

                // Add enabled-only load packages
                if (ContentPackageManager.EnabledPackages.All.Contains(package))
                {
                    dllPaths.AddRange(FindAssembliesFilePaths(GetPath(package.Path, false, true)));
                    dllPaths.AddRange(FindAssembliesFilePaths(GetPath(package.Path, false, false)));
                }
            }
            catch(Exception e)
            {
                ModUtils.Logging.PrintError($"PluginHelper::GetAllAssemblyPathsInPackages() | Unable to parse the package: {package.Name} | Details: {e.Message}");
            }
        }
        return dllPaths;

        string GetPath(string packagePath, bool forced, bool basePath)
        {
            if (basePath)
            {
                return Path.Combine(
                    Path.GetDirectoryName(packagePath)!,
                    GetApplicationModSubDir(mode),
                    forced ? "Forced" : "Standard"
                    );
            }

            return Path.Combine(
                Path.GetDirectoryName(packagePath)!,
                GetApplicationModSubDir(mode),
                forced ? "Forced" : "Standard",
                GetPlatformModSubDir(platform)
            );
        }

        string GetApplicationModSubDir(ApplicationMode mode) =>
            mode switch
            {
                ApplicationMode.Client => "bin/Client",
                ApplicationMode.Server => "bin/Server",
                _ => "bin/Client"   //default to client mode
            };

        string GetPlatformModSubDir(TargetPlatform target) =>
            target switch
            {
                TargetPlatform.Windows => "Windows",
                TargetPlatform.Linux => "Linux",
                TargetPlatform.MacOSX => "OSX",
                _ => "Windows"
            };
    }
    
    [MethodImpl(MethodImplOptions.Synchronized | MethodImplOptions.NoInlining)]
    internal static void UnloadAssemblies()
    {
        if (!IsInit)
            InitHooks();
        
        lock (_OpsLock)
        {
            int count = 100;
            AssemblyManager.TryBeginDispose();
            while (!AssemblyManager.FinalizeDispose() && count > 0)
            {
                count--;
                System.Threading.Thread.Sleep(10);
            }
        }
    }
    
    [MethodImpl(MethodImplOptions.Synchronized | MethodImplOptions.NoInlining)]
    internal static void LoadAssemblies()
    {
#if SERVER
        var appMode = ApplicationMode.Server;
#else
        var appMode = ApplicationMode.Client;
#endif

#if WINDOWS
        var targetPlatform = TargetPlatform.Windows;
#elif LINUX
        var targetPlatform = TargetPlatform.Linux;
#elif OSX
        var targetPlatform = TargetPlatform.MacOSX;
#else
        //Making the assumption that some random Linux distro target is most likely to be the platform to ever have this edge case exist.
        var targetPlatform = TargetPlatform.Linux;  
#endif
        
        if (!IsInit)
            InitHooks();
        
        lock (_OpsLock)
        {
            ModUtils.Logging.PrintMessage("Loading Assembly Plugins...");
            List<string> pluginDllPaths = GetAllAssemblyPathsInPackages(appMode, targetPlatform);

            foreach (string path in pluginDllPaths)
            {
                ModUtils.Logging.PrintMessage($"Found Assembly Path: {path}");
            }
            List<AssemblyManager.LoadedACL> loadedAcls = new();
            foreach (string dllPath in pluginDllPaths)
            {
                AssemblyManager.AssemblyLoadingSuccessState alss
                    = AssemblyManager.LoadAssembliesFromLocation(dllPath, out var loadedAcl);
                if (alss == AssemblyManager.AssemblyLoadingSuccessState.Success)
                {
                    if (loadedAcl is not null)
                        loadedAcls.Add(loadedAcl);
                }
            }

            if (AssemblyManager.LoadPlugins(out var pluginInfos))
            {
                foreach (var pluginInfo in pluginInfos)
                {
                    ModUtils.Logging.PrintMessage($"Loaded Assembly Plugin: {pluginInfo.ModName}, Version: {pluginInfo.Version}");
                }
            }
            else
            {
                ModUtils.Logging.PrintError("ERROR: Unable to load plugins.");
            }
        }
    }

    private static void OnAssemblyLoadedHandle(Assembly assembly)
    {
       ModUtils.Logging.PrintMessage($"Modding TK: Registering Assembly {assembly.FullName}");
        Barotrauma.ReflectionUtils.AddNonAbstractAssemblyTypes(assembly);
    }

    private static void InitHooks()
    {
        if (IsInit)
            return;
        AssemblyManager.OnException += AssemblyManagerOnException;
        AssemblyManager.OnAssemblyLoaded += OnAssemblyLoadedHandle;
        AssemblyManager.OnAssemblyUnloading += AssemblyManagerOnAssemblyUnloading;
        IsInit = true;
    }

    private static void AssemblyManagerOnAssemblyUnloading(Assembly assembly)
    {
        Barotrauma.ReflectionUtils.RemoveAssemblyFromCache(assembly);
    }

    private static void ReleaseHooks()
    {
        if (!IsInit)
            return;
        AssemblyManager.OnAssemblyUnloading -= AssemblyManagerOnAssemblyUnloading;
        AssemblyManager.OnAssemblyLoaded -= OnAssemblyLoadedHandle;
        AssemblyManager.OnException -= AssemblyManagerOnException;
        IsInit = false;
    }

    private static void AssemblyManagerOnException(string arg1, Exception arg2)
    {
       ModUtils.Logging.PrintError($"{arg1} | Exception Details: {arg2.Message}");
    }
}
