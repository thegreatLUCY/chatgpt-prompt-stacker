#!/usr/bin/env python3
"""Auto-crop a harness screenshot to the panel card, with a small margin."""
import sys
from PIL import Image

src, dst = sys.argv[1], sys.argv[2]
im = Image.open(src).convert("RGB")
w, h = im.size
px = im.load()
bg = px[2, 2]  # corner = background gradient sample


def differs(c):
    return sum(abs(a - b) for a, b in zip(c, bg)) > 40


# Scan for the panel's bounding box.
minx, miny, maxx, maxy = w, h, 0, 0
step = 2
for y in range(0, h, step):
    for x in range(0, w, step):
        if differs(px[x, y]):
            minx, maxx = min(minx, x), max(maxx, x)
            miny, maxy = min(miny, y), max(maxy, y)
if maxx <= minx:
    im.save(dst)
    sys.exit()

m = 24  # margin (device px)
box = (max(0, minx - m), max(0, miny - m), min(w, maxx + m), min(h, maxy + m))
im.crop(box).save(dst)
