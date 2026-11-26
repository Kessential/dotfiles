#!/usr/bin/env bash
# Cài theme SDDM Tokyo Night (nền: ảnh tối mặc định của Fedora). Chạy: sudo bash sddm/install.sh
# Hoàn tác: sudo cp /etc/sddm.conf.d/local.conf.bak-before-tokyonight /etc/sddm.conf.d/local.conf
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DST=/usr/share/sddm/themes/tokyonight-sway
install -d "$DST"
cp -r "$HERE/tokyonight-sway/." "$DST/"
# Ảnh nền tối mặc định của Fedora (.jxl) đổi sang jpg cho SDDM; chạy lại sau khi nâng cấp Fedora để lấy ảnh mới
ffmpeg -loglevel error -y -i /usr/share/backgrounds/default-dark.jxl -q:v 2 "$DST/wallpaper.jpg"
chmod -R a+rX "$DST"
install -d /etc/sddm.conf.d
[ -f /etc/sddm.conf.d/local.conf ] && cp -n /etc/sddm.conf.d/local.conf /etc/sddm.conf.d/local.conf.bak-before-tokyonight || true
printf '[Theme]\nCurrent=tokyonight-sway\n' > /etc/sddm.conf.d/local.conf
# Gỡ theme Catppuccin cũ nếu còn
rm -rf /usr/share/sddm/themes/catppuccin-sway
echo "Đã cài theme tokyonight-sway."
