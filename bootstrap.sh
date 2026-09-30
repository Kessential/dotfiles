#!/usr/bin/env bash
# Các bước cài đặt mà stow không làm được. Chạy sau khi đã stow các gói.
#   ./bootstrap.sh
set -euo pipefail

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Plugin zsh (repo git riêng, không lưu trong dotfiles)
clone() { [ -d "$2" ] || git clone --depth 1 "$1" "$2"; }
clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone https://github.com/zsh-users/zsh-autosuggestions     "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# Cache theme cho bat (theme nằm trong gói bat)
command -v bat >/dev/null && bat cache --build

# Icon theme và dark mode cho GTK (gsettings/dconf không nằm trong file)
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

echo "Xong. Theme SDDM cài riêng bằng: sudo bash sddm/install.sh"
