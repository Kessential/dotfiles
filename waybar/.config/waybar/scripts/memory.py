#!/usr/bin/env python3
import json
import subprocess


def meminfo():
    d = {}
    with open("/proc/meminfo") as f:
        for line in f:
            key, value = line.split(":", 1)
            d[key] = int(value.strip().split()[0])  # kB
    return d


def gib(kb):
    return f"{kb / 1048576:.1f}G"


def top_processes(n=5):
    out = subprocess.run(
        ["ps", "-eo", "comm,%mem", "--sort=-%mem", "--no-headers"],
        capture_output=True, text=True,
    ).stdout.splitlines()
    lines = []
    for row in out[:n]:
        row = row.strip()
        if not row:
            continue
        comm, pct = row.rsplit(None, 1)
        lines.append(f"{comm:<20} {float(pct):.1f}%")
    return lines


m = meminfo()
total = m["MemTotal"]
avail = m.get("MemAvailable", m["MemFree"])
used = total - avail
percentage = round(used / total * 100) if total else 0

tooltip = f"{gib(used)} / {gib(total)} used\n\nTop memory:\n" + "\n".join(top_processes())

if percentage >= 90:
    cls = "critical"
elif percentage >= 75:
    cls = "warning"
else:
    cls = "normal"

print(json.dumps({
    "text": f"{percentage}% ",
    "tooltip": tooltip,
    "percentage": percentage,
    "class": cls,
}))
