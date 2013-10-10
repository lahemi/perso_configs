
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

--[[local posix = require'posix'
while 0 do
    print(cpu.getdata())
    posix.sleep(1)
end]]--

return cpu

