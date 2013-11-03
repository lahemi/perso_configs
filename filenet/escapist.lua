#!/usr/bin/env lua5.1
-- Part of the filenet project. Say no to the evils of Flash!
-- For streaming the videos of www.escapistmagazine.com.
-- GPLv3, 2013, Lauri Peltomäki

local http = require'socket.http'
local string = { find = string.find,
                 gsub = string.gsub,
                 match = string.match,
                 gmatch = string.gmatch, }
local print = print

local futil = require'filenet_util'

escapist = function()

    local page = assert(futil.getpage(arg[1]))

    for line in page:gmatch'[^\n]+' do
        if line:find'param name="flashvars"' then
            -- Trim and match the config page url.
            local json = line:gsub('^%s+','')
                             :gsub('%s+$','')
                             :match('http.+js')
            local fetched = assert(futil.getpage(json))

            for r in fetched:gmatch'[^{]+' do
                if r:find'url' and r:find"'Video'" then -- Event category
                    return r:match'(http.-)["\']'
                end
            end
        end
    end
end

print(escapist())
