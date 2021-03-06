-- tboxbase.lua and this file could easily be a one file.
-- However, in case I'll need to use something else than a textbox,
-- I can keep things neatly separated this way.

local tbox = require('tboxbase')
local ave  = require('aveinit')

local boxen = {}

-- TODO implement a more refined parametres table handling.
boxen = {
    ['devbox'] = tbox.create(ave.df.getavail,{ fmtbefore = ' | DEV: ',
                                               timeout = 30 }),
    ['cpubox'] = tbox.create(ave.cpu.getdata,{ fmtbefore = ' | CPU: ' }),
    ['membox'] = tbox.create(ave.mem.getdata,{ fmtbefore = ' | '}),
    ['netbox'] = tbox.create(ave.net.getdata,{ params = 'enp2s0',
                                               fmtbefore = ' | '}),
    ['ossbox'] = tbox.create(ave.ossctl.volume,{ fmtbefore = ' | ♫' }),
    ['hexbox'] = tbox.create(ave.hexclock.time,{ fmtbefore = ' | ',
                                                 timeout = 1.3 }),
    ['unibox'] = tbox.create(ave.unixclock.time,{ fmtbefore = ' | ' }),
    ['tictoc'] = tbox.create(ave.tick.tock,{ fmtbefore = ' ' }),
}

return boxen

