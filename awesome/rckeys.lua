#!/usr/bin/env lua

-- Needs awful required, otherwise won't be able to handle functions correctly.
local awful = require("awful")
-- Mods need to be declared here too, to avoid some.. complications.
local modkey = "Mod4"
local mod1   = "Mod1"

local rckeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext ),
    awful.key({ modkey, mod1      }, "l", awful.tag.viewnext      ),
    awful.key({ modkey, mod1      }, "h", awful.tag.viewprev      ),

    awful.key({ modkey,           }, "j", function() awful.client.focus.byidx( 1) if client.focus then client.focus:raise() end end),
    awful.key({ modkey,           }, "k", function() awful.client.focus.byidx(-1) if client.focus then client.focus:raise() end end),

    awful.key({ modkey,           }, "Return", function() awful.util.spawn(terminal) end),
    awful.key({ modkey,           }, "t",      function() awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "s", function() awful.util.spawn_with_shell(terminal .. " -e csi") end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift", "Control" }, "q", awesome.quit),

    awful.key({ modkey, "Shift"   }, "j",     function() awful.client.swap.byidx(  1)  end),
    awful.key({ modkey, "Shift"   }, "k",     function() awful.client.swap.byidx( -1)  end),
    awful.key({ modkey,           }, "l",     function() awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function() awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey,           }, "space", function() awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function() awful.layout.inc(layouts, -1) end),

    awful.key({ }, "XF86AudioRaiseVolume", function() awful.util.spawn("ossmix -q jack.green.front +2")    end),
    awful.key({ }, "XF86AudioLowerVolume", function() awful.util.spawn("ossmix -q -- jack.green.front -2") end),
    -- Make that nasty pointer disappear.
    awful.key({ modkey }, "n", function() awful.util.spawn("xdotool mousemove 1600 0") end),

    awful.key({ }, "Print", function() awful.util.spawn("scrot -e 'mv $f ~/Scrots'") end),

    awful.key({ modkey }, "z", function() mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey }, "x", function() awful.prompt.run({ prompt = "Run Lua code: " },
                                                            mypromptbox[mouse.screen].widget,
                                                            awful.util.eval, nil,
                                                            awful.util.getdir("cache") .. "/history_eval")
                                                        end)
)

for i=1,9 do
    rckeys = awful.util.table.join(rckeys,
        awful.key({ modkey }, "" .. i, function()
                    local screen = mouse.screen
                    if tags[screen][i] then
                        awful.tag.viewonly(tags[screen][i])
                    end
                end),
        awful.key({ modkey, mod1 }, "" .. i, function()
                    local screen = mouse.screen
                    if tags[screen][i+9] then
                        awful.tag.viewonly(tags[screen][i+9])
                    end
                end),
        awful.key({ modkey, "Shift" }, "" .. i, function()
                    if client.focus and tags[client.focus.screen][i] then
                        awful.client.movetotag(tags[client.focus.screen][i])
                    end
                end),
        awful.key({ modkey, mod1, "Shift" }, "" .. i, function()
                    if client.focus and tags[client.focus.screen][i+9] then
                        awful.client.movetotag(tags[client.focus.screen][i+9])
                    end
                end))
end

-- in rc.lua, local rckeys = require("rckeys")
return rckeys
