-- luacheck: ignore 111

--[[--
Barotrauma.GameSession
]]
-- @code Game.GameSession
-- @pragma nostrip
local GameSession = {}

--- LoadPreviousSave
-- @realm shared
function LoadPreviousSave() end

--- SwitchSubmarine
-- @realm shared
-- @tparam SubmarineInfo newSubmarine
-- @tparam number cost
-- @tparam Client client
-- @treturn SubmarineInfo
function SwitchSubmarine(newSubmarine, cost, client) end

--- PurchaseSubmarine
-- @realm shared
-- @tparam SubmarineInfo newSubmarine
-- @tparam Client client
function PurchaseSubmarine(newSubmarine, client) end

--- IsSubmarineOwned
-- @realm shared
-- @tparam SubmarineInfo query
-- @treturn bool
function IsSubmarineOwned(query) end

--- IsCurrentLocationRadiated
-- @realm shared
-- @treturn bool
function IsCurrentLocationRadiated() end

--- StartRound
-- @realm shared
-- @tparam string levelSeed
-- @tparam Nullable`1 difficulty
-- @tparam LevelGenerationParams levelGenerationParams
function StartRound(levelSeed, difficulty, levelGenerationParams) end

--- StartRound
-- @realm shared
-- @tparam LevelData levelData
-- @tparam bool mirrorLevel
-- @tparam SubmarineInfo startOutpost
-- @tparam SubmarineInfo endOutpost
function StartRound(levelData, mirrorLevel, startOutpost, endOutpost) end

--- PlaceSubAtStart
-- @realm shared
-- @tparam Level level
function PlaceSubAtStart(level) end

--- Update
-- @realm shared
-- @tparam number deltaTime
function Update(deltaTime) end

--- GetMission
-- @realm shared
-- @tparam number index
-- @treturn Mission
function GetMission(index) end

--- GetMissionIndex
-- @realm shared
-- @tparam Mission mission
-- @treturn number
function GetMissionIndex(mission) end

--- EnforceMissionOrder
-- @realm shared
-- @tparam table missionIdentifiers
function EnforceMissionOrder(missionIdentifiers) end

--- GetSessionCrewCharacters
-- @realm shared
-- @tparam CharacterType type
-- @treturn ImmutableHashSet`1
function GameSession.GetSessionCrewCharacters(type) end

--- EndRound
-- @realm shared
-- @tparam string endMessage
-- @tparam table traitorResults
-- @tparam TransitionType transitionType
function EndRound(endMessage, traitorResults, transitionType) end

--- LogEndRoundStats
-- @realm shared
-- @tparam string eventId
function LogEndRoundStats(eventId) end

--- KillCharacter
-- @realm shared
-- @tparam Character character
function KillCharacter(character) end

--- ReviveCharacter
-- @realm shared
-- @tparam Character character
function ReviveCharacter(character) end

--- IsCompatibleWithEnabledContentPackages
-- @realm shared
-- @tparam IList`1 contentPackageNames
-- @tparam LocalizedString& errorMsg
-- @treturn bool
function GameSession.IsCompatibleWithEnabledContentPackages(contentPackageNames, errorMsg) end

--- Save
-- @realm shared
-- @tparam string filePath
function Save(filePath) end

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
-- Missions, Field of type Enumerable
-- @realm shared
-- @Enumerable Missions

---
-- Casualties, Field of type Enumerable
-- @realm shared
-- @Enumerable Casualties

---
-- IsRunning, Field of type bool
-- @realm shared
-- @bool IsRunning

---
-- RoundEnding, Field of type bool
-- @realm shared
-- @bool RoundEnding

---
-- Level, Field of type Level
-- @realm shared
-- @Level Level

---
-- LevelData, Field of type LevelData
-- @realm shared
-- @LevelData LevelData

---
-- MirrorLevel, Field of type bool
-- @realm shared
-- @bool MirrorLevel

---
-- Map, Field of type Map
-- @realm shared
-- @Map Map

---
-- Campaign, Field of type CampaignMode
-- @realm shared
-- @CampaignMode Campaign

---
-- StartLocation, Field of type Location
-- @realm shared
-- @Location StartLocation

---
-- EndLocation, Field of type Location
-- @realm shared
-- @Location EndLocation

---
-- SubmarineInfo, Field of type SubmarineInfo
-- @realm shared
-- @SubmarineInfo SubmarineInfo

---
-- Submarine, Field of type Submarine
-- @realm shared
-- @Submarine Submarine

---
-- SavePath, Field of type string
-- @realm shared
-- @string SavePath

---
-- EventManager, Field of type EventManager
-- @realm shared
-- @EventManager EventManager

---
-- GameMode, Field of type GameMode
-- @realm shared
-- @GameMode GameMode

---
-- CrewManager, Field of type CrewManager
-- @realm shared
-- @CrewManager CrewManager

---
-- RoundStartTime, Field of type number
-- @realm shared
-- @number RoundStartTime

---
-- TimeSpentCleaning, Field of type number
-- @realm shared
-- @number TimeSpentCleaning

---
-- TimeSpentPainting, Field of type number
-- @realm shared
-- @number TimeSpentPainting

---
-- WinningTeam, Field of type Nullable`1
-- @realm shared
-- @Nullable`1 WinningTeam

---
-- OwnedSubmarines, Field of type table
-- @realm shared
-- @table OwnedSubmarines

---
-- GameSession.MinimumLoadingTime, Field of type number
-- @realm shared
-- @number GameSession.MinimumLoadingTime

