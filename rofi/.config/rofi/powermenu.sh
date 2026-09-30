#!/usr/bin/env bash
# Rofi power menu (Catppuccin theme comes from config.rasi)

lock=$'  Lock'
logout=$'  Logout'
suspend=$'  Suspend'
reboot=$'  Reboot'
shutdown=$'  Shutdown'

menu() {
    rofi -dmenu -i -no-custom -p "$1" \
        -theme-str "window { width: 320px; } listview { lines: $2; }"
}

confirm() {
    [ "$(printf 'Yes\nNo\n' | menu "$1?" 2)" = "Yes" ]
}

choice=$(printf '%s\n' "$lock" "$logout" "$suspend" "$reboot" "$shutdown" | menu "Power" 5)

case "$choice" in
    "$lock")     swaylock -f ;;
    "$logout")   confirm "Logout"   && swaymsg exit ;;
    "$suspend")  systemctl suspend ;;
    "$reboot")   confirm "Reboot"   && systemctl reboot ;;
    "$shutdown") confirm "Shutdown" && systemctl poweroff ;;
esac
