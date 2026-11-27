#!/usr/bin/env bash
# Cài theme SDDM Tokyo Night (nền: ảnh tối mặc định của Fedora). Chạy: sudo bash sddm/install.sh
# Hoàn tác: sudo cp /etc/sddm-backup/local.conf.bak-before-tokyonight /etc/sddm.conf.d/local.conf
# Bản sao lưu KHÔNG được để trong /etc/sddm.conf.d: SDDM đọc mọi file trong đó theo thứ tự tên,
# nên file .bak (đứng sau local.conf) sẽ ghi đè theme.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DST=/usr/share/sddm/themes/tokyonight-sway
install -d "$DST"
cp -r "$HERE/tokyonight-sway/." "$DST/"
# Ảnh nền tối mặc định của Fedora (.jxl) đổi sang jpg cho SDDM; chạy lại sau khi nâng cấp Fedora để lấy ảnh mới
ffmpeg -loglevel error -y -i /usr/share/backgrounds/default-dark.jxl -q:v 2 "$DST/wallpaper.jpg"
chmod -R a+rX "$DST"
install -d /etc/sddm.conf.d
install -d /etc/sddm-backup
[ -f /etc/sddm.conf.d/local.conf ] && cp -n /etc/sddm.conf.d/local.conf /etc/sddm-backup/local.conf.bak-before-tokyonight || true
# Dọn các bản sao lưu cũ lỡ để trong sddm.conf.d
for f in /etc/sddm.conf.d/*.bak-*; do [ -e "$f" ] && mv -f "$f" /etc/sddm-backup/; done
# Font=: font chung cho mọi chữ không đặt font riêng trong Main.qml (phải là font cài cho toàn hệ thống)
printf '[Theme]\nCurrent=tokyonight-sway\nFont=Adwaita Sans,11\n' > /etc/sddm.conf.d/local.conf
# Gỡ theme Catppuccin cũ nếu còn
rm -rf /usr/share/sddm/themes/catppuccin-sway
echo "Đã cài theme tokyonight-sway."
