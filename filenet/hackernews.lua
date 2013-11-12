#!/usr/bin/env lua5.1
-- Get the top 30 of Hackernews; Rank, Points, Title, Link
-- Can be in fact used for gathering info about most popular stuff on
-- Hackernews. For instance, add a database or plain text file for
-- storing the values and then throw this in cron and - voilà!
-- You have your own Hackernews Weekly!
--
-- TODO: Actually implement the data gathering described above.
--
-- GPLv3, 2013, Lauri Peltomäki

local socket = require'socket'
local https  = require'ssl.https'
local print  = print
local tc     = table.concat -- table.concat nicer than ..
local string = {
    sub   = string.sub,
    find  = string.find,
    match = string.match,
}

hackernews = function()
    local body,code,headers,status = https.request'https://news.ycombinator.com/'

    local title = body:match'<title>(.-)</title>' -- Site title...

    local r     = body -- Compactify code
    local elems = {}   -- Gather the links, titles, points
    -- The main juice pattern and points
    local apat  = '<td class="title"><a href=".-">.-</a>'
    local dpat  = '>(%d+)%spoints<'

    -- Clean up and away the html and pretty format title and link.
    local fmt_l = function(r,s,e)
        return r:sub(s,e):gsub('<td.->',''):gsub('"%s+rel="nofollow','')
                :gsub('<a href="(.-)">(.-)</a>','Title: %2\nLink: %1\n')
    end

    -- Gathering all the values we're interested in. Maybe a bit messy-like.
    while true do
        s,e = r:find(apat)  if s==nil then break end
        l   = fmt_l(r,s,e)  if l==nil then break end
        r   = r:sub(e+1)
        p   = r:match(dpat) if p==nil then break end
        elems[#elems+1] = tc{'Points: ',p,'\n',l}
    end

    return elems
end

local news = hackernews()

-- "Good enough" for now.
for i=1,#news do
    print(i) -- Rank
    print(news[i])
end

