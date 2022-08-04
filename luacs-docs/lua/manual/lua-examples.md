# Lua Examples

```
Hook.Add('chatMessage', 'suicide_mod', function(msg, client)
    if msg == '!suicide' and client.Character ~= nil then
        client.Character.Kill(CauseOfDeathType.Unknown)
        Game.SendMessage(client.name .. ' killed himself!', ChatMessageType.Server)
        return true -- hide message
    end
end)
```

<br>

```
Hook.Add("itemApplyTreatment", "testItemApplyTreatment", function (item, user, character, targetlimb)
    if item.Prefab.Identifier == "antibleeding1" then
        local pos = character.WorldPosition
        Game.Explode(pos, 1, 500, 5000, 5000, 5000)

        Game.RemoveItem(item)
    end
end)
```

<br>


```
-- for example: create an item in xml named RandomComponent and add the wiring inputs/outputs trigger_random and random_out
Hook.Add("signalReceived", "signalReceivedTest", function (signal, connection)
    if connection.Item.Prefab.Identifier == "RandomComponent" and connection.Name == "trigger_random" then
        connection.Item.SendSignal(tostring(Random.Range(0, 100)), "random_out")
    end
end)
```

<br>

```
local discordWebHook = "your discord webhook here"

local function escapeQuotes(str)
    return str:gsub("\"", "\\\"")
end

Hook.Add("chatMessage", "discordIntegration", function (msg, client)
    local escapedName = escapeQuotes(client.name)
    local escapedMessage = escapeQuotes(msg)

    Networking.RequestPostHTTP(discordWebHook, function(result) end, '{\"content\": \"'..escapedMessage..'\", \"username\": \"'..escapedName..'\"}')
end)
```

<br>


```
-- by jimmyl
Hook.Add("chatMessage","controlhuskcommand",function(msg, client)
    if msg == "!controlhusk" then
        if client.Character ~= nil then
            if not client.Character.IsDead then
                return true
            end
        end
        if not client.InGame then
            return true
        end
        
        local chars = Character.CharacterList
        local suitablechars = {}
        for i = 1, #chars, 1 do
            local charat = chars[i]
            if not charat.IsDead and string.match(string.lower(charat.SpeciesName.Value), "husk") and not charat.IsRemotelyControlled then
                table.insert(suitablechars, charat)
            end
        end

        if #suitablechars >= 1 then
            client.SetClientCharacter(suitablechars[Random.Range(1, #suitablechars)])
        end

        return true -- hide message
    end
end)
```