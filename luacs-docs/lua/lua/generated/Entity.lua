-- luacheck: ignore 111

--[[--
Barotrauma Entity class with some additional functions and fields

Barotrauma source code: [Entity.cs](https://github.com/evilfactory/Barotrauma-lua-attempt/blob/master/Barotrauma/BarotraumaShared/SharedSource/Map/Entity.cs)
]]
-- @code Entity
-- @pragma nostrip

--- Remove
-- @realm shared
function Remove() end

--- ToString
-- @realm shared
-- @treturn string
function ToString() end

--- GetEntities
-- @realm shared
-- @treturn IReadOnlyCollection`1
function Entity.GetEntities() end

--- FindFreeIdBlock
-- @realm shared
-- @tparam number minBlockSize
-- @treturn number
function Entity.FindFreeIdBlock(minBlockSize) end

--- FindEntityByID
-- @realm shared
-- @tparam number ID
-- @treturn Entity
function Entity.FindEntityByID(ID) end

--- RemoveAll
-- @realm shared
function Entity.RemoveAll() end

--- FreeID
-- @realm shared
function FreeID() end

--- DumpIds
-- @realm shared
-- @tparam number count
-- @tparam string filename
function Entity.DumpIds(count, filename) end

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
-- Entity.EntityCount, Field of type number
-- @realm shared
-- @number Entity.EntityCount

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

---
-- Entity.Spawner, Field of type EntitySpawner
-- @realm shared
-- @EntitySpawner Entity.Spawner

---
-- Entity.NullEntityID, Field of type number
-- @realm shared
-- @number Entity.NullEntityID

---
-- Entity.EntitySpawnerID, Field of type number
-- @realm shared
-- @number Entity.EntitySpawnerID

---
-- Entity.RespawnManagerID, Field of type number
-- @realm shared
-- @number Entity.RespawnManagerID

---
-- Entity.DummyID, Field of type number
-- @realm shared
-- @number Entity.DummyID

---
-- Entity.ReservedIDStart, Field of type number
-- @realm shared
-- @number Entity.ReservedIDStart

---
-- Entity.MaxEntityCount, Field of type number
-- @realm shared
-- @number Entity.MaxEntityCount

