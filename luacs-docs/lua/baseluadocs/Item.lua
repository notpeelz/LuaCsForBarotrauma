-- luacheck: ignore 111

--[[--
Barotrauma Item class with some additional functions and fields

Barotrauma source code: [Item.cs](https://github.com/evilfactory/Barotrauma-lua-attempt/blob/master/Barotrauma/BarotraumaShared/SharedSource/Items/Item.cs)
]]
-- @code Item
-- @pragma nostrip

Item = {}

--- Adds to remove queue, use this instead of Remove, to prevent desync.
-- @realm server 
function Item.AddToRemoveQueue(item) end

--- Gets a component from an item by a string name.
-- @treturn Component component
-- @realm server 
function GetComponentString(componentName) end

--- Sends a signal.
-- @realm server 
function SendSignal(signalOrString, connectionOrConnectionName) end

---
-- Physics body of the item.
-- @realm shared
-- @PhysicsBody body
-- @usage
-- Item.ItemList[1].body.position = CreateVector2(0, 0) -- teleports first item created to 0, 0 of the level

---
-- Item.ItemList, Table containing all items.
-- @realm shared
-- @Item Item.ItemList

---
-- Prefab, ItemPrefab containing the original prefab of the item.
-- @realm shared
-- @ItemPrefab Prefab

---
-- WorldPosition, Vector2 position of the item in the world
-- @realm shared
-- @Vector2 WorldPosition
