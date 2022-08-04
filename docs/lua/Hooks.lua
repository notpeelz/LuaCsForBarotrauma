-- luacheck: ignore 111

--[[--
Hooks are basically functions that get called when events happen in-game, like chat messages.
]]
-- @code Hook
-- @pragma nostrip

local Hook = {}


--- Adds a hook.
-- @tparam string eventname event name
-- @tparam string hookname hook name
-- @tparam function func callback
-- @realm shared
-- @usage 
-- Hook.Add("characterDeath", "characterDeathExample", function(character)
--    print(character)
-- end)
function Hook.Add(eventName, hookName, func) end

--- Removes a hook.
-- @tparam string eventname event name
-- @tparam string hookname hook name
-- @realm shared
-- @usage 
-- Hook.Remove("character.death", "characterDeathExample")
function Hook.Remove(eventName, hookName) end

--- Calls a hook.
-- @tparam string eventname event name
-- @tparam table parameters parameters to be passed in 
-- @realm shared
-- @usage 
-- Hook.Add("think", "happyDebuggingSuckers", function()
--      Hook.Call("character.death", {}) -- ruin someone's day
-- end)
function Hook.Call(eventName, parameters) end

--- Patches a method, the callback is called with an instance variable and a ptable variable, ptable contains dictionary of parameter name -> parameter
-- @tparam string className
-- @tparam string methodName
-- @tparam function callback
-- @realm shared
-- @deprecated
-- @usage 
-- Hook.HookMethod("Barotrauma.CharacterInfo", "IncreaseSkillLevel", function (instance, ptable)
--    print(string.format("%s gained % xp", instance.Character.Name, ptable.increase))
-- end, Hook.HookMethodType.After)
function Hook.HookMethod(className, methodName, callback) end

--- Game's fixed update rate, gets called normally 60 times a second.
-- @realm shared
function think() end

--- Gets called everytime someone sends a chat message, return true to cancel message
-- @tparam string message
-- @tparam client sender
-- @realm shared
function chatMessage(message, sender) end

--- Called when a client connects
-- @tparam client connectedClient
-- @realm shared
function client.connected(connectedClient) end

--- Called when a client disconnects
-- @tparam client disconnectedClient
-- @realm shared
function client.disconnected(disconnectedClient) end


--- Called on round start
-- @realm shared
function roundStart() end

--- Called on round end
-- @realm shared
function roundEnd() end

--- Gets called everytime a character is created.
-- @tparam character createdCharacter
-- @realm shared
function character.created(createdCharacter) end

--- Gets called after the character is given the job items, useful if your script only wants to check for newly created characters in campaign gamemode.
-- @tparam character character
-- @tparam WayPoint waypoint
-- @realm shared
function character.giveJobItems(character, waypoint) end

--- Gets called everytime a Character dies.
-- @tparam Character character A dead Character.
-- @realm shared
-- @usage 
-- Hook.Add("character.death", "characterDeathExample", function(character)
--    print(character)
-- end)
function character.death(character) end

--- Gets called every time an affliction is applied to a character.
-- @realm shared
function character.applyAffliction(character, limbHealth, newAffliction, allowStacking) end

--- Gets gets called every time an attack damage.
-- @realm shared
function character.applyDamage(character, attackResult, hitLimb, allowStacking) end


--- Gets called every time an affliction updates.
-- @realm shared
function afflictionUpdate(affliction, characterHealth, limb) end
--- Gets called every time an Item gets "Used".
-- @realm shared
function item.use(item, itemUser, targetLimb) end
--- Same as itemUse.
-- @realm shared
function item.secondaryUse(item, itemUser) end
--- Gets called whenever an item is used as a treatment (eg. bandages).
-- @realm shared
function item.applyTreatment(item, usingCharacter, targetCharacter, limb) end

--- Gets called whenever an item is dropped, You can return true to cancel.
-- @realm shared
function item.drop(item, character) end  

--- Gets called whenever an item is equipped. Return true to cancel.
-- @realm shared
function item.equip(item, character) end

--- Same as itemEquip, but for unequipping.
-- @realm shared
function item.unequip(item, character) end

--- Gets called every time an item is interacted, eg: picking item on ground, fixing something with wrench
-- @realm shared
function item.interact(item, characterPicker, ignoreRequiredItemsBool, forceSelectKeyBool, forceActionKeyBool) end

--- Gets called every time two items are combined, eg: drag an half empty magazine to another half empty magazine to combine
-- @realm shared
function item.combine(item, deconstructor, characterUser, allowRemove) end

--- Gets called every time an item is deconstructed. Return true to prevent item from being removed.
-- @realm shared
function item.deconstructed(item, otherItem, userCharacter) end

--- Gets called every time an item is created.
-- @realm shared
function item.created(item) end

--- Gets called every time an item is moved from one inventory slot to another, return true to cancel
-- @realm shared
function inventoryPutItem(inventory, item, characterUser, index, removeItemBool) end

--- Gets called every time items are swapped, return true to cancel
-- @realm shared
function inventoryItemSwap(inventory, item, characterUser, index, swapWholeStackBool) end

--- 
-- @realm shared
function changeFallDamage() end

--- Gets called every update when a gap passes oxygen
-- @realm shared
function gapOxygenUpdate(gap, hull1, hull2) end

---  Gets called everytime an Item receives a wire signal
-- @realm shared
function signalReceived(signal, connection) end

--- Gets called everytime the specified item receives a signal.
-- @realm shared
function signalReceived.YourItemIdentifier(signal, connection) end

--- Gets called everytime a WifiComponent starts transmitting a signal
-- @realm shared
function wifiSignalTransmitted(wifiComponent, signal, sentFromChat) end

--- Gets called everytime something is logged to the Server Log, do not call print() inside this function, i repeat, do not call print() inside this function.
-- @realm shared
function serverLog(text, serverLogMessageType) end

--- Called each time a new round start job has been assigned, this context allows for you to change the role before it's applied in game.
-- @realm shared
-- @usage
-- Hook.Add("jobsAssigned", "", function ()
--   for key, value in pairs(Client.ClientList) do
--     value.AssignedJob = JobVariant(JobPrefab.Get("assistant"), 0)
--   end
-- end)
function jobsAssigned() end

--- Check if a client is allowed to hear radio voice to another client, return true to allow, false to disallow.
-- @realm shared
function canUseVoiceRadio(sender, receiver) end

--- Changes the local voice range, return a number to change the local voice range, 1 = normal, 0.5 = lower range, 2 = higher range.
-- @realm shared
function changeLocalVoiceRange(sender, receiver) end

--- Called right before a message is going to be sent, return true to stop message from being sent.
-- @realm shared
function modifyChatMessage(chatMessage, wifiComponentSender) end

--- Called when the script execution is terminating.
-- @realm shared
function stop() end

---
-- @realm shared
function husk.clientControl(client, husk) end

---
-- @realm shared
function traitor.traitorAssigned(traitor) end

--- Return true to accept traitor candidate.
-- @realm shared
function traitor.findTraitorCandidate(character, team) end

--- Called when a melee weapon has impacted a physical object.
-- @realm shared
function meleeWeapon.handleImpact(meleeComponent, targetBody) end

--- Called when a status effect is applied to the specified item, useful for things like medical items. You can also return true to cancel out the status effect.
-- @realm shared
-- @usage
-- Hook.Add("statusEffect.apply.antibleeding1", "test", function (effect, deltaTime, item, targets, worldPosition)
--    if effect.type == ActionType.OnUse then
--        print(effect, ' ', item, ' ', targets[3])
--        return true
--    end
--end) 
function statusEffect.apply.YourItemIdentifier(statusEffect, deltaTime, item, targets, worldPosition) end

--- Called when a client tries to change his name, return false to prevent the name from being changed.
-- @realm shared
function tryChangeClientName(client, newName, newJob, newTeam) end

--- Called after all mods are executed.
-- @realm shared
function loaded() end

--- Called after the CPR skill check succeeds.
-- @realm shared
function human.CPRSuccess(animController) end

--- Called after the CPR skill check fails.
-- @realm shared
function human.CPRFailed(animController) end