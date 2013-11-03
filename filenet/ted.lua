#!/usr/bin/env lua5.1
-- Part of the filenet project.
-- Small helper for TED talks, picks the video url for you.
-- GPLv3, 2013, Lauri Peltomäki

local http = require'socket.http'
local print  = print
local assert = assert
local string = { find = string.find,
                 gsub = string.gsub,
                 match = string.match,
                 gmatch = string.gmatch, }

ted = function()
    local page = assert(http.request(arg[1]))

    for line in page:gmatch'[^\n]+' do
        if line:find'no%-flash%-video%-download' then
            local ret = line:gsub("^%s+","")
                            :gsub("%s+$","")
                            :match'(http.-)"'
            return ret
        end
    end
end

print(ted())
