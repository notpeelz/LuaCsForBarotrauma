using Barotrauma;
using MoonSharp.Interpreter;

namespace TestProject.LuaCs
{
    internal static class HookPatchHelpers
    {
        public static DynValue AddPrefix<T>(this LuaCsSetup luaCs, string body, string testMethod = "Run", string? patchId = null)
        {
            var className = typeof(T).FullName;
            if (patchId != null)
            {
                return luaCs.Lua.DoString(@$"
                    return Hook.Patch('{patchId}', '{className}', '{testMethod}', function(instance, ptable)
                    {body}
                    end, Hook.HookMethodType.Before)
                ");
            }
            else
            {
                return luaCs.Lua.DoString(@$"
                    return Hook.Patch('{className}', '{testMethod}', function(instance, ptable)
                    {body}
                    end, Hook.HookMethodType.Before)
                ");
            }
        }

        public static DynValue AddPostfix<T>(this LuaCsSetup luaCs, string body, string testMethod = "Run", string? patchId = null)
        {
            var className = typeof(T).FullName;
            if (patchId != null)
            {
                return luaCs.Lua.DoString(@$"
                    return Hook.Patch('{patchId}', '{className}', '{testMethod}', function(instance, ptable)
                    {body}
                    end, Hook.HookMethodType.After)
                ");
            }
            else
            {
                return luaCs.Lua.DoString(@$"
                    return Hook.Patch('{className}', '{testMethod}', function(instance, ptable)
                    {body}
                    end, Hook.HookMethodType.After)
                ");
            }
        }
    }
}
