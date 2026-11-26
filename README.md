Install on new machine:

```bash
sudo pacman -S --needed \
  hyprland hyprlock hypridle \
  swaybg swayosd swaync jq fastfetch \
  alacritty tmux vim zsh rofi git bat \ 
  brightnessctl wl-clipboard grim slurp \
  papirus-icon-theme ttf-hack-nerd nautilus loupe


# GTK themes are not in git. Put Everforest-B-MB-Light and 
# Gruvbox-Green-Dark into ~/.themes manually from GNOME Look.

# On a real machine with not empty ~/.config
git clone --no-checkout git@github.com:therealmaendeleo/dotfiles.git \
  "$HOME/.config-dotfiles"
mv "$HOME/.config-dotfiles/.git" "$HOME/.config/.git"
rmdir "$HOME/.config-dotfiles"
git -C "$HOME/.config" checkout -- .

# Update symlinks for rc files
mkdir -p "$HOME/.vim/autoload"
ln -sfn "$HOME/.config/config/zshrc"    "$HOME/.zshrc"
ln -sfn "$HOME/.config/config/zshenv"   "$HOME/.zshenv"
ln -sfn "$HOME/.config/config/bashrc"   "$HOME/.bashrc"
ln -sfn "$HOME/.config/config/p10k.zsh" "$HOME/.p10k.zsh"
ln -sfn "$HOME/.config/config/vimrc"    "$HOME/.vimrc"
ln -sfn "$HOME/.config/config/vim/autoload/plug.vim" \
        "$HOME/.vim/autoload/plug.vim"

# Update symlinks for bin files
mkdir -p "$HOME/.local/bin"
for f in "$HOME"/.config/bin/*.sh; do
  ln -sfn "$f" "$HOME/.local/bin/$(basename "$f")"
done

# Finish setup
systemctl --user enable --now \
  "$HOME/.config/systemd/user/AlacrittyAutoTheme.service"
vim +PlugInstall +qall
~/.local/bin/install-firefox-profile.sh

# Full Firefox migration: close Firefox first, then run:
~/.local/bin/install-firefox-profile.sh --restore-all
```
