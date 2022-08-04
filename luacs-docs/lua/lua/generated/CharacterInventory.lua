-- luacheck: ignore 111

--[[--
Barotrauma.CharacterInventory
]]
-- @code CharacterInventory
-- @pragma nostrip
local CharacterInventory = {}

--- FindLimbSlot
-- @realm shared
-- @tparam InvSlotType limbSlot
-- @treturn number
function FindLimbSlot(limbSlot) end

--- GetItemInLimbSlot
-- @realm shared
-- @tparam InvSlotType limbSlot
-- @treturn Item
function GetItemInLimbSlot(limbSlot) end

--- IsInLimbSlot
-- @realm shared
-- @tparam Item item
-- @tparam InvSlotType limbSlot
-- @treturn bool
function IsInLimbSlot(item, limbSlot) end

--- CanBePutInSlot
-- @realm shared
-- @tparam Item item
-- @tparam number i
-- @tparam bool ignoreCondition
-- @treturn bool
function CanBePutInSlot(item, i, ignoreCondition) end

--- CanBePutInSlot
-- @realm shared
-- @tparam ItemPrefab itemPrefab
-- @tparam number i
-- @tparam Nullable`1 condition
-- @tparam Nullable`1 quality
-- @treturn bool
function CanBePutInSlot(itemPrefab, i, condition, quality) end

--- CanBeAutoMovedToCorrectSlots
-- @realm shared
-- @tparam Item item
-- @treturn bool
function CanBeAutoMovedToCorrectSlots(item) end

--- RemoveItem
-- @realm shared
-- @tparam Item item
function RemoveItem(item) end

--- RemoveItem
-- @realm shared
-- @tparam Item item
-- @tparam bool tryEquipFromSameStack
function RemoveItem(item, tryEquipFromSameStack) end

--- TryPutItemWithAutoEquipCheck
-- @realm shared
-- @tparam Item item
-- @tparam Character user
-- @tparam Enumerable allowedSlots
-- @tparam bool createNetworkEvent
-- @treturn bool
function TryPutItemWithAutoEquipCheck(item, user, allowedSlots, createNetworkEvent) end

--- TryPutItem
-- @realm shared
-- @tparam Item item
-- @tparam Character user
-- @tparam Enumerable allowedSlots
-- @tparam bool createNetworkEvent
-- @tparam bool ignoreCondition
-- @treturn bool
function TryPutItem(item, user, allowedSlots, createNetworkEvent, ignoreCondition) end

--- CheckIfAnySlotAvailable
-- @realm shared
-- @tparam Item item
-- @tparam bool inWrongSlot
-- @treturn number
function CheckIfAnySlotAvailable(item, inWrongSlot) end

--- TryPutItem
-- @realm shared
-- @tparam Item item
-- @tparam number index
-- @tparam bool allowSwapping
-- @tparam bool allowCombine
-- @tparam Character user
-- @tparam bool createNetworkEvent
-- @tparam bool ignoreCondition
-- @treturn bool
function TryPutItem(item, index, allowSwapping, allowCombine, user, createNetworkEvent, ignoreCondition) end

--- ServerEventRead
-- @realm shared
-- @tparam IReadMessage msg
-- @tparam Client c
function ServerEventRead(msg, c) end

--- ServerEventWrite
-- @realm shared
-- @tparam IWriteMessage msg
-- @tparam Client c
-- @tparam IData extraData
function ServerEventWrite(msg, c, extraData) end

--- Contains
-- @realm shared
-- @tparam Item item
-- @treturn bool
function Contains(item) end

--- FirstOrDefault
-- @realm shared
-- @treturn Item
function FirstOrDefault() end

--- LastOrDefault
-- @realm shared
-- @treturn Item
function LastOrDefault() end

--- GetItemAt
-- @realm shared
-- @tparam number index
-- @treturn Item
function GetItemAt(index) end

--- GetItemsAt
-- @realm shared
-- @tparam number index
-- @treturn Enumerable
function GetItemsAt(index) end

--- FindIndex
-- @realm shared
-- @tparam Item item
-- @treturn number
function FindIndex(item) end

--- FindIndices
-- @realm shared
-- @tparam Item item
-- @treturn table
function FindIndices(item) end

--- ItemOwnsSelf
-- @realm shared
-- @tparam Item item
-- @treturn bool
function ItemOwnsSelf(item) end

--- FindAllowedSlot
-- @realm shared
-- @tparam Item item
-- @tparam bool ignoreCondition
-- @treturn number
function FindAllowedSlot(item, ignoreCondition) end

--- CanBePut
-- @realm shared
-- @tparam Item item
-- @treturn bool
function CanBePut(item) end

--- CanBePut
-- @realm shared
-- @tparam ItemPrefab itemPrefab
-- @tparam Nullable`1 condition
-- @tparam Nullable`1 quality
-- @treturn bool
function CanBePut(itemPrefab, condition, quality) end

--- HowManyCanBePut
-- @realm shared
-- @tparam ItemPrefab itemPrefab
-- @tparam Nullable`1 condition
-- @treturn number
function HowManyCanBePut(itemPrefab, condition) end

--- HowManyCanBePut
-- @realm shared
-- @tparam ItemPrefab itemPrefab
-- @tparam number i
-- @tparam Nullable`1 condition
-- @treturn number
function HowManyCanBePut(itemPrefab, i, condition) end

--- IsEmpty
-- @realm shared
-- @treturn bool
function IsEmpty() end

--- IsFull
-- @realm shared
-- @tparam bool takeStacksIntoAccount
-- @treturn bool
function IsFull(takeStacksIntoAccount) end

--- CreateNetworkEvent
-- @realm shared
function CreateNetworkEvent() end

--- FindItem
-- @realm shared
-- @tparam function predicate
-- @tparam bool recursive
-- @treturn Item
function FindItem(predicate, recursive) end

--- FindAllItems
-- @realm shared
-- @tparam function predicate
-- @tparam bool recursive
-- @tparam table list
-- @treturn table
function FindAllItems(predicate, recursive, list) end

--- FindItemByTag
-- @realm shared
-- @tparam Identifier tag
-- @tparam bool recursive
-- @treturn Item
function FindItemByTag(tag, recursive) end

--- FindItemByIdentifier
-- @realm shared
-- @tparam Identifier identifier
-- @tparam bool recursive
-- @treturn Item
function FindItemByIdentifier(identifier, recursive) end

--- ForceToSlot
-- @realm shared
-- @tparam Item item
-- @tparam number index
function ForceToSlot(item, index) end

--- ForceRemoveFromSlot
-- @realm shared
-- @tparam Item item
-- @tparam number index
function ForceRemoveFromSlot(item, index) end

--- SharedRead
-- @realm shared
-- @tparam IReadMessage msg
-- @tparam List`1[]& newItemIds
function SharedRead(msg, newItemIds) end

--- SharedWrite
-- @realm shared
-- @tparam IWriteMessage msg
-- @tparam IData extraData
function SharedWrite(msg, extraData) end

--- DeleteAllItems
-- @realm shared
function DeleteAllItems() end

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
-- SlotTypes, Field of type InvSlotType[]
-- @realm shared
-- @InvSlotType[] SlotTypes

---
-- AccessibleWhenAlive, Field of type bool
-- @realm shared
-- @bool AccessibleWhenAlive

---
-- AccessibleByOwner, Field of type bool
-- @realm shared
-- @bool AccessibleByOwner

---
-- AllItems, Field of type Enumerable
-- @realm shared
-- @Enumerable AllItems

---
-- AllItemsMod, Field of type Enumerable
-- @realm shared
-- @Enumerable AllItemsMod

---
-- Capacity, Field of type number
-- @realm shared
-- @number Capacity

---
-- CharacterInventory.anySlot, Field of type table
-- @realm shared
-- @table CharacterInventory.anySlot

---
-- Owner, Field of type Entity
-- @realm shared
-- @Entity Owner

---
-- Locked, Field of type bool
-- @realm shared
-- @bool Locked

---
-- AllowSwappingContainedItems, Field of type bool
-- @realm shared
-- @bool AllowSwappingContainedItems

