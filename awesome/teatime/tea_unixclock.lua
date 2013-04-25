#!/usr/bin/env lua

-- Our environment
local io = { popen = io.popen,
             close = io.close }
local math = { floor = math.floor }
local string = { len = string.len }
local setmetatable = setmetatable
local capi = { timer = timer }
local textbox = require("wibox.widget.textbox")

-- Unix time, Year-Day:Hour:Min:Sec
local unixalone = { mt = {} }

local prf = "0"

local function unix_td()
    local exec = io.popen("date +%s")
    local unix_sec = exec:read()
    exec:close()

    local fl_min = math.floor(unix_sec / 60)
    local fl_hour = math.floor(fl_min / 60)
    local fl_day = math.floor(fl_hour / 24)
    local fl_year = math.floor(fl_day / 365)

    local oth_min = unix_sec / 60
    local oth_hour = oth_min / 60
    local oth_day = oth_hour / 24
    -- Leap year, hence 365.25
    local oth_year = math.floor(oth_day % 365.25)

    local mod_min = unix_sec % 60
    local mod_hour = math.floor(oth_min % 60)
    local mod_day = math.floor(oth_hour % 24)

    -- Adding leading zeroes, as in 02:05:09 instead of 2:5:9
    if string.len(oth_year) == 1 then
        oth_year = prf .. prf .. oth_year
    elseif string.len(oth_year) == 2 then
        oth_year = prf .. oth_year
    end

    if string.len(mod_day) == 1 then
        mod_day = prf .. mod_day
    end

    if string.len(mod_hour) == 1 then
        mod_hour = prf .. mod_hour
    end

    if string.len(mod_min) == 1 then
        mod_min = prf .. mod_min
    end

    local unix_time = fl_year .. "-" .. oth_year .. ":" .. mod_day .. ":" .. mod_hour .. ":" .. mod_min

    return unix_time
end

function unixalone.new(timeout)
    local timeout = timeout or 1

    local w = textbox()
    local timer = capi.timer { timeout = timeout }
    timer:connect_signal("timeout", function() w:set_markup(" | " .. unix_td() .. " ") end)

    timer:start()
    timer:emit_signal("timeout")
    return w
end

return setmetatable(unixalone, unixalone.mt)
