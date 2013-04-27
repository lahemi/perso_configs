#!/usr/bin/env lua

local io = io
local setmetatable = setmetatable
local tonumber = tonumber
local capi = { timer = timer }
local textbox = require("wibox.widget.textbox")

local osser = { mt = {} }

local function ossvol()
    local try = os.execute("type ossmix 2>/dev/null")
    if try ~= nil then
        local f = io.popen([[ossmix|awk 'BEGIN{ORS=$4} /jack.green.front / {printf substr($4,0,4)}']])
        if f ~= nil then
            local bri = f:read()
            f:close()
            if tonumber(bri) == nil then
                voll = "N/A"
            else
                voll = bri
            end
        else
            voll = "N/A"
        end
    else
        voll = "N/A"
    end

    return voll
end

function osser.new(format, timeout)
    local timeout = timeout or 1
    local format  = format or " | ♫"

    local w = textbox()
    local timer = capi.timer { timeout = timeout }
    timer:connect_signal("timeout", function() w:set_markup(format .. ossvol()) end)

    timer:start()
    timer:emit_signal("timeout")
    return w
end

return setmetatable(osser, osser.mt)
