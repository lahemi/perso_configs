#!/usr/bin/env lua5.1
-- Get the actual image url and the comic's number
-- of Cyanide and Happiness web comic.
--
-- GPLv3, 2013, Lauri Peltomäki

local assert = assert
local print  = print
local os = { exit = os.exit, }
local io = { write = io.write, }
local string = { match = string.match, }

local futil = require'filenet_util'

local pageurl = 'http://explosm.net/comics/'
local number  = false
local imgurl  = false
local toprint = false

local usage = function()
    io.write[[
Usage:
    -n[number]  Print the number of the comic.
    -i[mgurl]   Print the image-only url.
    -p[rint]    Print to stdout instead of just returning a value.
    -h[elp]     Print this help text.
]]
    os.exit(0)
end

-- Doesn't print the urls by default, instead it returns a table containing
-- them. Needless to say, works only with the actual comics, and not the
-- occasional embedded Youtube video they post instead of the comic.
explosm = function()
    local err = futil.assoc_opts{
        n = function() number = true end,
        i = function() imgurl = true end,
        p = function() toprint = true end,
        h = usage,
        help = usage,
        number = function() number = true end,
        imgurl = function() imgurl = true end,
        ['print'] = function() toprint = true end, -- print is "reserved".
    } if err=='err' then usage() end

    local page = assert(futil.getpage(pageurl))

    local ret = {}
    -- We use the "forum embedding" part of the page.
    if number then ret.u = page:match'%[URL="(.-)"%]'      end
    if imgurl then ret.i = page:match'%[IMG%](.-)%[/IMG%]' end
    if toprint then
        if ret.u then print(ret.u) end
        if ret.i then print(ret.i) end
    else
        return ret
    end
end

explosm()

