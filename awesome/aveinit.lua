-- Handles the evils of paths and acts as a central hub for our scripts.

aveinit = {}

-- We need to add this non-standard path, otherwise our machinations cannot be found.
package.path = os.getenv'HOME'..'/.config/awesome/avescripts/?.lua;'..package.path

df        = require'df'
cpu       = require'cpu'
net       = require'net'
mem       = require'mem'
mpl       = require'mpl'
tick      = require'tick'
ossctl    = require'ossctl'
hexclock  = require'hexclock'
unixclock = require'unixclock'

aveinit = { 
    ['df']        = df,
    ['cpu']       = cpu,
    ['net']       = net,
    ['mem']       = mem,
    ['mpl']       = mpl,
    ['tick']      = tick,
    ['ossctl']    = ossctl,
    ['hexclock']  = hexclock,
    ['unixclock'] = unixclock,
}

return aveinit

