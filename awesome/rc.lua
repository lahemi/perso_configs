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

terminal = "termit"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"
mod1 = "Mod1"

--base_dir = ("/home/blueberry/.config/awesome")
test_dir = ("/home/blueberry/perso_configs/awesome")
--themes_dir = (base_dir .. "/themes")
themes_dir = (test_dir .. "/themes")
beautiful.init(themes_dir .. "/modid/theme.lua")
if beautiful.wallpaper then
	gears.wallpaper.maximized(beautiful.wallpaper, 1, true)
end

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.max,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.fair
}

tags = { layout = { layouts[2], layouts[2], layouts[2], layouts[2], layouts[3],
                    layouts[2], layouts[2], layouts[1], layouts[1], layouts[1],
                    layouts[1], layouts[1], layouts[5], layouts[2], layouts[1],
                    layouts[1], layouts[1], layouts[1], layouts[1], layouts[1] } }
                    
for s = 1, screen.count() do
    tags[s] = awful.tag({1,2,3,4,5,6,7,8,9,10,11,12,13,14}, 1, tags.layout)
end

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Wibox
mytextclock = awful.widget.textclock()

-- CPU/Memory widgets , horrible colours
cpuwig = awful.widget.graph()
cpuwig:set_width(80):set_height(18)
cpuwig:set_background_color("#494B4F00"):set_border_color(nil)
cpuwig:set_color({type = "linear", from = { 0, 0 }, to = {0, 20}, stops = { { 0, "#AECF96" }, { 0.5, "#88A175" }, { 1.0, "#FF5656" } } } )
vicious.register(cpuwig, vicious.widgets.cpu, "$1", 2)

memwig = awful.widget.graph()
memwig:set_width(32):set_height(18)
memwig:set_background_color("#494B4F00"):set_border_color(nil)
memwig:set_color({type = "linear", from = { 0, 0 }, to = {0, 20}, stops = { { 0, "#AECF96" }, { 0.5, "#88A175" }, { 1.0, "#FF5656" } } } )
vicious.register(memwig, vicious.widgets.mem, "$1", 3)

-- Über wonderful random solution ! Something up with the cr:paint() ?
local separator = wibox.widget.imagebox()
separator.draw = function(wibox, cr, width, height)
    local width = 1
    cr:paint()
end
separator.fit = function(width, height)
    local width = 1
    local size = math.min(width, height)
    return size, size
end

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

-- Note, this works only with a single monitor.If you use multiple monitors use: for s=1,screen.count() do
mypromptbox[1] = awful.widget.prompt()
mylayoutbox[1] = awful.widget.layoutbox(1)
mytaglist[1] = awful.widget.taglist(1, awful.widget.taglist.filter.all, mytaglist.buttons)
mytasklist[1] = awful.widget.tasklist(1, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
mywibox[1] = awful.wibox({ position = "top", screen = 1, height = 18 })

-- Lefties
local left_layout = wibox.layout.fixed.horizontal()
left_layout:add(mytaglist[1])
left_layout:add(mypromptbox[1])
left_layout:add(separator)

-- Righties
local right_layout = wibox.layout.fixed.horizontal()
right_layout:add(mytextclock)
right_layout:add(cpuwig)
right_layout:add(separator)
-- if s == 1 then right_layout:add(wibox.widget.systray()) end
right_layout:add(memwig)
right_layout:add(mylayoutbox[1])

-- Now bring it all together (with the tasklist in the middle)
local layout = wibox.layout.align.horizontal()
layout:set_left(left_layout)
layout:set_middle(mytasklist[1])
layout:set_right(right_layout)

mywibox[1]:set_widget(layout)

-- Mouse bindings
--root.buttons(awful.util.table.join(
--    awful.button({ }, 3, function () mymainmenu:toggle() end),
--    awful.button({ }, 4, awful.tag.viewnext),
--    awful.button({ }, 5, awful.tag.viewprev)
--))

-- Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),

    awful.key({ modkey, mod1 }, "l", function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
    awful.key({ modkey, mod1 }, "h", function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,           }, "t", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Multimedia
    awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("ossmix -q jack.green.front +2") end),
    awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("ossmix -q -- jack.green.front -2") end),

    awful.key({ }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/Scrots'") end),

    -- Experiments. These two add and delete tags, some issues here though.
    awful.key({ modkey, mod1 }, "n", function () awful.tag.add("-", tags) end),
    awful.key({ modkey, mod1 }, "b", function () awful.tag.delete(awful.tag.selected()) end),

-- Looping did not work as I expected... for i=1,9 do globalkeys=awful.util.table.join(globalkeys, awful({},"",func()end)) end
--    awful.key({ modkey }, "1", function () awful.tag.viewonly(tags[1]) end),
--    awful.key({ modkey }, "2", function () awful.tag.viewonly(tags[2]) end),
--    awful.key({ modkey }, "3", function () awful.tag.viewonly(tags[3]) end),
--    awful.key({ modkey }, "4", function () awful.tag.viewonly(tags[4]) end),
--    awful.key({ modkey }, "5", function () awful.tag.viewonly(tags[5]) end),
--    awful.key({ modkey }, "6", function () awful.tag.viewonly(tags[6]) end),
--    awful.key({ modkey }, "7", function () awful.tag.viewonly(tags[7]) end),
--    awful.key({ modkey }, "8", function () awful.tag.viewonly(tags[8]) end),
--    awful.key({ modkey }, "9", function () awful.tag.viewonly(tags[9]) end),
--    awful.key({ modkey, mod1 }, "1", function () awful.tag.viewonly(tags[10]) end),
--    awful.key({ modkey, mod1 }, "2", function () awful.tag.viewonly(tags[11]) end),
--    awful.key({ modkey, mod1 }, "3", function () awful.tag.viewonly(tags[12]) end),
--    awful.key({ modkey, mod1 }, "4", function () awful.tag.viewonly(tags[13]) end),
--    awful.key({ modkey, mod1 }, "5", function () awful.tag.viewonly(tags[14]) end),
--    awful.key({ modkey, mod1 }, "6", function () awful.tag.viewonly(tags[15]) end),
--    awful.key({ modkey, mod1 }, "7", function () awful.tag.viewonly(tags[16]) end),
--    awful.key({ modkey, mod1 }, "8", function () awful.tag.viewonly(tags[17]) end),
--    awful.key({ modkey, mod1 }, "9", function () awful.tag.viewonly(tags[18]) end),
--
--  for i in {1..6} do awful.key({modkey}, "#" .. i + 9,
--  function local screen = mouse screen if tags[screen][i] then awful.tag.viewonly(tags[screen][i]) end

    -- Prompt
    awful.key({ modkey },            "z",     function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

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

-- 10,11,12,13 tags are bound to keys 0 nad backspace and those in between. 14 is tab.
keynumber = 0
for s = 1, screen.count() do
    keynumber = math.min(14, math.max(#tags[s], keynumber))
end

for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
            function ()
                local screen = mouse.screen
                if tags[screen][i] then
                    awful.tag.viewonly(tags[screen][i])
                end
            end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function ()
               if client.focus and tags[client.focus.screen][i] then
                   awful.client.movetotag(tags[client.focus.screen][i])
               end
            end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)

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

awful.util.spawn_with_shell("env bash ~/.rscripts/xmods.sh")
awful.util.spawn_with_shell("env bash ~/.rscripts/bamboo.sh")
