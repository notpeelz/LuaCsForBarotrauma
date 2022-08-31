using Barotrauma;
using Microsoft.Xna.Framework;
using MoonSharp.Interpreter;
using Xunit;
using Xunit.Abstractions;

namespace TestProject.LuaCs
{
    [Collection("LuaCs")]
    public class HookPatchTests : IClassFixture<LuaCsFixture>
    {
        private readonly LuaCsSetup luaCs;

        public HookPatchTests(LuaCsFixture luaCsFixture, ITestOutputHelper output)
        {
            // XXX: we can't have multiple instances of LuaCs patching the
            // same methods, otherwise we get script ownership exceptions.
            luaCs = luaCsFixture.LuaCs;

            luaCs.MessageLogger = (prefix, o) =>
            {
                o ??= "null";
                output?.WriteLine(prefix + o);
            };

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
            luaCs.AddPrefix<PatchTarget1>("ptable.PreventExecution = true");
            target.Run();
            Assert.False(target.ran);
        }

        [Fact]
        public void TestOverrideExistingPatch()
        {
            var target = new PatchTarget1();
            luaCs.AddPrefix<PatchTarget1>(@"
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
            luaCs.AddPrefix<PatchTarget1>("replacementPatchRan = true", patchId: "test");
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
            var patchId = luaCs.AddPrefix<PatchTarget1>(@"
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
            var patchId = luaCs.AddPostfix<PatchTarget1>(@"
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
            luaCs.AddPrefix<PatchTarget2>(@"
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
            luaCs.AddPrefix<PatchTarget2>("return");
            var returnValue = target.Run();
            Assert.True(target.ran);
            Assert.Equal(5, returnValue);
        }

        [Fact]
        public void TestReturnNil()
        {
            var target = new PatchTarget2();
            // This should modify the return value to "null"
            luaCs.AddPostfix<PatchTarget2>("return nil");
            var returnValue = target.Run();
            Assert.True(target.ran);
            Assert.Null(returnValue);
        }

        [Fact]
        public void TestReturnValueType()
        {
            var target = new PatchTarget2();
            luaCs.AddPostfix<PatchTarget2>(@"
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
            luaCs.AddPostfix<PatchTarget3>(@"
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
            luaCs.AddPrefix<PatchTarget4>(@"
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
            luaCs.AddPrefix<PatchTarget5>("patchRan = true");
            var returnValue = target.Run(new Vector2(1, 2));
            Assert.True(target.ran);
            Assert.True(luaCs.Lua.Globals["patchRan"] as bool?);
            Assert.Equal("{X:1 Y:2}", returnValue);
        }

        public class PatchTarget6
        {
            public bool ran;

            public sbyte RunSByte(sbyte v)
            {
                ran = true;
                return v;
            }

            public byte RunByte(byte v)
            {
                ran = true;
                return v;
            }

            public short RunInt16(short v)
            {
                ran = true;
                return v;
            }

            public ushort RunUInt16(ushort v)
            {
                ran = true;
                return v;
            }

            public int RunInt32(int v)
            {
                ran = true;
                return v;
            }

            public uint RunUInt32(uint v)
            {
                ran = true;
                return v;
            }

            public long RunInt64(long v)
            {
                ran = true;
                return v;
            }

            public ulong RunUInt64(ulong v)
            {
                ran = true;
                return v;
            }

            public float RunSingle(float v)
            {
                ran = true;
                return v;
            }

            public double RunDouble(double v)
            {
                ran = true;
                return v;
            }
        }

        [Fact]
        public void TestCastPrimitiveWrapperSByte()
        {
            var target = new PatchTarget6();
            luaCs.AddPrefix<PatchTarget6>(@"
                ptable['v'] = SByte(-6)
            ", testMethod: nameof(PatchTarget6.RunSByte));
            var returnValue = target.RunSByte(-5);
            Assert.True(target.ran);
            Assert.Equal(-6, returnValue);
        }

        [Fact]
        public void TestCastPrimitiveWrapperByte()
        {
            var target = new PatchTarget6();
            luaCs.AddPrefix<PatchTarget6>(@"
                ptable['v'] = Byte(6)
            ", testMethod: nameof(PatchTarget6.RunByte));
            var returnValue = target.RunByte(5);
            Assert.True(target.ran);
            Assert.Equal(6, returnValue);
        }

        [Fact]
        public void TestCastPrimitiveWrapperInt16()
        {
            var target = new PatchTarget6();
            luaCs.AddPrefix<PatchTarget6>(@"
                ptable['v'] = Int16(-25000)
            ", testMethod: nameof(PatchTarget6.RunInt16));
            var returnValue = target.RunInt16(30000);
            Assert.True(target.ran);
            Assert.Equal(-25000, returnValue);
        }

        [Fact]
        public void TestCastPrimitiveWrapperUInt16()
        {
            var target = new PatchTarget6();
            luaCs.AddPrefix<PatchTarget6>(@"
                ptable['v'] = UInt16(60000)
            ", testMethod: nameof(PatchTarget6.RunUInt16));
            var returnValue = target.RunUInt16(50000);
            Assert.True(target.ran);
            Assert.Equal(60000, returnValue);
        }

        [Fact]
        public void TestCastPrimitiveWrapperInt32()
        {
            var target = new PatchTarget6();
            luaCs.AddPrefix<PatchTarget6>(@"
                ptable['v'] = Int32('7FFFFF00', 16)
            ", testMethod: nameof(PatchTarget6.RunInt32));
            var returnValue = target.RunInt32(900000);
            Assert.True(target.ran);
            Assert.Equal(0x7FFFFF00, returnValue);
        }

        [Fact]
        public void TestCastPrimitiveWrapperUInt32()
        {
            var target = new PatchTarget6();
            luaCs.AddPrefix<PatchTarget6>(@"
                ptable['v'] = UInt32('AFFFFFFF', 16)
            ", testMethod: nameof(PatchTarget6.RunUInt32));
            var returnValue = target.RunUInt32(300500);
            Assert.True(target.ran);
            Assert.Equal(0xAFFFFFFF, returnValue);
        }

        [Fact]
        public void TestCastPrimitiveWrapperInt64()
        {
            var target = new PatchTarget6();
            luaCs.AddPrefix<PatchTarget6>(@"
                ptable['v'] = Int64('7555555555555555', 16)
            ", testMethod: nameof(PatchTarget6.RunInt64));
            var returnValue = target.RunInt64(0x7FFFFFFF00000000);
            Assert.True(target.ran);
            Assert.Equal(0x7555555555555555, returnValue);
        }

        [Fact]
        public void TestCastPrimitiveWrapperUInt64()
        {
            var target = new PatchTarget6();
            luaCs.AddPrefix<PatchTarget6>(@"
                ptable['v'] = UInt64('F555555555555555', 16)
            ", testMethod: nameof(PatchTarget6.RunUInt64));
            var returnValue = target.RunUInt64(0xFFFFFFFF00000000);
            Assert.True(target.ran);
            Assert.Equal(0xF555555555555555, returnValue);
        }

        [Fact]
        public void TestCastPrimitiveWrapperSingle()
        {
            var target = new PatchTarget6();
            luaCs.AddPrefix<PatchTarget6>(@"
                ptable['v'] = Single(123.456)
            ", testMethod: nameof(PatchTarget6.RunSingle));
            var returnValue = target.RunSingle(111.111f);
            Assert.True(target.ran);
            Assert.Equal(123.456f, returnValue);
        }

        [Fact]
        public void TestCastPrimitiveWrapperDouble()
        {
            var target = new PatchTarget6();
            luaCs.AddPrefix<PatchTarget6>(@"
                ptable['v'] = 123.456
            ", testMethod: nameof(PatchTarget6.RunDouble));
            var returnValue = target.RunDouble(111.111d);
            Assert.True(target.ran);
            Assert.Equal(123.456d, returnValue);
        }
    }
}
