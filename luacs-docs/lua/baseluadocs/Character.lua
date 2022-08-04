-- luacheck: ignore 111

--[[--
Barotrauma Character class with some additional functions and fields

Barotrauma source code: [Character.cs](https://github.com/evilfactory/Barotrauma-lua-attempt/blob/master/Barotrauma/BarotraumaShared/SharedSource/Characters/Character.cs)
]]
-- @code Character
-- @pragma nostrip

local Character = {}

-- @remove function Character.Create(characterInfo, position, seed, id, isRemotePlayer, hasAi, ragdoll) end
-- @remove function TeleportTo(worldPos) end
-- @remove Character.CharacterList

--- Creates a Character using CharacterInfo.
-- @realm server
-- @tparam CharacterInfo characterInfo
-- @tparam Vector2 position
-- @tparam string seed
-- @tparam number id
-- @tparam bool isRemotePlayer
-- @tparam bool hasAi
-- @tparam RagdollParams ragdoll
-- @treturn Character
-- @usage 
-- local vsauce = CharacterInfo("human", "custom name")
-- local character = Character.Create(vsauce, Vector2(0, 0), "some random characters")
-- print(character)
function Character.Create(characterInfo, position, seed, id, isRemotePlayer, hasAi, ragdoll) end


--- Teleports a character to a position.
-- @realm server 
-- @tparam Vector2 position
-- @usage 
-- Character.CharacterList[1].TeleportTo(Vector2(0, 0)) -- teleports first created characters to 0, 0
function TeleportTo(worldPos) end

---
-- Character.CharacterList, Table containing all characters.
-- @realm shared
-- @table Character.CharacterList
