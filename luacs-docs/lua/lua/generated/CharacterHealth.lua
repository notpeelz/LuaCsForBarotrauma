-- luacheck: ignore 111

--[[--
Barotrauma.CharacterHealth
]]
-- @code CharacterHealth
-- @pragma nostrip
local CharacterHealth = {}

--- GetAllAfflictions
-- @realm shared
-- @treturn IReadOnlyCollection`1
function GetAllAfflictions() end

--- GetAllAfflictions
-- @realm shared
-- @tparam function limbHealthFilter
-- @treturn Enumerable
function GetAllAfflictions(limbHealthFilter) end

--- GetAffliction
-- @realm shared
-- @tparam string identifier
-- @tparam bool allowLimbAfflictions
-- @treturn Affliction
function GetAffliction(identifier, allowLimbAfflictions) end

--- GetAffliction
-- @realm shared
-- @tparam Identifier identifier
-- @tparam bool allowLimbAfflictions
-- @treturn Affliction
function GetAffliction(identifier, allowLimbAfflictions) end

--- GetAfflictionOfType
-- @realm shared
-- @tparam Identifier afflictionType
-- @tparam bool allowLimbAfflictions
-- @treturn Affliction
function GetAfflictionOfType(afflictionType, allowLimbAfflictions) end

--- GetAffliction
-- @realm shared
-- @tparam string identifier
-- @tparam bool allowLimbAfflictions
-- @treturn T
function GetAffliction(identifier, allowLimbAfflictions) end

--- GetAffliction
-- @realm shared
-- @tparam string identifier
-- @tparam Limb limb
-- @treturn Affliction
function GetAffliction(identifier, limb) end

--- GetAfflictionLimb
-- @realm shared
-- @tparam Affliction affliction
-- @treturn Limb
function GetAfflictionLimb(affliction) end

--- GetAfflictionStrength
-- @realm shared
-- @tparam string afflictionType
-- @tparam Limb limb
-- @tparam bool requireLimbSpecific
-- @treturn number
function GetAfflictionStrength(afflictionType, limb, requireLimbSpecific) end

--- GetAfflictionStrength
-- @realm shared
-- @tparam string afflictionType
-- @tparam bool allowLimbAfflictions
-- @treturn number
function GetAfflictionStrength(afflictionType, allowLimbAfflictions) end

--- ApplyAffliction
-- @realm shared
-- @tparam Limb targetLimb
-- @tparam Affliction affliction
-- @tparam bool allowStacking
function ApplyAffliction(targetLimb, affliction, allowStacking) end

--- GetResistance
-- @realm shared
-- @tparam AfflictionPrefab afflictionPrefab
-- @treturn number
function GetResistance(afflictionPrefab) end

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

--- ReduceAllAfflictionsOnAllLimbs
-- @realm shared
-- @tparam number amount
-- @tparam Nullable`1 treatmentAction
function ReduceAllAfflictionsOnAllLimbs(amount, treatmentAction) end

--- ReduceAfflictionOnAllLimbs
-- @realm shared
-- @tparam Identifier affliction
-- @tparam number amount
-- @tparam Nullable`1 treatmentAction
function ReduceAfflictionOnAllLimbs(affliction, amount, treatmentAction) end

--- ReduceAllAfflictionsOnLimb
-- @realm shared
-- @tparam Limb targetLimb
-- @tparam number amount
-- @tparam Nullable`1 treatmentAction
function ReduceAllAfflictionsOnLimb(targetLimb, amount, treatmentAction) end

--- ReduceAfflictionOnLimb
-- @realm shared
-- @tparam Limb targetLimb
-- @tparam Identifier affliction
-- @tparam number amount
-- @tparam Nullable`1 treatmentAction
function ReduceAfflictionOnLimb(targetLimb, affliction, amount, treatmentAction) end

--- ApplyDamage
-- @realm shared
-- @tparam Limb hitLimb
-- @tparam AttackResult attackResult
-- @tparam bool allowStacking
function ApplyDamage(hitLimb, attackResult, allowStacking) end

--- SetAllDamage
-- @realm shared
-- @tparam number damageAmount
-- @tparam number bleedingDamageAmount
-- @tparam number burnDamageAmount
function SetAllDamage(damageAmount, bleedingDamageAmount, burnDamageAmount) end

--- GetLimbDamage
-- @realm shared
-- @tparam Limb limb
-- @tparam string afflictionType
-- @treturn number
function GetLimbDamage(limb, afflictionType) end

--- RemoveAllAfflictions
-- @realm shared
function RemoveAllAfflictions() end

--- RemoveNegativeAfflictions
-- @realm shared
function RemoveNegativeAfflictions() end

--- Update
-- @realm shared
-- @tparam number deltaTime
function Update(deltaTime) end

--- SetVitality
-- @realm shared
-- @tparam number newVitality
function SetVitality(newVitality) end

--- CalculateVitality
-- @realm shared
function CalculateVitality() end

--- ApplyAfflictionStatusEffects
-- @realm shared
-- @tparam function type
function ApplyAfflictionStatusEffects(type) end

--- GetCauseOfDeath
-- @realm shared
-- @treturn ValueTuple`2
function GetCauseOfDeath() end

--- GetSuitableTreatments
-- @realm shared
-- @tparam table treatmentSuitability
-- @tparam bool normalize
-- @tparam Limb limb
-- @tparam bool ignoreHiddenAfflictions
-- @tparam number predictFutureDuration
function GetSuitableTreatments(treatmentSuitability, normalize, limb, ignoreHiddenAfflictions, predictFutureDuration) end

--- GetActiveAfflictionTags
-- @realm shared
-- @treturn Enumerable
function GetActiveAfflictionTags() end

--- GetActiveAfflictionTags
-- @realm shared
-- @tparam Enumerable afflictions
-- @treturn Enumerable
function GetActiveAfflictionTags(afflictions) end

--- GetPredictedStrength
-- @realm shared
-- @tparam Affliction affliction
-- @tparam number predictFutureDuration
-- @tparam Limb limb
-- @treturn number
function GetPredictedStrength(affliction, predictFutureDuration, limb) end

--- ServerWrite
-- @realm shared
-- @tparam IWriteMessage msg
function ServerWrite(msg) end

--- Remove
-- @realm shared
function Remove() end

--- SortAfflictionsBySeverity
-- @realm shared
-- @tparam Enumerable afflictions
-- @tparam bool excludeBuffs
-- @treturn Enumerable
function CharacterHealth.SortAfflictionsBySeverity(afflictions, excludeBuffs) end

--- Save
-- @realm shared
-- @tparam XElement healthElement
function Save(healthElement) end

--- Load
-- @realm shared
-- @tparam XElement element
function Load(element) end

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
-- DoesBleed, Field of type bool
-- @realm shared
-- @bool DoesBleed

---
-- UseHealthWindow, Field of type bool
-- @realm shared
-- @bool UseHealthWindow

---
-- CrushDepth, Field of type number
-- @realm shared
-- @number CrushDepth

---
-- BloodlossAffliction, Field of type Affliction
-- @realm shared
-- @Affliction BloodlossAffliction

---
-- IsUnconscious, Field of type bool
-- @realm shared
-- @bool IsUnconscious

---
-- PressureKillDelay, Field of type number
-- @realm shared
-- @number PressureKillDelay

---
-- Vitality, Field of type number
-- @realm shared
-- @number Vitality

---
-- HealthPercentage, Field of type number
-- @realm shared
-- @number HealthPercentage

---
-- MaxVitality, Field of type number
-- @realm shared
-- @number MaxVitality

---
-- MinVitality, Field of type number
-- @realm shared
-- @number MinVitality

---
-- FaceTint, Field of type Color
-- @realm shared
-- @Color FaceTint

---
-- BodyTint, Field of type Color
-- @realm shared
-- @Color BodyTint

---
-- OxygenAmount, Field of type number
-- @realm shared
-- @number OxygenAmount

---
-- BloodlossAmount, Field of type number
-- @realm shared
-- @number BloodlossAmount

---
-- Stun, Field of type number
-- @realm shared
-- @number Stun

---
-- StunTimer, Field of type number
-- @realm shared
-- @number StunTimer

---
-- PressureAffliction, Field of type Affliction
-- @realm shared
-- @Affliction PressureAffliction

---
-- Unkillable, Field of type bool
-- @realm shared
-- @bool Unkillable

---
-- DefaultFaceTint, Field of type Color
-- @realm shared
-- @Color DefaultFaceTint

---
-- Character, Field of type Character
-- @realm shared
-- @Character Character

---
-- CharacterHealth.InsufficientOxygenThreshold, Field of type number
-- @realm shared
-- @number CharacterHealth.InsufficientOxygenThreshold

---
-- CharacterHealth.LowOxygenThreshold, Field of type number
-- @realm shared
-- @number CharacterHealth.LowOxygenThreshold

