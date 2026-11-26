-- Show borders and rounded corners only when the active workspace is split.
-- A single tiled window stays truly edge-to-edge.

local SINGLE = {
    ["decoration.rounding"] = 0,
    ["general.border_size"] = 0,
}

local SPLIT = {
    ["decoration.rounding"] = 6,
    ["general.border_size"] = 2,
}

local applied = nil

local function tiled_count_on(ws)
    if ws == nil then
        return 0
    end

    local n = 0
    for _, w in ipairs(hl.get_workspace_windows(ws)) do
        if not w.floating and not w.hidden then
            n = n + 1
        end
    end
    return n
end

local function apply(state)
    if applied == state then
        return
    end
    applied = state

    if state == "single" then
        hl.config(SINGLE)
    else
        hl.config(SPLIT)
    end
end

local function sync_decoration()
    apply(tiled_count_on(hl.get_active_workspace()) <= 1 and "single" or "split")
end

hl.on("window.open", sync_decoration)
hl.on("window.close", sync_decoration)
hl.on("window.destroy", sync_decoration)
hl.on("window.move_to_workspace", sync_decoration)
hl.on("window.update_state", sync_decoration)
hl.on("workspace.active", sync_decoration)
hl.on("config.reloaded", function()
    applied = nil
    sync_decoration()
end)

sync_decoration()
