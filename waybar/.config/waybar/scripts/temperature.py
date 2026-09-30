#!/usr/bin/env python3
import glob
import json


def read_temp(hwmon_glob, filename="temp1_input"):
    matches = glob.glob(f"{hwmon_glob}/hwmon*/{filename}")
    if not matches:
        return None
    with open(matches[0]) as f:
        return int(f.read().strip()) / 1000


CPU_HWMON = "/sys/devices/platform/coretemp.0/hwmon"
GPU_HWMON = "/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/hwmon"

ICON_LOW, ICON_MID, ICON_HIGH = "", "", ""

cpu = read_temp(CPU_HWMON)
gpu = read_temp(GPU_HWMON)

lines = []
if cpu is not None:
    lines.append(f"CPU package: {cpu:.0f}°C")
if gpu is not None:
    lines.append(f"GPU: {gpu:.0f}°C")
tooltip = "\n".join(lines) if lines else "No sensors found"

main = cpu if cpu is not None else gpu

if main is None:
    icon = ICON_LOW
elif main >= 75:
    icon = ICON_HIGH
elif main >= 55:
    icon = ICON_MID
else:
    icon = ICON_LOW

cpu_critical = cpu is not None and cpu >= 80
gpu_critical = gpu is not None and gpu >= 90
cpu_warning = cpu is not None and cpu >= 70
gpu_warning = gpu is not None and gpu >= 80

if cpu_critical or gpu_critical:
    cls = "critical"
elif cpu_warning or gpu_warning:
    cls = "warning"
else:
    cls = "normal"

text = f"{main:.0f}°C {icon}" if main is not None else "N/A"

print(json.dumps({
    "text": text,
    "tooltip": tooltip,
    "class": cls,
}))
