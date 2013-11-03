#!/usr/bin/env lua5.1
-- For that latest xkcd comic.
--
-- GPLv3, 2013, Lauri Peltomäki

-- Our "environment"
local assert = assert
local print  = print
local string = {
    find = string.find,
    gsub = string.gsub,
    match = string.match,
    sub = string.sub,
}
local os = { exit = os.exit, }
local io = { write = io.write, }
local table = { concat = table.concat, }

local http  = require'socket.http'
local futil = require'filenet_util'

local url     = 'http://xkcd.com/'
local title   = false
local imgsrc  = false
local alt     = false
local hover   = false
local perma   = false
local verbose = false

-- Auxillary special char cleaner, adjust as needed.
local cleanchars = function(str)
    local str = str:gsub('&amp;','&'):gsub('&quot;','"')
                   :gsub('&nbsp;',' '):gsub('&gt;','>')
                   :gsub('&lt;','<'):gsub('&#39;',"'")
    return str 
end

local usage = function()
    io.write[[
Usage:
    -t[itle]    Print the title.
    -s|-imgsrc  Print the full image-only url.
    -a[lt]      Print the "alternative" text of the image.
    -hover      Print the tooltip text of the image.
    -p[erma]    Print the permanent url of the image.
    -h[elp]     Print this help text.
]]
    os.exit(0)
end

xkcd = function()
    -- Handling the command line args. See filenet_util.lua.
    local err = futil.assoc_opts{
        t      = function() title = true end,
        title  = function() title = true end,
        s      = function() imgsrc = true end,
        imgsrc = function() imgsrc = true end,
        a      = function() alt = true end,
        alt    = function() alt = true end,
        hover  = function() hover = true end,
        p      = function() perma = true end,
        perma  = function() perma = true end,
        v      = function() verbose = true end,
        verbose= function() verbose = true end,
        h      = usage,
        help   = usage,
    } if err=='err' then usage() end

    local page = assert(futil.getpage(url))

    if title then title = page:match'<title>(.+)</title>' end
    if perma then perma = page:match'Permanent.-(http://xkcd.com/%d+/)' end

    local css,cse  = page:find'<div id="comic">'
    local rest     = page:sub(cse+1)
    local ces      = rest:find'</div>'
    local comicsrc = rest:sub(1,ces-1)

    if imgsrc then imgsrc = comicsrc:match'img src="(.-)"' end
    if alt    then alt    = comicsrc:match'alt="(.-)"' end
    if hover  then
        hover = futil.wraps(cleanchars(comicsrc:match'title="(.-)"'))
    end

    local ret = {}
    local retter = function(val,txt)
        if val then
            if verbose then val = txt..val end
            ret[#ret+1] = val
        end
    end
    retter(title,'Title: ')
    retter(imgsrc,'Image url: ')
    retter(alt,'Alternative text: ')
    retter(hover,'Tooltip text:\n')
    retter(perma,'Permanent url: ')

    return table.concat(ret,'\n')
end

print(xkcd())

