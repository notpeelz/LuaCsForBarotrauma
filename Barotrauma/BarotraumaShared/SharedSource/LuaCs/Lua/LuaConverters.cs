using System;
using MoonSharp.Interpreter;
using Microsoft.Xna.Framework;
using FarseerPhysics.Dynamics;
using LuaCsCompatPatchFunc = Barotrauma.LuaCsPatch;

namespace Barotrauma
{
    partial class LuaCsSetup
    {
        private static bool registered;

        private void RegisterLuaConverters()
        {
            if (registered) return;
            registered = true;

            RegisterAction<Item>();
            RegisterAction<Character>();
            RegisterAction<Entity>();
            RegisterAction<float>();
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
            RegisterAction<Microsoft.Xna.Framework.Graphics.SpriteBatch, GUICustomComponent>();
            RegisterAction<float, Microsoft.Xna.Framework.Graphics.SpriteBatch>();
            RegisterAction<Microsoft.Xna.Framework.Graphics.SpriteBatch, float>();

            {
                DynValue Call(object function, params object[] arguments) => CallLuaFunction(function, arguments);
                void RegisterHandler<T>(Func<Closure, T> converter)
                    => Script.GlobalOptions.CustomConverters.SetScriptToClrCustomConversion(DataType.Function, typeof(T), v => converter(v.Function));

                RegisterHandler(f => (GUIComponent.SecondaryButtonDownHandler)(
                (a1, a2) => Call(f, a1, a2)?.CastToBool() ?? default));

                RegisterHandler(f => (GUIButton.OnClickedHandler)(
                (a1, a2) => Call(f, a1, a2)?.CastToBool() ?? default));
                RegisterHandler(f => (GUIButton.OnButtonDownHandler)(
                () => Call(f)?.CastToBool() ?? default));
                RegisterHandler(f => (GUIButton.OnPressedHandler)(
                () => Call(f)?.CastToBool() ?? default));

                RegisterHandler(f => (GUIColorPicker.OnColorSelectedHandler)(
                (a1, a2) => Call(f, a1, a2)?.CastToBool() ?? default));

                RegisterHandler(f => (GUIDropDown.OnSelectedHandler)(
                (a1, a2) => Call(f, a1, a2)?.CastToBool() ?? default));

                RegisterHandler(f => (GUIListBox.OnSelectedHandler)(
                (a1, a2) => Call(f, a1, a2)?.CastToBool() ?? default));
                RegisterHandler(f => (GUIListBox.OnRearrangedHandler)(
                (a1, a2) => Call(f, a1, a2)));
                RegisterHandler(f => (GUIListBox.CheckSelectedHandler)(
                () => Call(f)?.ToObject() ?? default));

                RegisterHandler(f => (GUINumberInput.OnValueEnteredHandler)(
                (a1) => Call(f, a1)));
                RegisterHandler(f => (GUINumberInput.OnValueChangedHandler)(
                (a1) => Call(f, a1)));

                RegisterHandler(f => (GUIProgressBar.ProgressGetterHandler)(
                () => (float)(Call(f)?.CastToNumber() ?? default)));

                RegisterHandler(f => (GUIRadioButtonGroup.RadioButtonGroupDelegate)(
                (a1, a2) => Call(f, a1, a2)));

                RegisterHandler(f => (GUIScrollBar.OnMovedHandler)(
                (a1, a2) => Call(f, a1, a2)?.CastToBool() ?? default));
                RegisterHandler(f => (GUIScrollBar.ScrollConversion)(
                (a1, a2) => (float)(Call(f, a1, a2)?.CastToNumber() ?? default)));

                RegisterHandler(f => (GUITextBlock.TextGetterHandler)(
                () => Call(f, new object[0])?.CastToString() ?? default));

                RegisterHandler(f => (GUITextBox.OnEnterHandler)(
                (a1, a2) => Call(f, a1, a2)?.CastToBool() ?? default));
                RegisterHandler(f => (GUITextBox.OnTextChangedHandler)(
                (a1, a2) => Call(f, a1, a2)?.CastToBool() ?? default));
                RegisterHandler(f => (TextBoxEvent)(
                (a1, a2) => Call(f, a1, a2)));

                RegisterHandler(f => (GUITickBox.OnSelectedHandler)(
                (a1) => Call(f, a1)?.CastToBool() ?? default));

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
        }

        private void RegisterAction<T>()
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

        private void RegisterAction<T1, T2>()
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

        private void RegisterAction()
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

        private void RegisterFunc<T1>()
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

        private void RegisterFunc<T1, T2>()
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

        private void RegisterFunc<T1, T2, T3, T4, T5>()
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
