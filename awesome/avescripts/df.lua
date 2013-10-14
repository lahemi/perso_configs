-- Small wrapper script around the basic core utility df.
-- Data could also be read and calculated from /sys/block/<dev>/stat

local string = { match = string.match }
local tonumber = tonumber
local io = { popen = io.popen,
             lines = io.lines,
             close = io.close, }

df = {}

-- Remember device and format can be any the actual df program uses.
df.getavail = function(dev,fmt)
    local ret = ''
    local fmt = fmt or 'MB'
    local dev = dev or 'sda1'
    if dev=='' then dev='sda1' end

    if tonumber(dev:match'%d+') < 10 then
        dev = dev..' '
    end

    local fh = io.popen('df -P -B'..fmt)
    if fh==nil then return end
    for l in fh:lines() do
        if l:match(dev) then
            ret = l:match'%w+%s+%w+%s+%w+%s+(%w+)' -- Available
        end
    end fh:close()

    return ret
end

return df

