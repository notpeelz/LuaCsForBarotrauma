-- luacheck: ignore 111

--[[--
Barotrauma.Level
]]
-- @code Level
-- @pragma nostrip
local Level = {}

--- GenerateMissionResources
-- @realm shared
-- @tparam ItemPrefab prefab
-- @tparam number requiredAmount
-- @tparam Single& rotation
-- @treturn table
function GenerateMissionResources(prefab, requiredAmount, rotation) end

--- GetRandomItemPos
-- @realm shared
-- @tparam PositionType spawnPosType
-- @tparam number randomSpread
-- @tparam number minDistFromSubs
-- @tparam number offsetFromWall
-- @tparam function filter
-- @treturn Vector2
function GetRandomItemPos(spawnPosType, randomSpread, minDistFromSubs, offsetFromWall, filter) end

--- TryGetInterestingPositionAwayFromPoint
-- @realm shared
-- @tparam bool useSyncedRand
-- @tparam PositionType positionType
-- @tparam number minDistFromSubs
-- @tparam Vector2& position
-- @tparam Vector2 awayPoint
-- @tparam number minDistFromPoint
-- @tparam function filter
-- @treturn bool
function TryGetInterestingPositionAwayFromPoint(useSyncedRand, positionType, minDistFromSubs, position, awayPoint, minDistFromPoint, filter) end

--- TryGetInterestingPosition
-- @realm shared
-- @tparam bool useSyncedRand
-- @tparam PositionType positionType
-- @tparam number minDistFromSubs
-- @tparam Vector2& position
-- @tparam function filter
-- @treturn bool
function TryGetInterestingPosition(useSyncedRand, positionType, minDistFromSubs, position, filter) end

--- TryGetInterestingPosition
-- @realm shared
-- @tparam bool useSyncedRand
-- @tparam PositionType positionType
-- @tparam number minDistFromSubs
-- @tparam Point& position
-- @tparam Vector2 awayPoint
-- @tparam number minDistFromPoint
-- @tparam function filter
-- @treturn bool
function TryGetInterestingPosition(useSyncedRand, positionType, minDistFromSubs, position, awayPoint, minDistFromPoint, filter) end

--- Update
-- @realm shared
-- @tparam number deltaTime
-- @tparam Camera cam
function Update(deltaTime, cam) end

--- GetBottomPosition
-- @realm shared
-- @tparam number xPosition
-- @treturn Vector2
function GetBottomPosition(xPosition) end

--- GetAllCells
-- @realm shared
-- @treturn table
function GetAllCells() end

--- GetCells
-- @realm shared
-- @tparam Vector2 worldPos
-- @tparam number searchDepth
-- @treturn table
function GetCells(worldPos, searchDepth) end

--- GetClosestCell
-- @realm shared
-- @tparam Vector2 worldPos
-- @treturn VoronoiCell
function GetClosestCell(worldPos) end

--- IsCloseToStart
-- @realm shared
-- @tparam Vector2 position
-- @tparam number minDist
-- @treturn bool
function IsCloseToStart(position, minDist) end

--- IsCloseToEnd
-- @realm shared
-- @tparam Vector2 position
-- @tparam number minDist
-- @treturn bool
function IsCloseToEnd(position, minDist) end

--- IsCloseToStart
-- @realm shared
-- @tparam Point position
-- @tparam number minDist
-- @treturn bool
function IsCloseToStart(position, minDist) end

--- IsCloseToEnd
-- @realm shared
-- @tparam Point position
-- @tparam number minDist
-- @treturn bool
function IsCloseToEnd(position, minDist) end

--- PrepareBeaconStation
-- @realm shared
function PrepareBeaconStation() end

--- CheckBeaconActive
-- @realm shared
-- @treturn bool
function CheckBeaconActive() end

--- SpawnCorpses
-- @realm shared
function SpawnCorpses() end

--- SpawnNPCs
-- @realm shared
function SpawnNPCs() end

--- GetRealWorldDepth
-- @realm shared
-- @tparam number worldPositionY
-- @treturn number
function GetRealWorldDepth(worldPositionY) end

--- DebugSetStartLocation
-- @realm shared
-- @tparam Location newStartLocation
function DebugSetStartLocation(newStartLocation) end

--- DebugSetEndLocation
-- @realm shared
-- @tparam Location newEndLocation
function DebugSetEndLocation(newEndLocation) end

--- Remove
-- @realm shared
function Remove() end

--- ServerEventWrite
-- @realm shared
-- @tparam IWriteMessage msg
-- @tparam Client c
-- @tparam IData extraData
function ServerEventWrite(msg, c, extraData) end

--- Generate
-- @realm shared
-- @tparam LevelData levelData
-- @tparam bool mirror
-- @tparam SubmarineInfo startOutpost
-- @tparam SubmarineInfo endOutpost
-- @treturn Level
function Level.Generate(levelData, mirror, startOutpost, endOutpost) end

--- GetTooCloseCells
-- @realm shared
-- @tparam Vector2 position
-- @tparam number minDistance
-- @treturn table
function GetTooCloseCells(position, minDistance) end

--- FreeID
-- @realm shared
function FreeID() end

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
-- Level.Loaded, Field of type Level
-- @realm shared
-- @Level Level.Loaded

---
-- AbyssArea, Field of type Rectangle
-- @realm shared
-- @Rectangle AbyssArea

---
-- AbyssStart, Field of type number
-- @realm shared
-- @number AbyssStart

---
-- AbyssEnd, Field of type number
-- @realm shared
-- @number AbyssEnd

---
-- StartPosition, Field of type Vector2
-- @realm shared
-- @Vector2 StartPosition

---
-- StartExitPosition, Field of type Vector2
-- @realm shared
-- @Vector2 StartExitPosition

---
-- Size, Field of type Point
-- @realm shared
-- @Point Size

---
-- EndPosition, Field of type Vector2
-- @realm shared
-- @Vector2 EndPosition

---
-- EndExitPosition, Field of type Vector2
-- @realm shared
-- @Vector2 EndExitPosition

---
-- BottomPos, Field of type number
-- @realm shared
-- @number BottomPos

---
-- SeaFloorTopPos, Field of type number
-- @realm shared
-- @number SeaFloorTopPos

---
-- CrushDepth, Field of type number
-- @realm shared
-- @number CrushDepth

---
-- RealWorldCrushDepth, Field of type number
-- @realm shared
-- @number RealWorldCrushDepth

---
-- SeaFloor, Field of type LevelWall
-- @realm shared
-- @LevelWall SeaFloor

---
-- Ruins, Field of type table
-- @realm shared
-- @table Ruins

---
-- Wrecks, Field of type table
-- @realm shared
-- @table Wrecks

---
-- BeaconStation, Field of type Submarine
-- @realm shared
-- @Submarine BeaconStation

---
-- ExtraWalls, Field of type table
-- @realm shared
-- @table ExtraWalls

---
-- UnsyncedExtraWalls, Field of type table
-- @realm shared
-- @table UnsyncedExtraWalls

---
-- Tunnels, Field of type table
-- @realm shared
-- @table Tunnels

---
-- Caves, Field of type table
-- @realm shared
-- @table Caves

---
-- PositionsOfInterest, Field of type table
-- @realm shared
-- @table PositionsOfInterest

---
-- StartOutpost, Field of type Submarine
-- @realm shared
-- @Submarine StartOutpost

---
-- EndOutpost, Field of type Submarine
-- @realm shared
-- @Submarine EndOutpost

---
-- EqualityCheckValues, Field of type table
-- @realm shared
-- @table EqualityCheckValues

---
-- EntitiesBeforeGenerate, Field of type table
-- @realm shared
-- @table EntitiesBeforeGenerate

---
-- EntityCountBeforeGenerate, Field of type number
-- @realm shared
-- @number EntityCountBeforeGenerate

---
-- EntityCountAfterGenerate, Field of type number
-- @realm shared
-- @number EntityCountAfterGenerate

---
-- TopBarrier, Field of type Body
-- @realm shared
-- @Body TopBarrier

---
-- BottomBarrier, Field of type Body
-- @realm shared
-- @Body BottomBarrier

---
-- LevelObjectManager, Field of type LevelObjectManager
-- @realm shared
-- @LevelObjectManager LevelObjectManager

---
-- Generating, Field of type bool
-- @realm shared
-- @bool Generating

---
-- StartLocation, Field of type Location
-- @realm shared
-- @Location StartLocation

---
-- EndLocation, Field of type Location
-- @realm shared
-- @Location EndLocation

---
-- Mirrored, Field of type bool
-- @realm shared
-- @bool Mirrored

---
-- Seed, Field of type string
-- @realm shared
-- @string Seed

---
-- Difficulty, Field of type number
-- @realm shared
-- @number Difficulty

---
-- Type, Field of type LevelType
-- @realm shared
-- @LevelType Type

---
-- Level.IsLoadedOutpost, Field of type bool
-- @realm shared
-- @bool Level.IsLoadedOutpost

---
-- GenerationParams, Field of type LevelGenerationParams
-- @realm shared
-- @LevelGenerationParams GenerationParams

---
-- BackgroundTextureColor, Field of type Color
-- @realm shared
-- @Color BackgroundTextureColor

---
-- BackgroundColor, Field of type Color
-- @realm shared
-- @Color BackgroundColor

---
-- WallColor, Field of type Color
-- @realm shared
-- @Color WallColor

---
-- PathPoints, Field of type table
-- @realm shared
-- @table PathPoints

---
-- AbyssResources, Field of type table
-- @realm shared
-- @table AbyssResources

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
-- AbyssIslands, Field of type table
-- @realm shared
-- @table AbyssIslands

---
-- siteCoordsX, Field of type table
-- @realm shared
-- @table siteCoordsX

---
-- siteCoordsY, Field of type table
-- @realm shared
-- @table siteCoordsY

---
-- distanceField, Field of type table
-- @realm shared
-- @table distanceField

---
-- LevelData, Field of type LevelData
-- @realm shared
-- @LevelData LevelData

---
-- Level.ForcedDifficulty, Field of type Nullable`1
-- @realm shared
-- @Nullable`1 Level.ForcedDifficulty

---
-- Level.MaxEntityDepth, Field of type number
-- @realm shared
-- @number Level.MaxEntityDepth

---
-- Level.ShaftHeight, Field of type number
-- @realm shared
-- @number Level.ShaftHeight

---
-- Level.MaxSubmarineWidth, Field of type number
-- @realm shared
-- @number Level.MaxSubmarineWidth

---
-- Level.ExitDistance, Field of type number
-- @realm shared
-- @number Level.ExitDistance

---
-- Level.GridCellSize, Field of type number
-- @realm shared
-- @number Level.GridCellSize

---
-- Level.DefaultRealWorldCrushDepth, Field of type number
-- @realm shared
-- @number Level.DefaultRealWorldCrushDepth

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

