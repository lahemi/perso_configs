#!/usr/bin/env lua5.1
-- A small utility so you don't have to use that
-- benighted graphical web browser for Youtube.
-- Usage: $0 what ever you want to search
-- GPLv3, 2013, Lauri Peltomäki

local os = { exit = os.exit }

if #arg < 1 then
    print("Need at least one argument.")
    os.exit()
end

local http = require("socket.http")
local string = { find = string.find,
                 gsub = string.gsub,
                 match = string.match,
                 gmatch = string.gmatch, }
local table = { concat = table.concat }
local print = print

local youwatch  = "http://www.youtube.com/watch?v="
local yousearch = "http://www.youtube.com/results?search_query="

local searcharg = ""
-- If the argument is quoted and has whitespaces.
if #arg == 1 then
    searcharg = arg[1]:gsub("%s","+")
else
    for i=1,#arg do
        if i >= #arg then
            searcharg = searcharg .. arg[i]
        else
            searcharg = searcharg .. arg[i] .. "+"  -- == whitespace
        end
    end
end

local getpage = function(url)
    local page,err = ""
    local page,err = http.request(url)
    if not page then
        print("Error fetching the page: ", err)
    else
        return page
    end 
end
local page = getpage(yousearch..searcharg)

local context_items = {}
for w in page:gmatch("[^\n]+") do
    -- The templates of Youtube, huzzah for clean parsing!
    if w:find("data%-context%-item%-title") then
        if w:find("__title__") then
        else context_items[#context_items+1] = w
        end
    end
end

local cbase  = "data%-context%-item%-"  -- Escaped for pattern matching.
local cview  = cbase.."views=\".-\""
local cvidid = cbase.."id=\".-\""
local ctitle = cbase.."title=\".-\""
local cuser  = cbase.."user=\".-\""
local ctime  = cbase.."time=\".-\""

local viewtbl,vidtbl,tletbl,usrtbl,timetbl = {},{},{},{},{}

-- The magicks, do take a moment to peruse.
for i=1,#context_items do
    local m = function(s) return context_items[i]:match(s) end
    local trim = function(s) return s:match("\".-\""):gsub("\"","") end
    if m(cview)  then
        viewtbl[#viewtbl+1] = "Views: " .. m(cview):match("%d+.-%s")
    end
    if m(cvidid) then vidtbl[#vidtbl+1]   = youwatch  .. trim(m(cvidid)) end
    if m(ctitle) then tletbl[#tletbl+1]   = "Title: " .. trim(m(ctitle)) end
    if m(cuser)  then usrtbl[#usrtbl+1]   = "User: "  .. trim(m(cuser))  end
    if m(ctime)  then timetbl[#timetbl+1] = "Time: "  .. trim(m(ctime))  end
end

for i=1,#context_items do
    local n,t = "\n","\t"
    -- There are occasions, when the timetbl seems to bug, somewhat oddly.
    print(table.concat{tletbl[i],n,timetbl[i],t,usrtbl[i],
                       t,viewtbl[i],n,vidtbl[i],n})
end
