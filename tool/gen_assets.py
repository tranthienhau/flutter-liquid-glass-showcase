"""Generate original, license-clean mesh-gradient wallpapers used as the
photographic backdrops behind the Liquid Glass widgets. No third-party images.

Each image is a smooth multi-point radial mesh with subtle grain, so the glass
has rich, real-looking imagery to refract and blur.
"""
import math
import numpy as np
from PIL import Image, ImageFilter


def mesh(w, h, points, seed=0, grain=6.0):
    """points: list of (cx, cy, radius, (r,g,b), weight) in 0..1 coords."""
    ys, xs = np.mgrid[0:h, 0:w].astype(np.float32)
    xs /= w
    ys /= h
    acc = np.zeros((h, w, 3), np.float32)
    wsum = np.zeros((h, w), np.float32)
    for cx, cy, rad, col, wt in points:
        d = np.sqrt((xs - cx) ** 2 + (ys - cy) ** 2)
        f = np.exp(-(d / rad) ** 2) * wt
        for k in range(3):
            acc[..., k] += f * col[k]
        wsum += f
    wsum = np.maximum(wsum, 1e-4)
    img = acc / wsum[..., None]
    rng = np.random.default_rng(seed)
    img += rng.normal(0, grain, (h, w, 3)).astype(np.float32)
    img = np.clip(img, 0, 255).astype(np.uint8)
    out = Image.fromarray(img, "RGB").filter(ImageFilter.GaussianBlur(1.2))
    return out


SPECS = {
    # Deep aurora wallpaper — the frosted backdrop behind everything.
    "wallpaper": dict(size=(1200, 2600), grain=5, points=[
        (0.15, 0.10, 0.55, (36, 18, 92), 1.0),
        (0.85, 0.05, 0.50, (120, 40, 170), 0.9),
        (0.10, 0.55, 0.55, (200, 60, 150), 0.7),
        (0.90, 0.60, 0.60, (30, 80, 200), 0.9),
        (0.50, 0.95, 0.60, (10, 12, 40), 1.1),
        (0.50, 0.35, 0.40, (60, 30, 120), 0.5),
    ]),
    # Warm sunset — Music hero card.
    "music": dict(size=(1200, 800), grain=6, points=[
        (0.15, 0.20, 0.55, (255, 94, 58), 1.0),
        (0.85, 0.15, 0.5, (250, 45, 85), 1.0),
        (0.6, 0.9, 0.6, (120, 20, 70), 1.0),
        (0.1, 0.8, 0.5, (255, 160, 60), 0.7),
    ]),
    # Teal forest — Nature card.
    "nature": dict(size=(900, 900), grain=6, points=[
        (0.2, 0.2, 0.6, (18, 140, 110), 1.0),
        (0.85, 0.3, 0.5, (40, 190, 130), 0.9),
        (0.5, 0.9, 0.6, (10, 70, 60), 1.0),
        (0.9, 0.85, 0.4, (120, 210, 90), 0.6),
    ]),
    # Indigo travel — Travel card.
    "travel": dict(size=(900, 900), grain=6, points=[
        (0.2, 0.25, 0.6, (70, 90, 240), 1.0),
        (0.85, 0.2, 0.5, (150, 80, 240), 0.9),
        (0.5, 0.95, 0.6, (25, 20, 80), 1.0),
        (0.1, 0.85, 0.45, (60, 180, 240), 0.7),
    ]),
    # Album thumbnails.
    "album1": dict(size=(400, 400), grain=6, points=[
        (0.2, 0.2, 0.7, (255, 120, 40), 1.0), (0.9, 0.9, 0.6, (120, 20, 90), 1.0)]),
    "album2": dict(size=(400, 400), grain=6, points=[
        (0.2, 0.2, 0.7, (40, 200, 180), 1.0), (0.9, 0.9, 0.6, (20, 60, 120), 1.0)]),
    "album3": dict(size=(400, 400), grain=6, points=[
        (0.2, 0.2, 0.7, (200, 60, 200), 1.0), (0.9, 0.9, 0.6, (40, 30, 120), 1.0)]),
}

for i, (name, spec) in enumerate(SPECS.items()):
    w, h = spec["size"]
    img = mesh(w, h, spec["points"], seed=i, grain=spec["grain"])
    img.save(f"assets/photos/{name}.jpg", quality=88)
    print("wrote", name, img.size)
