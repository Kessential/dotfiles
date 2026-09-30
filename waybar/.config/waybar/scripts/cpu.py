#!/usr/bin/env python3
import json
import subprocess
import time


def read_stat():
    stats = {}
    with open("/proc/stat") as f:
        for line in f:
            if not line.startswith("cpu"):
                break
            parts = line.split()
            name = parts[0]
            nums = list(map(int, parts[1:]))
            idle = nums[3] + nums[4]  # idle + iowait
            total = sum(nums)
            stats[name] = (idle, total)
    return stats


def usage_percent(prev, cur):
    out = {}
    for name, (pidle, ptotal) in prev.items():
        cidle, ctotal = cur[name]
        dtotal = ctotal - ptotal
        didle = cidle - pidle
        out[name] = 0.0 if dtotal <= 0 else max(0.0, min(100.0, (1 - didle / dtotal) * 100))
    return out


def top_processes(n=5):
    out = subprocess.run(
        ["ps", "-eo", "comm,%cpu", "--sort=-%cpu", "--no-headers"],
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


prev = read_stat()
time.sleep(0.35)
cur = read_stat()
usage = usage_percent(prev, cur)

overall = round(usage["cpu"])
tooltip = "Top CPU:\n" + "\n".join(top_processes())

if overall >= 90:
    cls = "critical"
elif overall >= 70:
    cls = "warning"
else:
    cls = "normal"

print(json.dumps({
    "text": f"{overall}% ",
    "tooltip": tooltip,
    "percentage": overall,
    "class": cls,
}))
