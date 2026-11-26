# Helper functions for the ordinary dotfiles repository in ~/.config.
# Source from ~/.zshrc and ~/.bashrc.

dotstatus() {
  command git -C "$HOME/.config" status --short
}

dotuntracked() {
  if [ "$#" -eq 0 ]; then
    set -- hypr rofi tmux alacritty firefox htop dotfiles systemd/user config media bin
  fi
  command git -C "$HOME/.config" ls-files --others --exclude-standard -- "$@"
}

# Stages tracked modifications; new files must be named explicitly.
dotadd() {
  command git -C "$HOME/.config" add -u || return 1
  if [ "$#" -gt 0 ]; then
    command git -C "$HOME/.config" add -- "$@" || return 1
  fi
}

# Usage: dotsave "commit message" [new-file ...]
dotsave() {
  msg=$1
  shift 2>/dev/null || true
  [ -n "$msg" ] || { printf '%s\n' "Usage: dotsave 'msg' [new-file ...]" >&2; return 2; }

  dotadd "$@" || return 1
  command git -C "$HOME/.config" diff --cached --quiet && { printf '%s\n' 'Nothing to commit'; return 0; }

  command git -C "$HOME/.config" commit -m "$msg" &&
    command git -C "$HOME/.config" pull --rebase &&
    command git -C "$HOME/.config" push
}

# Shows top 5 memory consuming applications, grouped by name.
topmem() {
    ps -eo rss,args --no-headers |
    awk '{
        rss = $1;
        cmd = $2;
        app_name = cmd;

        # For interpreters, find the script name to use as the app name
        if (cmd ~ /\/(python|node|java|perl|ruby)[0-9.]*$/) {
            for (i = 3; i <= NF; i++) {
                # Find first argument that is not an option and looks like a path/script
                if ($i !~ /^-/ && $i ~ /[\/\.]/) {
                    app_name = $i;
                    break;
                }
            }
        }

        # Group all kernel threads together
        if (cmd ~ /^\[.*\]$/) {
            app_name = "Kernel Threads";
        }

        # Sum RSS and count processes for each unique application name
        rss_sum[app_name] += rss;
        count[app_name]++;
    }
    END {
        for (app in rss_sum) {
            # Print in a machine-sortable format with a tab separator
            printf "%f\t%s (%d processes)\n", rss_sum[app], app, count[app];
        }
    }' |
    sort -rn | # Sort numerically in reverse
    head -n 5 | # Take the top 5
    awk -F'\t' '{
        # Format the final output into a clean table
        rss_kb = $1;
        rest = $2;
        printf "%10.2f MB | %s\n", rss_kb/1024, rest;
    }'
}
