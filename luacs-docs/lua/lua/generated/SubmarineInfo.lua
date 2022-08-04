-- luacheck: ignore 111

--[[--
Barotrauma.SubmarineInfo
]]
-- @code SubmarineInfo
-- @pragma nostrip
local SubmarineInfo = {}

--- ToString
-- @realm shared
-- @treturn string
function ToString() end

--- Reload
-- @realm shared
function Reload() end

--- Dispose
-- @realm shared
function Dispose() end

--- IsVanillaSubmarine
-- @realm shared
-- @treturn bool
function IsVanillaSubmarine() end

--- StartHashDocTask
-- @realm shared
-- @tparam XDocument doc
function StartHashDocTask(doc) end

--- HasTag
-- @realm shared
-- @tparam SubmarineTag tag
-- @treturn bool
function HasTag(tag) end

--- AddTag
-- @realm shared
-- @tparam SubmarineTag tag
function AddTag(tag) end

--- RemoveTag
-- @realm shared
-- @tparam SubmarineTag tag
function RemoveTag(tag) end

--- CheckSubsLeftBehind
-- @realm shared
-- @tparam XElement element
function CheckSubsLeftBehind(element) end

--- GetRealWorldCrushDepth
-- @realm shared
-- @treturn number
function GetRealWorldCrushDepth() end

--- GetRealWorldCrushDepthMultiplier
-- @realm shared
-- @treturn number
function GetRealWorldCrushDepthMultiplier() end

--- SaveAs
-- @realm shared
-- @tparam string filePath
-- @tparam MemoryStream previewImage
function SaveAs(filePath, previewImage) end

--- AddToSavedSubs
-- @realm shared
-- @tparam SubmarineInfo subInfo
function SubmarineInfo.AddToSavedSubs(subInfo) end

--- RemoveSavedSub
-- @realm shared
-- @tparam string filePath
function SubmarineInfo.RemoveSavedSub(filePath) end

--- RefreshSavedSub
-- @realm shared
-- @tparam string filePath
function SubmarineInfo.RefreshSavedSub(filePath) end

--- RefreshSavedSubs
-- @realm shared
function SubmarineInfo.RefreshSavedSubs() end

--- OpenFile
-- @realm shared
-- @tparam string file
-- @treturn XDocument
function SubmarineInfo.OpenFile(file) end

--- OpenFile
-- @realm shared
-- @tparam string file
-- @tparam Exception& exception
-- @treturn XDocument
function SubmarineInfo.OpenFile(file, exception) end

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
-- SubmarineInfo.SavedSubmarines, Field of type Enumerable
-- @realm shared
-- @Enumerable SubmarineInfo.SavedSubmarines

---
-- Tags, Field of type SubmarineTag
-- @realm shared
-- @SubmarineTag Tags

---
-- EqualityCheckVal, Field of type number
-- @realm shared
-- @number EqualityCheckVal

---
-- Name, Field of type string
-- @realm shared
-- @string Name

---
-- DisplayName, Field of type LocalizedString
-- @realm shared
-- @LocalizedString DisplayName

---
-- Description, Field of type LocalizedString
-- @realm shared
-- @LocalizedString Description

---
-- Price, Field of type number
-- @realm shared
-- @number Price

---
-- InitialSuppliesSpawned, Field of type bool
-- @realm shared
-- @bool InitialSuppliesSpawned

---
-- GameVersion, Field of type Version
-- @realm shared
-- @Version GameVersion

---
-- Type, Field of type SubmarineType
-- @realm shared
-- @SubmarineType Type

---
-- OutpostModuleInfo, Field of type OutpostModuleInfo
-- @realm shared
-- @OutpostModuleInfo OutpostModuleInfo

---
-- IsOutpost, Field of type bool
-- @realm shared
-- @bool IsOutpost

---
-- IsWreck, Field of type bool
-- @realm shared
-- @bool IsWreck

---
-- IsBeacon, Field of type bool
-- @realm shared
-- @bool IsBeacon

---
-- IsPlayer, Field of type bool
-- @realm shared
-- @bool IsPlayer

---
-- IsRuin, Field of type bool
-- @realm shared
-- @bool IsRuin

---
-- IsCampaignCompatible, Field of type bool
-- @realm shared
-- @bool IsCampaignCompatible

---
-- IsCampaignCompatibleIgnoreClass, Field of type bool
-- @realm shared
-- @bool IsCampaignCompatibleIgnoreClass

---
-- MD5Hash, Field of type Md5Hash
-- @realm shared
-- @Md5Hash MD5Hash

---
-- CalculatingHash, Field of type bool
-- @realm shared
-- @bool CalculatingHash

---
-- Dimensions, Field of type Vector2
-- @realm shared
-- @Vector2 Dimensions

---
-- CargoCapacity, Field of type number
-- @realm shared
-- @number CargoCapacity

---
-- FilePath, Field of type string
-- @realm shared
-- @string FilePath

---
-- SubmarineElement, Field of type XElement
-- @realm shared
-- @XElement SubmarineElement

---
-- IsFileCorrupted, Field of type bool
-- @realm shared
-- @bool IsFileCorrupted

---
-- RequiredContentPackagesInstalled, Field of type bool
-- @realm shared
-- @bool RequiredContentPackagesInstalled

---
-- SubsLeftBehind, Field of type bool
-- @realm shared
-- @bool SubsLeftBehind

---
-- LeftBehindSubDockingPortOccupied, Field of type bool
-- @realm shared
-- @bool LeftBehindSubDockingPortOccupied

---
-- LastModifiedTime, Field of type DateTime
-- @realm shared
-- @DateTime LastModifiedTime

---
-- RecommendedCrewSizeMin, Field of type number
-- @realm shared
-- @number RecommendedCrewSizeMin

---
-- RecommendedCrewSizeMax, Field of type number
-- @realm shared
-- @number RecommendedCrewSizeMax

---
-- RecommendedCrewExperience, Field of type string
-- @realm shared
-- @string RecommendedCrewExperience

---
-- RequiredContentPackages, Field of type HashSet`1
-- @realm shared
-- @HashSet`1 RequiredContentPackages

---
-- SubmarineClass, Field of type SubmarineClass
-- @realm shared
-- @SubmarineClass SubmarineClass

---
-- LeftBehindDockingPortIDs, Field of type table
-- @realm shared
-- @table LeftBehindDockingPortIDs

---
-- BlockedDockingPortIDs, Field of type table
-- @realm shared
-- @table BlockedDockingPortIDs

---
-- OutpostGenerationParams, Field of type OutpostGenerationParams
-- @realm shared
-- @OutpostGenerationParams OutpostGenerationParams

---
-- OutpostNPCs, Field of type table
-- @realm shared
-- @table OutpostNPCs

