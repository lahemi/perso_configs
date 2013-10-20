-- Convert the seconds since the start of the Epoch
-- into: Year OrdinalDay Hour Minute Second
-- GPLv3, 2013, Lauri Peltomäki

local os = { time = os.time }
local tc = table.concat

unixclock = {}

-- Add those zeroes to make the output cleaner.
local mf = function(a)
    return string.format('%02.0f',math.floor(a))
end

unixclock.time = function()
    local now = os.time()

    local a  = mf(now/60/60/24/365.25)
    local d  = string.format('%03.0f',(now/60/60/24%365.25))
    local h  = mf(now/60/60%24)
    local m  = mf(now/60%60)
    local s  = mf(now%60)

    return tc{a,'-',d,'-',h,':',m,':',s}

end

return unixclock

