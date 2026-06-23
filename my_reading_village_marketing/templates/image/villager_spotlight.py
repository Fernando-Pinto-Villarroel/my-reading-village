#!/usr/bin/env python3
"""
My Reading Village — Villager Spotlight
Static 1080x1920: villager on background with name, rarity and description.
Usage: .venv/bin/python3 templates/image/villager_spotlight.py [--villager cat] [--lang en]
"""
import sys, os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))
from PIL import Image, ImageDraw, ImageFilter
from utils import *
import assets as _assets

_OUT = _assets.OUTPUT_DIR
os.makedirs(_OUT, exist_ok=True)


def run(villager='cat', lang='en', bg=2):
    rarity, tint, accent = SPECIES.get(villager, ('common', MINT, D_MINT))
    rlabel = RARITY_LABEL.get(lang, RARITY_LABEL['en'])[rarity]
    name   = species_name(villager, lang)
    desc   = species_desc(villager, lang)

    canvas = Image.new('RGBA', (W, H), (0, 0, 0, 255))

    bg_img = load_bg(f'images/backgrounds/splash_bg_{bg}.png', zoom=1.08, pan_y=0.42)
    bg_img = bg_img.filter(ImageFilter.GaussianBlur(7))
    canvas.alpha_composite(bg_img)
    color_ov(canvas, tint, 0.14)
    color_ov(canvas, (10, 5, 20), 0.50)

    pl = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw_particles(pl, 3.5, 0.45)
    canvas.alpha_composite(pl)

    draw_sparkles(canvas, 1.5, [
        (W * 0.16, H * 0.09, 28, 11, GOLD),
        (W * 0.84, H * 0.08, 22,  9, tint),
        (W * 0.09, H * 0.34, 16,  6, LAVENDER),
        (W * 0.91, H * 0.30, 18,  7, tint),
        (W * 0.14, H * 0.73, 20,  8, GOLD),
        (W * 0.86, H * 0.69, 14,  5, PINK),
    ], 0.9)

    halo = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    for rad, oa in [(280, 0.10), (210, 0.16), (150, 0.12)]:
        ImageDraw.Draw(halo).ellipse(
            [W // 2 - rad, int(H * 0.43) - rad,
             W // 2 + rad, int(H * 0.43) + rad],
            fill=(*tint[:3], int(oa * 255)))
    halo = halo.filter(ImageFilter.GaussianBlur(30))
    canvas.alpha_composite(halo)

    vimg = load_img(f'images/villagers/{villager}/{villager}_villager.png', w=520)
    paste_c(canvas, vimg, W * 0.5, H * 0.43)

    d = ImageDraw.Draw(canvas)

    txt_c(d, 'My Reading Village', W * 0.5, H * 0.085,
          F(FONT_B, 52), (*WHITE[:3], 220),
          stroke_fill=(0, 0, 0), stroke_width=3)

    for xf, c2 in ((0.40, PINK), (0.50, tint), (0.60, LAVENDER)):
        d.ellipse([W * xf - 7, H * 0.115 - 7, W * xf + 7, H * 0.115 + 7],
                  fill=(*c2, 200))

    rw  = max(300, len(rlabel) * 24 + 80)
    rx0 = (W - rw) // 2
    solid_pill(canvas, rx0, int(H * 0.695), rx0 + rw, int(H * 0.695) + 60, r=30,
               fill=(*accent[:3], 230))
    txt_c(d, rlabel.upper(), W * 0.5, H * 0.695 + 30,
          F(FONT_XB, 36), (*WHITE[:3], 255),
          stroke_fill=(0, 0, 0), stroke_width=2)

    txt_c(d, name, W * 0.5, H * 0.775,
          F(FONT_XB, 96), (*WHITE[:3], 255),
          stroke_fill=(0, 0, 0), stroke_width=5)

    lines = wrap_text(desc, max_chars=30)
    for i, line in enumerate(lines[:2]):
        txt_c(d, line, W * 0.5, H * 0.860 + i * 56,
              F(FONT_R, 44), (*CREAM[:3], 210), shadow=(0, 0, 0), sd=3)

    logo = load_img('images/logos/my_reading_village_icon_rounded.png', w=160)
    paste_c(canvas, logo, W * 0.5, H * 0.958)

    out = os.path.join(_OUT, f'villager_spotlight_{villager}_{lang}.png')
    canvas.convert('RGB').save(out)
    print(f'Saved: {out}')


def main():
    run()


if __name__ == '__main__':
    main()
