-- Grabs the contents of XClip and then
-- adds it to a special queuefile for mplayer.
-- Also mplayer control, using a fifo for mplayer.
-- GPLv3, 2013, Lauri Peltomäki

local table  = { concat = table.concat }
local string = { find  = string.find,
                 match = string.match, }
local os = { getenv  = os.getenv,
             execute = os.execute }
local io = { open  = io.open,
             read  = io.read,
             close = io.close,
             popen = io.popen,
             write = io.write, }

mpl = {}

local mpdir     = os.getenv'HOME'..'/.mplayer/'
local queuefile = mpdir..'queuelist'
local mpfifo    = mpdir..'mp_fifo'

local runrall = function(cmd)
    if cmd then
        local ret = ""
        local fh  = io.popen(cmd)
        if fh then ret = fh:read('*a') else ret = nil end
        fh:close()
        
        return ret
    end
end

mpl.queue = function()
    local clip = ""
    local clip = runrall("xclip -o")
    if clip == nil then return end

    -- Sanitizing the string a bit, nicer for Quvi.
    if clip:find("youtube") then
        if not clip:find("^http") then clip = "http://"..clip end
        if clip:find("feature")   then clip = clip:match("(http.-)&") end
    end

    local fh = io.open(queuefile,"a")
    if fh == nil then return else fh:write(clip..'\n') fh:close() end
end

mpl.ctl = function(cmd)
    if not cmd then return end
    os.execute(table.concat{'echo ',cmd,' > ',mpfifo})
end


return mpl

