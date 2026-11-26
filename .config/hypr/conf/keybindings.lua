local P       = require("conf.programs")
local mainMod = "SUPER"

-- Main programs
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(P.terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(P.fileManager))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(P.menu))

-- Session / lock
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprctl switchxkblayout all 0 && hyprlock"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("~/.local/bin/show-battery.sh"))

-- Keyboard layout switch
hl.bind("ALT + Shift_L", hl.dsp.exec_cmd("~/.local/bin/switch-layout.sh"))
hl.bind("SHIFT + Alt_L", hl.dsp.exec_cmd("~/.local/bin/switch-layout.sh"))

-- Windows
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -40, y =   0, relative = true }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x =  40, y =   0, relative = true }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x =   0, y = -40, relative = true }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x =   0, y =  40, relative = true }))

-- Workspaces 1-5
for i = 1, 5 do
    hl.bind(mainMod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"),      { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"),      { repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),  { locked = true })

hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"), { repeating = true })

-- Kept from the old config, even though it overlaps the locked mic-mute bind above.
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("[ -f /tmp/mic_lock ] || (touch /tmp/mic_lock; swayosd-client --input-volume mute-toggle; sleep 0.2; rm -f /tmp/mic_lock)"))

-- Screenshots
local screenshotSelection = [[mkdir -p ~/Pictures/Screenshots && grim -g "$(slurp)" - | tee ~/Pictures/Screenshots/Screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png | wl-copy]]
local screenshotAll       = [[mkdir -p ~/Pictures/Screenshots && grim - | tee ~/Pictures/Screenshots/Screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png | wl-copy]]

hl.bind("Print",                   hl.dsp.exec_cmd(screenshotSelection))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(screenshotSelection))
hl.bind(mainMod .. " + Print",     hl.dsp.exec_cmd(screenshotAll))

-- Theme
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("~/.local/bin/toggle-theme.sh"))

