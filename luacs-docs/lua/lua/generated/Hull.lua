-- luacheck: ignore 111

--[[--
Barotrauma.Hull
]]
-- @code Hull
-- @pragma nostrip
local Hull = {}

--- IncreaseSectionColorOrStrength
-- @realm shared
-- @tparam BackgroundSection section
-- @tparam Nullable`1 color
-- @tparam Nullable`1 strength
-- @tparam bool requiresUpdate
-- @tparam bool isCleaning
function IncreaseSectionColorOrStrength(section, color, strength, requiresUpdate, isCleaning) end

--- SetSectionColorOrStrength
-- @realm shared
-- @tparam BackgroundSection section
-- @tparam Nullable`1 color
-- @tparam Nullable`1 strength
function SetSectionColorOrStrength(section, color, strength) end

--- CleanSection
-- @realm shared
-- @tparam BackgroundSection section
-- @tparam number cleanVal
-- @tparam bool updateRequired
function CleanSection(section, cleanVal, updateRequired) end

--- Load
-- @realm shared
-- @tparam ContentXElement element
-- @tparam Submarine submarine
-- @tparam IdRemap idRemap
-- @treturn Hull
function Hull.Load(element, submarine, idRemap) end

--- Save
-- @realm shared
-- @tparam XElement parentElement
-- @treturn XElement
function Save(parentElement) end

--- IsMouseOn
-- @realm shared
-- @tparam Vector2 position
-- @treturn bool
function IsMouseOn(position) end

--- ServerEventWrite
-- @realm shared
-- @tparam IWriteMessage msg
-- @tparam Client c
-- @tparam IData extraData
function ServerEventWrite(msg, c, extraData) end

--- ServerEventRead
-- @realm shared
-- @tparam IReadMessage msg
-- @tparam Client c
function ServerEventRead(msg, c) end

--- GetBorders
-- @realm shared
-- @treturn Rectangle
function Hull.GetBorders() end

--- Clone
-- @realm shared
-- @treturn MapEntity
function Clone() end

--- GenerateEntityGrid
-- @realm shared
-- @tparam Rectangle worldRect
-- @treturn EntityGrid
function Hull.GenerateEntityGrid(worldRect) end

--- GenerateEntityGrid
-- @realm shared
-- @tparam Submarine submarine
-- @treturn EntityGrid
function Hull.GenerateEntityGrid(submarine) end

--- SetModuleTags
-- @realm shared
-- @tparam Enumerable tags
function SetModuleTags(tags) end

--- OnMapLoaded
-- @realm shared
function OnMapLoaded() end

--- AddToGrid
-- @realm shared
-- @tparam Submarine submarine
function AddToGrid(submarine) end

--- GetWaveIndex
-- @realm shared
-- @tparam Vector2 position
-- @treturn number
function GetWaveIndex(position) end

--- GetWaveIndex
-- @realm shared
-- @tparam number xPos
-- @treturn number
function GetWaveIndex(xPos) end

--- Move
-- @realm shared
-- @tparam Vector2 amount
function Move(amount) end

--- ShallowRemove
-- @realm shared
function ShallowRemove() end

--- Remove
-- @realm shared
function Remove() end

--- AddFireSource
-- @realm shared
-- @tparam FireSource fireSource
function AddFireSource(fireSource) end

--- AddDecal
-- @realm shared
-- @tparam number decalId
-- @tparam Vector2 worldPosition
-- @tparam number scale
-- @tparam bool isNetworkEvent
-- @tparam Nullable`1 spriteIndex
-- @treturn Decal
function AddDecal(decalId, worldPosition, scale, isNetworkEvent, spriteIndex) end

--- AddDecal
-- @realm shared
-- @tparam string decalName
-- @tparam Vector2 worldPosition
-- @tparam number scale
-- @tparam bool isNetworkEvent
-- @tparam Nullable`1 spriteIndex
-- @treturn Decal
function AddDecal(decalName, worldPosition, scale, isNetworkEvent, spriteIndex) end

--- Update
-- @realm shared
-- @tparam number deltaTime
-- @tparam Camera cam
function Update(deltaTime, cam) end

--- ApplyFlowForces
-- @realm shared
-- @tparam number deltaTime
-- @tparam Item item
function ApplyFlowForces(deltaTime, item) end

--- Extinguish
-- @realm shared
-- @tparam number deltaTime
-- @tparam number amount
-- @tparam Vector2 position
-- @tparam bool extinguishRealFires
-- @tparam bool extinguishFakeFires
function Extinguish(deltaTime, amount, position, extinguishRealFires, extinguishFakeFires) end

--- RemoveFire
-- @realm shared
-- @tparam FireSource fire
function RemoveFire(fire) end

--- GetConnectedHulls
-- @realm shared
-- @tparam bool includingThis
-- @tparam Nullable`1 searchDepth
-- @tparam bool ignoreClosedGaps
-- @treturn Enumerable
function GetConnectedHulls(includingThis, searchDepth, ignoreClosedGaps) end

--- GetApproximateDistance
-- @realm shared
-- @tparam Vector2 startPos
-- @tparam Vector2 endPos
-- @tparam Hull targetHull
-- @tparam number maxDistance
-- @tparam number distanceMultiplierPerClosedDoor
-- @treturn number
function GetApproximateDistance(startPos, endPos, targetHull, maxDistance, distanceMultiplierPerClosedDoor) end

--- FindHull
-- @realm shared
-- @tparam Vector2 position
-- @tparam Hull guess
-- @tparam bool useWorldCoordinates
-- @tparam bool inclusive
-- @treturn Hull
function Hull.FindHull(position, guess, useWorldCoordinates, inclusive) end

--- FindHullUnoptimized
-- @realm shared
-- @tparam Vector2 position
-- @tparam Hull guess
-- @tparam bool useWorldCoordinates
-- @tparam bool inclusive
-- @treturn Hull
function Hull.FindHullUnoptimized(position, guess, useWorldCoordinates, inclusive) end

--- DetectItemVisibility
-- @realm shared
-- @tparam Character c
function Hull.DetectItemVisibility(c) end

--- CreateRoomName
-- @realm shared
-- @treturn string
function CreateRoomName() end

--- IsTaggedAirlock
-- @realm shared
-- @treturn bool
function IsTaggedAirlock() end

--- LeadsOutside
-- @realm shared
-- @tparam Character character
-- @treturn bool
function LeadsOutside(character) end

--- GetCleanTarget
-- @realm shared
-- @tparam Vector2 worldPosition
-- @treturn Hull
function Hull.GetCleanTarget(worldPosition) end

--- GetBackgroundSection
-- @realm shared
-- @tparam Vector2 worldPosition
-- @treturn BackgroundSection
function GetBackgroundSection(worldPosition) end

--- GetBackgroundSectionsViaContaining
-- @realm shared
-- @tparam Rectangle rectArea
-- @treturn Enumerable
function GetBackgroundSectionsViaContaining(rectArea) end

--- DoesSectionMatch
-- @realm shared
-- @tparam number index
-- @tparam number row
-- @treturn bool
function DoesSectionMatch(index, row) end

--- AddLinked
-- @realm shared
-- @tparam MapEntity entity
function AddLinked(entity) end

--- ResolveLinks
-- @realm shared
-- @tparam IdRemap childRemap
function ResolveLinks(childRemap) end

--- HasUpgrade
-- @realm shared
-- @tparam Identifier identifier
-- @treturn bool
function HasUpgrade(identifier) end

--- GetUpgrade
-- @realm shared
-- @tparam Identifier identifier
-- @treturn Upgrade
function GetUpgrade(identifier) end

--- GetUpgrades
-- @realm shared
-- @treturn table
function GetUpgrades() end

--- SetUpgrade
-- @realm shared
-- @tparam Upgrade upgrade
-- @tparam bool createNetworkEvent
function SetUpgrade(upgrade, createNetworkEvent) end

--- AddUpgrade
-- @realm shared
-- @tparam Upgrade upgrade
-- @tparam bool createNetworkEvent
-- @treturn bool
function AddUpgrade(upgrade, createNetworkEvent) end

--- FlipX
-- @realm shared
-- @tparam bool relativeToSub
function FlipX(relativeToSub) end

--- FlipY
-- @realm shared
-- @tparam bool relativeToSub
function FlipY(relativeToSub) end

--- RemoveLinked
-- @realm shared
-- @tparam MapEntity e
function RemoveLinked(e) end

--- GetLinkedEntities
-- @realm shared
-- @tparam HashSet`1 list
-- @tparam Nullable`1 maxDepth
-- @tparam function filter
-- @treturn HashSet`1
function GetLinkedEntities(list, maxDepth, filter) end

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
-- SerializableProperties, Field of type table
-- @realm shared
-- @table SerializableProperties

---
-- Name, Field of type string
-- @realm shared
-- @string Name

---
-- DisplayName, Field of type LocalizedString
-- @realm shared
-- @LocalizedString DisplayName

---
-- OutpostModuleTags, Field of type Enumerable
-- @realm shared
-- @Enumerable OutpostModuleTags

---
-- RoomName, Field of type string
-- @realm shared
-- @string RoomName

---
-- AmbientLight, Field of type Color
-- @realm shared
-- @Color AmbientLight

---
-- Rect, Field of type Rectangle
-- @realm shared
-- @Rectangle Rect

---
-- Linkable, Field of type bool
-- @realm shared
-- @bool Linkable

---
-- LethalPressure, Field of type number
-- @realm shared
-- @number LethalPressure

---
-- Size, Field of type Vector2
-- @realm shared
-- @Vector2 Size

---
-- CeilingHeight, Field of type number
-- @realm shared
-- @number CeilingHeight

---
-- Surface, Field of type number
-- @realm shared
-- @number Surface

---
-- WorldSurface, Field of type number
-- @realm shared
-- @number WorldSurface

---
-- WaterVolume, Field of type number
-- @realm shared
-- @number WaterVolume

---
-- Oxygen, Field of type number
-- @realm shared
-- @number Oxygen

---
-- IsWetRoom, Field of type bool
-- @realm shared
-- @bool IsWetRoom

---
-- AvoidStaying, Field of type bool
-- @realm shared
-- @bool AvoidStaying

---
-- WaterPercentage, Field of type number
-- @realm shared
-- @number WaterPercentage

---
-- OxygenPercentage, Field of type number
-- @realm shared
-- @number OxygenPercentage

---
-- Volume, Field of type number
-- @realm shared
-- @number Volume

---
-- Pressure, Field of type number
-- @realm shared
-- @number Pressure

---
-- WaveY, Field of type Single[]
-- @realm shared
-- @Single[] WaveY

---
-- WaveVel, Field of type Single[]
-- @realm shared
-- @Single[] WaveVel

---
-- BackgroundSections, Field of type table
-- @realm shared
-- @table BackgroundSections

---
-- SupportsPaintedColors, Field of type bool
-- @realm shared
-- @bool SupportsPaintedColors

---
-- FireSources, Field of type table
-- @realm shared
-- @table FireSources

---
-- FakeFireSources, Field of type table
-- @realm shared
-- @table FakeFireSources

---
-- BallastFlora, Field of type BallastFloraBehavior
-- @realm shared
-- @BallastFloraBehavior BallastFlora

---
-- DisallowedUpgrades, Field of type string
-- @realm shared
-- @string DisallowedUpgrades

---
-- FlippedX, Field of type bool
-- @realm shared
-- @bool FlippedX

---
-- FlippedY, Field of type bool
-- @realm shared
-- @bool FlippedY

---
-- IsHighlighted, Field of type bool
-- @realm shared
-- @bool IsHighlighted

---
-- WorldRect, Field of type Rectangle
-- @realm shared
-- @Rectangle WorldRect

---
-- Sprite, Field of type Sprite
-- @realm shared
-- @Sprite Sprite

---
-- DrawBelowWater, Field of type bool
-- @realm shared
-- @bool DrawBelowWater

---
-- DrawOverWater, Field of type bool
-- @realm shared
-- @bool DrawOverWater

---
-- AllowedLinks, Field of type Enumerable
-- @realm shared
-- @Enumerable AllowedLinks

---
-- ResizeHorizontal, Field of type bool
-- @realm shared
-- @bool ResizeHorizontal

---
-- ResizeVertical, Field of type bool
-- @realm shared
-- @bool ResizeVertical

---
-- RectWidth, Field of type number
-- @realm shared
-- @number RectWidth

---
-- RectHeight, Field of type number
-- @realm shared
-- @number RectHeight

---
-- SpriteDepthOverrideIsSet, Field of type bool
-- @realm shared
-- @bool SpriteDepthOverrideIsSet

---
-- SpriteOverrideDepth, Field of type number
-- @realm shared
-- @number SpriteOverrideDepth

---
-- SpriteDepth, Field of type number
-- @realm shared
-- @number SpriteDepth

---
-- Scale, Field of type number
-- @realm shared
-- @number Scale

---
-- HiddenInGame, Field of type bool
-- @realm shared
-- @bool HiddenInGame

---
-- Position, Field of type Vector2
-- @realm shared
-- @Vector2 Position

---
-- SimPosition, Field of type Vector2
-- @realm shared
-- @Vector2 SimPosition

---
-- SoundRange, Field of type number
-- @realm shared
-- @number SoundRange

---
-- SightRange, Field of type number
-- @realm shared
-- @number SightRange

---
-- RemoveIfLinkedOutpostDoorInUse, Field of type bool
-- @realm shared
-- @bool RemoveIfLinkedOutpostDoorInUse

---
-- Layer, Field of type string
-- @realm shared
-- @string Layer

---
-- Removed, Field of type bool
-- @realm shared
-- @bool Removed

---
-- IdFreed, Field of type bool
-- @realm shared
-- @bool IdFreed

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
-- properties, Field of type table
-- @realm shared
-- @table properties

---
-- Visible, Field of type bool
-- @realm shared
-- @bool Visible

---
-- ConnectedGaps, Field of type table
-- @realm shared
-- @table ConnectedGaps

---
-- OriginalAmbientLight, Field of type Nullable`1
-- @realm shared
-- @Nullable`1 OriginalAmbientLight

---
-- xBackgroundMax, Field of type number
-- @realm shared
-- @number xBackgroundMax

---
-- yBackgroundMax, Field of type number
-- @realm shared
-- @number yBackgroundMax

---
-- Hull.HullList, Field of type table
-- @realm shared
-- @table Hull.HullList

---
-- Hull.EntityGrids, Field of type table
-- @realm shared
-- @table Hull.EntityGrids

---
-- Hull.ShowHulls, Field of type bool
-- @realm shared
-- @bool Hull.ShowHulls

---
-- Hull.EditWater, Field of type bool
-- @realm shared
-- @bool Hull.EditWater

---
-- Hull.EditFire, Field of type bool
-- @realm shared
-- @bool Hull.EditFire

---
-- Hull.WaveStiffness, Field of type number
-- @realm shared
-- @number Hull.WaveStiffness

---
-- Hull.WaveSpread, Field of type number
-- @realm shared
-- @number Hull.WaveSpread

---
-- Hull.WaveDampening, Field of type number
-- @realm shared
-- @number Hull.WaveDampening

---
-- Hull.OxygenDistributionSpeed, Field of type number
-- @realm shared
-- @number Hull.OxygenDistributionSpeed

---
-- Hull.OxygenDeteriorationSpeed, Field of type number
-- @realm shared
-- @number Hull.OxygenDeteriorationSpeed

---
-- Hull.OxygenConsumptionSpeed, Field of type number
-- @realm shared
-- @number Hull.OxygenConsumptionSpeed

---
-- Hull.WaveWidth, Field of type number
-- @realm shared
-- @number Hull.WaveWidth

---
-- Hull.MaxCompress, Field of type number
-- @realm shared
-- @number Hull.MaxCompress

---
-- Hull.BackgroundSectionSize, Field of type number
-- @realm shared
-- @number Hull.BackgroundSectionSize

---
-- Hull.BackgroundSectionsPerNetworkEvent, Field of type number
-- @realm shared
-- @number Hull.BackgroundSectionsPerNetworkEvent

---
-- Hull.MaxDecalsPerHull, Field of type number
-- @realm shared
-- @number Hull.MaxDecalsPerHull

---
-- Prefab, Field of type MapEntityPrefab
-- @realm shared
-- @MapEntityPrefab Prefab

---
-- unresolvedLinkedToID, Field of type table
-- @realm shared
-- @table unresolvedLinkedToID

---
-- DisallowedUpgradeSet, Field of type HashSet`1
-- @realm shared
-- @HashSet`1 DisallowedUpgradeSet

---
-- linkedTo, Field of type table
-- @realm shared
-- @table linkedTo

---
-- ShouldBeSaved, Field of type bool
-- @realm shared
-- @bool ShouldBeSaved

---
-- ExternalHighlight, Field of type bool
-- @realm shared
-- @bool ExternalHighlight

---
-- OriginalModuleIndex, Field of type number
-- @realm shared
-- @number OriginalModuleIndex

---
-- OriginalContainerIndex, Field of type number
-- @realm shared
-- @number OriginalContainerIndex

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

