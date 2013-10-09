-- Handles the evils of paths and acts as a central hub for our scripts.

aveinit = {}

-- We need to add this non-standard path,
-- otherwise our machinations cannot be found.
package.path = os.getenv'HOME'.."/.config/awesome/avescripts/?.lua;"..package.path

net       = require("net")
mem       = require("mem")
ossctl    = require("ossctl")
queueplay = require("queueplay")

aveinit = { 
    ["net"]       = net,    -- Note, not yet functional !
    ["mem"]       = mem,
    ["ossctl"]    = ossctl,
    ["queueplay"] = queueplay,
}

return aveinit

