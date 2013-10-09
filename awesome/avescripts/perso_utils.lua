#!/usr/bin/env lua
-- Misc utility "library" for some tasks of my life.
-- GPLv3, 2013, Lauri Peltomäki

perso_utils = {}

-- Produce letter patterns.
-- eg. lettermatch("title") => [tT][iI][tT][lL][eE]
perso_utils.lettermatch = function(str, flag)
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
perso_utils.filereadall = function(file)
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
perso_utils.brutalhtmlstrip = function(file)
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
perso_utils.wraps = function(str, limit, sep, flag)
    local flag  = flag  or "s"   -- Return string or table.
    local limit = limit or 72
    local sep   = sep   or " "
    local line  = ""
    local words = {}
--    local count = 0
    for word in str:gmatch("%S+") do
        local totalc = line:len() + word:len()
--        count = count + 1
        if totalc<limit then
            line = line .. word .. sep
        else
            line = line .. "\n"
            words[#words+1] = line
            line = word .. sep
        end
    end

    if flag == "s" then
        return table.concat(words)
    elseif flag == "t" then
        return words
    else
        return nil
    end
end

-- 5.1
--[[perso_utils.getpage = function(url)
    local http = require("socket.http")
    local page,err = ""
    local page,err = http.request(url)
    if not page then
        print("Error fetching the page: ", err)
    else
        return page
    end 
end]]--


return perso_utils

