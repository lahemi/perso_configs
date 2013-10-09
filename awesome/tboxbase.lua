-- Instead of having to do this for each and every textbox,
-- we use this little function to do it for us.
-- See boxen.lua

local capi = { timer = timer }
local textbox = require("wibox.widget.textbox")

tboxbase = {}

tboxbase.create = function(fun,ptbl)
    local timeout   = ptbl.timeout   or 1
    local fmtbefore = ptbl.fmtbefore or ""
    local fmtafter  = ptbl.fmtafter  or "" 
    local params    = ptbl.params    or ""

    local w = textbox()
    local timer = capi.timer({ timeout = timeout })
    timer:connect_signal("timeout",
        function() w:set_markup(fmtbefore..fun(params)..fmtafter) end)

    timer:start()
    timer:emit_signal("timeout")
    return w
end

return tboxbase

