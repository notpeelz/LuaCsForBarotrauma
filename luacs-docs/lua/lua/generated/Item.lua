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


--- ApplyStatusEffects
-- @realm shared
-- @tparam function type
-- @tparam number deltaTime
-- @tparam Character character
-- @tparam Limb limb
-- @tparam Entity useTarget
-- @tparam bool isNetworkEvent
-- @tparam Nullable`1 worldPosition
function ApplyStatusEffects(type, deltaTime, character, limb, useTarget, isNetworkEvent, worldPosition) end

--- ApplyStatusEffect
-- @realm shared
-- @tparam StatusEffect effect
-- @tparam function type
-- @tparam number deltaTime
-- @tparam Character character
-- @tparam Limb limb
-- @tparam Entity useTarget
-- @tparam bool isNetworkEvent
-- @tparam bool checkCondition
-- @tparam Nullable`1 worldPosition
function ApplyStatusEffect(effect, type, deltaTime, character, limb, useTarget, isNetworkEvent, checkCondition, worldPosition) end

--- AddDamage
-- @realm shared
-- @tparam Character attacker
-- @tparam Vector2 worldPosition
-- @tparam Attack attack
-- @tparam number deltaTime
-- @tparam bool playSound
-- @treturn AttackResult
function AddDamage(attacker, worldPosition, attack, deltaTime, playSound) end

--- SendPendingNetworkUpdates
-- @realm shared
function SendPendingNetworkUpdates() end

--- CreateStatusEvent
-- @realm shared
function CreateStatusEvent() end

--- Update
-- @realm shared
-- @tparam number deltaTime
-- @tparam Camera cam
function Update(deltaTime, cam) end

--- UpdateTransform
-- @realm shared
function UpdateTransform() end

--- FlipX
-- @realm shared
-- @tparam bool relativeToSub
function FlipX(relativeToSub) end

--- FlipY
-- @realm shared
-- @tparam bool relativeToSub
function FlipY(relativeToSub) end

--- GetConnectedComponents
-- @realm shared
-- @tparam bool recursive
-- @tparam bool allowTraversingBackwards
-- @treturn table
function GetConnectedComponents(recursive, allowTraversingBackwards) end

--- GetConnectedComponentsRecursive
-- @realm shared
-- @tparam Connection c
-- @tparam bool ignoreInactiveRelays
-- @tparam bool allowTraversingBackwards
-- @treturn table
function GetConnectedComponentsRecursive(c, ignoreInactiveRelays, allowTraversingBackwards) end

--- FindController
-- @realm shared
-- @tparam Nullable`1 tags
-- @treturn Controller
function FindController(tags) end

--- TryFindController
-- @realm shared
-- @tparam Controller& controller
-- @tparam Nullable`1 tags
-- @treturn bool
function TryFindController(controller, tags) end

--- SendSignal
-- @realm shared
-- @tparam string signal
-- @tparam string connectionName
function SendSignal(signal, connectionName) end

--- SendSignal
-- @realm shared
-- @tparam Signal signal
-- @tparam string connectionName
function SendSignal(signal, connectionName) end

--- SendSignal
-- @realm shared
-- @tparam Signal signal
-- @tparam Connection connection
function SendSignal(signal, connection) end

--- IsInsideTrigger
-- @realm shared
-- @tparam Vector2 worldPosition
-- @treturn bool
function IsInsideTrigger(worldPosition) end

--- IsInsideTrigger
-- @realm shared
-- @tparam Vector2 worldPosition
-- @tparam Rectangle& transformedTrigger
-- @treturn bool
function IsInsideTrigger(worldPosition, transformedTrigger) end

--- CanClientAccess
-- @realm shared
-- @tparam Client c
-- @treturn bool
function CanClientAccess(c) end

--- TryInteract
-- @realm shared
-- @tparam Character user
-- @tparam bool ignoreRequiredItems
-- @tparam bool forceSelectKey
-- @tparam bool forceUseKey
-- @treturn bool
function TryInteract(user, ignoreRequiredItems, forceSelectKey, forceUseKey) end

--- GetContainedItemConditionPercentage
-- @realm shared
-- @treturn number
function GetContainedItemConditionPercentage() end

--- Use
-- @realm shared
-- @tparam number deltaTime
-- @tparam Character character
-- @tparam Limb targetLimb
function Use(deltaTime, character, targetLimb) end

--- SecondaryUse
-- @realm shared
-- @tparam number deltaTime
-- @tparam Character character
function SecondaryUse(deltaTime, character) end

--- ApplyTreatment
-- @realm shared
-- @tparam Character user
-- @tparam Character character
-- @tparam Limb targetLimb
function ApplyTreatment(user, character, targetLimb) end

--- Combine
-- @realm shared
-- @tparam Item item
-- @tparam Character user
-- @treturn bool
function Combine(item, user) end

--- Drop
-- @realm shared
-- @tparam Character dropper
-- @tparam bool createNetworkEvent
-- @tparam bool setTransform
function Drop(dropper, createNetworkEvent, setTransform) end

--- Equip
-- @realm shared
-- @tparam Character character
function Equip(character) end

--- Unequip
-- @realm shared
-- @tparam Character character
function Unequip(character) end

--- GetProperties
-- @realm shared
-- @treturn table
function GetProperties() end

--- Load
-- @realm shared
-- @tparam ContentXElement element
-- @tparam Submarine submarine
-- @tparam IdRemap idRemap
-- @treturn Item
function Item.Load(element, submarine, idRemap) end

--- Load
-- @realm shared
-- @tparam ContentXElement element
-- @tparam Submarine submarine
-- @tparam bool createNetworkEvent
-- @tparam IdRemap idRemap
-- @treturn Item
function Item.Load(element, submarine, createNetworkEvent, idRemap) end

--- Save
-- @realm shared
-- @tparam XElement parentElement
-- @treturn XElement
function Save(parentElement) end

--- Reset
-- @realm shared
function Reset() end

--- OnMapLoaded
-- @realm shared
function OnMapLoaded() end

--- ShallowRemove
-- @realm shared
function ShallowRemove() end

--- Remove
-- @realm shared
function Remove() end

--- RemoveByPrefab
-- @realm shared
-- @tparam ItemPrefab prefab
function Item.RemoveByPrefab(prefab) end

--- GetComponentString
-- @realm shared
-- @tparam string component
-- @treturn Object
function GetComponentString(component) end

--- ToString
-- @realm shared
-- @treturn string
function ToString() end

--- IgnoreByAI
-- @realm shared
-- @tparam Character character
-- @treturn bool
function IgnoreByAI(character) end

--- IsContainerPreferred
-- @realm shared
-- @tparam ItemContainer container
-- @tparam Boolean& isPreferencesDefined
-- @tparam Boolean& isSecondary
-- @tparam bool requireConditionRestriction
-- @treturn bool
function IsContainerPreferred(container, isPreferencesDefined, isSecondary, requireConditionRestriction) end

--- Clone
-- @realm shared
-- @treturn MapEntity
function Clone() end

--- AddComponent
-- @realm shared
-- @tparam ItemComponent component
function AddComponent(component) end

--- EnableDrawableComponent
-- @realm shared
-- @tparam IDrawableComponent drawable
function EnableDrawableComponent(drawable) end

--- DisableDrawableComponent
-- @realm shared
-- @tparam IDrawableComponent drawable
function DisableDrawableComponent(drawable) end

--- GetComponentIndex
-- @realm shared
-- @tparam ItemComponent component
-- @treturn number
function GetComponentIndex(component) end

--- GetComponent
-- @realm shared
-- @treturn T
function GetComponent() end

--- GetComponents
-- @realm shared
-- @treturn Enumerable
function GetComponents() end

--- GetQualityModifier
-- @realm shared
-- @tparam StatType statType
-- @treturn number
function GetQualityModifier(statType) end

--- RemoveContained
-- @realm shared
-- @tparam Item contained
function RemoveContained(contained) end

--- SetTransform
-- @realm shared
-- @tparam Vector2 simPosition
-- @tparam number rotation
-- @tparam bool findNewHull
-- @tparam bool setPrevTransform
function SetTransform(simPosition, rotation, findNewHull, setPrevTransform) end

--- AllowDroppingOnSwapWith
-- @realm shared
-- @tparam Item otherItem
-- @treturn bool
function AllowDroppingOnSwapWith(otherItem) end

--- SetActiveSprite
-- @realm shared
function SetActiveSprite() end

--- Move
-- @realm shared
-- @tparam Vector2 amount
function Move(amount) end

--- Move
-- @realm shared
-- @tparam Vector2 amount
-- @tparam bool ignoreContacts
function Move(amount, ignoreContacts) end

--- TransformTrigger
-- @realm shared
-- @tparam Rectangle trigger
-- @tparam bool world
-- @treturn Rectangle
function TransformTrigger(trigger, world) end

--- UpdateHulls
-- @realm shared
function Item.UpdateHulls() end

--- FindHull
-- @realm shared
-- @treturn Hull
function FindHull() end

--- GetRootContainer
-- @realm shared
-- @treturn Item
function GetRootContainer() end

--- HasAccess
-- @realm shared
-- @tparam Character character
-- @treturn bool
function HasAccess(character) end

--- IsOwnedBy
-- @realm shared
-- @tparam Entity entity
-- @treturn bool
function IsOwnedBy(entity) end

--- GetRootInventoryOwner
-- @realm shared
-- @treturn Entity
function GetRootInventoryOwner() end

--- FindParentInventory
-- @realm shared
-- @tparam function predicate
-- @treturn Inventory
function FindParentInventory(predicate) end

--- SetContainedItemPositions
-- @realm shared
function SetContainedItemPositions() end

--- AddTag
-- @realm shared
-- @tparam string tag
function AddTag(tag) end

--- AddTag
-- @realm shared
-- @tparam Identifier tag
function AddTag(tag) end

--- HasTag
-- @realm shared
-- @tparam string tag
-- @treturn bool
function HasTag(tag) end

--- HasTag
-- @realm shared
-- @tparam Identifier tag
-- @treturn bool
function HasTag(tag) end

--- ReplaceTag
-- @realm shared
-- @tparam string tag
-- @tparam string newTag
function ReplaceTag(tag, newTag) end

--- ReplaceTag
-- @realm shared
-- @tparam Identifier tag
-- @tparam Identifier newTag
function ReplaceTag(tag, newTag) end

--- GetTags
-- @realm shared
-- @treturn Enumerable
function GetTags() end

--- HasTag
-- @realm shared
-- @tparam Enumerable allowedTags
-- @treturn bool
function HasTag(allowedTags) end

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

--- WriteSpawnData
-- @realm shared
-- @tparam IWriteMessage msg
-- @tparam number entityID
-- @tparam number originalInventoryID
-- @tparam Byte originalItemContainerIndex
-- @tparam number originalSlotIndex
function WriteSpawnData(msg, entityID, originalInventoryID, originalItemContainerIndex, originalSlotIndex) end

--- GetPositionUpdateInterval
-- @realm shared
-- @tparam Client recipient
-- @treturn number
function GetPositionUpdateInterval(recipient) end

--- ServerWritePosition
-- @realm shared
-- @tparam IWriteMessage msg
-- @tparam Client c
function ServerWritePosition(msg, c) end

--- CreateServerEvent
-- @realm shared
-- @tparam T ic
function CreateServerEvent(ic) end

--- CreateServerEvent
-- @realm shared
-- @tparam T ic
-- @tparam IEventData extraData
function CreateServerEvent(ic, extraData) end

--- TryCreateServerEventSpam
-- @realm shared
function TryCreateServerEventSpam() end

--- CreateServerEventString
-- @realm shared
-- @tparam string component
-- @treturn Object
function CreateServerEventString(component) end

--- CreateServerEventString
-- @realm shared
-- @tparam string component
-- @tparam Object[] extraData
-- @treturn Object
function CreateServerEventString(component, extraData) end

--- IsInteractable
-- @realm shared
-- @tparam Character character
-- @treturn bool
function IsInteractable(character) end

--- AddLinked
-- @realm shared
-- @tparam MapEntity entity
function AddLinked(entity) end

--- ResolveLinks
-- @realm shared
-- @tparam IdRemap childRemap
function ResolveLinks(childRemap) end

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
-- Sprite, Field of type Sprite
-- @realm shared
-- @Sprite Sprite

---
-- Prefab, Field of type ItemPrefab
-- @realm shared
-- @ItemPrefab Prefab

---
-- CurrentHull, Field of type Hull
-- @realm shared
-- @Hull CurrentHull

---
-- HullOxygenPercentage, Field of type number
-- @realm shared
-- @number HullOxygenPercentage

---
-- CampaignInteractionType, Field of type InteractionType
-- @realm shared
-- @InteractionType CampaignInteractionType

---
-- DefaultRect, Field of type Rectangle
-- @realm shared
-- @Rectangle DefaultRect

---
-- SerializableProperties, Field of type table
-- @realm shared
-- @table SerializableProperties

---
-- EditableWhenEquipped, Field of type bool
-- @realm shared
-- @bool EditableWhenEquipped

---
-- ParentInventory, Field of type Inventory
-- @realm shared
-- @Inventory ParentInventory

---
-- Container, Field of type Item
-- @realm shared
-- @Item Container

---
-- Name, Field of type string
-- @realm shared
-- @string Name

---
-- Description, Field of type string
-- @realm shared
-- @string Description

---
-- NonInteractable, Field of type bool
-- @realm shared
-- @bool NonInteractable

---
-- NonPlayerTeamInteractable, Field of type bool
-- @realm shared
-- @bool NonPlayerTeamInteractable

---
-- AllowSwapping, Field of type bool
-- @realm shared
-- @bool AllowSwapping

---
-- PurchasedNewSwap, Field of type bool
-- @realm shared
-- @bool PurchasedNewSwap

---
-- IsPlayerTeamInteractable, Field of type bool
-- @realm shared
-- @bool IsPlayerTeamInteractable

---
-- Rotation, Field of type number
-- @realm shared
-- @number Rotation

---
-- ImpactTolerance, Field of type number
-- @realm shared
-- @number ImpactTolerance

---
-- InteractDistance, Field of type number
-- @realm shared
-- @number InteractDistance

---
-- InteractPriority, Field of type number
-- @realm shared
-- @number InteractPriority

---
-- Position, Field of type Vector2
-- @realm shared
-- @Vector2 Position

---
-- SimPosition, Field of type Vector2
-- @realm shared
-- @Vector2 SimPosition

---
-- InteractionRect, Field of type Rectangle
-- @realm shared
-- @Rectangle InteractionRect

---
-- Scale, Field of type number
-- @realm shared
-- @number Scale

---
-- PositionUpdateInterval, Field of type number
-- @realm shared
-- @number PositionUpdateInterval

---
-- SpriteColor, Field of type Color
-- @realm shared
-- @Color SpriteColor

---
-- InventoryIconColor, Field of type Color
-- @realm shared
-- @Color InventoryIconColor

---
-- ContainerColor, Field of type Color
-- @realm shared
-- @Color ContainerColor

---
-- ContainerIdentifier, Field of type Identifier
-- @realm shared
-- @Identifier ContainerIdentifier

---
-- SonarLabel, Field of type string
-- @realm shared
-- @string SonarLabel

---
-- PhysicsBodyActive, Field of type bool
-- @realm shared
-- @bool PhysicsBodyActive

---
-- SoundRange, Field of type number
-- @realm shared
-- @number SoundRange

---
-- SightRange, Field of type number
-- @realm shared
-- @number SightRange

---
-- IsShootable, Field of type bool
-- @realm shared
-- @bool IsShootable

---
-- RequireAimToUse, Field of type bool
-- @realm shared
-- @bool RequireAimToUse

---
-- RequireAimToSecondaryUse, Field of type bool
-- @realm shared
-- @bool RequireAimToSecondaryUse

---
-- Color, Field of type Color
-- @realm shared
-- @Color Color

---
-- IsFullCondition, Field of type bool
-- @realm shared
-- @bool IsFullCondition

---
-- MaxCondition, Field of type number
-- @realm shared
-- @number MaxCondition

---
-- ConditionPercentage, Field of type number
-- @realm shared
-- @number ConditionPercentage

---
-- OffsetOnSelectedMultiplier, Field of type number
-- @realm shared
-- @number OffsetOnSelectedMultiplier

---
-- HealthMultiplier, Field of type number
-- @realm shared
-- @number HealthMultiplier

---
-- MaxRepairConditionMultiplier, Field of type number
-- @realm shared
-- @number MaxRepairConditionMultiplier

---
-- Condition, Field of type number
-- @realm shared
-- @number Condition

---
-- ConditionIncreasedRecently, Field of type bool
-- @realm shared
-- @bool ConditionIncreasedRecently

---
-- Health, Field of type number
-- @realm shared
-- @number Health

---
-- Indestructible, Field of type bool
-- @realm shared
-- @bool Indestructible

---
-- AllowDeconstruct, Field of type bool
-- @realm shared
-- @bool AllowDeconstruct

---
-- InvulnerableToDamage, Field of type bool
-- @realm shared
-- @bool InvulnerableToDamage

---
-- SpawnedInCurrentOutpost, Field of type bool
-- @realm shared
-- @bool SpawnedInCurrentOutpost

---
-- AllowStealing, Field of type bool
-- @realm shared
-- @bool AllowStealing

---
-- OriginalOutpost, Field of type string
-- @realm shared
-- @string OriginalOutpost

---
-- Tags, Field of type string
-- @realm shared
-- @string Tags

---
-- FireProof, Field of type bool
-- @realm shared
-- @bool FireProof

---
-- WaterProof, Field of type bool
-- @realm shared
-- @bool WaterProof

---
-- UseInHealthInterface, Field of type bool
-- @realm shared
-- @bool UseInHealthInterface

---
-- Quality, Field of type number
-- @realm shared
-- @number Quality

---
-- InWater, Field of type bool
-- @realm shared
-- @bool InWater

---
-- LastSentSignalRecipients, Field of type table
-- @realm shared
-- @table LastSentSignalRecipients

---
-- ConfigFilePath, Field of type ContentPath
-- @realm shared
-- @ContentPath ConfigFilePath

---
-- AllowedSlots, Field of type Enumerable
-- @realm shared
-- @Enumerable AllowedSlots

---
-- Connections, Field of type table
-- @realm shared
-- @table Connections

---
-- ContainedItems, Field of type Enumerable
-- @realm shared
-- @Enumerable ContainedItems

---
-- OwnInventory, Field of type ItemInventory
-- @realm shared
-- @ItemInventory OwnInventory

---
-- DisplaySideBySideWhenLinked, Field of type bool
-- @realm shared
-- @bool DisplaySideBySideWhenLinked

---
-- Repairables, Field of type table
-- @realm shared
-- @table Repairables

---
-- Components, Field of type table
-- @realm shared
-- @table Components

---
-- Linkable, Field of type bool
-- @realm shared
-- @bool Linkable

---
-- PositionX, Field of type number
-- @realm shared
-- @number PositionX

---
-- PositionY, Field of type number
-- @realm shared
-- @number PositionY

---
-- Infector, Field of type BallastFloraBranch
-- @realm shared
-- @BallastFloraBranch Infector

---
-- PendingItemSwap, Field of type ItemPrefab
-- @realm shared
-- @ItemPrefab PendingItemSwap

---
-- AllPropertyObjects, Field of type IReadOnlyList`1
-- @realm shared
-- @IReadOnlyList`1 AllPropertyObjects

---
-- OrderedToBeIgnored, Field of type bool
-- @realm shared
-- @bool OrderedToBeIgnored

---
-- HasBallastFloraInHull, Field of type bool
-- @realm shared
-- @bool HasBallastFloraInHull

---
-- IsClaimedByBallastFlora, Field of type bool
-- @realm shared
-- @bool IsClaimedByBallastFlora

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
-- HiddenInGame, Field of type bool
-- @realm shared
-- @bool HiddenInGame

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
-- PreviousParentInventory, Field of type Inventory
-- @realm shared
-- @Inventory PreviousParentInventory

---
-- Visible, Field of type bool
-- @realm shared
-- @bool Visible

---
-- body, Field of type PhysicsBody
-- @realm shared
-- @PhysicsBody body

---
-- StaticBodyConfig, Field of type XElement
-- @realm shared
-- @XElement StaticBodyConfig

---
-- StaticFixtures, Field of type table
-- @realm shared
-- @table StaticFixtures

---
-- StolenDuringRound, Field of type bool
-- @realm shared
-- @bool StolenDuringRound

---
-- AvailableSwaps, Field of type HashSet`1
-- @realm shared
-- @HashSet`1 AvailableSwaps

---
-- Item.ItemList, Field of type table
-- @realm shared
-- @table Item.ItemList

---
-- Item.ShowLinks, Field of type bool
-- @realm shared
-- @bool Item.ShowLinks

---
-- Item.connectionPairs, Field of type ImmutableArray`1
-- @realm shared
-- @ImmutableArray`1 Item.connectionPairs

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

