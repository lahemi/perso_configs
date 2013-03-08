#!/usr/bin/env lua

-- Our "environment"
local os = { date = os.date }
local math = { floor = math.floor }
local setmetatable = setmetatable

-- The hexadecimal clock
local hexclock = {}

-- Base 16 is beautiful.
local hex = { "1", "2", "3", "4", "5", "6", "7",
              "8", "9", "A", "B", "C", "D", "E", "F" }
-- Hex starts with 0 and this is a gum/glue solution that
-- makes string concat at hexadecValue possible later on.
hex[0] = "0"

local hexprefix = "0x"

-- Vicious-style
local function worker(warg)

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

-- Set update to 1.3 secs ?
return setmetatable(hexclock, { __call = function(_, ...) return worker(...) end})
