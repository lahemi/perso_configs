#!/usr/bin/env lua

local io = io
local setmetatable = setmetatable
local tonumber = tonumber
local capi = { timer = timer }
local textbox = require("wibox.widget.textbox")

local osser = { mt = {} }

local function ossvol()
    local f = io.popen([[ossmix|awk 'BEGIN{ORS=$4} /jack.green.front / {printf substr($4,0,4)}']])
    local bri = f:read()
    f:close()

    local voll = tonumber(bri)

    return voll
end

function osser.new(timeout)
    local timeout = timeout or 1

    local w = textbox()
    local timer = capi.timer { timeout = timeout }
    timer:connect_signal("timeout", function() w:set_markup(" | ♫" .. ossvol()) end)

    timer:start()
    timer:emit_signal("timeout")
    return w
end

return setmetatable(osser, osser.mt)
