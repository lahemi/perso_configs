#!/usr/bin/env lua5.1
-- The Interwebs as a part of the file system, huzzah!
-- This is for grabbing those pretty pictures from deviantart.com.
-- The first in the series.
-- GPLv3, 2013, Lauri Peltomäki

local http = require("socket.http")
local print = print
local os = { date  = os.date,
             execute = os.execute }
local io = { open  = io.open,
             write = io.write,
             close = io.close }
local string = { gsub = string.gsub,
                 match = string.match,
                 gmatch = string.gmatch }
local table = { concat = table.concat }


local url = arg[1]
local verbose = false

local getpage = function(url)
    local page,err = ""
    local page,err = http.request(url)
    if not page then
        print("Error fetching the page: ", err)
    else
        return page
    end
end

local page = getpage(url)

local super_img = {}
local counter = 0
for line in page:gmatch("%S+") do
    -- The images we are interested in are behind
    -- this kind of thingy in deviantart. Go figure.
    if line:match("^data%-super%-img") then
        local line = line:gsub("^.+=",""):gsub("\"","'")
        super_img[#super_img+1] = line
        counter = counter + 1
    end
end

local file = os.date("%H%M%S_%d%m%y") .. "_" ..
             url:gsub("/","_"):gsub("http:","") .. ".sh"
local super_string = table.concat(super_img,"\n")
if verbose == true then
    print(file)
    print(super_string)
end
local fh = io.open(file,"w")

local shbase = '#!/usr/bin/env mksh\n\
c=0\nmax='..counter..'\n\nurlarray=('

local shfor = [[)

test $# -ne 1 && print "Name the download directory." && exit 0
title="$1"
test -d "$title" || mkdir -p "$title"
cd "$title"

for i in "${urlarray[@]}"; do
    print "$c out of $max done"
    wget "$i"
    let "c = c + 1"
done
]]
fh:write(shbase)
fh:write(super_string)
fh:write(shfor)
fh:close()

os.execute("chmod 700 "..file)

