-- luacheck: ignore 111

--[[--
Barotrauma.GameSettings
]]
-- @code Game.Settings
-- @pragma nostrip
local GameSettings = {}

--- Init
-- @realm shared
function GameSettings.Init() end

--- SetCurrentConfig
-- @realm shared
-- @tparam Config& newConfig
function GameSettings.SetCurrentConfig(newConfig) end

--- SaveCurrentConfig
-- @realm shared
function GameSettings.SaveCurrentConfig() end

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
-- GameSettings.CurrentConfig, Field of type Config&
-- @realm shared
-- @Config& GameSettings.CurrentConfig

---
-- GameSettings.PlayerConfigPath, Field of type string
-- @realm shared
-- @string GameSettings.PlayerConfigPath

