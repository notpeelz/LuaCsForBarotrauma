-- luacheck: ignore 111

--[[--
Barotrauma.AfflictionPrefab
]]
-- @code AfflictionPrefab
-- @pragma nostrip
local AfflictionPrefab = {}

--- Dispose
-- @realm shared
function Dispose() end

--- LoadAllEffects
-- @realm shared
function AfflictionPrefab.LoadAllEffects() end

--- ClearAllEffects
-- @realm shared
function AfflictionPrefab.ClearAllEffects() end

--- LoadEffects
-- @realm shared
function LoadEffects() end

--- ClearEffects
-- @realm shared
function ClearEffects() end

--- ToString
-- @realm shared
-- @treturn string
function ToString() end

--- Instantiate
-- @realm shared
-- @tparam number strength
-- @tparam Character source
-- @treturn Affliction
function Instantiate(strength, source) end

--- GetActiveEffect
-- @realm shared
-- @tparam number currentStrength
-- @treturn Effect
function GetActiveEffect(currentStrength) end

--- GetTreatmentSuitability
-- @realm shared
-- @tparam Item item
-- @treturn number
function GetTreatmentSuitability(item) end

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
-- AfflictionPrefab.InternalDamage, Field of type AfflictionPrefab
-- @realm shared
-- @AfflictionPrefab AfflictionPrefab.InternalDamage

---
-- AfflictionPrefab.ImpactDamage, Field of type AfflictionPrefab
-- @realm shared
-- @AfflictionPrefab AfflictionPrefab.ImpactDamage

---
-- AfflictionPrefab.Bleeding, Field of type AfflictionPrefab
-- @realm shared
-- @AfflictionPrefab AfflictionPrefab.Bleeding

---
-- AfflictionPrefab.Burn, Field of type AfflictionPrefab
-- @realm shared
-- @AfflictionPrefab AfflictionPrefab.Burn

---
-- AfflictionPrefab.OxygenLow, Field of type AfflictionPrefab
-- @realm shared
-- @AfflictionPrefab AfflictionPrefab.OxygenLow

---
-- AfflictionPrefab.Bloodloss, Field of type AfflictionPrefab
-- @realm shared
-- @AfflictionPrefab AfflictionPrefab.Bloodloss

---
-- AfflictionPrefab.Pressure, Field of type AfflictionPrefab
-- @realm shared
-- @AfflictionPrefab AfflictionPrefab.Pressure

---
-- AfflictionPrefab.Stun, Field of type AfflictionPrefab
-- @realm shared
-- @AfflictionPrefab AfflictionPrefab.Stun

---
-- AfflictionPrefab.RadiationSickness, Field of type AfflictionPrefab
-- @realm shared
-- @AfflictionPrefab AfflictionPrefab.RadiationSickness

---
-- AfflictionPrefab.List, Field of type Enumerable
-- @realm shared
-- @Enumerable AfflictionPrefab.List

---
-- Effects, Field of type Enumerable
-- @realm shared
-- @Enumerable Effects

---
-- PeriodicEffects, Field of type IList`1
-- @realm shared
-- @IList`1 PeriodicEffects

---
-- TreatmentSuitability, Field of type Enumerable
-- @realm shared
-- @Enumerable TreatmentSuitability

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
-- AfflictionType, Field of type Identifier
-- @realm shared
-- @Identifier AfflictionType

---
-- LimbSpecific, Field of type bool
-- @realm shared
-- @bool LimbSpecific

---
-- IndicatorLimb, Field of type LimbType
-- @realm shared
-- @LimbType IndicatorLimb

---
-- Name, Field of type LocalizedString
-- @realm shared
-- @LocalizedString Name

---
-- Description, Field of type LocalizedString
-- @realm shared
-- @LocalizedString Description

---
-- TranslationIdentifier, Field of type Identifier
-- @realm shared
-- @Identifier TranslationIdentifier

---
-- IsBuff, Field of type bool
-- @realm shared
-- @bool IsBuff

---
-- HealableInMedicalClinic, Field of type bool
-- @realm shared
-- @bool HealableInMedicalClinic

---
-- HealCostMultiplier, Field of type number
-- @realm shared
-- @number HealCostMultiplier

---
-- BaseHealCost, Field of type number
-- @realm shared
-- @number BaseHealCost

---
-- CauseOfDeathDescription, Field of type LocalizedString
-- @realm shared
-- @LocalizedString CauseOfDeathDescription

---
-- SelfCauseOfDeathDescription, Field of type LocalizedString
-- @realm shared
-- @LocalizedString SelfCauseOfDeathDescription

---
-- ActivationThreshold, Field of type number
-- @realm shared
-- @number ActivationThreshold

---
-- ShowIconThreshold, Field of type number
-- @realm shared
-- @number ShowIconThreshold

---
-- ShowIconToOthersThreshold, Field of type number
-- @realm shared
-- @number ShowIconToOthersThreshold

---
-- MaxStrength, Field of type number
-- @realm shared
-- @number MaxStrength

---
-- GrainBurst, Field of type number
-- @realm shared
-- @number GrainBurst

---
-- ShowInHealthScannerThreshold, Field of type number
-- @realm shared
-- @number ShowInHealthScannerThreshold

---
-- TreatmentThreshold, Field of type number
-- @realm shared
-- @number TreatmentThreshold

---
-- KarmaChangeOnApplied, Field of type number
-- @realm shared
-- @number KarmaChangeOnApplied

---
-- BurnOverlayAlpha, Field of type number
-- @realm shared
-- @number BurnOverlayAlpha

---
-- DamageOverlayAlpha, Field of type number
-- @realm shared
-- @number DamageOverlayAlpha

---
-- AchievementOnRemoved, Field of type Identifier
-- @realm shared
-- @Identifier AchievementOnRemoved

---
-- Icon, Field of type Sprite
-- @realm shared
-- @Sprite Icon

---
-- IconColors, Field of type Color[]
-- @realm shared
-- @Color[] IconColors

---
-- AfflictionOverlay, Field of type Sprite
-- @realm shared
-- @Sprite AfflictionOverlay

---
-- AfflictionOverlayAlphaIsLinear, Field of type bool
-- @realm shared
-- @bool AfflictionOverlayAlphaIsLinear

---
-- AfflictionPrefab.Prefabs, Field of type PrefabCollection`1
-- @realm shared
-- @PrefabCollection`1 AfflictionPrefab.Prefabs

---
-- Identifier, Field of type Identifier
-- @realm shared
-- @Identifier Identifier

---
-- ContentFile, Field of type ContentFile
-- @realm shared
-- @ContentFile ContentFile

