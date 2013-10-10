-- Convert the seconds since the start of the Epoch
-- into: Year OrdinalDay Hour Minute Second
-- GPLv3, 2013, Lauri Peltomäki

local os = { time = os.time }
local tc = table.concat
local mf = math.floor

unixclock = {}

unixclock.time = function()
    local now = os.time()

    local a  = mf(now/60/60/24/365.25)
    local df = mf(now/60/60/24%365.25)
    local h  = mf(now/60/60%24)
    local m  = mf(now/60%60)
    local s  = mf(now%60)
    local d  = ''

    if     df<10  then d='00'..df
    elseif df<100 then d='0'..df
    else d=df end

    if h<10 then h='0'..h end
    if m<10 then m='0'..m end
    if s<10 then s='0'..s end

    return tc{a,'-',d,'-',h,':',m,':',s}

end

return unixclock

