-- Empty output field = all monitors. Auto scale keeps the current 1.5 on eDP-1.
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

hl.config({
    general = {
        gaps_in     = 2,
        gaps_out    = 0,
        border_size = 2,

        col = {
            active_border = {
                colors  = { "rgba(719672ff)", "rgba(799dcbff)" },
                angle   = 45,
            },
            inactive_border = "rgba(4e4e4eff)",
        },

        layout = "dwindle",
    },

    decoration = {
        rounding         = 6,
        active_opacity   = 1.0,
        inactive_opacity = 0.95,

        blur = {
            enabled = false,
        },

        shadow = {
            enabled = false,
        },
    },

    animations = {
        enabled = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

hl.animation({ 
    leaf    = "windows",
    enabled = true,
    speed   = 3,
    bezier  = "default",
    style   = "popin 90%"
})
hl.animation({
    leaf    = "windowsOut",
    enabled = true,
    speed   = 2,
    bezier  = "default",
    style   = "popin 90%"
})
hl.animation({
    leaf    = "border",
    enabled = true,
    speed   = 5,
    bezier  = "default"
})
hl.animation({
    leaf    = "fade",
    enabled = true,
    speed   = 3,
    bezier  = "default"
})
hl.animation({
    leaf    = "workspaces",
    enabled = true,
    speed   = 2,
    bezier  = "default",
    style   = "slide"
})

