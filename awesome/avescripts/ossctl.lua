#!/usr/bin/env lua
-- OSS controllering interface.
-- GPLv3, 2013, Lauri Peltomäki

-- Our "environment"
local type = type
local os = { execute = os.execute }
local string = { gsub = string.gsub,
                 match = string.match }
local io = { read  = io.read,
             popen = io.popen,
             close = io.close }

-- We'll pack everything in a table - creating a "module".
ossctl = {}

-- Adjust according to your local setup.
local device = "jack.green.front"
local mute   = "jack.green.mute"
local ossmix = "ossmix -q "

local escapemeta = function(s)
    return s:gsub("([().%%%+-$*[?^])","%%%1")
end

local execossmix = function()
    local ret = ""

    local fh = io.popen("ossmix -c")
    if fh then ret = fh:read('*a')
    else return nil end
    fh:close()

    return ret
end

ossctl.togglemute = function()
    local m = ""
    local m = execossmix()
    local m = m:match("!ossmix[^\n]-"..escapemeta(mute).." (%a+)")
    if m == "OFF" then os.execute(ossmix..mute.." ON")
    else os.execute(ossmix..mute.." OFF") end
end

ossctl.volume = function()
    local m = ""
    local m = execossmix()
    return m:match("!ossmix[^\n]-"..escapemeta(device).." (%d+%.%d+)")
end

ossctl.setvol = function(vol)
    if vol and type(vol) == "number" then
        os.execute(ossmix..device.." "..vol)
    end
end

ossctl.increase = function(amount)
    if amount and type(amount) == "number" then
        local vol = ossctl.volume()
        local vol = vol + amount
        os.execute(ossmix..device.." "..vol)
    end
end

ossctl.decrease = function(amount)
    if amount and type(amount) == "number" then
        local vol = ossctl.volume()
        local vol = vol - amount
        os.execute(ossmix..device.." "..vol)
    end
end

---- For standalone running. Adjust accordingly.
--[[main = function(arg)
    if     arg[1] == "-i" then increase(tonumber(arg[2]))
    elseif arg[1] == "-d" then decrease(tonumber(arg[2]))
    elseif arg[1] == "-s" then setvol(tonumber(arg[2]))
    elseif arg[1] == "-c" then print(volume())
    elseif arg[1] == "-m" then togglemute()
    else print("Usage: $0 <idsmc> [vol]") end
end
main(arg)]]--

return ossctl

