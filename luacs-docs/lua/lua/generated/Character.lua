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


--- TrySeverLimbJoints
-- @realm shared
-- @tparam Limb targetLimb
-- @tparam number severLimbsProbability
-- @tparam number damage
-- @tparam bool allowBeheading
-- @tparam Character attacker
function TrySeverLimbJoints(targetLimb, severLimbsProbability, damage, allowBeheading, attacker) end

--- AddDamage
-- @realm shared
-- @tparam Vector2 worldPosition
-- @tparam Enumerable afflictions
-- @tparam number stun
-- @tparam bool playSound
-- @tparam number attackImpulse
-- @tparam Character attacker
-- @tparam number damageMultiplier
-- @treturn AttackResult
function AddDamage(worldPosition, afflictions, stun, playSound, attackImpulse, attacker, damageMultiplier) end

--- AddDamage
-- @realm shared
-- @tparam Vector2 worldPosition
-- @tparam Enumerable afflictions
-- @tparam number stun
-- @tparam bool playSound
-- @tparam number attackImpulse
-- @tparam Limb& hitLimb
-- @tparam Character attacker
-- @tparam number damageMultiplier
-- @treturn AttackResult
function AddDamage(worldPosition, afflictions, stun, playSound, attackImpulse, hitLimb, attacker, damageMultiplier) end

--- RecordKill
-- @realm shared
-- @tparam Character target
function RecordKill(target) end

--- AddEncounter
-- @realm shared
-- @tparam Character other
function AddEncounter(other) end

--- DamageLimb
-- @realm shared
-- @tparam Vector2 worldPosition
-- @tparam Limb hitLimb
-- @tparam Enumerable afflictions
-- @tparam number stun
-- @tparam bool playSound
-- @tparam number attackImpulse
-- @tparam Character attacker
-- @tparam number damageMultiplier
-- @tparam bool allowStacking
-- @tparam number penetration
-- @tparam bool shouldImplode
-- @treturn AttackResult
function DamageLimb(worldPosition, hitLimb, afflictions, stun, playSound, attackImpulse, attacker, damageMultiplier, allowStacking, penetration, shouldImplode) end

--- TryAdjustAttackerSkill
-- @realm shared
-- @tparam Character attacker
-- @tparam number healthChange
function TryAdjustAttackerSkill(attacker, healthChange) end

--- SetStun
-- @realm shared
-- @tparam number newStun
-- @tparam bool allowStunDecrease
-- @tparam bool isNetworkMessage
function SetStun(newStun, allowStunDecrease, isNetworkMessage) end

--- ApplyStatusEffects
-- @realm shared
-- @tparam function actionType
-- @tparam number deltaTime
function ApplyStatusEffects(actionType, deltaTime) end

--- BreakJoints
-- @realm shared
function BreakJoints() end

--- Kill
-- @realm shared
-- @tparam CauseOfDeathType causeOfDeath
-- @tparam Affliction causeOfDeathAffliction
-- @tparam bool isNetworkMessage
-- @tparam bool log
function Kill(causeOfDeath, causeOfDeathAffliction, isNetworkMessage, log) end

--- Revive
-- @realm shared
-- @tparam bool removeAllAfflictions
function Revive(removeAllAfflictions) end

--- Remove
-- @realm shared
function Remove() end

--- SaveInventory
-- @realm shared
-- @tparam Inventory inventory
-- @tparam XElement parentElement
function Character.SaveInventory(inventory, parentElement) end

--- SaveInventory
-- @realm shared
function SaveInventory() end

--- SpawnInventoryItems
-- @realm shared
-- @tparam Inventory inventory
-- @tparam ContentXElement itemData
function SpawnInventoryItems(inventory, itemData) end

--- GetAttackContexts
-- @realm shared
-- @treturn Enumerable
function GetAttackContexts() end

--- GetVisibleHulls
-- @realm shared
-- @treturn table
function GetVisibleHulls() end

--- GetRelativeSimPosition
-- @realm shared
-- @tparam ISpatialEntity target
-- @tparam Nullable`1 worldPos
-- @treturn Vector2
function GetRelativeSimPosition(target, worldPos) end

--- HasJob
-- @realm shared
-- @tparam string identifier
-- @treturn bool
function HasJob(identifier) end

--- IsProtectedFromPressure
-- @realm shared
-- @treturn bool
function IsProtectedFromPressure() end

--- LoadTalents
-- @realm shared
function LoadTalents() end

--- GiveTalent
-- @realm shared
-- @tparam Identifier talentIdentifier
-- @tparam bool addingFirstTime
-- @treturn bool
function GiveTalent(talentIdentifier, addingFirstTime) end

--- GiveTalent
-- @realm shared
-- @tparam number talentIdentifier
-- @tparam bool addingFirstTime
-- @treturn bool
function GiveTalent(talentIdentifier, addingFirstTime) end

--- GiveTalent
-- @realm shared
-- @tparam TalentPrefab talentPrefab
-- @tparam bool addingFirstTime
-- @treturn bool
function GiveTalent(talentPrefab, addingFirstTime) end

--- HasTalent
-- @realm shared
-- @tparam Identifier identifier
-- @treturn bool
function HasTalent(identifier) end

--- HasUnlockedAllTalents
-- @realm shared
-- @treturn bool
function HasUnlockedAllTalents() end

--- GetFriendlyCrew
-- @realm shared
-- @tparam Character character
-- @treturn Enumerable
function Character.GetFriendlyCrew(character) end

--- HasTalents
-- @realm shared
-- @treturn bool
function HasTalents() end

--- CheckTalents
-- @realm shared
-- @tparam AbilityEffectType abilityEffectType
-- @tparam AbilityObject abilityObject
function CheckTalents(abilityEffectType, abilityObject) end

--- CheckTalents
-- @realm shared
-- @tparam AbilityEffectType abilityEffectType
function CheckTalents(abilityEffectType) end

--- HasRecipeForItem
-- @realm shared
-- @tparam Identifier recipeIdentifier
-- @treturn bool
function HasRecipeForItem(recipeIdentifier) end

--- GiveMoney
-- @realm shared
-- @tparam number amount
function GiveMoney(amount) end

--- GetStatValue
-- @realm shared
-- @tparam StatTypes statType
-- @treturn number
function GetStatValue(statType) end

--- OnWearablesChanged
-- @realm shared
function OnWearablesChanged() end

--- ChangeStat
-- @realm shared
-- @tparam StatTypes statType
-- @tparam number value
function ChangeStat(statType, value) end

--- AddAbilityFlag
-- @realm shared
-- @tparam AbilityFlags abilityFlag
function AddAbilityFlag(abilityFlag) end

--- RemoveAbilityFlag
-- @realm shared
-- @tparam AbilityFlags abilityFlag
function RemoveAbilityFlag(abilityFlag) end

--- HasAbilityFlag
-- @realm shared
-- @tparam AbilityFlags abilityFlag
-- @treturn bool
function HasAbilityFlag(abilityFlag) end

--- GetAbilityResistance
-- @realm shared
-- @tparam AfflictionPrefab affliction
-- @treturn number
function GetAbilityResistance(affliction) end

--- ChangeAbilityResistance
-- @realm shared
-- @tparam Identifier resistanceId
-- @tparam number value
function ChangeAbilityResistance(resistanceId, value) end

--- IsFriendly
-- @realm shared
-- @tparam Character other
-- @treturn bool
function IsFriendly(other) end

--- IsFriendly
-- @realm shared
-- @tparam Character me
-- @tparam Character other
-- @treturn bool
function Character.IsFriendly(me, other) end

--- ResetNetState
-- @realm shared
function ResetNetState() end

--- ClearInput
-- @realm shared
-- @tparam InputType inputType
function ClearInput(inputType) end

--- ClearInputs
-- @realm shared
function ClearInputs() end

--- ToString
-- @realm shared
-- @treturn string
function ToString() end

--- GiveJobItems
-- @realm shared
-- @tparam WayPoint spawnPoint
function GiveJobItems(spawnPoint) end

--- GiveIdCardTags
-- @realm shared
-- @tparam WayPoint spawnPoint
-- @tparam bool createNetworkEvent
function GiveIdCardTags(spawnPoint, createNetworkEvent) end

--- GetSkillLevel
-- @realm shared
-- @tparam string skillIdentifier
-- @treturn number
function GetSkillLevel(skillIdentifier) end

--- GetSkillLevel
-- @realm shared
-- @tparam Identifier skillIdentifier
-- @treturn number
function GetSkillLevel(skillIdentifier) end

--- GetTargetMovement
-- @realm shared
-- @treturn Vector2
function GetTargetMovement() end

--- ApplyMovementLimits
-- @realm shared
-- @tparam Vector2 targetMovement
-- @tparam number currentSpeed
-- @treturn Vector2
function ApplyMovementLimits(targetMovement, currentSpeed) end

--- StackSpeedMultiplier
-- @realm shared
-- @tparam number val
function StackSpeedMultiplier(val) end

--- ResetSpeedMultiplier
-- @realm shared
function ResetSpeedMultiplier() end

--- StackHealthMultiplier
-- @realm shared
-- @tparam number val
function StackHealthMultiplier(val) end

--- AddStaticHealthMultiplier
-- @realm shared
-- @tparam number newMultiplier
function AddStaticHealthMultiplier(newMultiplier) end

--- GetTemporarySpeedReduction
-- @realm shared
-- @treturn number
function GetTemporarySpeedReduction() end

--- GetRightHandPenalty
-- @realm shared
-- @treturn number
function GetRightHandPenalty() end

--- GetLeftHandPenalty
-- @realm shared
-- @treturn number
function GetLeftHandPenalty() end

--- GetLegPenalty
-- @realm shared
-- @tparam number startSum
-- @treturn number
function GetLegPenalty(startSum) end

--- ApplyTemporarySpeedLimits
-- @realm shared
-- @tparam number speed
-- @treturn number
function ApplyTemporarySpeedLimits(speed) end

--- Control
-- @realm shared
-- @tparam number deltaTime
-- @tparam Camera cam
function Control(deltaTime, cam) end

--- SetAttackTarget
-- @realm shared
-- @tparam Limb attackLimb
-- @tparam IDamageable damageTarget
-- @tparam Vector2 attackPos
function SetAttackTarget(attackLimb, damageTarget, attackPos) end

--- CanSeeCharacter
-- @realm shared
-- @tparam Character target
-- @treturn bool
function CanSeeCharacter(target) end

--- CanSeeTarget
-- @realm shared
-- @tparam ISpatialEntity target
-- @tparam ISpatialEntity seeingEntity
-- @treturn bool
function CanSeeTarget(target, seeingEntity) end

--- IsFacing
-- @realm shared
-- @tparam Vector2 targetWorldPos
-- @treturn bool
function IsFacing(targetWorldPos) end

--- HasItem
-- @realm shared
-- @tparam Item item
-- @tparam bool requireEquipped
-- @tparam Nullable`1 slotType
-- @treturn bool
function HasItem(item, requireEquipped, slotType) end

--- HasEquippedItem
-- @realm shared
-- @tparam Item item
-- @tparam Nullable`1 slotType
-- @tparam function predicate
-- @treturn bool
function HasEquippedItem(item, slotType, predicate) end

--- HasEquippedItem
-- @realm shared
-- @tparam string tagOrIdentifier
-- @tparam bool allowBroken
-- @tparam Nullable`1 slotType
-- @treturn bool
function HasEquippedItem(tagOrIdentifier, allowBroken, slotType) end

--- HasEquippedItem
-- @realm shared
-- @tparam Identifier tagOrIdentifier
-- @tparam bool allowBroken
-- @tparam Nullable`1 slotType
-- @treturn bool
function HasEquippedItem(tagOrIdentifier, allowBroken, slotType) end

--- GetEquippedItem
-- @realm shared
-- @tparam string tagOrIdentifier
-- @tparam Nullable`1 slotType
-- @treturn Item
function GetEquippedItem(tagOrIdentifier, slotType) end

--- CanAccessInventory
-- @realm shared
-- @tparam Inventory inventory
-- @treturn bool
function CanAccessInventory(inventory) end

--- FindItem
-- @realm shared
-- @tparam Int32& itemIndex
-- @tparam Item& targetItem
-- @tparam Enumerable identifiers
-- @tparam bool ignoreBroken
-- @tparam Enumerable ignoredItems
-- @tparam Enumerable ignoredContainerIdentifiers
-- @tparam function customPredicate
-- @tparam function customPriorityFunction
-- @tparam number maxItemDistance
-- @tparam ISpatialEntity positionalReference
-- @treturn bool
function FindItem(itemIndex, targetItem, identifiers, ignoreBroken, ignoredItems, ignoredContainerIdentifiers, customPredicate, customPriorityFunction, maxItemDistance, positionalReference) end

--- IsItemTakenBySomeoneElse
-- @realm shared
-- @tparam Item item
-- @treturn bool
function IsItemTakenBySomeoneElse(item) end

--- CanInteractWith
-- @realm shared
-- @tparam Character c
-- @tparam number maxDist
-- @tparam bool checkVisibility
-- @tparam bool skipDistanceCheck
-- @treturn bool
function CanInteractWith(c, maxDist, checkVisibility, skipDistanceCheck) end

--- CanInteractWith
-- @realm shared
-- @tparam Item item
-- @tparam bool checkLinked
-- @treturn bool
function CanInteractWith(item, checkLinked) end

--- CanInteractWith
-- @realm shared
-- @tparam Item item
-- @tparam Single& distanceToItem
-- @tparam bool checkLinked
-- @treturn bool
function CanInteractWith(item, distanceToItem, checkLinked) end

--- SetCustomInteract
-- @realm shared
-- @tparam function onCustomInteract
-- @tparam LocalizedString hudText
function SetCustomInteract(onCustomInteract, hudText) end

--- SelectCharacter
-- @realm shared
-- @tparam Character character
function SelectCharacter(character) end

--- DeselectCharacter
-- @realm shared
function DeselectCharacter() end

--- DoInteractionUpdate
-- @realm shared
-- @tparam number deltaTime
-- @tparam Vector2 mouseSimPos
function DoInteractionUpdate(deltaTime, mouseSimPos) end

--- UpdateAnimAll
-- @realm shared
-- @tparam number deltaTime
function Character.UpdateAnimAll(deltaTime) end

--- UpdateAll
-- @realm shared
-- @tparam number deltaTime
-- @tparam Camera cam
function Character.UpdateAll(deltaTime, cam) end

--- Update
-- @realm shared
-- @tparam number deltaTime
-- @tparam Camera cam
function Update(deltaTime, cam) end

--- AddAttacker
-- @realm shared
-- @tparam Character character
-- @tparam number damage
function AddAttacker(character, damage) end

--- ForgiveAttacker
-- @realm shared
-- @tparam Character character
function ForgiveAttacker(character) end

--- GetDamageDoneByAttacker
-- @realm shared
-- @tparam Character otherCharacter
-- @treturn number
function GetDamageDoneByAttacker(otherCharacter) end

--- DespawnNow
-- @realm shared
-- @tparam bool createNetworkEvents
function DespawnNow(createNetworkEvents) end

--- RemoveByPrefab
-- @realm shared
-- @tparam CharacterPrefab prefab
function Character.RemoveByPrefab(prefab) end

--- CanHearCharacter
-- @realm shared
-- @tparam Character speaker
-- @treturn bool
function CanHearCharacter(speaker) end

--- SetOrder
-- @realm shared
-- @tparam Order order
-- @tparam bool isNewOrder
-- @tparam bool speak
-- @tparam bool force
function SetOrder(order, isNewOrder, speak, force) end

--- GetCurrentOrderWithTopPriority
-- @realm shared
-- @treturn Order
function GetCurrentOrderWithTopPriority() end

--- GetCurrentOrder
-- @realm shared
-- @tparam Order order
-- @treturn Order
function GetCurrentOrder(order) end

--- DisableLine
-- @realm shared
-- @tparam Identifier identifier
function DisableLine(identifier) end

--- DisableLine
-- @realm shared
-- @tparam string identifier
function DisableLine(identifier) end

--- Speak
-- @realm shared
-- @tparam string message
-- @tparam Nullable`1 messageType
-- @tparam number delay
-- @tparam Identifier identifier
-- @tparam number minDurationBetweenSimilar
function Speak(message, messageType, delay, identifier, minDurationBetweenSimilar) end

--- ShowSpeechBubble
-- @realm shared
-- @tparam number duration
-- @tparam Color color
function ShowSpeechBubble(duration, color) end

--- SetAllDamage
-- @realm shared
-- @tparam number damageAmount
-- @tparam number bleedingDamageAmount
-- @tparam number burnDamageAmount
function SetAllDamage(damageAmount, bleedingDamageAmount, burnDamageAmount) end

--- AddDamage
-- @realm shared
-- @tparam Character attacker
-- @tparam Vector2 worldPosition
-- @tparam Attack attack
-- @tparam number deltaTime
-- @tparam bool playSound
-- @treturn AttackResult
function AddDamage(attacker, worldPosition, attack, deltaTime, playSound) end

--- ApplyAttack
-- @realm shared
-- @tparam Character attacker
-- @tparam Vector2 worldPosition
-- @tparam Attack attack
-- @tparam number deltaTime
-- @tparam bool playSound
-- @tparam Limb targetLimb
-- @tparam number penetration
-- @treturn AttackResult
function ApplyAttack(attacker, worldPosition, attack, deltaTime, playSound, targetLimb, penetration) end

--- Create
-- @realm shared
-- @tparam string speciesName
-- @tparam Vector2 position
-- @tparam string seed
-- @tparam CharacterInfo characterInfo
-- @tparam number id
-- @tparam bool isRemotePlayer
-- @tparam bool hasAi
-- @tparam bool createNetworkEvent
-- @tparam RagdollParams ragdoll
-- @treturn Character
function Character.Create(speciesName, position, seed, characterInfo, id, isRemotePlayer, hasAi, createNetworkEvent, ragdoll) end

--- Create
-- @realm shared
-- @tparam Identifier speciesName
-- @tparam Vector2 position
-- @tparam string seed
-- @tparam CharacterInfo characterInfo
-- @tparam number id
-- @tparam bool isRemotePlayer
-- @tparam bool hasAi
-- @tparam bool createNetworkEvent
-- @tparam RagdollParams ragdoll
-- @treturn Character
function Character.Create(speciesName, position, seed, characterInfo, id, isRemotePlayer, hasAi, createNetworkEvent, ragdoll) end

--- Create
-- @realm shared
-- @tparam CharacterPrefab prefab
-- @tparam Vector2 position
-- @tparam string seed
-- @tparam CharacterInfo characterInfo
-- @tparam number id
-- @tparam bool isRemotePlayer
-- @tparam bool hasAi
-- @tparam bool createNetworkEvent
-- @tparam RagdollParams ragdoll
-- @treturn Character
function Character.Create(prefab, position, seed, characterInfo, id, isRemotePlayer, hasAi, createNetworkEvent, ragdoll) end

--- ReloadHead
-- @realm shared
-- @tparam Nullable`1 headId
-- @tparam number hairIndex
-- @tparam number beardIndex
-- @tparam number moustacheIndex
-- @tparam number faceAttachmentIndex
function ReloadHead(headId, hairIndex, beardIndex, moustacheIndex, faceAttachmentIndex) end

--- LoadHeadAttachments
-- @realm shared
function LoadHeadAttachments() end

--- IsKeyHit
-- @realm shared
-- @tparam InputType inputType
-- @treturn bool
function IsKeyHit(inputType) end

--- IsKeyDown
-- @realm shared
-- @tparam InputType inputType
-- @treturn bool
function IsKeyDown(inputType) end

--- SetInput
-- @realm shared
-- @tparam InputType inputType
-- @tparam bool hit
-- @tparam bool held
function SetInput(inputType, hit, held) end

--- GetPositionUpdateInterval
-- @realm shared
-- @tparam Client recipient
-- @treturn number
function GetPositionUpdateInterval(recipient) end

--- ServerReadInput
-- @realm shared
-- @tparam IReadMessage msg
-- @tparam Client c
function ServerReadInput(msg, c) end

--- ServerEventRead
-- @realm shared
-- @tparam IReadMessage msg
-- @tparam Client c
function ServerEventRead(msg, c) end

--- ServerWritePosition
-- @realm shared
-- @tparam IWriteMessage msg
-- @tparam Client c
function ServerWritePosition(msg, c) end

--- ServerEventWrite
-- @realm shared
-- @tparam IWriteMessage msg
-- @tparam Client c
-- @tparam IData extraData
function ServerEventWrite(msg, c, extraData) end

--- WriteSpawnData
-- @realm shared
-- @tparam IWriteMessage msg
-- @tparam number entityId
-- @tparam bool restrictMessageSize
function WriteSpawnData(msg, entityId, restrictMessageSize) end

--- ThrowIfAccessingWalletsInSingleplayer
-- @realm shared
function Character.ThrowIfAccessingWalletsInSingleplayer() end

--- SetOriginalTeam
-- @realm shared
-- @tparam CharacterTeamType newTeam
function SetOriginalTeam(newTeam) end

--- HasTeamChange
-- @realm shared
-- @tparam string identifier
-- @treturn bool
function HasTeamChange(identifier) end

--- TryAddNewTeamChange
-- @realm shared
-- @tparam string identifier
-- @tparam ActiveTeamChange newTeamChange
-- @treturn bool
function TryAddNewTeamChange(identifier, newTeamChange) end

--- TryRemoveTeamChange
-- @realm shared
-- @tparam string identifier
-- @treturn bool
function TryRemoveTeamChange(identifier) end

--- UpdateTeam
-- @realm shared
function UpdateTeam() end

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
-- Character.Controlled, Field of type Character
-- @realm shared
-- @Character Character.Controlled

---
-- Enabled, Field of type bool
-- @realm shared
-- @bool Enabled

---
-- IsRemotelyControlled, Field of type bool
-- @realm shared
-- @bool IsRemotelyControlled

---
-- IsRemotePlayer, Field of type bool
-- @realm shared
-- @bool IsRemotePlayer

---
-- IsLocalPlayer, Field of type bool
-- @realm shared
-- @bool IsLocalPlayer

---
-- IsPlayer, Field of type bool
-- @realm shared
-- @bool IsPlayer

---
-- IsCommanding, Field of type bool
-- @realm shared
-- @bool IsCommanding

---
-- IsBot, Field of type bool
-- @realm shared
-- @bool IsBot

---
-- IsEscorted, Field of type bool
-- @realm shared
-- @bool IsEscorted

---
-- SerializableProperties, Field of type table
-- @realm shared
-- @table SerializableProperties

---
-- Keys, Field of type Key[]
-- @realm shared
-- @Key[] Keys

---
-- TeamID, Field of type CharacterTeamType
-- @realm shared
-- @CharacterTeamType TeamID

---
-- Wallet, Field of type Wallet
-- @realm shared
-- @Wallet Wallet

---
-- IsOnPlayerTeam, Field of type bool
-- @realm shared
-- @bool IsOnPlayerTeam

---
-- IsInstigator, Field of type bool
-- @realm shared
-- @bool IsInstigator

---
-- LastAttackers, Field of type Enumerable
-- @realm shared
-- @Enumerable LastAttackers

---
-- LastAttacker, Field of type Character
-- @realm shared
-- @Character LastAttacker

---
-- LastOrderedCharacter, Field of type Character
-- @realm shared
-- @Character LastOrderedCharacter

---
-- SecondLastOrderedCharacter, Field of type Character
-- @realm shared
-- @Character SecondLastOrderedCharacter

---
-- ItemSelectedDurations, Field of type table
-- @realm shared
-- @table ItemSelectedDurations

---
-- SpeciesName, Field of type Identifier
-- @realm shared
-- @Identifier SpeciesName

---
-- Group, Field of type Identifier
-- @realm shared
-- @Identifier Group

---
-- IsHumanoid, Field of type bool
-- @realm shared
-- @bool IsHumanoid

---
-- IsHusk, Field of type bool
-- @realm shared
-- @bool IsHusk

---
-- IsMale, Field of type bool
-- @realm shared
-- @bool IsMale

---
-- IsFemale, Field of type bool
-- @realm shared
-- @bool IsFemale

---
-- BloodDecalName, Field of type string
-- @realm shared
-- @string BloodDecalName

---
-- CanSpeak, Field of type bool
-- @realm shared
-- @bool CanSpeak

---
-- NeedsAir, Field of type bool
-- @realm shared
-- @bool NeedsAir

---
-- NeedsWater, Field of type bool
-- @realm shared
-- @bool NeedsWater

---
-- NeedsOxygen, Field of type bool
-- @realm shared
-- @bool NeedsOxygen

---
-- Noise, Field of type number
-- @realm shared
-- @number Noise

---
-- Visibility, Field of type number
-- @realm shared
-- @number Visibility

---
-- IsTraitor, Field of type bool
-- @realm shared
-- @bool IsTraitor

---
-- IsHuman, Field of type bool
-- @realm shared
-- @bool IsHuman

---
-- CurrentOrders, Field of type table
-- @realm shared
-- @table CurrentOrders

---
-- IsDismissed, Field of type bool
-- @realm shared
-- @bool IsDismissed

---
-- ViewTarget, Field of type Entity
-- @realm shared
-- @Entity ViewTarget

---
-- AimRefPosition, Field of type Vector2
-- @realm shared
-- @Vector2 AimRefPosition

---
-- Info, Field of type CharacterInfo
-- @realm shared
-- @CharacterInfo Info

---
-- VariantOf, Field of type Identifier
-- @realm shared
-- @Identifier VariantOf

---
-- Name, Field of type string
-- @realm shared
-- @string Name

---
-- DisplayName, Field of type string
-- @realm shared
-- @string DisplayName

---
-- LogName, Field of type string
-- @realm shared
-- @string LogName

---
-- HideFace, Field of type bool
-- @realm shared
-- @bool HideFace

---
-- ConfigPath, Field of type string
-- @realm shared
-- @string ConfigPath

---
-- Mass, Field of type number
-- @realm shared
-- @number Mass

---
-- Inventory, Field of type CharacterInventory
-- @realm shared
-- @CharacterInventory Inventory

---
-- CustomInteractHUDText, Field of type LocalizedString
-- @realm shared
-- @LocalizedString CustomInteractHUDText

---
-- AllowCustomInteract, Field of type bool
-- @realm shared
-- @bool AllowCustomInteract

---
-- LockHands, Field of type bool
-- @realm shared
-- @bool LockHands

---
-- AllowInput, Field of type bool
-- @realm shared
-- @bool AllowInput

---
-- CanMove, Field of type bool
-- @realm shared
-- @bool CanMove

---
-- CanInteract, Field of type bool
-- @realm shared
-- @bool CanInteract

---
-- CanEat, Field of type bool
-- @realm shared
-- @bool CanEat

---
-- CursorPosition, Field of type Vector2
-- @realm shared
-- @Vector2 CursorPosition

---
-- SmoothedCursorPosition, Field of type Vector2
-- @realm shared
-- @Vector2 SmoothedCursorPosition

---
-- CursorWorldPosition, Field of type Vector2
-- @realm shared
-- @Vector2 CursorWorldPosition

---
-- FocusedCharacter, Field of type Character
-- @realm shared
-- @Character FocusedCharacter

---
-- SelectedCharacter, Field of type Character
-- @realm shared
-- @Character SelectedCharacter

---
-- SelectedBy, Field of type Character
-- @realm shared
-- @Character SelectedBy

---
-- HeldItems, Field of type Enumerable
-- @realm shared
-- @Enumerable HeldItems

---
-- LowPassMultiplier, Field of type number
-- @realm shared
-- @number LowPassMultiplier

---
-- ObstructVision, Field of type bool
-- @realm shared
-- @bool ObstructVision

---
-- PressureProtection, Field of type number
-- @realm shared
-- @number PressureProtection

---
-- InPressure, Field of type bool
-- @realm shared
-- @bool InPressure

---
-- IsIncapacitated, Field of type bool
-- @realm shared
-- @bool IsIncapacitated

---
-- IsUnconscious, Field of type bool
-- @realm shared
-- @bool IsUnconscious

---
-- IsArrested, Field of type bool
-- @realm shared
-- @bool IsArrested

---
-- IsPet, Field of type bool
-- @realm shared
-- @bool IsPet

---
-- Oxygen, Field of type number
-- @realm shared
-- @number Oxygen

---
-- OxygenAvailable, Field of type number
-- @realm shared
-- @number OxygenAvailable

---
-- HullOxygenPercentage, Field of type number
-- @realm shared
-- @number HullOxygenPercentage

---
-- UseHullOxygen, Field of type bool
-- @realm shared
-- @bool UseHullOxygen

---
-- Stun, Field of type number
-- @realm shared
-- @number Stun

---
-- CharacterHealth, Field of type CharacterHealth
-- @realm shared
-- @CharacterHealth CharacterHealth

---
-- Vitality, Field of type number
-- @realm shared
-- @number Vitality

---
-- Health, Field of type number
-- @realm shared
-- @number Health

---
-- HealthPercentage, Field of type number
-- @realm shared
-- @number HealthPercentage

---
-- MaxVitality, Field of type number
-- @realm shared
-- @number MaxVitality

---
-- MaxHealth, Field of type number
-- @realm shared
-- @number MaxHealth

---
-- AIState, Field of type AIState
-- @realm shared
-- @AIState AIState

---
-- IsLatched, Field of type bool
-- @realm shared
-- @bool IsLatched

---
-- Bloodloss, Field of type number
-- @realm shared
-- @number Bloodloss

---
-- Bleeding, Field of type number
-- @realm shared
-- @number Bleeding

---
-- SpeechImpediment, Field of type number
-- @realm shared
-- @number SpeechImpediment

---
-- PressureTimer, Field of type number
-- @realm shared
-- @number PressureTimer

---
-- DisableImpactDamageTimer, Field of type number
-- @realm shared
-- @number DisableImpactDamageTimer

---
-- CurrentSpeed, Field of type number
-- @realm shared
-- @number CurrentSpeed

---
-- SelectedConstruction, Field of type Item
-- @realm shared
-- @Item SelectedConstruction

---
-- FocusedItem, Field of type Item
-- @realm shared
-- @Item FocusedItem

---
-- PickingItem, Field of type Item
-- @realm shared
-- @Item PickingItem

---
-- AIController, Field of type AIController
-- @realm shared
-- @AIController AIController

---
-- IsDead, Field of type bool
-- @realm shared
-- @bool IsDead

---
-- EnableDespawn, Field of type bool
-- @realm shared
-- @bool EnableDespawn

---
-- CauseOfDeath, Field of type CauseOfDeath
-- @realm shared
-- @CauseOfDeath CauseOfDeath

---
-- CanBeSelected, Field of type bool
-- @realm shared
-- @bool CanBeSelected

---
-- CanBeDragged, Field of type bool
-- @realm shared
-- @bool CanBeDragged

---
-- CanInventoryBeAccessed, Field of type bool
-- @realm shared
-- @bool CanInventoryBeAccessed

---
-- CanAim, Field of type bool
-- @realm shared
-- @bool CanAim

---
-- InWater, Field of type bool
-- @realm shared
-- @bool InWater

---
-- SimPosition, Field of type Vector2
-- @realm shared
-- @Vector2 SimPosition

---
-- Position, Field of type Vector2
-- @realm shared
-- @Vector2 Position

---
-- DrawPosition, Field of type Vector2
-- @realm shared
-- @Vector2 DrawPosition

---
-- IsInFriendlySub, Field of type bool
-- @realm shared
-- @bool IsInFriendlySub

---
-- OverrideMovement, Field of type Nullable`1
-- @realm shared
-- @Nullable`1 OverrideMovement

---
-- ForceRun, Field of type bool
-- @realm shared
-- @bool ForceRun

---
-- IsClimbing, Field of type bool
-- @realm shared
-- @bool IsClimbing

---
-- CanRun, Field of type bool
-- @realm shared
-- @bool CanRun

---
-- SpeedMultiplier, Field of type number
-- @realm shared
-- @number SpeedMultiplier

---
-- PropulsionSpeedMultiplier, Field of type number
-- @realm shared
-- @number PropulsionSpeedMultiplier

---
-- HealthMultiplier, Field of type number
-- @realm shared
-- @number HealthMultiplier

---
-- StaticHealthMultiplier, Field of type number
-- @realm shared
-- @number StaticHealthMultiplier

---
-- IsKnockedDown, Field of type bool
-- @realm shared
-- @bool IsKnockedDown

---
-- IsCaptain, Field of type bool
-- @realm shared
-- @bool IsCaptain

---
-- IsEngineer, Field of type bool
-- @realm shared
-- @bool IsEngineer

---
-- IsMechanic, Field of type bool
-- @realm shared
-- @bool IsMechanic

---
-- IsMedic, Field of type bool
-- @realm shared
-- @bool IsMedic

---
-- IsSecurity, Field of type bool
-- @realm shared
-- @bool IsSecurity

---
-- IsAssistant, Field of type bool
-- @realm shared
-- @bool IsAssistant

---
-- IsWatchman, Field of type bool
-- @realm shared
-- @bool IsWatchman

---
-- IsVip, Field of type bool
-- @realm shared
-- @bool IsVip

---
-- IsPrisoner, Field of type bool
-- @realm shared
-- @bool IsPrisoner

---
-- UniqueNameColor, Field of type Nullable`1
-- @realm shared
-- @Nullable`1 UniqueNameColor

---
-- HealthUpdateInterval, Field of type number
-- @realm shared
-- @number HealthUpdateInterval

---
-- MemState, Field of type table
-- @realm shared
-- @table MemState

---
-- MemLocalState, Field of type table
-- @realm shared
-- @table MemLocalState

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
-- OwnerClientEndPoint, Field of type string
-- @realm shared
-- @string OwnerClientEndPoint

---
-- OwnerClientName, Field of type string
-- @realm shared
-- @string OwnerClientName

---
-- ClientDisconnected, Field of type bool
-- @realm shared
-- @bool ClientDisconnected

---
-- KillDisconnectedTimer, Field of type number
-- @realm shared
-- @number KillDisconnectedTimer

---
-- HealthUpdatePending, Field of type bool
-- @realm shared
-- @bool HealthUpdatePending

---
-- PreviousHull, Field of type Hull
-- @realm shared
-- @Hull PreviousHull

---
-- CurrentHull, Field of type Hull
-- @realm shared
-- @Hull CurrentHull

---
-- Properties, Field of type table
-- @realm shared
-- @table Properties

---
-- HumanPrefab, Field of type HumanPrefab
-- @realm shared
-- @HumanPrefab HumanPrefab

---
-- Latchers, Field of type HashSet`1
-- @realm shared
-- @HashSet`1 Latchers

---
-- AttachedProjectiles, Field of type HashSet`1
-- @realm shared
-- @HashSet`1 AttachedProjectiles

---
-- CombatAction, Field of type CombatAction
-- @realm shared
-- @CombatAction CombatAction

---
-- AnimController, Field of type AnimController
-- @realm shared
-- @AnimController AnimController

---
-- Seed, Field of type string
-- @realm shared
-- @string Seed

---
-- LastDamageSource, Field of type Entity
-- @realm shared
-- @Entity LastDamageSource

---
-- LastDamage, Field of type AttackResult
-- @realm shared
-- @AttackResult LastDamage

---
-- InvisibleTimer, Field of type number
-- @realm shared
-- @number InvisibleTimer

---
-- Prefab, Field of type CharacterPrefab
-- @realm shared
-- @CharacterPrefab Prefab

---
-- Params, Field of type CharacterParams
-- @realm shared
-- @CharacterParams Params

---
-- TraitorCurrentObjective, Field of type LocalizedString
-- @realm shared
-- @LocalizedString TraitorCurrentObjective

---
-- ResetInteract, Field of type bool
-- @realm shared
-- @bool ResetInteract

---
-- ActiveConversation, Field of type ConversationAction
-- @realm shared
-- @ConversationAction ActiveConversation

---
-- RequireConsciousnessForCustomInteract, Field of type bool
-- @realm shared
-- @bool RequireConsciousnessForCustomInteract

---
-- KnockbackCooldownTimer, Field of type number
-- @realm shared
-- @number KnockbackCooldownTimer

---
-- IsRagdolled, Field of type bool
-- @realm shared
-- @bool IsRagdolled

---
-- IsForceRagdolled, Field of type bool
-- @realm shared
-- @bool IsForceRagdolled

---
-- dontFollowCursor, Field of type bool
-- @realm shared
-- @bool dontFollowCursor

---
-- DisableHealthWindow, Field of type bool
-- @realm shared
-- @bool DisableHealthWindow

---
-- GodMode, Field of type bool
-- @realm shared
-- @bool GodMode

---
-- CampaignInteractionType, Field of type InteractionType
-- @realm shared
-- @InteractionType CampaignInteractionType

---
-- MerchantIdentifier, Field of type Identifier
-- @realm shared
-- @Identifier MerchantIdentifier

---
-- OnDeath, Field of type OnDeathHandler
-- @realm shared
-- @OnDeathHandler OnDeath

---
-- OnAttacked, Field of type OnAttackedHandler
-- @realm shared
-- @OnAttackedHandler OnAttacked

---
-- LastNetworkUpdateID, Field of type number
-- @realm shared
-- @number LastNetworkUpdateID

---
-- LastProcessedID, Field of type number
-- @realm shared
-- @number LastProcessedID

---
-- healthUpdateTimer, Field of type number
-- @realm shared
-- @number healthUpdateTimer

---
-- isSynced, Field of type bool
-- @realm shared
-- @bool isSynced

---
-- Character.CharacterUpdateInterval, Field of type number
-- @realm shared
-- @number Character.CharacterUpdateInterval

---
-- Character.KnockbackCooldown, Field of type number
-- @realm shared
-- @number Character.KnockbackCooldown

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

