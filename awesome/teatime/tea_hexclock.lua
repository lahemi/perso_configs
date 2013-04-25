#!/usr/bin/env lua

-- Our "environment"
local os = { date = os.date }
local math = { floor = math.floor }
local setmetatable = setmetatable
local capi = { timer = timer }
local textbox = require("wibox.widget.textbox")

-- The hexadecimal clock
local hexclock = { mt = {} }

-- Base 16 is beautiful.
local hex = { "1", "2", "3", "4", "5", "6", "7",
              "8", "9", "A", "B", "C", "D", "E", "F" }
-- Hex starts with 0 and this is a gum/glue solution that
-- makes string concat at hexadecValue possible later on.
hex[0] = "0"

local hexprefix = "0x"

local function hexclk()

    local now = os.date
    local hrs = now("%H")
    local mins = now("%M")
    local secs = now("%S")
    local totsecs = hrs*3600 + mins*60 + secs

    local hextime = math.floor(totsecs / (86400 / 65536)) -- 16^4
    local hex1 = math.floor(hextime / 4096)               -- 16^3
    local hextime = hextime - 4096 * hex1
    local hex2 = math.floor(hextime / 256)                -- 16^2
    local hextime = hextime - 256 * hex2
    local hex3 = math.floor(hextime / 16)                 -- 16^1
    local hextime = hextime - 16 * hex3
    local hex4 = hextime

    -- Underscores to make output cleaner.
    local hexadecValue = hexprefix .. hex[hex1] .. "_" .. hex[hex2] .. hex[hex3] .. "_" .. hex[hex4]

    return hexadecValue
end

function hexclock.new(timeout)
    local timeout = timeout or 1.1318

    local w = textbox()
    local timer = capi.timer { timeout = timeout }
    timer:connect_signal("timeout", function() w:set_markup(hexclk() .. " | ") end)

    timer:start()
    timer:emit_signal("timeout")
    return w
end


return setmetatable(hexclock, hexclock.mt)
