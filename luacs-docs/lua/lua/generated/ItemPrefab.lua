-- luacheck: ignore 111

--[[--
Barotrauma ItemPrefab class with some additional functions and fields

Barotrauma source code: [ItemPrefab.cs](https://github.com/evilfactory/Barotrauma-lua-attempt/blob/master/Barotrauma/BarotraumaShared/SharedSource/Items/ItemPrefab.cs)
]]
-- @code ItemPrefab
-- @pragma nostrip

local ItemPrefab = {}

--- Add ItemPrefab to spawn queue and spawns it at the specified position
-- @tparam ItemPrefab itemPrefab
-- @tparam Vector2 position
-- @tparam function spawned
-- @realm server 
function ItemPrefab.AddToSpawnQueue(itemPrefab, position, spawned) end

--- Add ItemPrefab to spawn queue and spawns it inside the specified inventory
-- @tparam ItemPrefab itemPrefab
-- @tparam Inventory inventory
-- @tparam function spawned
-- @realm server 
function ItemPrefab.AddToSpawnQueue(itemPrefab, inventory, spawned) end

--- Get a item prefab via name or id
-- @tparam string itemNameOrId
-- @treturn ItemPrefab
-- @realm shared 
function ItemPrefab.GetItemPrefab(itemNameOrId) end

---
-- Identifier, the identifier of the prefab.
-- @realm shared
-- @string Identifier


--- GenerateLegacyIdentifier
-- @realm shared
-- @tparam string name
-- @treturn Identifier
function ItemPrefab.GenerateLegacyIdentifier(name) end

--- GetTreatmentSuitability
-- @realm shared
-- @tparam Identifier treatmentIdentifier
-- @treturn number
function GetTreatmentSuitability(treatmentIdentifier) end

--- GetPriceInfo
-- @realm shared
-- @tparam StoreInfo store
-- @treturn PriceInfo
function GetPriceInfo(store) end

--- CanBeBoughtFrom
-- @realm shared
-- @tparam StoreInfo store
-- @tparam PriceInfo& priceInfo
-- @treturn bool
function CanBeBoughtFrom(store, priceInfo) end

--- CanBeBoughtFrom
-- @realm shared
-- @tparam Location location
-- @treturn bool
function CanBeBoughtFrom(location) end

--- GetMinPrice
-- @realm shared
-- @treturn Nullable`1
function GetMinPrice() end

--- GetBuyPricesUnder
-- @realm shared
-- @tparam number maxCost
-- @treturn ImmutableDictionary`2
function GetBuyPricesUnder(maxCost) end

--- GetSellPricesOver
-- @realm shared
-- @tparam number minCost
-- @tparam bool sellingImportant
-- @treturn ImmutableDictionary`2
function GetSellPricesOver(minCost, sellingImportant) end

--- Find
-- @realm shared
-- @tparam string name
-- @tparam Identifier identifier
-- @treturn ItemPrefab
function ItemPrefab.Find(name, identifier) end

--- IsContainerPreferred
-- @realm shared
-- @tparam Item item
-- @tparam ItemContainer targetContainer
-- @tparam Boolean& isPreferencesDefined
-- @tparam Boolean& isSecondary
-- @tparam bool requireConditionRequirement
-- @treturn bool
function IsContainerPreferred(item, targetContainer, isPreferencesDefined, isSecondary, requireConditionRequirement) end

--- IsContainerPreferred
-- @realm shared
-- @tparam Item item
-- @tparam Identifier[] identifiersOrTags
-- @tparam Boolean& isPreferencesDefined
-- @tparam Boolean& isSecondary
-- @treturn bool
function IsContainerPreferred(item, identifiersOrTags, isPreferencesDefined, isSecondary) end

--- IsContainerPreferred
-- @realm shared
-- @tparam Enumerable preferences
-- @tparam ItemContainer c
-- @treturn bool
function ItemPrefab.IsContainerPreferred(preferences, c) end

--- IsContainerPreferred
-- @realm shared
-- @tparam Enumerable preferences
-- @tparam Enumerable ids
-- @treturn bool
function ItemPrefab.IsContainerPreferred(preferences, ids) end

--- Dispose
-- @realm shared
function Dispose() end

--- InheritFrom
-- @realm shared
-- @tparam ItemPrefab parent
function InheritFrom(parent) end

--- ToString
-- @realm shared
-- @treturn string
function ToString() end

--- GetItemPrefab
-- @realm shared
-- @tparam string itemNameOrId
-- @treturn ItemPrefab
function ItemPrefab.GetItemPrefab(itemNameOrId) end

--- GetItemNameTextId
-- @realm shared
-- @treturn string
function GetItemNameTextId() end

--- GetHullNameTextId
-- @realm shared
-- @treturn string
function GetHullNameTextId() end

--- GetAllowedUpgrades
-- @realm shared
-- @treturn Enumerable
function GetAllowedUpgrades() end

--- HasSubCategory
-- @realm shared
-- @tparam string subcategory
-- @treturn bool
function HasSubCategory(subcategory) end

--- DebugCreateInstance
-- @realm shared
function DebugCreateInstance() end

--- NameMatches
-- @realm shared
-- @tparam string name
-- @tparam StringComparison comparisonType
-- @treturn bool
function NameMatches(name, comparisonType) end

--- NameMatches
-- @realm shared
-- @tparam Enumerable allowedNames
-- @tparam StringComparison comparisonType
-- @treturn bool
function NameMatches(allowedNames, comparisonType) end

--- IsLinkAllowed
-- @realm shared
-- @tparam MapEntityPrefab target
-- @treturn bool
function IsLinkAllowed(target) end

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
-- Size, Field of type Vector2
-- @realm shared
-- @Vector2 Size

---
-- DefaultPrice, Field of type PriceInfo
-- @realm shared
-- @PriceInfo DefaultPrice

---
-- CanBeBought, Field of type bool
-- @realm shared
-- @bool CanBeBought

---
-- CanBeSold, Field of type bool
-- @realm shared
-- @bool CanBeSold

---
-- Triggers, Field of type ImmutableArray`1
-- @realm shared
-- @ImmutableArray`1 Triggers

---
-- IsOverride, Field of type bool
-- @realm shared
-- @bool IsOverride

---
-- ConfigElement, Field of type ContentXElement
-- @realm shared
-- @ContentXElement ConfigElement

---
-- DeconstructItems, Field of type ImmutableArray`1
-- @realm shared
-- @ImmutableArray`1 DeconstructItems

---
-- FabricationRecipes, Field of type ImmutableDictionary`2
-- @realm shared
-- @ImmutableDictionary`2 FabricationRecipes

---
-- DeconstructTime, Field of type number
-- @realm shared
-- @number DeconstructTime

---
-- AllowDeconstruct, Field of type bool
-- @realm shared
-- @bool AllowDeconstruct

---
-- PreferredContainers, Field of type ImmutableArray`1
-- @realm shared
-- @ImmutableArray`1 PreferredContainers

---
-- SwappableItem, Field of type SwappableItem
-- @realm shared
-- @SwappableItem SwappableItem

---
-- LevelCommonness, Field of type ImmutableDictionary`2
-- @realm shared
-- @ImmutableDictionary`2 LevelCommonness

---
-- LevelQuantity, Field of type ImmutableDictionary`2
-- @realm shared
-- @ImmutableDictionary`2 LevelQuantity

---
-- CanSpriteFlipX, Field of type bool
-- @realm shared
-- @bool CanSpriteFlipX

---
-- CanSpriteFlipY, Field of type bool
-- @realm shared
-- @bool CanSpriteFlipY

---
-- AllowAsExtraCargo, Field of type Nullable`1
-- @realm shared
-- @Nullable`1 AllowAsExtraCargo

---
-- RandomDeconstructionOutput, Field of type bool
-- @realm shared
-- @bool RandomDeconstructionOutput

---
-- RandomDeconstructionOutputAmount, Field of type number
-- @realm shared
-- @number RandomDeconstructionOutputAmount

---
-- Sprite, Field of type Sprite
-- @realm shared
-- @Sprite Sprite

---
-- OriginalName, Field of type string
-- @realm shared
-- @string OriginalName

---
-- Name, Field of type LocalizedString
-- @realm shared
-- @LocalizedString Name

---
-- Tags, Field of type ImmutableHashSet`1
-- @realm shared
-- @ImmutableHashSet`1 Tags

---
-- AllowedLinks, Field of type ImmutableHashSet`1
-- @realm shared
-- @ImmutableHashSet`1 AllowedLinks

---
-- Category, Field of type MapEntityCategory
-- @realm shared
-- @MapEntityCategory Category

---
-- Aliases, Field of type ImmutableHashSet`1
-- @realm shared
-- @ImmutableHashSet`1 Aliases

---
-- InteractDistance, Field of type number
-- @realm shared
-- @number InteractDistance

---
-- InteractPriority, Field of type number
-- @realm shared
-- @number InteractPriority

---
-- InteractThroughWalls, Field of type bool
-- @realm shared
-- @bool InteractThroughWalls

---
-- HideConditionBar, Field of type bool
-- @realm shared
-- @bool HideConditionBar

---
-- HideConditionInTooltip, Field of type bool
-- @realm shared
-- @bool HideConditionInTooltip

---
-- RequireBodyInsideTrigger, Field of type bool
-- @realm shared
-- @bool RequireBodyInsideTrigger

---
-- RequireCursorInsideTrigger, Field of type bool
-- @realm shared
-- @bool RequireCursorInsideTrigger

---
-- RequireCampaignInteract, Field of type bool
-- @realm shared
-- @bool RequireCampaignInteract

---
-- FocusOnSelected, Field of type bool
-- @realm shared
-- @bool FocusOnSelected

---
-- OffsetOnSelected, Field of type number
-- @realm shared
-- @number OffsetOnSelected

---
-- Health, Field of type number
-- @realm shared
-- @number Health

---
-- AllowSellingWhenBroken, Field of type bool
-- @realm shared
-- @bool AllowSellingWhenBroken

---
-- Indestructible, Field of type bool
-- @realm shared
-- @bool Indestructible

---
-- DamagedByExplosions, Field of type bool
-- @realm shared
-- @bool DamagedByExplosions

---
-- ExplosionDamageMultiplier, Field of type number
-- @realm shared
-- @number ExplosionDamageMultiplier

---
-- DamagedByProjectiles, Field of type bool
-- @realm shared
-- @bool DamagedByProjectiles

---
-- DamagedByMeleeWeapons, Field of type bool
-- @realm shared
-- @bool DamagedByMeleeWeapons

---
-- DamagedByRepairTools, Field of type bool
-- @realm shared
-- @bool DamagedByRepairTools

---
-- DamagedByMonsters, Field of type bool
-- @realm shared
-- @bool DamagedByMonsters

---
-- FireProof, Field of type bool
-- @realm shared
-- @bool FireProof

---
-- WaterProof, Field of type bool
-- @realm shared
-- @bool WaterProof

---
-- ImpactTolerance, Field of type number
-- @realm shared
-- @number ImpactTolerance

---
-- OnDamagedThreshold, Field of type number
-- @realm shared
-- @number OnDamagedThreshold

---
-- SonarSize, Field of type number
-- @realm shared
-- @number SonarSize

---
-- UseInHealthInterface, Field of type bool
-- @realm shared
-- @bool UseInHealthInterface

---
-- DisableItemUsageWhenSelected, Field of type bool
-- @realm shared
-- @bool DisableItemUsageWhenSelected

---
-- CargoContainerIdentifier, Field of type string
-- @realm shared
-- @string CargoContainerIdentifier

---
-- UseContainedSpriteColor, Field of type bool
-- @realm shared
-- @bool UseContainedSpriteColor

---
-- UseContainedInventoryIconColor, Field of type bool
-- @realm shared
-- @bool UseContainedInventoryIconColor

---
-- AddedRepairSpeedMultiplier, Field of type number
-- @realm shared
-- @number AddedRepairSpeedMultiplier

---
-- AddedPickingSpeedMultiplier, Field of type number
-- @realm shared
-- @number AddedPickingSpeedMultiplier

---
-- CannotRepairFail, Field of type bool
-- @realm shared
-- @bool CannotRepairFail

---
-- EquipConfirmationText, Field of type string
-- @realm shared
-- @string EquipConfirmationText

---
-- AllowRotatingInEditor, Field of type bool
-- @realm shared
-- @bool AllowRotatingInEditor

---
-- ShowContentsInTooltip, Field of type bool
-- @realm shared
-- @bool ShowContentsInTooltip

---
-- CanFlipX, Field of type bool
-- @realm shared
-- @bool CanFlipX

---
-- CanFlipY, Field of type bool
-- @realm shared
-- @bool CanFlipY

---
-- IsDangerous, Field of type bool
-- @realm shared
-- @bool IsDangerous

---
-- MaxStackSize, Field of type number
-- @realm shared
-- @number MaxStackSize

---
-- AllowDroppingOnSwap, Field of type bool
-- @realm shared
-- @bool AllowDroppingOnSwap

---
-- AllowDroppingOnSwapWith, Field of type ImmutableHashSet`1
-- @realm shared
-- @ImmutableHashSet`1 AllowDroppingOnSwapWith

---
-- VariantOf, Field of type Identifier
-- @realm shared
-- @Identifier VariantOf

---
-- ResizeHorizontal, Field of type bool
-- @realm shared
-- @bool ResizeHorizontal

---
-- ResizeVertical, Field of type bool
-- @realm shared
-- @bool ResizeVertical

---
-- Description, Field of type LocalizedString
-- @realm shared
-- @LocalizedString Description

---
-- AllowedUpgrades, Field of type string
-- @realm shared
-- @string AllowedUpgrades

---
-- HideInMenus, Field of type bool
-- @realm shared
-- @bool HideInMenus

---
-- Subcategory, Field of type string
-- @realm shared
-- @string Subcategory

---
-- Linkable, Field of type bool
-- @realm shared
-- @bool Linkable

---
-- SpriteColor, Field of type Color
-- @realm shared
-- @Color SpriteColor

---
-- Scale, Field of type number
-- @realm shared
-- @number Scale

---
-- UintIdentifier, Field of type number
-- @realm shared
-- @number UintIdentifier

---
-- ContentPackage, Field of type ContentPackage
-- @realm shared
-- @ContentPackage ContentPackage

---
-- FilePath, Field of type ContentPath
-- @realm shared
-- @ContentPath FilePath

---
-- ItemPrefab.Prefabs, Field of type PrefabCollection`1
-- @realm shared
-- @PrefabCollection`1 ItemPrefab.Prefabs

---
-- Identifier, Field of type Identifier
-- @realm shared
-- @Identifier Identifier

---
-- ContentFile, Field of type ContentFile
-- @realm shared
-- @ContentFile ContentFile

