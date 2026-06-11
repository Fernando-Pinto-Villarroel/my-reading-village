#!/usr/bin/env python3
"""
My Reading Village — Reading Tip
Static 1080x1920: a quote from the game's reading_tips JSON, with villager.
Usage: .venv/bin/python3 templates/image/reading_tip.py [--lang en]
"""
import sys, os, json, textwrap
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))
from PIL import Image, ImageDraw, ImageFilter
from utils import *
import assets as _assets

_OUT = _assets.OUTPUT_DIR
os.makedirs(_OUT, exist_ok=True)

_HEADER = {
    'en': 'Reading tip',
    'es': 'Consejo de lectura',
    'pt': 'Dica de leitura',
    'fr': 'Conseil de lecture',
    'it': 'Consiglio di lettura',
}

_CTA = {
    'en': '@myreadingvillage',
    'es': '@myreadingvillage',
    'pt': '@myreadingvillage',
    'fr': '@myreadingvillage',
    'it': '@myreadingvillage',
}


def run(lang='en'):
    tips_path = _assets.asset(f'messages/{lang}/reading_tips.json')
    if not os.path.exists(tips_path):
        tips_path = _assets.asset('messages/en/reading_tips.json')
    tips = json.load(open(tips_path))['tips']
    tip  = tips[0]

    header = _HEADER.get(lang, _HEADER['en'])

    canvas = Image.new('RGBA', (W, H), (0, 0, 0, 255))

    bg = load_bg('images/backgrounds/splash_bg_3.png', zoom=1.06, pan_y=0.40)
    bg = bg.filter(ImageFilter.GaussianBlur(7))
    canvas.alpha_composite(bg)
    color_ov(canvas, PINK, 0.12)
    color_ov(canvas, (8, 4, 18), 0.50)

    pl = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw_particles(pl, 5.0, 0.45)
    canvas.alpha_composite(pl)

    draw_sparkles(canvas, 3.0, [
        (W * 0.12, H * 0.08, 26, 10, GOLD),
        (W * 0.88, H * 0.07, 20,  8, PINK),
        (W * 0.08, H * 0.30, 14,  5, LAVENDER),
        (W * 0.92, H * 0.28, 16,  6, MINT),
        (W * 0.10, H * 0.82, 18,  7, GOLD),
        (W * 0.90, H * 0.80, 12,  4, SKY_BLUE),
    ], 0.85)

    d = ImageDraw.Draw(canvas)

    solid_pill(canvas, (W - 420) // 2, int(H * 0.100),
               (W + 420) // 2, int(H * 0.100) + 58, r=29,
               fill=(*D_PINK[:3], 210))
    txt_c(d, header.upper(), W * 0.5, H * 0.100 + 29,
          F(FONT_XB, 36), (*WHITE[:3], 255))

    lines  = textwrap.wrap(f'"{tip}"', width=28)
    card_h = 100 + len(lines) * 72
    cy0    = int(H * 0.200)
    glass_card(canvas, (W - 900) // 2, cy0,
               (W + 900) // 2, cy0 + card_h, r=40,
               tint=PINK, ta=0.25, blur=18, border=D_PINK)

    for i, line in enumerate(lines):
        txt_c(d, line, W * 0.5, cy0 + 55 + i * 72,
              F(FONT_SB, 46), (*WHITE[:3], 245), shadow=(0, 0, 0), sd=3)

    cat = load_img('images/villagers/cat/cat_villager.png', w=420)
    paste_c(canvas, cat, W * 0.5, int(H * 0.685))

    glass_card(canvas, (W - 660) // 2, int(H * 0.845),
               (W + 660) // 2, int(H * 0.845) + 80, r=40,
               tint=LAVENDER, ta=0.28, blur=12, border=D_LAV)
    txt_c(d, _CTA.get(lang, '@myreadingvillage'),
          W * 0.5, H * 0.845 + 40,
          F(FONT_SB, 48), (*D_LAV[:3], 255), shadow=(220, 220, 240), sd=3)

    logo = load_img('images/logos/my_reading_village_icon_rounded.png', w=88)
    paste_c(canvas, logo, W * 0.5, H * 0.950)

    out = os.path.join(_OUT, f'reading_tip_{lang}.png')
    canvas.convert('RGB').save(out)
    print(f'Saved: {out}')


def main():
    run()


if __name__ == '__main__':
    main()
