using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;

namespace Barotrauma
{
    public abstract class ACsMod : IDisposable
    {
        private static List<ACsMod> mods = new List<ACsMod>();
        public static List<ACsMod> LoadedMods { get => mods; }

        private const string MOD_STORE = "LocalMods/.modstore";
        public static string GetSoreFolder<T>() where T : ACsMod
        {
            if (!Directory.Exists(MOD_STORE)) Directory.CreateDirectory(MOD_STORE);
            var modFolder = $"{MOD_STORE}/{typeof(T)}";
            if (!Directory.Exists(modFolder)) Directory.CreateDirectory(modFolder);
            return modFolder;
        }


        public bool IsDisposed { get; private set; }

        /// Mod initialization
        public ACsMod()
        {
            IsDisposed = false;
            LoadedMods.Add(this);
        }

        public void Dispose()
        {
            try
            {
                Stop();
            }
            catch (Exception e)
            {
                GameMain.LuaCs.HandleException(e, origin: LuaCsMessageOrigin.CSharpMod);
            }

            LoadedMods.Remove(this);
            IsDisposed = true;
        }

        /// Error or client exit
        public abstract void Stop();
    }
}