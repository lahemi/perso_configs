#!/usr/bin/env lua
-- AwesomeWM keybindings with a little wizardry. We have three dirrefent modes
-- of input; the main mode and two subsets for clients and running programs.
-- GPLv3, 2013, Lauri Peltomäki. 

local a   = require'awful'
local ave = require'aveinit'  -- Our 'module' hub.

local mod4 = 'Mod4'
local alt  = 'Mod1'
local sft  = 'Shift'
local ctl  = 'Control'
local aus   = a.util.spawn

-- We have two special modes in addition to the normal, global one.
-- Meta+r grabs your keyboards focus after which pressing any of the
-- keys accordingly performs the defined action.
-- Pressing any non-assigned key actually breaks you off the mode,
-- though 'q' is defined as 'guaranteed' way to break off of keygrabber.
local run_table = {
    q      = keygrabber.stop(),
    g      = function() aus('gimp')    end,
    k      = function() aus('krita')   end,
    l      = function() aus('luakit')  end,
    m      = function() aus('mypaint') end,
    s      = function() aus('slock')   end,
    t      = function() aus(terminal)  end,
    x      = function() aus('xdotool mousemove 1600 0') end,
    z      = function() mypromptbox[mouse.screen]:run() end,
    Print  = function() aus('scrot -e "mv $f ~/Scrotes"') end,
    Return = function() aus(terminal) end,

    -- Add pathtofile|url to mplayer queuelist, form xclip.
    y      = function() aus(ave.mpl.queue()) end,
}

-- Same as above, except press meta+c to enter the mode.
local client_mode = {
    q      = keygrabber.stop(),
    x      = function(c) c:kill() end,
    o      = a.client.movetoscreen,
    f      = function(c) c.fullscreen = not c.fullscreen  end,
    m      = function(c) c.maximized_horizontal = not c.maximized_horizontal
                         c.maximized_vertical   = not c.maximized_vertical end,
    Return = function(c) c:swap(a.client.getmaster()) end,
}

-- Normal, general, 'global', mode.
local allmodekeys = a.util.table.join(
    a.key({mod4,sft,ctl}, 'q', awesome.quit),
    a.key({mod4,ctl},  'r', awesome.restart),
    a.key({mod4},     'Return', function() aus(terminal) end),
    a.key({mod4,alt}, 'l',     a.tag.viewnext),
    a.key({mod4,alt}, 'h',     a.tag.viewprev),
    a.key({mod4},     'Left',  a.tag.viewprev),
    a.key({mod4},     'Right', a.tag.viewnext),
    a.key({mod4,ctl}, 'k',     function() a.screen.focus_relative(-1) end),
    a.key({mod4,ctl}, 'j',     function() a.screen.focus_relative( 1) end),
    a.key({mod4},     'space', function() a.layout.inc(layouts,  1) end),
    a.key({mod4,sft}, 'space', function() a.layout.inc(layouts, -1) end),
    a.key({mod4,sft}, 'j',     function() a.client.swap.byidx(  1)  end),
    a.key({mod4,sft}, 'k',     function() a.client.swap.byidx( -1)  end),
    a.key({mod4}, 'l', function() a.tag.incmwfact( 0.05)    end),
    a.key({mod4}, 'h', function() a.tag.incmwfact(-0.05)    end),
    a.key({mod4}, 'j', function()
                           a.client.focus.byidx( 1)
                           if client.focus then client.focus:raise() end end),
    a.key({mod4}, 'k', function()
                           a.client.focus.byidx(-1)
                           if client.focus then client.focus:raise() end end),

    a.key({mod4}, '+', function() aus(ave.ossctl.increase(2)) end),
    a.key({mod4}, '-', function() aus(ave.ossctl.decrease(2)) end),
    a.key({}, 'XF86AudioMute', function() aus(ave.ossctl.togglemute()) end),
    a.key({}, 'XF86AudioRaiseVolume', function() aus(ave.ossctl.increase(2)) end),
    a.key({}, 'XF86AudioLowerVolume', function() aus(ave.ossctl.decrease(2)) end),
    a.key({mod4,alt}, 'Up',    function() aus(ave.mpl.ctl('quit'))  end),
    a.key({mod4,alt}, 'Down',  function() aus(ave.mpl.ctl('pause')) end),
    a.key({mod4,alt}, 'Left',  function() aus(ave.mpl.ctl('pt_step -1')) end),
    a.key({mod4,alt}, 'Right', function() aus(ave.mpl.ctl('pt_step 1'))  end),
    a.key({mod4,alt}, '+',     function() aus(ave.mpl.ctl('seek 20'))  end),
    a.key({mod4,alt}, '-',     function() aus(ave.mpl.ctl('seek -20')) end),
    a.key({mod4,alt}, 'p',     function() aus(ave.mpl.oggctl()) end),

    a.key({mod4}, 'r', function()
        keygrabber.run(function(mod,key,event)
            if event == 'release' then return true end
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
    allmodekeys = a.util.table.join(allmodekeys,
        a.key({mod4}, ''..i, function()
            local s = mouse.screen
            if tags[s][i] then a.tag.viewonly(tags[s][i]) end end),
        a.key({mod4,alt}, ''..i, function()
            local s = mouse.screen
            if tags[s][i+9] then a.tag.viewonly(tags[s][i+9]) end end),
        a.key({mod4,sft}, ''..i, function()
            if client.focus and tags[client.focus.screen][i] then
                a.client.movetotag(tags[client.focus.screen][i])
            end end),
        a.key({mod4,alt,sft}, ''..i, function()
            if client.focus and tags[client.focus.screen][i+9] then
                a.client.movetotag(tags[client.focus.screen][i+9])
            end end))
end

-- See client_mode.
clientkeys = a.util.table.join(
    a.key({mod4}, 'c', function(c)
        keygrabber.run(function(mod,key,event)
            if event == 'release' then return true end
            keygrabber.stop()
            if client_mode[key] then client_mode[key](c) end
            return true
        end)
    end)
)

clientbuttons = a.util.table.join(
    a.button({},     1, function(c) client.focus = c; c:raise() end),
    a.button({mod4}, 1, a.mouse.client.move),
    a.button({mod4}, 3, a.mouse.client.resize)
)

return allmodekeys, clientkeys, clientbuttons
