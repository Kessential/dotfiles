#!/usr/bin/env bash
# Các bước cài đặt mà stow không làm được. Chạy sau khi đã stow các gói (xem README.md).
#   ./bootstrap.sh
# Cần sẵn: git.
# Riêng gói zsh phải stow bằng `stow --no-folding zsh` để ~/.oh-my-zsh là thư mục thật.
set -euo pipefail

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# --- Gói trong repo Fedora: chỉ in lệnh còn thiếu, không tự chạy sudo
want=(
    git stow zsh tmux neovim make gcc nodejs npm  # nodejs/npm: LSP bash/json/yaml của nvim
    fzf fd-find bat eza ripgrep zoxide btop                     # công cụ dòng lệnh mà .zshrc dùng
    sway swaylock swayidle waybar foot mako rofi grimshot cliphist wl-clipboard
    fcitx5 fcitx5-gtk fcitx5-qt papirus-icon-theme
    wf-recorder zathura zathura-pdf-mupdf gh imv yazi golang-github-jesseduffield-lazygit  # lazygit: repo terra
    fontawesome-fonts-all jetbrainsmono-nerd-fonts noto-nerd-fonts  # nerd fonts: repo terra (foot, waybar)
)
missing=()
# --whatprovides: nhận cả gói ảo (vd: nodejs do nodejs22 cung cấp)
for p in "${want[@]}"; do rpm -q --whatprovides "$p" >/dev/null 2>&1 || missing+=("$p"); done
if [ "${#missing[@]}" -gt 0 ]; then
    echo ">> Còn thiếu gói, chạy: sudo dnf install -y ${missing[*]}"
fi

# --- oh-my-zsh (không dùng install script vì nó ghi đè ~/.zshrc)
if [ -L "$HOME/.oh-my-zsh" ]; then
    echo "~/.oh-my-zsh là symlink (stow đã gộp thư mục). Chạy: stow -D zsh && stow --no-folding zsh" >&2
    exit 1
fi
if [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
    mkdir -p "$HOME/.oh-my-zsh"
    git -C "$HOME/.oh-my-zsh" init -q
    git -C "$HOME/.oh-my-zsh" remote add origin https://github.com/ohmyzsh/ohmyzsh.git 2>/dev/null || true
    git -C "$HOME/.oh-my-zsh" fetch -q --depth 1 origin master
    git -C "$HOME/.oh-my-zsh" checkout -q -B master FETCH_HEAD
fi

# --- Plugin zsh (repo git riêng, không lưu trong dotfiles)
clone() { [ -d "$2" ] || git clone --depth 1 "$1" "$2"; }
clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone https://github.com/zsh-users/zsh-autosuggestions     "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# --- tmux: tpm rồi cài các plugin khai báo trong .tmux.conf (cần stow gói tmux trước)
clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
if command -v tmux >/dev/null && [ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
    "$HOME/.tmux/plugins/tpm/bin/install_plugins" || true
fi

# yazi: cài flavor theo yazi/.config/yazi/package.toml
command -v ya >/dev/null && { ya pkg install || true; }

# --- Cache theme cho bat (theme nằm trong gói bat)
command -v bat >/dev/null && bat cache --build

# --- Icon theme và dark mode cho GTK (gsettings/dconf không nằm trong file)
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# --- ssh-agent của systemd (.zshrc trỏ SSH_AUTH_SOCK tới socket này)
systemctl --user enable --now ssh-agent.socket || true

echo "Xong. Theme SDDM cài riêng bằng: sudo bash sddm/install.sh"
echo "Nên chạy thêm: gh auth login"
