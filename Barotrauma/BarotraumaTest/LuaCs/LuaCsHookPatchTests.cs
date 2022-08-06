using Barotrauma;
using Microsoft.Xna.Framework;
using MoonSharp.Interpreter;
using System;
using System.Diagnostics;
using Xunit;
using Xunit.Abstractions;

namespace TestProject.LuaCs
{
    public class LuaCsHookPatchTests
    {
        private readonly LuaCsSetup luaCs = new() { CatchLuaErrors = false };

        public LuaCsHookPatchTests(ITestOutputHelper output)
        {
            Console.SetOut(new TestOutputTextWriterAdapter(output));
            Trace.Listeners.Add(new TestOutputTraceListenerAdapter(output));

            UserData.RegisterType<TestValueType>();
            UserData.RegisterType<IBogusInterface>();
            UserData.RegisterType<InterfaceImplementingType>();
            UserData.RegisterType<PatchTarget1>();
            UserData.RegisterType<PatchTarget2>();
            UserData.RegisterType<PatchTarget3>();
            UserData.RegisterType<PatchTarget4>();
            UserData.RegisterType<PatchTarget5>();
            UserData.RegisterType<PatchTarget6>();

            luaCs.Initialize();
            luaCs.Lua.Globals["TestValueType"] = UserData.CreateStatic<TestValueType>();
            luaCs.Lua.Globals["InterfaceImplementingType"] = UserData.CreateStatic<InterfaceImplementingType>();
        }

        private DynValue AddPrefix<T>(string body, string testMethod = "Run", string? patchId = null)
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

        private DynValue AddPostfix<T>(string body, string testMethod = "Run", string? patchId = null)
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

        private DynValue RemovePrefix<T>(string patchName, string testMethod = "Run")
        {
            var className = typeof(T).FullName;
            return luaCs.Lua.DoString($@"
                return Hook.RemovePatch('{patchName}', '{className}', '{testMethod}', Hook.HookMethodType.Before)
            ");
        }

        private DynValue RemovePostfix<T>(string patchName, string testMethod = "Run")
        {
            var className = typeof(T).FullName;
            return luaCs.Lua.DoString($@"
                return Hook.RemovePatch('{patchName}', '{className}', '{testMethod}', Hook.HookMethodType.After)
            ");
        }

        public class PatchTarget1
        {
            public bool ran;

            public void Run()
            {
                ran = true;
            }
        }

        [Fact]
        public void TestFullMethodReplacement()
        {
            var target = new PatchTarget1();
            AddPrefix<PatchTarget1>("ptable.PreventExecution = true");
            target.Run();
            Assert.False(target.ran);
        }

        [Fact]
        public void TestOverrideExistingPatch()
        {
            var target = new PatchTarget1();
            AddPrefix<PatchTarget1>(@"
                ptable.PreventExecution = true
                originalPatchRan = true
            ", patchId: "test");
            target.Run();
            Assert.False(target.ran);
            Assert.True(luaCs.Lua.Globals["originalPatchRan"] as bool?);

            // Reset this global so we can test if the original patch ran
            // after replacing it.
            luaCs.Lua.Globals["originalPatchRan"] = false;

            // Replace the existing prefix, but don't prevent execution this time
            AddPrefix<PatchTarget1>("replacementPatchRan = true", patchId: "test");
            target.Run();
            Assert.True(target.ran);

            // Make sure the original patch didn't run
            Assert.False(luaCs.Lua.Globals["originalPatchRan"] as bool?);

            // Test if the replacement patch ran
            Assert.True(luaCs.Lua.Globals["replacementPatchRan"] as bool?);
        }

        [Fact]
        public void TestRemovePrefix()
        {
            var target = new PatchTarget1();
            var patchId = AddPrefix<PatchTarget1>(@"
                ptable.PreventExecution = true
                patchRan = true
            ");
            target.Run();
            Assert.False(target.ran);
            Assert.True(luaCs.Lua.Globals["patchRan"] as bool?);

            luaCs.Lua.Globals["patchRan"] = false;

            Assert.Equal(DataType.String, patchId.Type);
            RemovePrefix<PatchTarget1>(patchId.String);
            target.Run();
            Assert.True(target.ran);
            Assert.False(luaCs.Lua.Globals["patchRan"] as bool?);
        }

        [Fact]
        public void TestRemovePostfix()
        {
            var target = new PatchTarget1();
            var patchId = AddPostfix<PatchTarget1>(@"
                patchRan = true
            ");
            target.Run();
            Assert.True(target.ran);
            Assert.True(luaCs.Lua.Globals["patchRan"] as bool?);

            target.ran = false;
            luaCs.Lua.Globals["patchRan"] = false;

            Assert.Equal(DataType.String, patchId.Type);
            RemovePostfix<PatchTarget1>(patchId.String);
            target.Run();
            Assert.True(target.ran);
            Assert.False(luaCs.Lua.Globals["patchRan"] as bool?);
        }

        public struct TestValueType
        {
            public int foo;

            public TestValueType(int foo)
            {
                this.foo = foo;
            }
        }

        public class PatchTarget2
        {
            public bool ran;

            public object Run()
            {
                ran = true;
                return 5;
            }
        }

        public interface IBogusInterface
        {
            int GetFoo();
        }

        public class InterfaceImplementingType : IBogusInterface
        {
            private readonly int foo;

            public InterfaceImplementingType(int foo)
            {
                this.foo = foo;
            }

            public int GetFoo() => foo;
        }

        [Fact]
        public void TestReturnBoxed()
        {
            var target = new PatchTarget2();
            AddPrefix<PatchTarget2>(@"
                ptable.PreventExecution = true
                return 123
            ");
            var returnValue = target.Run();
            Assert.False(target.ran);
            Assert.Equal(123, (int)(double)returnValue);
        }

        [Fact]
        public void TestReturnVoid()
        {
            var target = new PatchTarget2();
            // This should have no effect
            AddPrefix<PatchTarget2>("return");
            var returnValue = target.Run();
            Assert.True(target.ran);
            Assert.Equal(5, returnValue);
        }

        [Fact]
        public void TestReturnNil()
        {
            var target = new PatchTarget2();
            // This should modify the return value to "null"
            AddPostfix<PatchTarget2>("return nil");
            var returnValue = target.Run();
            Assert.True(target.ran);
            Assert.Null(returnValue);
        }

        [Fact]
        public void TestReturnValueType()
        {
            var target = new PatchTarget2();
            AddPostfix<PatchTarget2>(@"
                return TestValueType.__new(100)
            ");
            var returnValue = target.Run();
            Assert.True(target.ran);
            Assert.IsType<TestValueType>(returnValue);
            Assert.Equal(100, ((TestValueType)returnValue).foo);
        }

        public class PatchTarget3
        {
            public bool ran;

            public IBogusInterface Run()
            {
                ran = true;
                return new InterfaceImplementingType(5);
            }
        }

        [Fact]
        public void TestReturnInterfaceImplementingType()
        {
            var target = new PatchTarget3();
            AddPostfix<PatchTarget3>(@"
                return InterfaceImplementingType.__new(100);
            ");
            var returnValue = target.Run()!;
            Assert.True(target.ran);
            Assert.Equal(100, returnValue.GetFoo());
        }

        public class PatchTarget4
        {
            public bool ran;

            public void Run(int a, out string outString, ref byte refByte, string b)
            {
                ran = true;
                outString = a + b + refByte;
            }
        }

        [Fact]
        public void TestModifyParameters()
        {
            var target = new PatchTarget4();
            AddPrefix<PatchTarget4>(@"
                ptable['a'] = Int32(100)
                ptable['b'] = 'abc'
                ptable['refByte'] = Byte(4)
            ");
            byte refByte = 123;
            target.Run(5, out var outString, ref refByte, "foo");
            Assert.True(target.ran);
            Assert.Equal("100abc4", outString);
        }

        public class PatchTarget5
        {
            public bool ran;

            public string Run(Vector2 vec)
            {
                ran = true;
                return vec.ToString();
            }
        }

        [Fact]
        public void TestParameterValueType()
        {
            var target = new PatchTarget5();
            AddPrefix<PatchTarget5>("patchRan = true");
            var returnValue = target.Run(new Vector2(1, 2));
            Assert.True(target.ran);
            Assert.True(luaCs.Lua.Globals["patchRan"] as bool?);
            Assert.Equal("{X:1 Y:2}", returnValue);
        }

        public class PatchTarget6
        {
            public bool ran;

            public byte Run(byte b)
            {
                ran = true;
                return b;
            }
        }

        [Fact]
        public void TestCastWithImplicitOperator()
        {
            var target = new PatchTarget6();
            AddPrefix<PatchTarget6>(@"
                ptable['b'] = Byte(6)
            ");
            var returnValue = target.Run(5);
            Assert.True(target.ran);
            Assert.Equal(6, returnValue);
        }
    }
}
