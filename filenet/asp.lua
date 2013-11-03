#!/usr/bin/env lua5.1
-- Amazing Super Powers, webcomic. Hosted on Wordpress.
--
-- GPLv3, 2013, Lauri Peltomäki

local assert = assert
local print  = print
local os = { exit = os.exit, }
local io = { write = io.write, }
local string = {
    find = string.find,
    gmatch = string.gmatch,
    match = string.match,
}

local futil = require'filenet_util'

local pageurl = 'http://www.amazingsuperpowers.com/'
local toprint = false
local alt     = false
local img     = false
local quest   = false

local usage = function()
    io.write[[
Usage:
    -i[mg]      Print the main image url.
    -a[lt]      Print the "alternative" text.
    -q[uest]    Print the "hidden" question mark extra image.
    -p[rint]    Print to stdout instead of just returning a value.
    -h[elp]     Print this help text.
]]
    os.exit(0)
end

asp = function()
    local err = futil.assoc_opts{
        p = function() toprint = true end,
        a = function() alt = true end,
        i = function() img = true end,
        q = function() quest = true end,
        h = usage,
        help = usage,
        alt = function() alt = true end,
        img = function() img = true end,
        quest = function() quest = true end,
        ['print'] = function() toprint = true end,
    } if err=='err' then usage() end

    local page = assert(futil.getpage(pageurl))

    local ret = {}
    for line in page:gmatch'[^\n]+' do
        if quest then -- "Hidden" extra comic panel.
            if line:find'http://www%.amazingsuperpowers%.com/hc/%d+/' then
                local hc = assert(futil.getpage(line:match'(http://.-)"'))
                ret.quest = hc:match'(http://www%.amazingsuperpowers%.com/hc/comics/.-)"'
            end
        end
        if alt or img then
            if line:find'comicpane' then -- The main comic.
                if alt then ret.alt = line:match'alt="(.-)"' end
                if img then ret.img = line:match'src="(.-)"' end
                break
            end
        end
    end
    if toprint then
        if alt then print(ret.alt) end
        if img then print(ret.img) end
        if quest then print(ret.quest) end
    else
        return ret
    end
end

asp()

