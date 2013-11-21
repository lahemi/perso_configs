local colors = require("termit.colormaps")

defaults = {}
defaults.windowTitle = 'Termit'
defaults.tabName = 'Terminal'
defaults.encoding = 'UTF-8'
defaults.wordChars = '+-AA-Za-z0-9,./?%&#:_~'
defaults.scrollbackLines = 4096
defaults.font = 'Monospace 11'
defaults.geometry = '80x24'
defaults.hideSingleTab = true
defaults.showScrollbar = false
defaults.fillTabbar = false
defaults.hideMenubar = true
defaults.allowChangingTitle = true
defaults.visibleBell = false
defaults.audibleBell = false
defaults.urgencyOnBell = false
-- defaults.transparency = 0.3
defaults.colormap = colors.mikadoModid
setOptions(defaults)

setKbPolicy('keysym')
