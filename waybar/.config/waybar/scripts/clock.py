#!/usr/bin/env python3
"""Đồng hồ waybar: 'Thu 26 Nov · 00:18', tooltip là lịch tháng (tuần bắt đầu thứ Hai)."""
import calendar
import json
from datetime import datetime

DAYS = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
MONTHS = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
MONTHS_FULL = ["", "January", "February", "March", "April", "May", "June",
               "July", "August", "September", "October", "November", "December"]

now = datetime.now()
icon = "<span color='#7aa2f7'></span>"
text = f"{icon} {DAYS[now.weekday()]} {now.day} {MONTHS[now.month]} · <b>{now:%H:%M}</b>"

title = f"{MONTHS_FULL[now.month]} {now.year}"
rows = [f"<b>{title.center(20)}</b>", "Mo Tu We Th Fr Sa Su"]
for week in calendar.Calendar(firstweekday=0).monthdayscalendar(now.year, now.month):
    cells = []
    for i, d in enumerate(week):
        if d == 0:
            cells.append("  ")
        elif d == now.day:
            cells.append(f"<span background='#7aa2f7' color='#16161e'><b>{d:2d}</b></span>")
        elif i >= 5:
            cells.append(f"<span color='#bb9af7'>{d:2d}</span>")
        else:
            cells.append(f"{d:2d}")
    rows.append(" ".join(cells))

print(json.dumps({
    "text": text,
    "tooltip": "<tt>" + "\n".join(rows) + "</tt>",
}))
