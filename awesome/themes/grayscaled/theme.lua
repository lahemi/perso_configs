-- Grayscaled Awesome WM theme
-- See corresponding lilyterm config.

theme = {}

theme.font          = "Monoscape 10"

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
theme.taglist_squares_sel   = themes_dir .. "/grayscaled/taglist/squarefw.png"
theme.taglist_squares_unsel = themes_dir .. "/grayscaled/taglist/squarew.png"
theme.taglist_bg_focus = "#c0c0c0"
theme.taglist_fg_focus = "#000000"

theme.wallpaper = themes_dir .. "/grayscaled/tylers/fireinthesky_tylercreatesworlds.jpg"

-- Layout icons
theme.layout_fairv      = themes_dir .. "/grayscaled/layouts/fair.png"
theme.layout_floating   = themes_dir .. "/grayscaled/layouts/float.png"
theme.layout_max        = themes_dir .. "/grayscaled/layouts/max.png"
theme.layout_tileleft   = themes_dir .. "/grayscaled/layouts/tileleft.png"
theme.layout_tile       = themes_dir .. "/grayscaled/layouts/tile.png"

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
