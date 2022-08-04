-- luacheck: ignore 111

--[[--
Barotrauma EntitySpawner class with some additional functions and fields

Barotrauma source code: [EntitySpawner.cs](https://github.com/evilfactory/Barotrauma-lua-attempt/blob/master/Barotrauma/BarotraumaShared/SharedSource/Networking/EntitySpawner.cs)
]]
-- @code Entity.Spawner
-- @pragma nostrip


--- CreateNetworkEvent
-- @realm shared
-- @tparam SpawnOrRemove spawnOrRemove
function CreateNetworkEvent(spawnOrRemove) end

--- ServerEventWrite
-- @realm shared
-- @tparam IWriteMessage message
-- @tparam Client client
-- @tparam IData extraData
function ServerEventWrite(message, client, extraData) end

--- ToString
-- @realm shared
-- @treturn string
function ToString() end

--- AddItemToSpawnQueue
-- @realm shared
-- @tparam ItemPrefab itemPrefab
-- @tparam Vector2 worldPosition
-- @tparam Nullable`1 condition
-- @tparam Nullable`1 quality
-- @tparam function onSpawned
function AddItemToSpawnQueue(itemPrefab, worldPosition, condition, quality, onSpawned) end

--- AddItemToSpawnQueue
-- @realm shared
-- @tparam ItemPrefab itemPrefab
-- @tparam Vector2 position
-- @tparam Submarine sub
-- @tparam Nullable`1 condition
-- @tparam Nullable`1 quality
-- @tparam function onSpawned
function AddItemToSpawnQueue(itemPrefab, position, sub, condition, quality, onSpawned) end

--- AddItemToSpawnQueue
-- @realm shared
-- @tparam ItemPrefab itemPrefab
-- @tparam Inventory inventory
-- @tparam Nullable`1 condition
-- @tparam Nullable`1 quality
-- @tparam function onSpawned
-- @tparam bool spawnIfInventoryFull
-- @tparam bool ignoreLimbSlots
-- @tparam InvSlotType slot
function AddItemToSpawnQueue(itemPrefab, inventory, condition, quality, onSpawned, spawnIfInventoryFull, ignoreLimbSlots, slot) end

--- AddCharacterToSpawnQueue
-- @realm shared
-- @tparam Identifier speciesName
-- @tparam Vector2 worldPosition
-- @tparam function onSpawn
function AddCharacterToSpawnQueue(speciesName, worldPosition, onSpawn) end

--- AddCharacterToSpawnQueue
-- @realm shared
-- @tparam Identifier speciesName
-- @tparam Vector2 position
-- @tparam Submarine sub
-- @tparam function onSpawn
function AddCharacterToSpawnQueue(speciesName, position, sub, onSpawn) end

--- AddCharacterToSpawnQueue
-- @realm shared
-- @tparam Identifier speciesName
-- @tparam Vector2 worldPosition
-- @tparam CharacterInfo characterInfo
-- @tparam function onSpawn
function AddCharacterToSpawnQueue(speciesName, worldPosition, characterInfo, onSpawn) end

--- AddEntityToRemoveQueue
-- @realm shared
-- @tparam Entity entity
function AddEntityToRemoveQueue(entity) end

--- AddItemToRemoveQueue
-- @realm shared
-- @tparam Item item
function AddItemToRemoveQueue(item) end

--- IsInSpawnQueue
-- @realm shared
-- @tparam Predicate`1 predicate
-- @treturn bool
function IsInSpawnQueue(predicate) end

--- CountSpawnQueue
-- @realm shared
-- @tparam Predicate`1 predicate
-- @treturn number
function CountSpawnQueue(predicate) end

--- IsInRemoveQueue
-- @realm shared
-- @tparam Entity entity
-- @treturn bool
function IsInRemoveQueue(entity) end

--- Update
-- @realm shared
-- @tparam bool createNetworkEvents
function Update(createNetworkEvents) end

--- Reset
-- @realm shared
function Reset() end

--- FreeID
-- @realm shared
function FreeID() end

--- Remove
-- @realm shared
function Remove() end

--- GetType
-- @realm shared
-- @treturn Type
function GetType() end

--- Equals
-- @realm shared
-- @tparam Object obj
-- @treturn bool
function Equals(obj) end

--- GetHashCode
-- @realm shared
-- @treturn number
function GetHashCode() end

---
-- Removed, Field of type bool
-- @realm shared
-- @bool Removed

---
-- IdFreed, Field of type bool
-- @realm shared
-- @bool IdFreed

---
-- SimPosition, Field of type Vector2
-- @realm shared
-- @Vector2 SimPosition

---
-- Position, Field of type Vector2
-- @realm shared
-- @Vector2 Position

---
-- WorldPosition, Field of type Vector2
-- @realm shared
-- @Vector2 WorldPosition

---
-- DrawPosition, Field of type Vector2
-- @realm shared
-- @Vector2 DrawPosition

---
-- Submarine, Field of type Submarine
-- @realm shared
-- @Submarine Submarine

---
-- AiTarget, Field of type AITarget
-- @realm shared
-- @AITarget AiTarget

---
-- InDetectable, Field of type bool
-- @realm shared
-- @bool InDetectable

---
-- SpawnTime, Field of type number
-- @realm shared
-- @number SpawnTime

---
-- ErrorLine, Field of type string
-- @realm shared
-- @string ErrorLine

---
-- ID, Field of type number
-- @realm shared
-- @number ID

---
-- CreationStackTrace, Field of type string
-- @realm shared
-- @string CreationStackTrace

---
-- CreationIndex, Field of type number
-- @realm shared
-- @number CreationIndex

