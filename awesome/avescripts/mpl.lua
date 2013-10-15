-- Grabs the contents of XClip and then
-- adds it to a special queuefile for mplayer.
-- Also mplayer control, using a fifo for mplayer.
-- GPLv3, 2013, Lauri Peltomäki

local tonumber = tonumber
local table  = { concat = table.concat }
local string = { find  = string.find,
                 match = string.match, }
local os = { getenv  = os.getenv,
             execute = os.execute }
local io = { open  = io.open,
             read  = io.read,
             close = io.close,
             lines = io.lines,
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

-- Hangs occasionally, freezing Awesome with it.
-- Maybe use luaposix for this ?
mpl.ctl = function(cmd)
    if not cmd then return end
    os.execute(table.concat{'echo ',cmd,' > ',mpfifo})
end

-- Toggle "pause" of ogg123 by using PID and signals.
mpl.oggctl = function()
    local pid   = 0 
    local state = ''

    local fh = io.popen'ps cx'
    if fh==nil then return end 
    for l in fh:lines() do
        if l:find'ogg123' then
            local c = 0 
            for t in l:gmatch'[^%s]+' do
                c=c+1
                if     c==1 then pid   = tonumber(t)
                elseif c==3 then state = t 
                break end 
            end
            break
        end
    end fh:close()

    if state:find'Sl' then
        os.execute('kill -s TSTP '..pid)
    elseif state:find'Tl' then
        os.execute('kill -s CONT '..pid)
    end 
end


return mpl

