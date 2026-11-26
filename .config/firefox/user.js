// --- FIREFOX OPTIMIZATIONS (8GB RAM & HYPRLAND) ---

// Process limit & Memory management
user_pref("dom.ipc.processCount", 2);
user_pref("dom.ipc.processCount.webIsolated", 2);
user_pref("browser.tabs.unloadOnLowMemory", true);
user_pref("browser.low_commit_space_threshold_mb", 2048);

// Hardware Acceleration (VA-API / AMD iGPU)
user_pref("media.ffmpeg.vaapi.enabled", true);
user_pref("gfx.webrender.all", true);
user_pref("media.av1.enabled", false);

// Disable Telemetry & Pocket
user_pref("toolkit.telemetry.enabled", false);
user_pref("extensions.pocket.enabled", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.ping-centre.telemetry", false);
