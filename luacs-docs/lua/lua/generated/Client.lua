-- luacheck: ignore 111

--[[--
Barotrauma Client class with some additional functions and fields

Barotrauma source code: [Client.cs](https://github.com/evilfactory/Barotrauma-lua-attempt/blob/master/Barotrauma/BarotraumaShared/SharedSource/Networking/Client.cs)
]]
-- @code Client
-- @pragma nostrip

local Client = {}

-- @remove function SetClientCharacter(character) end
-- @remove function Kick(reason) end
-- @remove function Ban(reason, range, seconds) end
-- @remove function Client.Unban(player, endpoint) end
-- @remove function CheckPermission(permissions) end

--- Sets the client character.
-- @realm server 
function SetClientCharacter(character) end

--- Kick a client.
-- @realm server 
function Kick(reason) end

--- Ban a client.
-- @realm server 
function Ban(reason, range, seconds) end

--- Checks permissions, Client.Permissions.
-- @realm server 
function CheckPermission(permissions) end

--- Unban a client.
-- @realm server 
function Client.Unban(player, endpoint) end


--- Ban
-- @realm shared
-- @tparam string player
-- @tparam string reason
-- @tparam bool range
-- @tparam number seconds
function Client.Ban(player, reason, range, seconds) end

--- InitClientSync
-- @realm shared
function InitClientSync() end

--- IsValidName
-- @realm shared
-- @tparam string name
-- @tparam ServerSettings serverSettings
-- @treturn bool
function Client.IsValidName(name, serverSettings) end

--- EndpointMatches
-- @realm shared
-- @tparam string endPoint
-- @treturn bool
function EndpointMatches(endPoint) end

--- SetPermissions
-- @realm shared
-- @tparam ClientPermissions permissions
-- @tparam Enumerable permittedConsoleCommands
function SetPermissions(permissions, permittedConsoleCommands) end

--- GivePermission
-- @realm shared
-- @tparam ClientPermissions permission
function GivePermission(permission) end

--- RemovePermission
-- @realm shared
-- @tparam ClientPermissions permission
function RemovePermission(permission) end

--- HasPermission
-- @realm shared
-- @tparam ClientPermissions permission
-- @treturn bool
function HasPermission(permission) end

--- GetVote
-- @realm shared
-- @tparam VoteType voteType
-- @treturn T
function GetVote(voteType) end

--- SetVote
-- @realm shared
-- @tparam VoteType voteType
-- @tparam Object value
function SetVote(voteType, value) end

--- ResetVotes
-- @realm shared
function ResetVotes() end

--- AddKickVote
-- @realm shared
-- @tparam Client voter
function AddKickVote(voter) end

--- RemoveKickVote
-- @realm shared
-- @tparam Client voter
function RemoveKickVote(voter) end

--- HasKickVoteFrom
-- @realm shared
-- @tparam Client voter
-- @treturn bool
function HasKickVoteFrom(voter) end

--- HasKickVoteFromID
-- @realm shared
-- @tparam number id
-- @treturn bool
function HasKickVoteFromID(id) end

--- UpdateKickVotes
-- @realm shared
-- @tparam table connectedClients
function Client.UpdateKickVotes(connectedClients) end

--- WritePermissions
-- @realm shared
-- @tparam IWriteMessage msg
function WritePermissions(msg) end

--- ReadPermissions
-- @realm shared
-- @tparam IReadMessage inc
-- @tparam ClientPermissions& permissions
-- @tparam List`1& permittedCommands
function Client.ReadPermissions(inc, permissions, permittedCommands) end

--- ReadPermissions
-- @realm shared
-- @tparam IReadMessage inc
function ReadPermissions(inc) end

--- SanitizeName
-- @realm shared
-- @tparam string name
-- @treturn string
function Client.SanitizeName(name) end

--- Dispose
-- @realm shared
function Dispose() end

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
-- CharacterInfo, Field of type CharacterInfo
-- @realm shared
-- @CharacterInfo CharacterInfo

---
-- Connection, Field of type NetworkConnection
-- @realm shared
-- @NetworkConnection Connection

---
-- Karma, Field of type number
-- @realm shared
-- @number Karma

---
-- Client.ClientList, Field of type table
-- @realm shared
-- @table Client.ClientList

---
-- Character, Field of type Character
-- @realm shared
-- @Character Character

---
-- SpectatePos, Field of type Nullable`1
-- @realm shared
-- @Nullable`1 SpectatePos

---
-- Spectating, Field of type bool
-- @realm shared
-- @bool Spectating

---
-- Muted, Field of type bool
-- @realm shared
-- @bool Muted

---
-- HasPermissions, Field of type bool
-- @realm shared
-- @bool HasPermissions

---
-- VoipQueue, Field of type VoipQueue
-- @realm shared
-- @VoipQueue VoipQueue

---
-- InGame, Field of type bool
-- @realm shared
-- @bool InGame

---
-- KickVoteCount, Field of type number
-- @realm shared
-- @number KickVoteCount

---
-- VoiceEnabled, Field of type bool
-- @realm shared
-- @bool VoiceEnabled

---
-- LastRecvClientListUpdate, Field of type number
-- @realm shared
-- @number LastRecvClientListUpdate

---
-- LastSentServerSettingsUpdate, Field of type number
-- @realm shared
-- @number LastSentServerSettingsUpdate

---
-- LastRecvServerSettingsUpdate, Field of type number
-- @realm shared
-- @number LastRecvServerSettingsUpdate

---
-- LastRecvLobbyUpdate, Field of type number
-- @realm shared
-- @number LastRecvLobbyUpdate

---
-- LastSentChatMsgID, Field of type number
-- @realm shared
-- @number LastSentChatMsgID

---
-- LastRecvChatMsgID, Field of type number
-- @realm shared
-- @number LastRecvChatMsgID

---
-- LastSentEntityEventID, Field of type number
-- @realm shared
-- @number LastSentEntityEventID

---
-- LastRecvEntityEventID, Field of type number
-- @realm shared
-- @number LastRecvEntityEventID

---
-- LastRecvCampaignUpdate, Field of type number
-- @realm shared
-- @number LastRecvCampaignUpdate

---
-- LastRecvCampaignSave, Field of type number
-- @realm shared
-- @number LastRecvCampaignSave

---
-- LastCampaignSaveSendTime, Field of type Pair`2
-- @realm shared
-- @Pair`2 LastCampaignSaveSendTime

---
-- ChatMsgQueue, Field of type table
-- @realm shared
-- @table ChatMsgQueue

---
-- LastChatMsgQueueID, Field of type number
-- @realm shared
-- @number LastChatMsgQueueID

---
-- LastSentChatMessages, Field of type table
-- @realm shared
-- @table LastSentChatMessages

---
-- ChatSpamSpeed, Field of type number
-- @realm shared
-- @number ChatSpamSpeed

---
-- ChatSpamTimer, Field of type number
-- @realm shared
-- @number ChatSpamTimer

---
-- ChatSpamCount, Field of type number
-- @realm shared
-- @number ChatSpamCount

---
-- RoundsSincePlayedAsTraitor, Field of type number
-- @realm shared
-- @number RoundsSincePlayedAsTraitor

---
-- KickAFKTimer, Field of type number
-- @realm shared
-- @number KickAFKTimer

---
-- MidRoundSyncTimeOut, Field of type number
-- @realm shared
-- @number MidRoundSyncTimeOut

---
-- NeedsMidRoundSync, Field of type bool
-- @realm shared
-- @bool NeedsMidRoundSync

---
-- UnreceivedEntityEventCount, Field of type number
-- @realm shared
-- @number UnreceivedEntityEventCount

---
-- FirstNewEventID, Field of type number
-- @realm shared
-- @number FirstNewEventID

---
-- EntityEventLastSent, Field of type table
-- @realm shared
-- @table EntityEventLastSent

---
-- PositionUpdateLastSent, Field of type table
-- @realm shared
-- @table PositionUpdateLastSent

---
-- PendingPositionUpdates, Field of type Queue`1
-- @realm shared
-- @Queue`1 PendingPositionUpdates

---
-- ReadyToStart, Field of type bool
-- @realm shared
-- @bool ReadyToStart

---
-- JobPreferences, Field of type table
-- @realm shared
-- @table JobPreferences

---
-- AssignedJob, Field of type JobVariant
-- @realm shared
-- @JobVariant AssignedJob

---
-- DeleteDisconnectedTimer, Field of type number
-- @realm shared
-- @number DeleteDisconnectedTimer

---
-- SpectateOnly, Field of type bool
-- @realm shared
-- @bool SpectateOnly

---
-- WaitForNextRoundRespawn, Field of type Nullable`1
-- @realm shared
-- @Nullable`1 WaitForNextRoundRespawn

---
-- KarmaKickCount, Field of type number
-- @realm shared
-- @number KarmaKickCount

---
-- Name, Field of type string
-- @realm shared
-- @string Name

---
-- NameID, Field of type number
-- @realm shared
-- @number NameID

---
-- ID, Field of type Byte
-- @realm shared
-- @Byte ID

---
-- SteamID, Field of type number
-- @realm shared
-- @number SteamID

---
-- OwnerSteamID, Field of type number
-- @realm shared
-- @number OwnerSteamID

---
-- Language, Field of type LanguageIdentifier
-- @realm shared
-- @LanguageIdentifier Language

---
-- Ping, Field of type number
-- @realm shared
-- @number Ping

---
-- PreferredJob, Field of type Identifier
-- @realm shared
-- @Identifier PreferredJob

---
-- TeamID, Field of type CharacterTeamType
-- @realm shared
-- @CharacterTeamType TeamID

---
-- PreferredTeam, Field of type CharacterTeamType
-- @realm shared
-- @CharacterTeamType PreferredTeam

---
-- CharacterID, Field of type number
-- @realm shared
-- @number CharacterID

---
-- HasSpawned, Field of type bool
-- @realm shared
-- @bool HasSpawned

---
-- GivenAchievements, Field of type HashSet`1
-- @realm shared
-- @HashSet`1 GivenAchievements

---
-- Permissions, Field of type ClientPermissions
-- @realm shared
-- @ClientPermissions Permissions

---
-- PermittedConsoleCommands, Field of type HashSet`1
-- @realm shared
-- @HashSet`1 PermittedConsoleCommands

---
-- Client.MaxNameLength, Field of type number
-- @realm shared
-- @number Client.MaxNameLength

