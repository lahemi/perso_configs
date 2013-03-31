-- Modid Awesome WM theme

theme = {}

theme.font          = "Monoscape 10"

-- Pseudo transparency
theme.bg_normal     = "#000000"
theme.bg_focus      = "#c0c0c0"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#000000"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = 0
theme.border_normal = "#000000"
theme.border_focus  = "#000000"
theme.border_marked = "#000000"

-- Display the taglist squares
theme.taglist_squares_sel   = themes_dir .. "/modid/taglist/squarefw.png"
theme.taglist_squares_unsel = themes_dir .. "/modid/taglist/squarew.png"
theme.taglist_fg_focus = "#c0c0c0"
theme.taglist_fg_focus = "#000000"

theme.wallpaper = themes_dir .. "/modid/tylers/fireinthesky_tylercreatesworlds.jpg"

-- Layout icons
theme.layout_fairv      = themes_dir .. "/modid/layouts/fairv.png"
theme.layout_floating   = themes_dir .. "/modid/layouts/float.png"
theme.layout_max        = themes_dir .. "/modid/layouts/max.png"
theme.layout_tileleft   = themes_dir .. "/modid/layouts/tileleft.png"
theme.layout_tile       = themes_dir .. "/modid/layouts/tile.png"

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
