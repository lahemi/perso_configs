#!/usr/bin/env lua
-- Memory usage in Mb and %
-- GPLv3, 2013, Lauri Peltomäki

local tonumber = tonumber
local tostring = tostring
local io = { open  = io.open,
             read  = io.read,
             close = io.close, }
local string = { match  = string.match,
                 format = string.format, }

mem = {}

mem.getdata = function()
    local filetbl = {}
    local fh = io.open("/proc/meminfo")
    if not fh then return
    else -- We only need the 4 first lines.
        local c=0
        while c<4 do
            filetbl[#filetbl+1] = fh:read'*l'
            c=c+1
        end
    end fh:close()
    local data = {}
    for i=1,#filetbl do 
        data[#data+1] = (tonumber -- Coercion is bad, hence we convert.
                          (("%.0f"):format
                            (tonumber -- Twice.
                              (filetbl[i]:match("%d+"))/1024)))
    end
    local free  = data[2]+data[3]+data[4]
    local inuse = data[1]-free
    local usepr = (tostring
                    (("%.0f"):format
                      (inuse/data[1]*100)))

    return table.concat{"MEM: ",tostring(inuse),"Mb"," - ",usepr,"%"}
end

--[[
-- Maybe clearer. Note, though, that here we read the whole
-- file even though we don't need to. Also, the gmatch loop
-- does almost 40 unnecessary iterations.
mem.getdata = function()
    local p = require'perso_utils'
    local s = p.filereadall("/proc/meminfo")
    local data = { memt = 0, mb_f = 0, mb_b = 0, mb_c = 0 }

    for l in s:gmatch("[^\n]+") do
        if l:find("MemTotal") then data.memt = tonumber(l:match("%d+"))/1024 end
        if l:find("MemFree")  then data.mb_f = tonumber(l:match("%d+"))/1024 end
        if l:find("Buffers")  then data.mb_b = tonumber(l:match("%d+"))/1024 end
        if l:find("^Cached")  then data.mb_c = tonumber(l:match("%d+"))/1024 end
    end

    local rfree  = data.mb_f+data.mb_b+data.mb_c
    local rinuse = data.memt-rfree
    local rusep  = rinuse/data.memt*100

    local rinuse = string.format("%.0fMb",rinuse)
    local rusep  = string.format("%.0f%%",rusep)
    return rinuse,rusep
end
]]--


return mem

