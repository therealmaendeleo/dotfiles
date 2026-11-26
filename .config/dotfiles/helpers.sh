# Helper functions for the bare dotfiles repository in ~/.cfg.
# Source from ~/.zshrc and ~/.bashrc.

dotfiles() {
  command git --git-dir="$HOME/.cfg" --work-tree="$HOME" "$@"
}

dotstatus() {
  dotfiles status --short
}

dotuntracked() {
  if [ "$#" -eq 0 ]; then
    set -- .config/hypr .config/rofi .config/tmux .vim .local/bin .config/systemd/user
  fi
  dotfiles ls-files --others --exclude-standard -- "$@"
}

# Stages tracked modifications; new files must be named explicitly.
dotadd() {
  dotfiles add -u || return 1
  if [ "$#" -gt 0 ]; then
    dotfiles add -- "$@" || return 1
  fi
}

# Usage: dotsave "commit message" [new-file ...]
dotsave() {
  msg=$1
  shift 2>/dev/null || true
  [ -n "$msg" ] || { printf '%s\n' "Usage: dotsave 'msg' [new-file ...]" >&2; return 2; }

  dotadd "$@" || return 1
  dotfiles diff --cached --quiet && { printf '%s\n' 'Nothing to commit'; return 0; }

  dotfiles commit -m "$msg" && dotfiles pull --rebase && dotfiles push
}
