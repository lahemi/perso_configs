-- Catbug Awesome WM theme

theme = {}

theme.font          = "Monoscape 10"

theme.bg_normal     = "#f7a64a"
theme.bg_focus      = "#000000"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#000000"
theme.fg_focus      = "#f7a64a"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = 1
theme.border_normal = "#000000"
theme.border_focus  = "#000000"
theme.border_marked = "#000000"

-- Display the taglist squares
theme.taglist_squares_sel   = themes_dir .. "/catbug/taglist/squarefw.png"
theme.taglist_squares_unsel = themes_dir .. "/catbug/taglist/squarew.png"
theme.taglist_bg_focus = "#000000"
theme.taglist_fg_focus = "#f7a64a"

theme.wallpaper = themes_dir .. "/catbug/catbug_by_water_wing.jpg"

-- Layout icons
theme.layout_fairv      = themes_dir .. "/catbug/layouts/fair.png"
theme.layout_floating   = themes_dir .. "/catbug/layouts/float.png"
theme.layout_max        = themes_dir .. "/catbug/layouts/max.png"
theme.layout_tileleft   = themes_dir .. "/catbug/layouts/tileleft.png"
theme.layout_tile       = themes_dir .. "/catbug/layouts/tile.png"

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
