-- tboxbase.lua and this file could easily be a one file.
-- However, in case I'll need to use something else than a textbox,
-- I can keep things neatly separated this way.

local tbox = require("tboxbase")
local ave  = require("aveinit")

local boxen = {}

-- TODO implement a more refined parametres table handling.
boxen = {
    ["membox"] = tbox.create(ave.mem.getdata,{ fmtbefore = " | "}),
    ["netbox"] = tbox.create(ave.net.getdata,{ params = "enp2s0",
                                               fmtbefore = " | "}),
}

return boxen

