#!/usr/bin/env bash
# Apply the portable Firefox snapshot from ~/.config/firefox to the active profile.
#
# Usage:
#   install-firefox-profile.sh [--restore-prefs] [--restore-extensions]
#                              [--restore-all] [--dry-run]
set -euo pipefail

SRC_DIR="$HOME/.config/firefox"
USER_JS="$SRC_DIR/user.js"
PREFS_JS="$SRC_DIR/prefs.js"
EXTENSIONS_JSON="$SRC_DIR/extensions.json"
ADDONS_JSON="$SRC_DIR/addons.json"
EXT_PREFS_JSON="$SRC_DIR/extension-preferences.json"
INI="$HOME/.mozilla/firefox/profiles.ini"

DO_PREFS=0
DO_EXTENSIONS=0
DRY_RUN=0

for arg in "$@"; do
  case "$arg" in
    --restore-prefs) DO_PREFS=1 ;;
    --restore-extensions) DO_EXTENSIONS=1 ;;
    --restore-all) DO_PREFS=1; DO_EXTENSIONS=1 ;;
    --dry-run) DRY_RUN=1 ;;
    *)
      printf 'unknown option: %s\n' "$arg" >&2
      exit 2
      ;;
  esac
done

for f in "$USER_JS" "$PREFS_JS" "$EXTENSIONS_JSON" "$ADDONS_JSON" "$EXT_PREFS_JSON"; do
  [[ -f "$f" ]] || { printf 'missing snapshot: %s\n' "$f" >&2; exit 1; }
done

[[ -f "$INI" ]] || {
  printf 'Firefox is not initialized yet: %s is missing\n' "$INI" >&2
  exit 1
}

# Prefer the profile pinned in [Install...] Default=..., fall back to the
# first Path= in [Profile*].
profile=$(awk -F= '
  /^\[Install/ { in_install = 1; in_profile = 0; next }
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

if (( DO_EXTENSIONS )) && ! (( DRY_RUN )); then
  if pgrep -x firefox >/dev/null 2>&1 || pgrep -x firefox-bin >/dev/null 2>&1; then
    printf 'Close Firefox before restoring extensions.\n' >&2
    exit 1
  fi
fi

printf 'profile: %s\n' "$profile_dir"
printf 'link user.js -> %s/user.js\n' "$profile_dir"
(( DRY_RUN )) || ln -sfn "$USER_JS" "$profile_dir/user.js"

if (( DO_PREFS )); then
  printf 'restore prefs.js (@@HOME@@ -> %s)\n' "$HOME"
  if ! (( DRY_RUN )); then
    sed "s|@@HOME@@|$HOME|g" "$PREFS_JS" > "$profile_dir/prefs.js"
  fi
fi

if (( DO_EXTENSIONS )); then
  ext_dir="$profile_dir/extensions"
  printf 'download extensions from pinned sourceURI URLs into %s\n' "$ext_dir"

  while IFS=$'\t' read -r id url; do
    [[ -n "$id" && -n "$url" ]] || continue
    dest="$ext_dir/$id.xpi"
    if [[ -f "$dest" ]]; then
      printf '  skip (exists): %s\n' "$id"
      continue
    fi
    printf '  fetch: %s -> %s\n' "$url" "$dest"
    if ! (( DRY_RUN )); then
      mkdir -p "$ext_dir"
      curl -fL --retry 3 --retry-delay 2 -o "$dest" "$url"
    fi
  done < <(python3 - "$EXTENSIONS_JSON" <<'PY'
import json, sys
data = json.load(open(sys.argv[1], encoding='utf-8'))
for addon in data.get('addons', []):
    if addon.get('location') == 'app-profile' and addon.get('sourceURI'):
        print(f"{addon['id']}\t{addon['sourceURI']}")
PY
)

  printf 'restore extensions.json (@@FIREFOX_PROFILE@@ -> %s)\n' "$profile_dir"
  printf 'restore addons.json and extension-preferences.json\n'
  if ! (( DRY_RUN )); then
    sed "s|@@FIREFOX_PROFILE@@|$profile_dir|g" "$EXTENSIONS_JSON" > "$profile_dir/extensions.json"
    cp -f "$ADDONS_JSON" "$profile_dir/addons.json"
    cp -f "$EXT_PREFS_JSON" "$profile_dir/extension-preferences.json"
  fi
fi

if (( DRY_RUN )); then
  printf 'dry run only; no files were changed\n'
fi
