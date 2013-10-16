-- Monitoring CPU is really a horridly complicated task.
-- This script is only supposed to give a rough idea.
-- GPLv3, 2013, Lauri Peltomäki

local tonumber = tonumber
local math = { floor = math.floor }
local string = { match = string.match,
                 gmatch = string.gmatch,}
local io = { open = io.open,
             read = io.read,
             close = io.close,}

cpu = {}

local prev_total = 0
local prev_idle  = 0

cpu.getdata = function()
    local fh = io.open'/proc/stat'
    if fh == nil then return
    else
        local cdata = ""
        local idle,total,c = 0,0,0

        cdata = fh:read'*l':match'^cpu%s+(.+)$'
        fh:close()

        for d in cdata:gmatch("[^%s]+") do
            c,d = (c+1),tonumber(d)
            if c==4 then idle = d end
            total = total + d
        end

        local diff_idle  = idle-prev_idle
        local diff_total = total-prev_total
        local diff_usage = math.floor((100*(diff_total-diff_idle)/diff_total))
        
        prev_total = total
        prev_idle  = idle

        return diff_usage.."%"
    end
end

return cpu

