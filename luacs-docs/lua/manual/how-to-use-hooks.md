# How to use hooks

Hooks are basically functions that get called when events happen in-game, like chat messages. They can be triggered either by Lua itself or the game code.

## Adding hooks

Hooks can be added like this:

```
Hook.Add("chatMessage", "test", function(message, client)
    print(client.Name .. " has sent " .. message)
end)
```

The event name (first argument), is case-insensitive, so you can call it chatMessage, cHaTmEsSaGe, chatmessage, etc.

## Calling hooks

You can also call hooks with the following code:

```
Hook.Call("myCustomEvent", {"some", "arguments", 123})
```

## XML Status Effect Hooks

With Lua, a new XML tags is added, it can be used to call Lua hooks inside status effects:

```
<StatusEffect type="OnUse">
    <LuaHook name="doSomething" />
</StatusEffect>
```

```
Hook.Add("doSomething", "something", function (effect, deltaTime, item, targets, worldPosition)
    print(effect, ' ', item)
end)
```

## Patching

Patching allows you to hook into existing methods in the game code, notice that it can be a little unstable depending on the method that you are patching, so be aware.

```
Hook.HookMethod("Barotrauma.CharacterInfo", "IncreaseSkillLevel", function (instance, ptable)
    print(string.format("%s gained % xp", instance.Character.Name, ptable.increase))
end, Hook.HookMethodType.After)
```

If you return anything other than nil, it will stop the execution of the method, if the method has a return type, it will also return what you returned in the Lua function. (Only in Hook.HookMethodType.After)