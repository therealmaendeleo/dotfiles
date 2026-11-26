-- Environment
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("ADW_DISABLE_PORTAL", "0")

-- Modular config files live in ~/.config/hypr/conf/*.lua
require("conf.autostart")
require("conf.input")
require("conf.appearance")
require("conf.keybindings")
require("conf.windowrules")
