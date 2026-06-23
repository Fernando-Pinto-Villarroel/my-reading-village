#!/usr/bin/env python3
"""
My Reading Village — Excuses Not to Read
Static 1080x1920: relatable list of reading excuses + solution pivot.
Usage: .venv/bin/python3 templates/image/excuses_not_to_read.py [--lang en]
"""
import sys, os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))
from PIL import Image, ImageDraw, ImageFilter
from utils import *
import assets as _assets

_OUT = _assets.OUTPUT_DIR
os.makedirs(_OUT, exist_ok=True)

_HEADER = {
    'en': "Let's be real",
    'es': 'Seamos honestos',
    'pt': 'Sejamos honestos',
    'fr': 'Soyons honnêtes',
    'it': 'Siamo onesti',
}

_EXCUSES = {
    'en': [
        '"I don\'t have time."',
        '"I can\'t focus."',
        '"Books are boring."',
        '"I\'ll start tomorrow."',
    ],
    'es': [
        '"No tengo tiempo."',
        '"No puedo concentrarme."',
        '"Los libros son aburridos."',
        '"Empezaré mañana."',
    ],
    'pt': [
        '"Não tenho tempo."',
        '"Não consigo me concentrar."',
        '"Livros são chatos."',
        '"Começo amanhã."',
    ],
    'fr': [
        '"Je n\'ai pas le temps."',
        '"Je n\'arrive pas à me concentrer."',
        '"Les livres sont ennuyeux."',
        '"Je commencerai demain."',
    ],
    'it': [
        '"Non ho tempo."',
        '"Non riesco a concentrarmi."',
        '"I libri sono noiosi."',
        '"Comincio domani."',
    ],
}

_SOLUTION = {
    'en': 'Make reading feel like a reward.',
    'es': 'Haz que leer se sienta como recompensa.',
    'pt': 'Faça a leitura parecer uma recompensa.',
    'fr': 'Rends la lecture irrésistible.',
    'it': 'Rendi la lettura un premio.',
}

_CTA = {
    'en': '@myreadingvillage',
    'es': '@myreadingvillage',
    'pt': '@myreadingvillage',
    'fr': '@myreadingvillage',
    'it': '@myreadingvillage',
}


def run(lang='en', bg=5):
    header   = _HEADER.get(lang, _HEADER['en'])
    excuses  = _EXCUSES.get(lang, _EXCUSES['en'])
    solution = _SOLUTION.get(lang, _SOLUTION['en'])
    cta      = _CTA.get(lang, _CTA['en'])

    canvas = Image.new('RGBA', (W, H), (0, 0, 0, 255))

    bg_img = load_bg(f'images/backgrounds/splash_bg_{bg}.png', zoom=1.06, pan_y=0.40)
    bg_img = bg_img.filter(ImageFilter.GaussianBlur(7))
    canvas.alpha_composite(bg_img)
    color_ov(canvas, PINK, 0.10)
    color_ov(canvas, (8, 4, 18), 0.52)

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

    _logo_size = 220
    _pill_h    = 68
    _gap       = 46
    _logo_cy   = int(H * 0.083)
    _pill_top  = _logo_cy + _logo_size // 2 + _gap
    _pill_cy   = _pill_top + _pill_h // 2
    _card_top  = _pill_top + _pill_h + _gap

    logo = load_img('images/logos/my_reading_village_icon_rounded.png', w=_logo_size)
    paste_c(canvas, logo, W * 0.5, _logo_cy)

    solid_pill(canvas, (W - 520) // 2, _pill_top,
               (W + 520) // 2, _pill_top + _pill_h, r=34,
               fill=(*D_PINK[:3], 210))
    txt_c(d, header.upper(), W * 0.5, _pill_cy,
          F(FONT_XB, 46), (*WHITE[:3], 255))

    _row_h    = 98
    _v_pad    = 50
    card_h    = _v_pad + 56 + 22 + len(excuses) * _row_h + _v_pad + 58 + _v_pad
    cx0 = (W - 920) // 2
    cy0 = _card_top
    glass_card(canvas, cx0, cy0, cx0 + 920, cy0 + card_h, r=40,
               tint=PINK, ta=0.25, blur=18, border=D_PINK)

    txt_c(d, 'Excuses we all make', W * 0.5, cy0 + _v_pad + 28,
          F(FONT_B, 52), (*WHITE[:3], 240), shadow=(0, 0, 0), sd=3)

    sep_y = cy0 + _v_pad + 56 + 16
    ImageDraw.Draw(canvas).line(
        [(cx0 + 60, sep_y), (cx0 + 860, sep_y)],
        fill=(*D_PINK[:3], 80), width=2)

    row_start = sep_y + 22
    for i, excuse in enumerate(excuses):
        ry = row_start + i * _row_h + _row_h // 2
        badge_x = cx0 + 72
        solid_pill(canvas, badge_x - 22, ry - 22, badge_x + 22, ry + 22, r=22,
                   fill=(*D_PINK[:3], 220))
        txt_c(d, 'X', badge_x, ry,
              F(FONT_XB, 28), (*WHITE[:3], 255))
        txt_c(d, excuse, cx0 + 500, ry,
              F(FONT_SB, 46), (*CREAM[:3], 235), shadow=(0, 0, 0), sd=2)

    sol_y = row_start + len(excuses) * _row_h + _v_pad // 2
    ImageDraw.Draw(canvas).line(
        [(cx0 + 60, sol_y - 22), (cx0 + 860, sol_y - 22)],
        fill=(*MINT[:3], 80), width=2)
    txt_c(d, solution, W * 0.5, sol_y + 22,
          F(FONT_I, 48), (*MINT[:3], 245), shadow=(0, 0, 0), sd=2)

    card_bottom = cy0 + card_h
    villager_y  = int(card_bottom + (H * 0.870 - card_bottom) * 0.42)
    cat = load_img('images/villagers/cat/cat_villager.png', w=400)
    paste_c(canvas, cat, W * 0.5, villager_y)

    glass_card(canvas, (W - 660) // 2, int(H * 0.870),
               (W + 660) // 2, int(H * 0.870) + 80, r=40,
               tint=LAVENDER, ta=0.28, blur=12, border=D_LAV)
    txt_c(d, cta, W * 0.5, H * 0.870 + 40,
          F(FONT_R, 52), (*WHITE[:3], 255), shadow=(180, 180, 220), sd=3)

    out = os.path.join(_OUT, f'excuses_not_to_read_{lang}.png')
    canvas.convert('RGB').save(out)
    print(f'Saved: {out}')


def main():
    run()


if __name__ == '__main__':
    main()
