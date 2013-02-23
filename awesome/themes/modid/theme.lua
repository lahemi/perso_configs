---------------------------
-- Default awesome theme --
---------------------------

theme = {}

theme.font          = "Monoscape 10"

-- Pseudo transparency
theme.bg_normal     = "#00000000"
theme.bg_focus      = "#322a2c80"
theme.bg_urgent     = "#ff000066"
theme.bg_minimize   = "#44444466"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = 0
theme.border_normal = "#00000000"
theme.border_focus  = "#535d6c66"
theme.border_marked = "#91231c66"

-- Display the taglist squares
theme.taglist_squares_sel   = themes_dir .. "/modid/taglist/squarefw.png"
theme.taglist_squares_unsel = themes_dir .. "/modid/taglist/squarew.png"
theme.taglist_fg_focus  = "#9aefda"

theme.wallpaper = themes_dir .. "/modid/tylers/circlethedrain_tylercreatesworlds_h.jpg"

-- Layout icons
theme.layout_fairv      = themes_dir .. "/modid/layouts/fairvw.png"
theme.layout_floating   = themes_dir .. "/modid/layouts/floatingw.png"
theme.layout_max        = themes_dir .. "/modid/layouts/maxw.png"
theme.layout_tileleft   = themes_dir .. "/modid/layouts/tileleftw.png"
theme.layout_tile       = themes_dir .. "/modid/layouts/tilew.png"

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
