#!/usr/bin/env bash
# Các bước cài đặt mà stow không làm được. Chạy sau khi đã stow các gói.
#   ./bootstrap.sh
# Cần sẵn: git, curl, jq, và unzip hoặc python3.
set -euo pipefail

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
BIN="${BIN:-$HOME/.local/bin}"
mkdir -p "$BIN"

# --- Plugin zsh (repo git riêng, không lưu trong dotfiles)
clone() { [ -d "$2" ] || git clone --depth 1 "$1" "$2"; }
clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone https://github.com/zsh-users/zsh-autosuggestions     "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# --- tmux: tpm rồi cài các plugin khai báo trong .tmux.conf (cần stow gói tmux trước)
clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
if command -v tmux >/dev/null && [ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
    "$HOME/.tmux/plugins/tpm/bin/install_plugins" || true
fi

# --- Gói trong repo Fedora: chỉ in lệnh còn thiếu, không tự chạy sudo
want=(wf-recorder mpv zathura zathura-pdf-mupdf gh atuin duf procs du-dust imv)
missing=()
for p in "${want[@]}"; do rpm -q "$p" >/dev/null 2>&1 || missing+=("$p"); done
if [ "${#missing[@]}" -gt 0 ]; then
    echo ">> Còn thiếu gói, chạy: sudo dnf install -y ${missing[*]}"
fi

# --- Công cụ không có trong repo Fedora: tải bản release của GitHub.
# Kiểm tra sha256 theo trường "digest" mà GitHub API trả về cho từng asset.
install_release() {
    local repo=$1 pattern=$2; shift 2
    local bins=("$@")
    if [ -x "$BIN/${bins[0]}" ]; then echo "bỏ qua ${bins[0]} (đã có)"; return 0; fi

    local tmp json name url digest got
    tmp=$(mktemp -d)
    json=$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest")
    name=$(jq -r --arg re "$pattern" '[.assets[] | select(.name | test($re))][0].name // empty' <<<"$json")
    [ -n "$name" ] || { echo "không tìm thấy asset cho $repo" >&2; rm -rf "$tmp"; return 1; }
    url=$(jq -r --arg n "$name" '.assets[] | select(.name == $n) | .browser_download_url' <<<"$json")
    digest=$(jq -r --arg n "$name" '.assets[] | select(.name == $n) | .digest // empty' <<<"$json")

    curl -fsSL -o "$tmp/$name" "$url"
    if [ -n "$digest" ]; then
        got="sha256:$(sha256sum "$tmp/$name" | cut -d' ' -f1)"
        [ "$got" = "$digest" ] || { echo "SAI checksum $name" >&2; rm -rf "$tmp"; return 1; }
    else
        echo "cảnh báo: $name không có digest để kiểm tra" >&2
    fi

    mkdir "$tmp/x"
    case "$name" in
        *.zip)    unzip -q "$tmp/$name" -d "$tmp/x" 2>/dev/null \
                      || python3 -c "import sys,zipfile;zipfile.ZipFile(sys.argv[1]).extractall(sys.argv[2])" "$tmp/$name" "$tmp/x" ;;
        *.tar.gz) tar xzf "$tmp/$name" -C "$tmp/x" ;;
        *)        echo "định dạng lạ: $name" >&2; rm -rf "$tmp"; return 1 ;;
    esac
    for b in "${bins[@]}"; do
        install -m 755 "$(find "$tmp/x" -type f -name "$b" | head -1)" "$BIN/$b"
    done
    rm -rf "$tmp"
    echo "đã cài ${bins[*]} ($name)"
}

install_release sxyazi/yazi              '^yazi-x86_64-unknown-linux-gnu\.zip$'        yazi ya
install_release jesseduffield/lazygit    '^lazygit_.*_linux_x86_64\.tar\.gz$'          lazygit
install_release ClementTsang/bottom      '^bottom_x86_64-unknown-linux-gnu\.tar\.gz$'  btm

# yazi: cài flavor theo yazi/.config/yazi/package.toml
if [ -x "$BIN/ya" ]; then PATH="$BIN:$PATH" ya pkg install || true; fi

# --- Cache theme cho bat (theme nằm trong gói bat)
command -v bat >/dev/null && bat cache --build

# --- Icon theme và dark mode cho GTK (gsettings/dconf không nằm trong file)
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

echo "Xong. Theme SDDM cài riêng bằng: sudo bash sddm/install.sh"
echo "Nên chạy thêm: gh auth login ; atuin import auto"
