-- luacheck: ignore 111

--[[--
Barotrauma.Networking.ServerSettings
]]
-- @code Game.ServerSettings
-- @pragma nostrip
local ServerSettings = {}

--- ReadMonsterEnabled
-- @realm shared
-- @tparam IReadMessage inc
function ReadMonsterEnabled(inc) end

--- WriteMonsterEnabled
-- @realm shared
-- @tparam IWriteMessage msg
-- @tparam table monsterEnabled
function WriteMonsterEnabled(msg, monsterEnabled) end

--- ReadExtraCargo
-- @realm shared
-- @tparam IReadMessage msg
-- @treturn bool
function ReadExtraCargo(msg) end

--- WriteExtraCargo
-- @realm shared
-- @tparam IWriteMessage msg
function WriteExtraCargo(msg) end

--- ReadHiddenSubs
-- @realm shared
-- @tparam IReadMessage msg
function ReadHiddenSubs(msg) end

--- WriteHiddenSubs
-- @realm shared
-- @tparam IWriteMessage msg
function WriteHiddenSubs(msg) end

--- SetPassword
-- @realm shared
-- @tparam string password
function SetPassword(password) end

--- SaltPassword
-- @realm shared
-- @tparam Byte[] password
-- @tparam number salt
-- @treturn Byte[]
function ServerSettings.SaltPassword(password, salt) end

--- IsPasswordCorrect
-- @realm shared
-- @tparam Byte[] input
-- @tparam number salt
-- @treturn bool
function IsPasswordCorrect(input, salt) end

--- UpdateFlag
-- @realm shared
-- @tparam NetFlags flag
function UpdateFlag(flag) end

--- GetRequiredFlags
-- @realm shared
-- @tparam Client c
-- @treturn NetFlags
function GetRequiredFlags(c) end

--- ServerAdminWrite
-- @realm shared
-- @tparam IWriteMessage outMsg
-- @tparam Client c
function ServerAdminWrite(outMsg, c) end

--- ServerWrite
-- @realm shared
-- @tparam IWriteMessage outMsg
-- @tparam Client c
function ServerWrite(outMsg, c) end

--- ServerRead
-- @realm shared
-- @tparam IReadMessage incMsg
-- @tparam Client c
function ServerRead(incMsg, c) end

--- SaveSettings
-- @realm shared
function SaveSettings() end

--- SelectNonHiddenSubmarine
-- @realm shared
-- @tparam string current
-- @treturn string
function SelectNonHiddenSubmarine(current) end

--- LoadClientPermissions
-- @realm shared
function LoadClientPermissions() end

--- SaveClientPermissions
-- @realm shared
function SaveClientPermissions() end

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
-- LastPropertyUpdateId, Field of type number
-- @realm shared
-- @number LastPropertyUpdateId

---
-- Name, Field of type string
-- @realm shared
-- @string Name

---
-- SerializableProperties, Field of type table
-- @realm shared
-- @table SerializableProperties

---
-- ServerName, Field of type string
-- @realm shared
-- @string ServerName

---
-- ServerMessageText, Field of type string
-- @realm shared
-- @string ServerMessageText

---
-- MonsterEnabled, Field of type table
-- @realm shared
-- @table MonsterEnabled

---
-- ExtraCargo, Field of type table
-- @realm shared
-- @table ExtraCargo

---
-- HiddenSubs, Field of type HashSet`1
-- @realm shared
-- @HashSet`1 HiddenSubs

---
-- ClientPermissions, Field of type table
-- @realm shared
-- @table ClientPermissions

---
-- Whitelist, Field of type WhiteList
-- @realm shared
-- @WhiteList Whitelist

---
-- TickRate, Field of type number
-- @realm shared
-- @number TickRate

---
-- RandomizeSeed, Field of type bool
-- @realm shared
-- @bool RandomizeSeed

---
-- UseRespawnShuttle, Field of type bool
-- @realm shared
-- @bool UseRespawnShuttle

---
-- RespawnInterval, Field of type number
-- @realm shared
-- @number RespawnInterval

---
-- MaxTransportTime, Field of type number
-- @realm shared
-- @number MaxTransportTime

---
-- MinRespawnRatio, Field of type number
-- @realm shared
-- @number MinRespawnRatio

---
-- AutoRestartInterval, Field of type number
-- @realm shared
-- @number AutoRestartInterval

---
-- StartWhenClientsReady, Field of type bool
-- @realm shared
-- @bool StartWhenClientsReady

---
-- StartWhenClientsReadyRatio, Field of type number
-- @realm shared
-- @number StartWhenClientsReadyRatio

---
-- AllowSpectating, Field of type bool
-- @realm shared
-- @bool AllowSpectating

---
-- SaveServerLogs, Field of type bool
-- @realm shared
-- @bool SaveServerLogs

---
-- AllowModDownloads, Field of type bool
-- @realm shared
-- @bool AllowModDownloads

---
-- AllowRagdollButton, Field of type bool
-- @realm shared
-- @bool AllowRagdollButton

---
-- AllowFileTransfers, Field of type bool
-- @realm shared
-- @bool AllowFileTransfers

---
-- VoiceChatEnabled, Field of type bool
-- @realm shared
-- @bool VoiceChatEnabled

---
-- PlayStyle, Field of type PlayStyle
-- @realm shared
-- @PlayStyle PlayStyle

---
-- LosMode, Field of type LosMode
-- @realm shared
-- @LosMode LosMode

---
-- LinesPerLogFile, Field of type number
-- @realm shared
-- @number LinesPerLogFile

---
-- AutoRestart, Field of type bool
-- @realm shared
-- @bool AutoRestart

---
-- HasPassword, Field of type bool
-- @realm shared
-- @bool HasPassword

---
-- AllowVoteKick, Field of type bool
-- @realm shared
-- @bool AllowVoteKick

---
-- AllowEndVoting, Field of type bool
-- @realm shared
-- @bool AllowEndVoting

---
-- AllowRespawn, Field of type bool
-- @realm shared
-- @bool AllowRespawn

---
-- BotCount, Field of type number
-- @realm shared
-- @number BotCount

---
-- MaxBotCount, Field of type number
-- @realm shared
-- @number MaxBotCount

---
-- BotSpawnMode, Field of type BotSpawnMode
-- @realm shared
-- @BotSpawnMode BotSpawnMode

---
-- DisableBotConversations, Field of type bool
-- @realm shared
-- @bool DisableBotConversations

---
-- SelectedLevelDifficulty, Field of type number
-- @realm shared
-- @number SelectedLevelDifficulty

---
-- AllowDisguises, Field of type bool
-- @realm shared
-- @bool AllowDisguises

---
-- AllowRewiring, Field of type bool
-- @realm shared
-- @bool AllowRewiring

---
-- LockAllDefaultWires, Field of type bool
-- @realm shared
-- @bool LockAllDefaultWires

---
-- AllowLinkingWifiToChat, Field of type bool
-- @realm shared
-- @bool AllowLinkingWifiToChat

---
-- AllowFriendlyFire, Field of type bool
-- @realm shared
-- @bool AllowFriendlyFire

---
-- DestructibleOutposts, Field of type bool
-- @realm shared
-- @bool DestructibleOutposts

---
-- KillableNPCs, Field of type bool
-- @realm shared
-- @bool KillableNPCs

---
-- BanAfterWrongPassword, Field of type bool
-- @realm shared
-- @bool BanAfterWrongPassword

---
-- MaxPasswordRetriesBeforeBan, Field of type number
-- @realm shared
-- @number MaxPasswordRetriesBeforeBan

---
-- SelectedSubmarine, Field of type string
-- @realm shared
-- @string SelectedSubmarine

---
-- SelectedShuttle, Field of type string
-- @realm shared
-- @string SelectedShuttle

---
-- TraitorsEnabled, Field of type YesNoMaybe
-- @realm shared
-- @YesNoMaybe TraitorsEnabled

---
-- TraitorsMinPlayerCount, Field of type number
-- @realm shared
-- @number TraitorsMinPlayerCount

---
-- TraitorsMinStartDelay, Field of type number
-- @realm shared
-- @number TraitorsMinStartDelay

---
-- TraitorsMaxStartDelay, Field of type number
-- @realm shared
-- @number TraitorsMaxStartDelay

---
-- TraitorsMinRestartDelay, Field of type number
-- @realm shared
-- @number TraitorsMinRestartDelay

---
-- TraitorsMaxRestartDelay, Field of type number
-- @realm shared
-- @number TraitorsMaxRestartDelay

---
-- SubSelectionMode, Field of type SelectionMode
-- @realm shared
-- @SelectionMode SubSelectionMode

---
-- ModeSelectionMode, Field of type SelectionMode
-- @realm shared
-- @SelectionMode ModeSelectionMode

---
-- BanList, Field of type BanList
-- @realm shared
-- @BanList BanList

---
-- EndVoteRequiredRatio, Field of type number
-- @realm shared
-- @number EndVoteRequiredRatio

---
-- VoteRequiredRatio, Field of type number
-- @realm shared
-- @number VoteRequiredRatio

---
-- VoteTimeout, Field of type number
-- @realm shared
-- @number VoteTimeout

---
-- KickVoteRequiredRatio, Field of type number
-- @realm shared
-- @number KickVoteRequiredRatio

---
-- KillDisconnectedTime, Field of type number
-- @realm shared
-- @number KillDisconnectedTime

---
-- KickAFKTime, Field of type number
-- @realm shared
-- @number KickAFKTime

---
-- KarmaEnabled, Field of type bool
-- @realm shared
-- @bool KarmaEnabled

---
-- KarmaPreset, Field of type string
-- @realm shared
-- @string KarmaPreset

---
-- GameModeIdentifier, Field of type Identifier
-- @realm shared
-- @Identifier GameModeIdentifier

---
-- MissionType, Field of type string
-- @realm shared
-- @string MissionType

---
-- MaxPlayers, Field of type number
-- @realm shared
-- @number MaxPlayers

---
-- AllowedRandomMissionTypes, Field of type table
-- @realm shared
-- @table AllowedRandomMissionTypes

---
-- AutoBanTime, Field of type number
-- @realm shared
-- @number AutoBanTime

---
-- MaxAutoBanTime, Field of type number
-- @realm shared
-- @number MaxAutoBanTime

---
-- RadiationEnabled, Field of type bool
-- @realm shared
-- @bool RadiationEnabled

---
-- MaxMissionCount, Field of type number
-- @realm shared
-- @number MaxMissionCount

---
-- AllowSubVoting, Field of type bool
-- @realm shared
-- @bool AllowSubVoting

---
-- AllowModeVoting, Field of type bool
-- @realm shared
-- @bool AllowModeVoting

---
-- AllowedClientNameChars, Field of type table
-- @realm shared
-- @table AllowedClientNameChars

---
-- LastUpdateIdForFlag, Field of type table
-- @realm shared
-- @table LastUpdateIdForFlag

---
-- ServerDetailsChanged, Field of type bool
-- @realm shared
-- @bool ServerDetailsChanged

---
-- Port, Field of type number
-- @realm shared
-- @number Port

---
-- QueryPort, Field of type number
-- @realm shared
-- @number QueryPort

---
-- ListenIPAddress, Field of type IPAddress
-- @realm shared
-- @IPAddress ListenIPAddress

---
-- EnableUPnP, Field of type bool
-- @realm shared
-- @bool EnableUPnP

---
-- ServerLog, Field of type ServerLog
-- @realm shared
-- @ServerLog ServerLog

---
-- AutoRestartTimer, Field of type number
-- @realm shared
-- @number AutoRestartTimer

---
-- IsPublic, Field of type bool
-- @realm shared
-- @bool IsPublic

---
-- ServerSettings.ClientPermissionsFile, Field of type string
-- @realm shared
-- @string ServerSettings.ClientPermissionsFile

---
-- ServerSettings.SubmarineSeparatorChar, Field of type Char
-- @realm shared
-- @Char ServerSettings.SubmarineSeparatorChar

---
-- ServerSettings.PermissionPresetFile, Field of type string
-- @realm shared
-- @string ServerSettings.PermissionPresetFile

---
-- ServerSettings.SettingsFile, Field of type string
-- @realm shared
-- @string ServerSettings.SettingsFile

---
-- ServerSettings.MaxExtraCargoItemsOfType, Field of type number
-- @realm shared
-- @number ServerSettings.MaxExtraCargoItemsOfType

---
-- ServerSettings.MaxExtraCargoItemTypes, Field of type number
-- @realm shared
-- @number ServerSettings.MaxExtraCargoItemTypes

