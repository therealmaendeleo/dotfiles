// --- Firefox durable settings ---
// Applied on every startup; these override values in prefs.js.
// Edit this file, not about:config, for persistent changes.

// Process limit & memory management
user_pref("dom.ipc.processCount", 3);
user_pref("dom.ipc.processCount.webIsolated", 2);
user_pref("browser.tabs.unloadOnLowMemory", true);
user_pref("browser.low_commit_space_threshold_mb", 2048);

// Hardware acceleration (VA-API / AMD iGPU)
user_pref("media.ffmpeg.vaapi.enabled", true);
user_pref("gfx.webrender.all", true);
user_pref("media.av1.enabled", false);

// Privacy and tracking protection
user_pref("browser.contentblocking.category", "strict");
user_pref("privacy.fingerprintingProtection", true);
user_pref("privacy.query_stripping.enabled", true);
user_pref("privacy.query_stripping.enabled.pbmode", true);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.emailtracking.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.annotate_channels.strict_list.enabled", true);
user_pref("privacy.bounceTrackingProtection.mode", 1);
user_pref("privacy.clearOnShutdown_v2.formdata", true);
user_pref("privacy.sanitize.timeSpan", 0);

// Telemetry and Pocket
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("datareporting.healthreport.service.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("browser.ping-centre.telemetry", false);
user_pref("extensions.pocket.enabled", false);
