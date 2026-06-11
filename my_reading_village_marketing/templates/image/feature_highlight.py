#!/usr/bin/env python3
"""
My Reading Village — Feature Highlight
Static 1080x1920: "Did you know?" glassmorphism card with a reading fact.
Usage: .venv/bin/python3 templates/image/feature_highlight.py [--lang en]
"""
import sys, os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))
from PIL import Image, ImageDraw, ImageFilter
from utils import *
import assets as _assets

_OUT = _assets.OUTPUT_DIR
os.makedirs(_OUT, exist_ok=True)

_FACTS = {
    'en': [
        ('68%', 'Stress reduction', 'Reading just 6 minutes\ncuts stress by 68%.'),
        ('100k', 'Words per hour', 'Speed readers process\n100,000 words per hour.'),
        ('2x', 'Better sleep', 'Reading before bed\nimproves sleep quality 2x.'),
    ],
    'es': [
        ('68%', 'Reducción del estrés', 'Leer solo 6 minutos\nreduce el estrés un 68%.'),
        ('6 min', 'Al día es suficiente', 'Basta con 6 minutos\nde lectura diaria.'),
        ('2x', 'Mejor sueño', 'Leer antes de dormir\nmejora el sueño 2x.'),
    ],
}

_HEADER = {
    'en': 'Did you know?',
    'es': '¿Sabías que...?',
    'pt': 'Você sabia?',
    'fr': 'Le saviez-vous ?',
    'it': 'Lo sapevi?',
}

_CTA = {
    'en': 'Read. Build. Grow.',
    'es': 'Lee. Construye. Crece.',
    'pt': 'Leia. Construa. Cresça.',
    'fr': 'Lis. Construis. Grandis.',
    'it': 'Leggi. Costruisci. Cresci.',
}


def run(lang='en'):
    facts = _FACTS.get(lang, _FACTS['en'])
    stat, title, body = facts[0]
    header = _HEADER.get(lang, _HEADER['en'])
    cta    = _CTA.get(lang, _CTA['en'])

    canvas = Image.new('RGBA', (W, H), (0, 0, 0, 255))

    bg = load_bg('images/backgrounds/splash_bg_1.png', zoom=1.05, pan_y=0.35)
    bg = bg.filter(ImageFilter.GaussianBlur(5))
    canvas.alpha_composite(bg)
    color_ov(canvas, (12, 6, 22), 0.58)

    pl = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw_particles(pl, 4.0, 0.5)
    canvas.alpha_composite(pl)

    draw_sparkles(canvas, 2.0, [
        (W * 0.14, H * 0.07, 30, 12, GOLD),
        (W * 0.86, H * 0.07, 24, 10, LAVENDER),
        (W * 0.08, H * 0.22, 16,  6, MINT),
        (W * 0.92, H * 0.25, 18,  7, PINK),
        (W * 0.12, H * 0.80, 20,  8, GOLD),
        (W * 0.88, H * 0.78, 14,  5, SKY_BLUE),
        (W * 0.50, H * 0.95, 16,  6, LAVENDER),
    ], 0.88)

    d = ImageDraw.Draw(canvas)

    txt_c(d, header, W * 0.5, H * 0.130,
          F(FONT_SB, 68), (*CREAM[:3], 240), shadow=(0, 0, 0), sd=4)

    cw, ch = 860, 620
    cx0 = (W - cw) // 2
    cy0 = int(H * 0.205)
    glass_card(canvas, cx0, cy0, cx0 + cw, cy0 + ch, r=40,
               tint=LAVENDER, ta=0.28, blur=20, border=D_LAV)

    txt_c(d, stat, W * 0.5, cy0 + 150,
          F(FONT_XB, 160), (*GOLD[:3], 255), shadow=(60, 40, 0), sd=8)

    txt_c(d, title, W * 0.5, cy0 + 300,
          F(FONT_B, 58), (*WHITE[:3], 255), shadow=(0, 0, 0), sd=4)

    for i, line in enumerate(body.split('\n')):
        txt_c(d, line, W * 0.5, cy0 + 400 + i * 62,
              F(FONT_R, 44), (*CREAM[:3], 220), shadow=(0, 0, 0), sd=3)

    rabbit = load_img('images/villagers/rabbit/rabbit_villager.png', w=360)
    paste_c(canvas, rabbit, W * 0.75, H * 0.730)

    glass_card(canvas, (W - 700) // 2, int(H * 0.845),
               (W + 700) // 2, int(H * 0.845) + 90, r=45,
               tint=MINT, ta=0.30, blur=12, border=D_MINT)
    txt_c(d, cta, W * 0.5, H * 0.845 + 45,
          F(FONT_B, 46), (*WHITE[:3], 255), shadow=(0, 0, 0), sd=3)

    logo = load_img('images/logos/my_reading_village_icon_rounded.png', w=88)
    paste_c(canvas, logo, W * 0.5, H * 0.950)

    out = os.path.join(_OUT, f'feature_highlight_{lang}.png')
    canvas.convert('RGB').save(out)
    print(f'Saved: {out}')


def main():
    run()


if __name__ == '__main__':
    main()
