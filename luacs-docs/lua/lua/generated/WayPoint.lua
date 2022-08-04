-- luacheck: ignore 111

--[[--
Barotrauma.WayPoint
]]
-- @code WayPoint
-- @pragma nostrip
local WayPoint = {}

--- Clone
-- @realm shared
-- @treturn MapEntity
function Clone() end

--- GenerateSubWaypoints
-- @realm shared
-- @tparam Submarine submarine
-- @treturn bool
function WayPoint.GenerateSubWaypoints(submarine) end

--- ConnectTo
-- @realm shared
-- @tparam WayPoint wayPoint2
function ConnectTo(wayPoint2) end

--- GetRandom
-- @realm shared
-- @tparam SpawnType spawnType
-- @tparam JobPrefab assignedJob
-- @tparam Submarine sub
-- @tparam bool useSyncedRand
-- @tparam string spawnPointTag
-- @tparam bool ignoreSubmarine
-- @treturn WayPoint
function WayPoint.GetRandom(spawnType, assignedJob, sub, useSyncedRand, spawnPointTag, ignoreSubmarine) end

--- SelectCrewSpawnPoints
-- @realm shared
-- @tparam table crew
-- @tparam Submarine submarine
-- @treturn WayPoint[]
function WayPoint.SelectCrewSpawnPoints(crew, submarine) end

--- FindHull
-- @realm shared
function FindHull() end

--- OnMapLoaded
-- @realm shared
function OnMapLoaded() end

--- InitializeLinks
-- @realm shared
function InitializeLinks() end

--- Load
-- @realm shared
-- @tparam ContentXElement element
-- @tparam Submarine submarine
-- @tparam IdRemap idRemap
-- @treturn WayPoint
function WayPoint.Load(element, submarine, idRemap) end

--- Save
-- @realm shared
-- @tparam XElement parentElement
-- @treturn XElement
function Save(parentElement) end

--- ShallowRemove
-- @realm shared
function ShallowRemove() end

--- Remove
-- @realm shared
function Remove() end

--- AddLinked
-- @realm shared
-- @tparam MapEntity entity
function AddLinked(entity) end

--- ResolveLinks
-- @realm shared
-- @tparam IdRemap childRemap
function ResolveLinks(childRemap) end

--- Move
-- @realm shared
-- @tparam Vector2 amount
function Move(amount) end

--- IsMouseOn
-- @realm shared
-- @tparam Vector2 position
-- @treturn bool
function IsMouseOn(position) end

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

--- Update
-- @realm shared
-- @tparam number deltaTime
-- @tparam Camera cam
function Update(deltaTime, cam) end

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
-- ConnectedGap, Field of type Gap
-- @realm shared
-- @Gap ConnectedGap

---
-- ConnectedDoor, Field of type Door
-- @realm shared
-- @Door ConnectedDoor

---
-- CurrentHull, Field of type Hull
-- @realm shared
-- @Hull CurrentHull

---
-- SpawnType, Field of type SpawnType
-- @realm shared
-- @SpawnType SpawnType

---
-- OnLinksChanged, Field of type function
-- @realm shared
-- @function OnLinksChanged

---
-- Name, Field of type string
-- @realm shared
-- @string Name

---
-- IdCardDesc, Field of type string
-- @realm shared
-- @string IdCardDesc

---
-- IdCardTags, Field of type String[]
-- @realm shared
-- @String[] IdCardTags

---
-- Tags, Field of type Enumerable
-- @realm shared
-- @Enumerable Tags

---
-- AssignedJob, Field of type JobPrefab
-- @realm shared
-- @JobPrefab AssignedJob

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
-- Rect, Field of type Rectangle
-- @realm shared
-- @Rectangle Rect

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
-- Linkable, Field of type bool
-- @realm shared
-- @bool Linkable

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
-- Ladders, Field of type Ladder
-- @realm shared
-- @Ladder Ladders

---
-- Stairs, Field of type Structure
-- @realm shared
-- @Structure Stairs

---
-- isObstructed, Field of type bool
-- @realm shared
-- @bool isObstructed

---
-- Tunnel, Field of type Tunnel
-- @realm shared
-- @Tunnel Tunnel

---
-- Ruin, Field of type Ruin
-- @realm shared
-- @Ruin Ruin

---
-- WayPoint.WayPointList, Field of type table
-- @realm shared
-- @table WayPoint.WayPointList

---
-- WayPoint.ShowWayPoints, Field of type bool
-- @realm shared
-- @bool WayPoint.ShowWayPoints

---
-- WayPoint.ShowSpawnPoints, Field of type bool
-- @realm shared
-- @bool WayPoint.ShowSpawnPoints

---
-- WayPoint.LadderWaypointInterval, Field of type number
-- @realm shared
-- @number WayPoint.LadderWaypointInterval

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

