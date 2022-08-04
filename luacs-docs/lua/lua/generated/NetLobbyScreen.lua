-- luacheck: ignore 111

--[[--
Barotrauma.NetLobbyScreen
]]
-- @code Game.NetLobbyScreen
-- @pragma nostrip
local NetLobbyScreen = {}

--- ChangeServerName
-- @realm shared
-- @tparam string n
function ChangeServerName(n) end

--- ChangeServerMessage
-- @realm shared
-- @tparam string m
function ChangeServerMessage(m) end

--- GetSubList
-- @realm shared
-- @treturn IReadOnlyList`1
function GetSubList() end

--- AddSub
-- @realm shared
-- @tparam SubmarineInfo sub
function AddSub(sub) end

--- ToggleCampaignMode
-- @realm shared
-- @tparam bool enabled
function ToggleCampaignMode(enabled) end

--- Select
-- @realm shared
function Select() end

--- RandomizeSettings
-- @realm shared
function RandomizeSettings() end

--- SetLevelDifficulty
-- @realm shared
-- @tparam number difficulty
function SetLevelDifficulty(difficulty) end

--- ToggleTraitorsEnabled
-- @realm shared
-- @tparam number dir
function ToggleTraitorsEnabled(dir) end

--- SetBotCount
-- @realm shared
-- @tparam number botCount
function SetBotCount(botCount) end

--- SetBotSpawnMode
-- @realm shared
-- @tparam BotSpawnMode botSpawnMode
function SetBotSpawnMode(botSpawnMode) end

--- SetTraitorsEnabled
-- @realm shared
-- @tparam YesNoMaybe enabled
function SetTraitorsEnabled(enabled) end

--- Deselect
-- @realm shared
function Deselect() end

--- Update
-- @realm shared
-- @tparam number deltaTime
function Update(deltaTime) end

--- GetType
-- @realm shared
-- @treturn Type
function GetType() end

--- ToString
-- @realm shared
-- @treturn string
function ToString() end

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
-- SelectedSub, Field of type SubmarineInfo
-- @realm shared
-- @SubmarineInfo SelectedSub

---
-- SelectedShuttle, Field of type SubmarineInfo
-- @realm shared
-- @SubmarineInfo SelectedShuttle

---
-- GameModes, Field of type GameModePreset[]
-- @realm shared
-- @GameModePreset[] GameModes

---
-- SelectedModeIndex, Field of type number
-- @realm shared
-- @number SelectedModeIndex

---
-- SelectedModeIdentifier, Field of type Identifier
-- @realm shared
-- @Identifier SelectedModeIdentifier

---
-- SelectedMode, Field of type GameModePreset
-- @realm shared
-- @GameModePreset SelectedMode

---
-- MissionType, Field of type MissionType
-- @realm shared
-- @MissionType MissionType

---
-- MissionTypeName, Field of type string
-- @realm shared
-- @string MissionTypeName

---
-- JobPreferences, Field of type table
-- @realm shared
-- @table JobPreferences

---
-- LevelSeed, Field of type string
-- @realm shared
-- @string LevelSeed

---
-- LastUpdateID, Field of type number
-- @realm shared
-- @number LastUpdateID

---
-- Cam, Field of type Camera
-- @realm shared
-- @Camera Cam

---
-- IsEditor, Field of type bool
-- @realm shared
-- @bool IsEditor

---
-- RadiationEnabled, Field of type bool
-- @realm shared
-- @bool RadiationEnabled

