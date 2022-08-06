using System;
using MoonSharp.Interpreter;
using Microsoft.Xna.Framework;
using FarseerPhysics.Dynamics;
using LuaCsCompatPatchFunc = Barotrauma.LuaCsPatch;

namespace Barotrauma
{
    public delegate DynValue CallLuaFunctionFunc(object function, params object[] args);

    internal static class LuaCustomConverters
    {
        private static CallLuaFunctionFunc CallLuaFunction;

        public static void Initialize(CallLuaFunctionFunc callLuaFunction)
        {
            CallLuaFunction = callLuaFunction;

            RegisterAction<Item>();
            RegisterAction<Character>();
            RegisterAction<Entity>();
            RegisterAction();

            RegisterFunc<Fixture, Vector2, Vector2, float, float>();
            RegisterFunc<AIObjective, bool>();

            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(
                DataType.Function,
                typeof(LuaCsAction),
                v => (LuaCsAction)(args => CallLuaFunction(v.Function, args)));
            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(
                DataType.Function,
                typeof(LuaCsFunc),
                v => (LuaCsFunc)(args => CallLuaFunction(v.Function, args)));
            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(
                DataType.Function,
                typeof(LuaCsCompatPatchFunc),
                v => (LuaCsCompatPatchFunc)((self, args) => CallLuaFunction(v.Function, self, args)));
            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(
                DataType.Function,
                typeof(LuaCsPatchFunc),
                v => (LuaCsPatchFunc)((self, args) => CallLuaFunction(v.Function, self, args)));

#if CLIENT
            RegisterAction<float>();
            RegisterAction<Microsoft.Xna.Framework.Graphics.SpriteBatch, float>();

            {
                DynValue Call(object function, params object[] arguments) => CallLuaFunction(function, arguments);
                void RegisterHandler<T>(Func<Closure, T> converter)
                    => Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(DataType.Function, typeof(T), v => converter(v.Function));

                RegisterHandler(f => (GUIComponent.SecondaryButtonDownHandler)(
                (a1, a2) => Call(f, a1, a2).CastToBool()));

                RegisterHandler(f => (GUIButton.OnClickedHandler)(
                (a1, a2) => Call(f, a1, a2).CastToBool()));
                RegisterHandler(f => (GUIButton.OnButtonDownHandler)(
                () => Call(f).CastToBool()));
                RegisterHandler(f => (GUIButton.OnPressedHandler)(
                () => Call(f).CastToBool()));

                RegisterHandler(f => (GUIColorPicker.OnColorSelectedHandler)(
                (a1, a2) => Call(f, a1, a2).CastToBool()));

                RegisterHandler(f => (GUIDropDown.OnSelectedHandler)(
                (a1, a2) => Call(f, a1, a2).CastToBool()));

                RegisterHandler(f => (GUIListBox.OnSelectedHandler)(
                (a1, a2) => Call(f, a1, a2).CastToBool()));
                RegisterHandler(f => (GUIListBox.OnRearrangedHandler)(
                (a1, a2) => Call(f, a1, a2)));
                RegisterHandler(f => (GUIListBox.CheckSelectedHandler)(
                () => Call(f).ToObject()));

                RegisterHandler(f => (GUINumberInput.OnValueEnteredHandler)(
                (a1) => Call(f, a1)));
                RegisterHandler(f => (GUINumberInput.OnValueChangedHandler)(
                (a1) => Call(f, a1)));

                RegisterHandler(f => (GUIProgressBar.ProgressGetterHandler)(
                () => (float)(Call(f).CastToNumber() ?? 0)));

                RegisterHandler(f => (GUIRadioButtonGroup.RadioButtonGroupDelegate)(
                (a1, a2) => Call(f, a1, a2)));

                RegisterHandler(f => (GUIScrollBar.OnMovedHandler)(
                (a1, a2) => Call(f, a1, a2).CastToBool()));
                RegisterHandler(f => (GUIScrollBar.ScrollConversion)(
                (a1, a2) => (float)(Call(f, a1, a2).CastToNumber() ?? 0)));

                RegisterHandler(f => (GUITextBlock.TextGetterHandler)(
                () => Call(f, new object[0]).CastToString()));

                RegisterHandler(f => (GUITextBox.OnEnterHandler)(
                (a1, a2) => Call(f, a1, a2).CastToBool()));
                RegisterHandler(f => (GUITextBox.OnTextChangedHandler)(
                (a1, a2) => Call(f, a1, a2).CastToBool()));
                RegisterHandler(f => (TextBoxEvent)(
                (a1, a2) => Call(f, a1, a2)));

                RegisterHandler(f => (GUITickBox.OnSelectedHandler)(
                (a1) => Call(f, a1).CastToBool()));

            }
#endif

            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(DataType.Table, typeof(Pair<JobPrefab, int>), v =>
            {
                return new Pair<JobPrefab, int>((JobPrefab)v.Table.Get(1).ToObject(), (int)v.Table.Get(2).CastToNumber());
            });

            Script.GlobalOptions.CustomConverters.SetClrToScriptCustomConversion<ulong>((Script script, ulong v) => 
            {
                return DynValue.NewString(v.ToString());
            });

            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(DataType.String, typeof(ulong), v =>
            {
                return ulong.Parse(v.String);
            });

            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(
                scriptDataType: DataType.UserData,
                clrDataType: typeof(sbyte),
                canConvert: luaValue => luaValue.UserData?.Object is LuaSByte,
                converter: luaValue => luaValue.UserData.Object is LuaSByte v
                    ? (sbyte)v
                    : throw new ScriptRuntimeException("use SByte(value) to pass primitive type 'sbyte' to C#"));
            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(
                scriptDataType: DataType.UserData,
                clrDataType: typeof(byte),
                canConvert: luaValue => luaValue.UserData?.Object is LuaByte,
                converter: luaValue => luaValue.UserData.Object is LuaByte v
                    ? (byte)v
                    : throw new ScriptRuntimeException("use Byte(value) to pass primitive type 'byte' to C#"));
            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(
                scriptDataType: DataType.UserData,
                clrDataType: typeof(short),
                canConvert: luaValue => luaValue.UserData?.Object is LuaInt16,
                converter: luaValue => luaValue.UserData.Object is LuaInt16 v
                    ? (short)v
                    : throw new ScriptRuntimeException("use Int16(value) to pass primitive type 'short' to C#"));
            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(
                scriptDataType: DataType.UserData,
                clrDataType: typeof(ushort),
                canConvert: luaValue => luaValue.UserData?.Object is LuaUInt16,
                converter: luaValue => luaValue.UserData.Object is LuaUInt16 v
                    ? (ushort)v
                    : throw new ScriptRuntimeException("use UInt16(value) to pass primitive type 'ushort' to C#"));
            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(
                scriptDataType: DataType.UserData,
                clrDataType: typeof(int),
                canConvert: luaValue => luaValue.UserData?.Object is LuaInt32,
                converter: luaValue => luaValue.UserData.Object is LuaInt32 v
                    ? (int)v
                    : throw new ScriptRuntimeException("use Int32(value) to pass primitive type 'int' to C#"));
            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(
                scriptDataType: DataType.UserData,
                clrDataType: typeof(uint),
                canConvert: luaValue => luaValue.UserData?.Object is LuaUInt32,
                converter: luaValue => luaValue.UserData.Object is LuaUInt32 v
                    ? (uint)v
                    : throw new ScriptRuntimeException("use UInt32(value) to pass primitive type 'uint' to C#"));
            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(
                scriptDataType: DataType.UserData,
                clrDataType: typeof(long),
                canConvert: luaValue => luaValue.UserData?.Object is LuaInt64,
                converter: luaValue => luaValue.UserData.Object is LuaInt64 v
                    ? (long)v
                    : throw new ScriptRuntimeException("use Int64(value) to pass primitive type 'long' to C#"));
            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(
                scriptDataType: DataType.UserData,
                clrDataType: typeof(ulong),
                canConvert: luaValue => luaValue.UserData?.Object is LuaUInt64,
                converter: luaValue => luaValue.UserData.Object is LuaUInt64 v
                    ? (ulong)v
                    : throw new ScriptRuntimeException("use UInt64(value) to pass primitive type 'ulong' to C#"));
            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(
                scriptDataType: DataType.UserData,
                clrDataType: typeof(float),
                canConvert: luaValue => luaValue.UserData?.Object is LuaSingle,
                converter: luaValue => luaValue.UserData.Object is LuaSingle v
                    ? (float)v
                    : throw new ScriptRuntimeException("use Single(value) to pass primitive type 'float' to C#"));
            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(
                scriptDataType: DataType.UserData,
                clrDataType: typeof(double),
                canConvert: luaValue => luaValue.UserData?.Object is LuaDouble,
                converter: luaValue => luaValue.UserData.Object is LuaDouble v
                    ? (double)v
                    : throw new ScriptRuntimeException("use Double(value) to pass primitive type 'double' to C#"));
        }

        public static void RegisterAction<T>()
        {
            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(DataType.Function, typeof(Action<T>), v =>
            {
                var function = v.Function;
                return (Action<T>)(p => CallLuaFunction(function, p));
            });

            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(DataType.ClrFunction, typeof(Action<T>), v =>
            {
                var function = v.Function;
                return (Action<T>)(p => CallLuaFunction(function, p));
            });
        }

        public static void RegisterAction<T1, T2>()
        {
            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(DataType.Function, typeof(Action<T1, T2>), v =>
            {
                var function = v.Function;
                return (Action<T1, T2>)((a1, a2) => CallLuaFunction(function, a1, a2));
            });

            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(DataType.ClrFunction, typeof(Action<T1, T2>), v =>
            {
                var function = v.Function;
                return (Action<T1, T2>)((a1, a2) => CallLuaFunction(function, a1, a2));
            });
        }

        public static void RegisterAction()
        {
            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(DataType.Function, typeof(Action), v => 
            {
                var function = v.Function;
                return (Action)(() => CallLuaFunction(function));
            });

            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(DataType.ClrFunction, typeof(Action), v =>
            {
                var function = v.Function;
                return (Action)(() => CallLuaFunction(function));
            });
        }

        public static void RegisterFunc<T1>()
        {
            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(DataType.Function, typeof(Func<T1>), v =>
            {
                var function = v.Function;
                return (Func<T1>)(() => function.Call().ToObject<T1>());
            });

            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(DataType.ClrFunction, typeof(Func<T1>), v =>
            {
                var function = v.Function;
                return (Func<T1>)(() => function.Call().ToObject<T1>());
            });
        }

        public static void RegisterFunc<T1, T2>()
        {
            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(DataType.Function, typeof(Func<T1, T2>), v =>
            {
                var function = v.Function;
                return (Func<T1, T2>)((T1 a) => function.Call(a).ToObject<T2>());
            });

            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(DataType.ClrFunction, typeof(Func<T1, T2>), v =>
            {
                var function = v.Function;
                return (Func<T1, T2>)((T1 a) => function.Call(a).ToObject<T2>());
            });
        }

        public static void RegisterFunc<T1, T2, T3, T4, T5>()
        {
            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(DataType.Function, typeof(Func<T1, T2, T3, T4, T5>), v =>
            {
                var function = v.Function;
                return (Func<T1, T2, T3, T4, T5>)((T1 a, T2 b, T3 c, T4 d) => function.Call(a, b, c, d).ToObject<T5>());
            });

            Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(DataType.Function, typeof(Func<T1, T2, T3, T4, T5>), v =>
            {
                var function = v.Function;
                return (Func<T1, T2, T3, T4, T5>)((T1 a, T2 b, T3 c, T4 d) => function.Call(a, b, c, d).ToObject<T5>());
            });
        }
    }
}
