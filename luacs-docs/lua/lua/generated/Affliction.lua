-- luacheck: ignore 111

--[[--
Barotrauma.Affliction
]]
-- @code Affliction
-- @pragma nostrip
local Affliction = {}

--- Serialize
-- @realm shared
-- @tparam XElement element
function Serialize(element) end

--- Deserialize
-- @realm shared
-- @tparam XElement element
function Deserialize(element) end

--- CreateMultiplied
-- @realm shared
-- @tparam number multiplier
-- @treturn Affliction
function CreateMultiplied(multiplier) end

--- ToString
-- @realm shared
-- @treturn string
function ToString() end

--- GetActiveEffect
-- @realm shared
-- @treturn Effect
function GetActiveEffect() end

--- GetVitalityDecrease
-- @realm shared
-- @tparam CharacterHealth characterHealth
-- @treturn number
function GetVitalityDecrease(characterHealth) end

--- GetVitalityDecrease
-- @realm shared
-- @tparam CharacterHealth characterHealth
-- @tparam number strength
-- @treturn number
function GetVitalityDecrease(characterHealth, strength) end

--- GetScreenGrainStrength
-- @realm shared
-- @treturn number
function GetScreenGrainStrength() end

--- GetScreenDistortStrength
-- @realm shared
-- @treturn number
function GetScreenDistortStrength() end

--- GetRadialDistortStrength
-- @realm shared
-- @treturn number
function GetRadialDistortStrength() end

--- GetChromaticAberrationStrength
-- @realm shared
-- @treturn number
function GetChromaticAberrationStrength() end

--- GetAfflictionOverlayMultiplier
-- @realm shared
-- @treturn number
function GetAfflictionOverlayMultiplier() end

--- GetFaceTint
-- @realm shared
-- @treturn Color
function GetFaceTint() end

--- GetBodyTint
-- @realm shared
-- @treturn Color
function GetBodyTint() end

--- GetScreenBlurStrength
-- @realm shared
-- @treturn number
function GetScreenBlurStrength() end

--- GetSkillMultiplier
-- @realm shared
-- @treturn number
function GetSkillMultiplier() end

--- CalculateDamagePerSecond
-- @realm shared
-- @tparam number currentVitalityDecrease
function CalculateDamagePerSecond(currentVitalityDecrease) end

--- GetResistance
-- @realm shared
-- @tparam Identifier afflictionId
-- @treturn number
function GetResistance(afflictionId) end

--- GetSpeedMultiplier
-- @realm shared
-- @treturn number
function GetSpeedMultiplier() end

--- GetStatValue
-- @realm shared
-- @tparam StatTypes statType
-- @treturn number
function GetStatValue(statType) end

--- HasFlag
-- @realm shared
-- @tparam AbilityFlags flagType
-- @treturn bool
function HasFlag(flagType) end

--- Update
-- @realm shared
-- @tparam CharacterHealth characterHealth
-- @tparam Limb targetLimb
-- @tparam number deltaTime
function Update(characterHealth, targetLimb, deltaTime) end

--- ApplyStatusEffects
-- @realm shared
-- @tparam function type
-- @tparam number deltaTime
-- @tparam CharacterHealth characterHealth
-- @tparam Limb targetLimb
function ApplyStatusEffects(type, deltaTime, characterHealth, targetLimb) end

--- ApplyStatusEffect
-- @realm shared
-- @tparam function type
-- @tparam StatusEffect statusEffect
-- @tparam number deltaTime
-- @tparam CharacterHealth characterHealth
-- @tparam Limb targetLimb
function ApplyStatusEffect(type, statusEffect, deltaTime, characterHealth, targetLimb) end

--- SetStrength
-- @realm shared
-- @tparam number strength
function SetStrength(strength) end

--- ShouldShowIcon
-- @realm shared
-- @tparam Character afflictedCharacter
-- @treturn bool
function ShouldShowIcon(afflictedCharacter) end

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
-- Name, Field of type string
-- @realm shared
-- @string Name

---
-- SerializableProperties, Field of type table
-- @realm shared
-- @table SerializableProperties

---
-- PendingAdditionStrength, Field of type number
-- @realm shared
-- @number PendingAdditionStrength

---
-- AdditionStrength, Field of type number
-- @realm shared
-- @number AdditionStrength

---
-- Strength, Field of type number
-- @realm shared
-- @number Strength

---
-- NonClampedStrength, Field of type number
-- @realm shared
-- @number NonClampedStrength

---
-- Identifier, Field of type Identifier
-- @realm shared
-- @Identifier Identifier

---
-- Probability, Field of type number
-- @realm shared
-- @number Probability

---
-- Prefab, Field of type AfflictionPrefab
-- @realm shared
-- @AfflictionPrefab Prefab

---
-- DamagePerSecond, Field of type number
-- @realm shared
-- @number DamagePerSecond

---
-- DamagePerSecondTimer, Field of type number
-- @realm shared
-- @number DamagePerSecondTimer

---
-- PreviousVitalityDecrease, Field of type number
-- @realm shared
-- @number PreviousVitalityDecrease

---
-- StrengthDiminishMultiplier, Field of type number
-- @realm shared
-- @number StrengthDiminishMultiplier

---
-- MultiplierSource, Field of type Affliction
-- @realm shared
-- @Affliction MultiplierSource

---
-- PeriodicEffectTimers, Field of type table
-- @realm shared
-- @table PeriodicEffectTimers

---
-- AppliedAsSuccessfulTreatmentTime, Field of type number
-- @realm shared
-- @number AppliedAsSuccessfulTreatmentTime

---
-- AppliedAsFailedTreatmentTime, Field of type number
-- @realm shared
-- @number AppliedAsFailedTreatmentTime

---
-- Source, Field of type Character
-- @realm shared
-- @Character Source

