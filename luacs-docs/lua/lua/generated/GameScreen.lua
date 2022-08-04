-- luacheck: ignore 111

--[[--
Barotrauma.GameScreen
]]
-- @code Game.GameScreen
-- @pragma nostrip
local GameScreen = {}

--- Select
-- @realm shared
function Select() end

--- Deselect
-- @realm shared
function Deselect() end

--- Update
-- @realm shared
-- @tparam number deltaTime
function Update(deltaTime) end

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
-- Cam, Field of type Camera
-- @realm shared
-- @Camera Cam

---
-- GameTime, Field of type number
-- @realm shared
-- @number GameTime

---
-- IsEditor, Field of type bool
-- @realm shared
-- @bool IsEditor

