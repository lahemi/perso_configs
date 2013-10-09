#!/usr/bin/env lua
-- Incomplete.

--local posix = require'posix'
local tonumber = tonumber
local io = { open = io.open,
             read = io.read,
             close = io.close, }

net = {}

local units = { b = 1, kb = 1024, mb = 1024^2 }

local readf = function(file)
    local ret = ""
    local fh = io.open(file)
    if fh ~= nil then ret = fh:read'*l' else ret = nil end fh:close()
    return ret
end

-- The idea is sort there about. Doesn't really work yet though.
net.getdata = function(interfacename,unit)
    local name    = interfacename or "eth0"
    local unit    = unit or "kb"
    local now     = os.time()
    local rbytes  = "/sys/class/net/"..name.."/statistics/rx_bytes"
    local tbytes  = "/sys/class/net/"..name.."/statistics/tx_bytes"
    local rc1,rc2,sn1,sn2,down,up = 0,0,0,0,0,0

    rc1 = tonumber(readf(rbytes))/units[unit]
    sn1 = tonumber(readf(tbytes))/units[unit]

--    posix.sleep(0.01)

    rc2 = tonumber(readf(rbytes))/units[unit]
    sn2 = tonumber(readf(tbytes))/units[unit]

    up   = (sn2 - sn1)
    down = (rc2 - rc1)

    if unit ~= "b" then
        up   = ('%.01f'):format(up)
        down = ('%.01f'):format(down)
    end
    return table.concat{"↑ ",up," ","↓ ",down}
end

return net

