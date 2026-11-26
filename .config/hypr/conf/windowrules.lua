-- Browsers -> workspace 1
hl.window_rule({ match = { class = "^(firefox)$" },       workspace = "1" })
hl.window_rule({ match = { class = "^(google-chrome)$" }, workspace = "1" })
hl.window_rule({ match = { class = "^(zen-alpha)$" },     workspace = "1" })

-- Terminal / IDE -> workspace 2
hl.window_rule({ match = { class = "^(Alacritty)$" },     workspace = "2" })
hl.window_rule({ match = { class = "^(jetbrains-idea)$" }, workspace = "2" })

-- Chat -> workspace 3
hl.window_rule({ match = { class = "^(org.telegram.desktop)$" }, workspace = "3" })
hl.window_rule({ match = { class = "^(discord)$" },               workspace = "3" })

-- Files / video -> workspace 4
hl.window_rule({ match = { class = "^(org.gnome.Nautilus)$" }, workspace = "4" })
hl.window_rule({ match = { class = "^(vlc)$" },                 workspace = "4" })

-- Dialogs float
hl.window_rule({ match = { class = "^(pavucontrol)$" },              float = true })
hl.window_rule({ match = { title = "^(Open File)$" },                float = true })
hl.window_rule({ match = { title = "^(Save File)$" },                float = true })
hl.window_rule({ match = { title = "^(Confirm to replace files)$" }, float = true })

