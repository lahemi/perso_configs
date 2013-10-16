-- Standard awesome library
local gears = require'gears'
local awful = require'awful'
local rules = require'awful.rules'
require'awful.autofocus'

local wibox     = require'wibox'     -- Widget and layout library
local beautiful = require'beautiful' -- Theme handling library
local naughty   = require'naughty'   -- Notification library
local modekeys  = require'modekeys'  -- Keybindings
local boxen     = require'boxen'     -- Our widget "module"

-- Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end

-- Variable definitions
terminal = "sakura"
mod4     = "Mod4"

themefile  = '/grayscaled/theme.lua' --A_rch,catbug
themes_dir = os.getenv'HOME'..'/.config/awesome/themes'
beautiful.init(themes_dir..themefile)
if beautiful.wallpaper then
    for s=1,screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper,s,true)
    end
end

-- Necessary to declare global, otherwise modekeys won't be able to see these.
local als = awful.layout.suit
layouts = { als.floating, als.max, als.tile, als.tile.left,
            als.fair, als.tile.bottom, }
ttags = { layouts[2],layouts[2],layouts[2],layouts[2],layouts[3],
          layouts[2],layouts[2],layouts[1],layouts[1],layouts[1],
          layouts[2],layouts[2],layouts[5],layouts[2],layouts[1],
          layouts[1],layouts[3],layouts[3] }
tags = {}
for s=1,screen.count() do
    tags[s] = awful.tag({1,2,3,4,5,6,7,8,9,10,11,12,
                         13,14,15,16,17,18},s,ttags)
end

-- Create a wibox and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({},1,awful.tag.viewonly),
                    awful.button({mod4},1,awful.client.movetotag),
                    awful.button({},3,awful.tag.viewtoggle),
                    awful.button({mod4},3,awful.client.toggletag))
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({},1,
                        function(c)
                            if c == client.focus then c.minimized = true
                            else
                                c.minimized = false
                                if not c:isvisible() then
                                    awful.tag.viewonly(c:tags()[1])
                                end
                                client.focus = c
                                c:raise()
                            end end))

for s=1,screen.count() do
    mypromptbox[s] = awful.widget.prompt()
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mytaglist[s]   = awful.widget.taglist(s,awful.widget.taglist.filter.all,mytaglist.buttons)
    mytasklist[s]  = awful.widget.tasklist(s,awful.widget.tasklist.filter.currenttags,mytasklist.buttons)
    mywibox[s]     = awful.wibox({position = "top",screen = s,height = 18})

    -- Lefties
    local llayout = wibox.layout.fixed.horizontal()
    llayout:add(mytaglist[s])
    llayout:add(mypromptbox[s])

    -- Righties
    local rlayout = wibox.layout.fixed.horizontal()
    rlayout:add(boxen.tictoc)
    rlayout:add(boxen.hexbox)
    rlayout:add(boxen.unibox)
    rlayout:add(boxen.devbox)
    rlayout:add(boxen.cpubox)
    rlayout:add(boxen.ossbox)
    rlayout:add(boxen.netbox)
    rlayout:add(boxen.membox)
    rlayout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(llayout)
    layout:set_middle(mytasklist[s])
    layout:set_right(rlayout)
    mywibox[s]:set_widget(layout)
end

-- Key bindings. See modekeys, also contains clientkeys.
root.keys(modekeys)

-- Rules
rules.rules = {
    -- All clients will match this rule.
    { rule = {},
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons }}}

-- Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    if not startup then
        -- Set the windows at the slave,
        awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
end)

client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
