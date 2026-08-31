"""Wrap raw simulator screenshots in a clean iPhone device frame on a soft
brand-gradient canvas, so the README screenshots look like a portfolio, not
raw captures. Pure Pillow, no assets.
"""
import sys
from PIL import Image, ImageDraw, ImageFilter


def rounded_mask(size, radius):
    m = Image.new("L", size, 0)
    d = ImageDraw.Draw(m)
    d.rounded_rectangle([0, 0, size[0], size[1]], radius=radius, fill=255)
    return m


def vertical_gradient(size, top, bottom):
    w, h = size
    base = Image.new("RGB", size, top)
    top_a = Image.new("RGB", size, bottom)
    mask = Image.new("L", size)
    mask.putdata([int(255 * (y / h)) for y in range(h) for _ in range(w)])
    base.paste(top_a, (0, 0), mask)
    return base


def frame(src_path, out_path, pad=90, bezel=16, radius=96, corner_screen=68):
    shot = Image.open(src_path).convert("RGB")
    sw, sh = shot.size

    # Device: screen + black bezel.
    dev_w, dev_h = sw + bezel * 2, sh + bezel * 2
    device = Image.new("RGB", (dev_w, dev_h), (12, 12, 14))
    screen = shot.copy()
    screen.putalpha(rounded_mask((sw, sh), corner_screen))
    device.paste(screen, (bezel, bezel), screen)
    device.putalpha(rounded_mask((dev_w, dev_h), radius))

    # Canvas with soft brand gradient.
    cw, ch = dev_w + pad * 2, dev_h + pad * 2
    canvas = vertical_gradient((cw, ch), (46, 27, 82), (18, 14, 40))

    # Drop shadow.
    shadow = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.rounded_rectangle(
        [pad, pad + 18, pad + dev_w, pad + dev_h + 18],
        radius=radius, fill=(0, 0, 0, 150),
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(40))
    canvas.paste(shadow, (0, 0), shadow)
    canvas.paste(device, (pad, pad), device)
    canvas.save(out_path, quality=92)
    print("wrote", out_path, canvas.size)


if __name__ == "__main__":
    pairs = [
        ("/tmp/shot_home.png", "screenshots/01-home.png"),
        ("/tmp/shot_actions.png", "screenshots/02-controls-actions.png"),
        ("/tmp/shot_controls.png", "screenshots/03-controls.png"),
    ]
    for src, out in pairs:
        frame(src, out)
