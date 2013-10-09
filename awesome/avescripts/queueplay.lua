#!/usr/bin/env lua

local string = { find = string.find,
                 gsub = string.gsub,
                 match = string.match,
                 gmatch = string.gmatch, }
local io = { open  = io.open,
             read  = io.read,
             close = io.close,
             popen = io.popen,
             write = io.write, }

queueplay = {}

local queuefile = os.getenv'HOME'..'/.mplayer/queuelist'

local runrall = function(cmd)
    if cmd then
        local ret = ""
        local fh  = io.popen(cmd)
        if fh then ret = fh:read('*a') else ret = nil end
        fh:close()
        
        return ret
    end
end

local appendqueue = function(url)
    if url then
        local fh = io.open(queuefile,"a")
        if fh then fh:write(url..'\n') end
        fh:close()
    end
end


queueplay.addlist = function()

    local clip = ""
    local clip = runrall("xclip -o")
    if clip == nil then return end

    if clip:find("youtube") then
        if not clip:find("^http") then clip = "http://"..clip end
        if clip:find("feature")   then clip = clip:match("(http.-)&") end

        local url = ""
        local url = runrall("quvi --verbosity quiet "..clip)
        if url == nil then return end

        local vidurl = url:match('"url": "(http.-)"')
        appendqueue(vidurl)        

        -- Requires lua5.1. Need to find something I can use with 5.2...
--[[    elseif clip:find("ted") then
        local http = require'socket.http'
        local page = assert(http.request(clip))

        for line in page:gmatch("[^\n]+") do
            if line:find("no%-flash%-video%-download") then
                local ret = line:gsub("^%s+","")
                                :gsub("%s+$","")
                                :match('(http.-)"')
                appendqueue(ret)
                break
            end
        end]]--
    end
end

--queueplay.play()

return queueplay

