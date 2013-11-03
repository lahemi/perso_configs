#!/usr/bin/env lua5.1
-- Misc utility "library" for some tasks of my life.
-- GPLv3, 2013, Lauri Peltomäki

local print = print
local type  = type
local io = {
    close = io.close,
    lines = io.lines,
    open = io.open,
    read = io.read,
}
local string = {
    find = string.find,
    gmatch = string.gmatch,
    gsub = string.gsub,
    len = string.len,
    match = string.match,
    sub = string.sub,
}
local table = {
    concat = table.concat,
}


filenet_utils = {}

-- require'assoc_opts'
-- local verbose = false
-- assoc_opts{
--     v = function() verbose = true end,
-- }
-- Note: Makes no distinction between short(-) and long(--)
-- prefixes for the options; you can use whichever you want to.
filenet_utils.assoc_opts = function(atbl)
    local c = 1
    if #arg==0 then return 'err' end
    local a,e = arg[1]:gsub('^%-%-?','')
    if e==0 or not atbl[a] then return 'err' end
    while c<=#arg do
        local a,e = arg[c]:gsub('^%-%-?','')
        local param = ''
        if atbl[a] then
            if type(atbl[a])=='function' then
                if c~=#arg then
                    if not arg[c+1]:match'^%-' then
                        param = arg[c+1]
                        c = c + 1
                    end
                end
                atbl[a](param)
            end
        end
        c = c + 1
    end
end

-- Produce letter patterns.
-- eg. lettermatch("title") => [tT][iI][tT][lL][eE]
filenet_utils.lettermatch = function(str, flag)
    if str:find("[^%a ]") then return end

    local flag = flag or "s" -- Return string or table.

    local m = { 
        a = "[aA]", b = "[bB]", c = "[cC]", d = "[dD]",
        e = "[eE]", f = "[fF]", g = "[gG]", h = "[hH]",
        i = "[iI]", j = "[jJ]", k = "[kK]", l = "[lL]",
        m = "[mM]", n = "[nN]", o = "[oO]", p = "[pP]",
        q = "[qQ]", r = "[rR]", s = "[sS]", t = "[tT]",
        u = "[uU]", v = "[vV]", w = "[wW]", x = "[xX]",
        y = "[yY]", z = "[zZ]", }
    local a = { "a","b","c","d","e","f","g","h","i",
                "j","k","l","m","n","o","p","q","r",
                "s","t","u","v","w","x","y","z", }

    local pat = {}

    for i=1,#str do
        for j=1,#a do
            local ma = str:sub(i,i)
            if ma:match(" ") then
                pat[#pat+1] = " "
            else
                if ma:match(a[j]) then
                    pat[#pat+1] = m[a[j]]
                end
            end
        end
    end

    if flag == "s" then  -- Workaround, to force a single whitespace
        return table.concat(pat):gsub("%s+"," ")
    elseif flag == "t" then
        return pat
    else
        return nil
    end
end

-- A sort of generic file reading helper
-- function, with some "error handling".
filenet_utils.filereadall = function(file)
    local ret = ""
    if file then
        local fh = io.open(file)
        if not fh then 
            ret = "File handle not handled!"
        else
            ret = fh:read('*a')
            fh:close()
        end
    else ret = nil end

    return ret
end

-- Primitive <html> stripping, not pretty at all, but works.
filenet_utils.brutalhtmlstrip = function(file)
    if file then
        local cont = {}
        for line in io.lines(file) do
            cont[#cont+1] = string.gsub(line,"<(.-)>","")
        end
        return table.concat(cont, "\n")
    end
end

-- Primitve wrapper, ignores newlines == output has no
-- extra newlines and such. There's room for improvement.
-- Maybe first loop through line by line and then word by word...
filenet_utils.wraps = function(str)
    local limit = 72
    local sep   = ' ' 
    local line  = ''
    local words = {}
    -- Dirty workaround if the last word doesn't fit on the last line.
    local last  = ''
    for word in str:gmatch'%S+' do
        local totalc = line:len() + word:len()
        if totalc<limit then
            line = line..word..sep
        else
            line = line..'\n'
            words[#words+1] = line
            line = word..sep
        end
        last = word
    end 
    if not words[#words]:match(last..'$') then
        words[#words] = words[#words]..last
    end

    return table.concat(words)
end

filenet_utils.getpage = function(url)
    local http = require'socket.http'
    local page,err = ''
    local page,err = http.request(url)
    if not page then
        print("Error fetching the page: ", err)
    else
        return page
    end 
end


return filenet_utils

