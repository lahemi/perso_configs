-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
local vicious = require("vicious")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local rckeys = require("rckeys")

-- {{{ Error handling
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
-- }}}

-- Variable definitions
terminal = "lilyterm"
editor = os.getenv("EDITOR") or "vim"
modkey = "Mod4"
mod1 = "Mod1"

base_dir = ("/home/blueberry/.config/awesome")
themes_dir = (base_dir .. "/themes")
beautiful.init(themes_dir .. "/modid/theme.lua")
if beautiful.wallpaper then
	gears.wallpaper.maximized(beautiful.wallpaper, 1, true)
end

-- Table of layouts to cover with awful.layout.inc, order matters.
-- Necessar to declare global, otherwise rckeys won't be able to see it.
-- (Without somehow returning this and then require in rckeys?)
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.max,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.fair
}

tags = { layout = { layouts[2], layouts[2], layouts[2], layouts[2], layouts[3],
                    layouts[2], layouts[2], layouts[1], layouts[1], layouts[1],
                    layouts[1], layouts[2], layouts[5], layouts[2], layouts[1],
                    layouts[1], layouts[3], layouts[2] } }

for s = 1, screen.count() do
    tags[s] = awful.tag({1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18}, 1, tags.layout)
end

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Widgets. Simple is beautiful.
cpuwig = wibox.widget.textbox()
vicious.register(cpuwig, vicious.widgets.cpu, "| CPU: $1% ", 3)

memwig = wibox.widget.textbox()
vicious.register(memwig, vicious.widgets.mem, "| MEM: $2MB ", 5)

netwig = wibox.widget.textbox()             -- ip a and change to correspond your system.
vicious.register(netwig, vicious.widgets.net, " | UP: ${enp2s0 up_kb} DOWN: ${enp2s0 down_kb} ", 1)

osswig = wibox.widget.textbox()
vicious.register(osswig, vicious.teatime.osses, "| OSS: $1 dB ", 1)

hexclock = wibox.widget.textbox()
vicious.register(hexclock, vicious.teatime.hexclock, "$1", 1.318)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end))

for s = 1, screen.count() do
    mypromptbox[1] = awful.widget.prompt()
    mylayoutbox[1] = awful.widget.layoutbox(1)
    mytaglist[1] = awful.widget.taglist(1, awful.widget.taglist.filter.all, mytaglist.buttons)
    mytasklist[1] = awful.widget.tasklist(1, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
    mywibox[1] = awful.wibox({ position = "top", screen = 1, height = 18 })

    -- Lefties
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[1])
    left_layout:add(mypromptbox[1])

    -- Righties
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(hexclock)
    right_layout:add(netwig)
    right_layout:add(cpuwig)
    -- if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(memwig)
    right_layout:add(osswig)
    right_layout:add(mylayoutbox[1])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[1])
    layout:set_right(right_layout)

    mywibox[1]:set_widget(layout)
end

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Key bindings. They can be found in rckeys, huzzah for modularity.
root.keys(rckeys)

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
}
-- }}}

-- {{{ Signals
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

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Don't mind these.
awful.util.spawn_with_shell("env bash ~/.rscripts/xmods.sh")
awful.util.spawn_with_shell("env bash ~/.rscripts/bamboo.sh")
