#!/usr/bin/env bash
# Link the portable Firefox user.js into the currently active profile.
# With --restore-prefs, also copy the saved prefs.js snapshot into it.
set -euo pipefail

SRC_DIR="$HOME/.config/firefox"
USER_JS="$SRC_DIR/user.js"
PREFS_JS="$SRC_DIR/prefs.js"
INI="$HOME/.mozilla/firefox/profiles.ini"
RESTORE_PREFS=0

[[ "${1:-}" == "--restore-prefs" ]] && RESTORE_PREFS=1

for f in "$USER_JS" "$PREFS_JS"; do
  [[ -f "$f" ]] || { printf 'missing: %s\n' "$f" >&2; exit 1; }
done

[[ -f "$INI" ]] || {
  printf 'Firefox is not initialized yet: %s is missing\n' "$INI" >&2
  exit 1
}

# Prefer the profile pinned in [Install...] Default=..., fall back to the
# first Path= in [Profile*].
profile=$(awk -F= '
  /^\[Install/ { in_install = 1; next }
  /^\[Profile/ { in_install = 0; in_profile = 1; next }
  /^\[/        { in_install = 0; in_profile = 0; next }
  in_install && $1 == "Default" { print $2; exit }
' "$INI")

if [[ -z "$profile" ]]; then
  profile=$(awk -F= '
    /^\[Profile/ { in_profile = 1; next }
    /^\[/        { in_profile = 0; next }
    in_profile && $1 == "Path" { print $2; exit }
  ' "$INI")
fi

[[ -n "$profile" ]] || { printf 'no Firefox profile found in %s\n' "$INI" >&2; exit 1; }

profile_dir="$HOME/.mozilla/firefox/$profile"
[[ -d "$profile_dir" ]] || { printf 'profile directory missing: %s\n' "$profile_dir" >&2; exit 1; }

ln -sfn "$USER_JS" "$profile_dir/user.js"
printf 'linked user.js -> %s/user.js\n' "$profile_dir"

if (( RESTORE_PREFS )); then
  cp -f "$PREFS_JS" "$profile_dir/prefs.js"
  printf 'restored prefs.js snapshot -> %s/prefs.js\n' "$profile_dir"
  printf 'Restart Firefox to apply; Firefox rewrites prefs.js on exit.\n'
fi
