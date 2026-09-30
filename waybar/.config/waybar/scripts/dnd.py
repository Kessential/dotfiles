#!/usr/bin/env python3
import json
import subprocess

modes = subprocess.run(
    ["makoctl", "mode"], capture_output=True, text=True
).stdout.split()
dnd = "do-not-disturb" in modes

print(json.dumps({
    "text": "" if dnd else "",
    "tooltip": "Do not disturb: on (click to turn off)" if dnd
               else "Do not disturb: off (click to turn on)",
    "class": "dnd" if dnd else "normal",
}))
