#!/usr/bin/env bash
# Cài theme SDDM Catppuccin. Chạy: sudo bash sddm/install.sh
# Hoàn tác: sudo cp /etc/sddm.conf.d/local.conf.bak-before-catppuccin /etc/sddm.conf.d/local.conf
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DST=/usr/share/sddm/themes/catppuccin-sway
install -d "$DST"
cp -r "$HERE/catppuccin-sway/." "$DST/"
# Ảnh nền mặc định của Fedora (.jxl) đổi sang jpg cho SDDM
ffmpeg -loglevel error -y -i /usr/share/backgrounds/default-dark.jxl -q:v 2 "$DST/wallpaper.jpg"
chmod -R a+rX "$DST"
install -d /etc/sddm.conf.d
[ -f /etc/sddm.conf.d/local.conf ] && cp -n /etc/sddm.conf.d/local.conf /etc/sddm.conf.d/local.conf.bak-before-catppuccin || true
printf '[Theme]\nCurrent=catppuccin-sway\n' > /etc/sddm.conf.d/local.conf
echo "Đã cài theme catppuccin-sway."
