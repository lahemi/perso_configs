#!/usr/bin/env lua

local io = { popen = io.popen }
local setmetatable = setmetatable
local tonumber = tonumber

local ossvol = {}

local function osser(warg)

    local f = io.popen([[ossmix|grep "jack.green.front "|awk 'BEGIN{FS=":"} {print $3}'|awk '{print $1}']])
    local bri = f:read()
    f:close()

    local voll = tonumber(bri)

    return {voll}
end

return setmetatable(ossvol, { __call = function(_, ...) return osser(...) end })
