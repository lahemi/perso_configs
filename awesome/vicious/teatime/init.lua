-------------------------------------------------------------
-- A few widgets for the awesome wm, using vicious as a base.
------------------------------------------------------------
-- Vicious is licensed under GNU General Public License v2
-- and are copyleft of Adrian C. <anrxc@sysphere.org>
------------------------------------------------------------
-- These particular widgets are provided "as is" and without
-- any warranty. You are fully entitled to use them for your
-- own needs and to elaborate on them as you see fit.
-- No copyright claimed, 2013,
-- Lauri P. <lahemi.maki@gmail.com>
-----------------------------------------------------------

local setmetatable = setmetatable
local wrequire = require("vicious.helpers").wrequire

local teatime = { _NAME = "vicious.teatime" }

return setmetatable(teatime, { __index = wrequire })
