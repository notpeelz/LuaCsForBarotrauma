using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.IO;

namespace Barotrauma
{
    public abstract class ACsMod : IDisposable, IAssemblyPlugin
    {
        private static List<ACsMod> mods = new List<ACsMod>();
        public static List<ACsMod> LoadedMods { get => mods; }

        private const string MOD_STORE = "LocalMods/.modstore";
        public static string GetStoreFolder<T>() where T : ACsMod
        {
            if (!Directory.Exists(MOD_STORE)) Directory.CreateDirectory(MOD_STORE);
            var modFolder = $"{MOD_STORE}/{typeof(T)}";
            if (!Directory.Exists(modFolder)) Directory.CreateDirectory(modFolder);
            return modFolder;
        }
        public static string GetSoreFolder<T>() where T : ACsMod => GetStoreFolder<T>();

        public bool IsDisposed { get; private set; }

        /// Mod initialization
        public ACsMod()
        {
            IsDisposed = false;
            LoadedMods.Add(this);
        }

        public virtual void Initialize() { }

        public virtual void OnLoadCompleted() { }

        public virtual PluginInfo GetPluginInfo() =>
            new PluginInfo("Undefined", "0.0.0.0", ImmutableArray<string>.Empty);

        public virtual void Dispose()
        {
            try
            {
                Stop();
            }
            catch (Exception e)
            {
                LuaCsLogger.HandleException(e, LuaCsMessageOrigin.CSharpMod);
            }

            LoadedMods.Remove(this);
            IsDisposed = true;
        }

        /// <summary>
        /// [Obsolete] use Dispose instead. Called on plugin unloading. 
        /// </summary>
        [Obsolete]
        public abstract void Stop();
    }
}
