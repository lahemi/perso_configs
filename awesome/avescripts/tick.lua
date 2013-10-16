#!/usr/bin/env lua
-- "Through life some wander while others seem to race
--  success beating outwards no end to the maze
--  It takes all of us in and feeds on our strength
--  For those who remember it causes their pain
--
--  It makes us worry and takes our dreams
--  sometimes it's the enemy or so it seems
--  Forces us to hurry this threat through night and day
--  it's owned by the patient no price to pay"

local os = { date = os.date }
local string = { format = string.format }
local tonumber = tonumber
local tostring = tostring

tick = {}

-- Lo, horrifying code!
tick.tock = function()
    local t = { os.date'%Y',os.date'%m',os.date'%d',
                os.date'%H',os.date'%M' } -- Current times.
    local d = { 2049,12,31,24,60 }        -- Our end.
    for i=1,5 do
        local r = d[i]-tonumber(t[i])
        if r<10 then t[i] = '0'..tostring(r)
        else         t[i] = tostring(r) end
    end
    return ('%s-%s-%s:%s:%s'):format(t[1],t[2],t[3],
                                     t[4],t[5])
end

return tick

