#!/usr/bin/env lua
-- AwesomeWM keybindings with a little wizardry. We have three dirrefent modes
-- of input; the main mode and two subsets for clients and running programs.
-- Anything 'featureful', suggestions, questions and especially advice would
-- be well directed at Lauri Peltomäki, icelesstea at freenode.

-- Needs awful required, otherwise won't be able to handle functions correctly.
local awful = require("awful")
-- Modifiers. Mod4 is the meta key("Windows key")
local mod4 = "Mod4"
local alt  = "Mod1"
local ctl  = "Control"
local sft  = "Shift"

-- We have two special modes in addition to the normal, global one.
-- Meta+r grabs your keyboards focus after which pressing any of the
-- keys accordingly performs the defined action.
-- Pressing any non-assigned key actually breaks you off the mode,
-- though 'q' is defined as "guaranteed" way to break off of keygrabber.
local run_table = {
    g       = function() awful.util.spawn("gimp") end,
    k       = function() awful.util.spawn("krita") end,
    m       = function() awful.util.spawn("mypaint") end,
    q       = keygrabber.stop(),
    t       = function() awful.util.spawn(terminal) end,
    x       = function() awful.util.spawn("xdotool mousemove 1600 0") end,
    z       = function() mypromptbox[mouse.screen]:run() end,
    Print   = function() awful.util.spawn("scrot -e 'mv $f ~/Scrotes'") end,
    Return  = function() awful.util.spawn(terminal) end,
}

-- Same as above, except press meta+c to enter the mode.
local client_mode = {
    c       = function(c) c:kill() end,
    f       = function(c) c.fullscreen = not c.fullscreen  end,
    m       = function(c) c.maximized_horizontal = not c.maximized_horizontal
                          c.maximized_vertical   = not c.maximized_vertical end,
    q       = keygrabber.stop(),
    Return  = function(c) c:swap(awful.client.getmaster()) end,
}

-- Normal, general, 'global', mode.
local allmodekeys = awful.util.table.join(
    awful.key({ mod4, },      "Return", function() awful.util.spawn(terminal) end),
    awful.key({ mod4, ctl },       "r", awesome.restart   ),
    awful.key({ mod4, sft, ctl },  "q", awesome.quit      ),
    awful.key({ mod4, alt },       "l", awful.tag.viewnext),
    awful.key({ mod4, alt },       "h", awful.tag.viewprev),
    awful.key({ mod4, },       "Left",  awful.tag.viewprev),
    awful.key({ mod4, },       "Right", awful.tag.viewnext),
    awful.key({ mod4, },       "space", function() awful.layout.inc(layouts,  1) end),
    awful.key({ mod4, sft },   "space", function() awful.layout.inc(layouts, -1) end),
    awful.key({ mod4, sft },       "j", function() awful.client.swap.byidx(  1)  end),
    awful.key({ mod4, sft },       "k", function() awful.client.swap.byidx( -1)  end),
    awful.key({ mod4, },           "l", function() awful.tag.incmwfact( 0.05)    end),
    awful.key({ mod4, },           "h", function() awful.tag.incmwfact(-0.05)    end),
    awful.key({ mod4, },           "j", function()
                                            awful.client.focus.byidx( 1)
                                            if client.focus then
                                                client.focus:raise()
                                            end end),
    awful.key({ mod4, },           "k", function()
                                            awful.client.focus.byidx(-1)
                                            if client.focus then
                                                client.focus:raise()
                                            end end),
    awful.key({ }, "XF86AudioRaiseVolume",
        function() awful.util.spawn("ossmix -q jack.green.front +2") end),
    awful.key({ }, "XF86AudioLowerVolume",
        function() awful.util.spawn("ossmix -q -- jack.green.front -2") end),
    awful.key({ mod4, }, "r", function()
        keygrabber.run(function(mod,key,event)
            if event == "release" then return true end
            keygrabber.stop()
            if run_table[key] then run_table[key]() end
            return true
        end)
    end)
)

-- We have 18 tags, so we need to do some magicks in order to have shortcuts
-- mapped to all of them. Meta+1 to 9 for the nine first ones, and then
-- meta+alt+1 to 9 for the rest.
for i=1,9 do
    allmodekeys = awful.util.table.join(allmodekeys,
        awful.key({ mod4 }, "" .. i, function()
                    local screen = mouse.screen
                    if tags[screen][i] then
                        awful.tag.viewonly(tags[screen][i])
                    end
                end),
        awful.key({ mod4, alt }, "" .. i, function()
                    local screen = mouse.screen
                    if tags[screen][i+9] then
                        awful.tag.viewonly(tags[screen][i+9])
                    end
                end),
        awful.key({ mod4, "Shift" }, "" .. i, function()
                    if client.focus and tags[client.focus.screen][i] then
                        awful.client.movetotag(tags[client.focus.screen][i])
                    end
                end),
        awful.key({ mod4, alt, "Shift" }, "" .. i, function()
                    if client.focus and tags[client.focus.screen][i+9] then
                        awful.client.movetotag(tags[client.focus.screen][i+9])
                    end
                end))
end

-- See client_mode.
clientkeys = awful.util.table.join(
    awful.key({ mod4, }, "c", function(c)
        keygrabber.run(function(mod,key,event)
            if event == "release" then return true end
            keygrabber.stop()
            if client_mode[key] then client_mode[key](c) end
            return true
        end)
    end)
)

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
    awful.button({ mod4 }, 1, awful.mouse.client.move),
    awful.button({ mod4 }, 3, awful.mouse.client.resize)
)

return allmodekeys, clientkeys, clientbuttons
