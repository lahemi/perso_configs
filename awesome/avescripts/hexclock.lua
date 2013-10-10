-- Convert from mixed base time into a more sensible hexadecimal format.
-- A hexday is divided into 65536 parts. "Normal" day has 86400 seconds,
-- which makes one hex second roughly 1.31 common seconds.
-- GPLv3, 2013, Lauri Peltomäki

local dt = os.date
local mf = math.floor
local tc = table.concat

hexclock = {}

-- Base 16 is pretty.
local X = { '1','2','3','4','5','6','7',
            '8','9','A','B','C','D','E','F' }
X[0] = '0' -- Time can be used as the table index.

local pre = '0x'
local sep = '_'  -- To make the output cleaner.

hexclock.time = function()
    local h  = dt('%H')
    local m  = dt('%M')
    local s  = dt('%S')
    local ts = (h*3600)+(m*60)+s    -- total

    local xt = mf(ts/(86400/65536)) -- 16^4
    local h1 = mf(xt/4096)          -- 16^3
    local xt = xt-4096*h1  -- Sly var reuse
    local h2 = mf(xt/256)           -- 16^2
    local xt = xt-256*h2
    local h3 = mf(xt/16)            -- 16^1
    local xt = xt-16*h3
    local h4 = xt
    
    return tc{pre,X[h1],sep,X[h2],X[h3],sep,X[h4]}
end

return hexclock

