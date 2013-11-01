#!/usr/bin/env lua
-- Reads a Lua source file, checks for standard functions and then
-- prints a new source file which has all the used standard functions
-- declared local at the start of the file to the standard output.
-- Saves you some excruciating boilerplating.
--
-- Usage: $0 <file>
--
-- Licensed same as Lua is:
-- http://opensource.org/licenses/mit-license.html
-- MIT license, Copyright (c) 2013 Lauri Peltomäki

local singlefuns = {
    'assert','collectgarbage','dofile','xpcall','error',
    'getmetatable','ipairs','load','loadfile','next','pairs',
    'pcall','print','rawequal','rawget','rawlen','rawset',
    'select','setmetatable','tonumber','tostring','type',
}
local tablelist = {
    ['io'] = { 
        'close','flush','input','lines','open','output',
        'popen','seek','read','stderr','stdin','stdout',
        'tmpfile','type','write','setvbuf',
    },
    ['os'] = {
        'clock','date','difftime','execute','exit','getenv',
        'remove','rename','setlocale','time','tmpname',
    },
    ['string'] = {
        'byte','char','dump','find','format','gmatch','gsub',
        'len','lower','match','rep','reverse','sub','upper',
    },
    ['math'] = {
        'abs','acos','asin','atan','atan2','ceil','cos','cosh',
        'deg','exp','floor','fmod','frexp','huge','ldexp','log',
        'max','min','modf','pi','pow','rad','random','randomseed',
        'sin','sinh','sqrt','tan','tanh',
    },
    ['table'] = {
        'concat','insert','pack','remove','sort','unpack'
    },
    ['bit32'] = {
        'arshift','band','bnot','bor','btest','bxor','extract',
        'lrotate','lshift','replace','rrotate','rshift',
    },
    ['coroutine'] = {
        'create','resume','running','status','wrap','yield',
    },
}

local localgen = function(file)
    if not file then return end
    local fh = io.open(file,'r')
    if fh==nil then return end

    local tab   = '    '        -- Late assignment ;)
    local first = fh:read'*l'   -- Capture the #! line..
    local data  = fh:read'*a'   -- and the rest.
    fh:close()

    -- No need to do anything if no data.
    if data and data~='' then
        print(first..'\n')
        local togens = {
            io = {}, table = {}, single = {}, math = {}, 
            os = {}, bit32 = {}, string = {}, coroutine = {}, 
        }

        -- Lone, "librariless", functions.
        for i=1,#singlefuns do
            if data:find(singlefuns[i]) then
                togens.single[#togens.single+1] = singlefuns[i]
            end
        end
        -- Functions that require local lib = { fun = lib.fun } format.
        for n,t in pairs(tablelist) do
            for i=1,#t do
                if data:find(n..'%.'..t[i]) or
                   data:find('%w+:'..t[i]) then
                   togens[n][#togens[n]+1] = t[i]
               end
            end
        end

        for n,t in pairs(togens) do
            if next(t)~=nil then
                if n=='single' then -- Again, special case.
                    for i=1,#t do
                        print('local '..t[i]..' = '..t[i])
                    end
                elseif tablelist[n] then
                    print('local '..n..' = {')
                    for i=1,#t do
                        print(tab..t[i]..' = '..n..'.'..t[i]..',')
                    end
                    print'}'
                end
            end
        end
        print(data)
    end
end

localgen(arg[1])

