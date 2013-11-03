#!/usr/bin/env lua5.1
-- This is for grabbing those pretty pictures from deviantart.com.
-- The first in the series.
--
-- Usage: $0 [-v] -url <url>
--
-- GPLv3, 2013, Lauri Peltomäki

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

local http  = require'socket.http'
local futil = require'filenet_util'

local verbose = false
local url     = ''

deviant = function()
    futil.assoc_opts{
        v   = function() verbose = true end,
        url = function(a) url = a end,
    } if url=='' then return end

    local page = futil.getpage(url)

    local super_img = {}
    local counter = 0
    for word in page:gmatch("%S+") do
        -- The images we are interested in are behind
        -- this kind of thingy in deviantart. Go figure.
        if word:match("^data%-super%-img") then
            local word = word:gsub("^.+=",""):gsub("\"","'")
            super_img[#super_img+1] = word
            counter = counter + 1
        end
    end

    local file = os.date("%H%M%S_%d%m%y") .. "_" ..
                 url:gsub("/","_"):gsub("http:","") .. ".sh"
    local super_string = table.concat(super_img,"\n")
    if verbose then
        print(file)
        print(super_string)
    end

    local fh = io.open(file,"w")
    if fh~=nil then
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
        if verbose then
            print(shbase)
            print(super_string)
            print(shfor)
        end
        fh:write(shbase)
        fh:write(super_string)
        fh:write(shfor)
        fh:close()

        os.execute("chmod 700 "..file)
    else
        if verbose then print'File opening failed.' end
    end
end

deviant()
