#!/usr/bin/env python3
"""
My Reading Village — Who Should Read More?
Static 1080x1920: engaging list of who benefits from reading + product bridge.
Usage: .venv/bin/python3 templates/image/who_should_read.py [--lang en]
"""
import sys, os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))
from PIL import Image, ImageDraw, ImageFilter
from utils import *
import assets as _assets

_OUT = _assets.OUTPUT_DIR
os.makedirs(_OUT, exist_ok=True)

_HEADER = {
    'en': 'Who should read more?',
    'es': '¿Quién debería leer más?',
    'pt': 'Quem deveria ler mais?',
    'fr': 'Qui devrait lire plus ?',
    'it': 'Chi dovrebbe leggere di più?',
}

_ROWS = {
    'en': [
        ('You',       '68% less stress · sharper memory',  PINK,     D_PINK),
        ('Your kids', 'Empathy · vocabulary · habit',       LAVENDER, D_LAV),
        ('Students',  'Focus · critical thinking',          MINT,     D_MINT),
        ('Partner',   'Better sleep · calmer mornings',     SKY_BLUE, (60, 100, 180, 255)),
        ('Friend',    'They just need a nudge',             GOLD,     (160, 120, 0, 255)),
    ],
    'es': [
        ('Tú',          '68% menos estrés · mejor memoria', PINK,     D_PINK),
        ('Tus hijos',   'Empatía · vocabulario · hábito',   LAVENDER, D_LAV),
        ('Estudiantes', 'Concentración · pensamiento',       MINT,     D_MINT),
        ('Tu pareja',   'Mejor sueño · mañanas tranquilas', SKY_BLUE, (60, 100, 180, 255)),
        ('Tu amigo/a',  'Solo necesitan un empujón',         GOLD,     (160, 120, 0, 255)),
    ],
    'pt': [
        ('Você',          '68% menos estresse · memória',   PINK,     D_PINK),
        ('Seus filhos',   'Empatia · vocabulário · hábito', LAVENDER, D_LAV),
        ('Estudantes',    'Foco · pensamento crítico',       MINT,     D_MINT),
        ('Parceiro/a',    'Sono melhor · manhãs calmas',     SKY_BLUE, (60, 100, 180, 255)),
        ('Amigo/a',       'Só precisam de um empurrão',      GOLD,     (160, 120, 0, 255)),
    ],
    'fr': [
        ('Toi',          '68% moins de stress · mémoire',  PINK,     D_PINK),
        ('Tes enfants',  'Empathie · vocabulaire · habitude', LAVENDER, D_LAV),
        ('Les élèves',   'Concentration · esprit critique', MINT,     D_MINT),
        ('Ton partenaire', 'Meilleur sommeil · sérénité',   SKY_BLUE, (60, 100, 180, 255)),
        ('Ton ami/e',    'Il faut juste un coup de pouce',  GOLD,     (160, 120, 0, 255)),
    ],
    'it': [
        ('Tu',            '68% meno stress · memoria',      PINK,     D_PINK),
        ('I tuoi figli',  'Empatia · vocabolario · abitudine', LAVENDER, D_LAV),
        ('Gli studenti',  'Concentrazione · pensiero critico', MINT,   D_MINT),
        ('Il partner',    'Sonno migliore · mattine serene', SKY_BLUE, (60, 100, 180, 255)),
        ('L\'amico/a',    'Hanno solo bisogno di un impulso', GOLD,   (160, 120, 0, 255)),
    ],
}

_CTA = {
    'en': '@myreadingvillage',
    'es': '@myreadingvillage',
    'pt': '@myreadingvillage',
    'fr': '@myreadingvillage',
    'it': '@myreadingvillage',
}


def run(lang='en', bg=3):
    header = _HEADER.get(lang, _HEADER['en'])
    rows   = _ROWS.get(lang, _ROWS['en'])
    cta    = _CTA.get(lang, _CTA['en'])

    canvas = Image.new('RGBA', (W, H), (0, 0, 0, 255))

    bg_img = load_bg(f'images/backgrounds/splash_bg_{bg}.png', zoom=1.06, pan_y=0.40)
    bg_img = bg_img.filter(ImageFilter.GaussianBlur(7))
    canvas.alpha_composite(bg_img)
    color_ov(canvas, LAVENDER, 0.10)
    color_ov(canvas, (8, 4, 18), 0.52)

    pl = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw_particles(pl, 5.0, 0.45)
    canvas.alpha_composite(pl)

    draw_sparkles(canvas, 3.0, [
        (W * 0.12, H * 0.08, 26, 10, GOLD),
        (W * 0.88, H * 0.07, 20,  8, LAVENDER),
        (W * 0.08, H * 0.30, 14,  5, PINK),
        (W * 0.92, H * 0.28, 16,  6, MINT),
        (W * 0.10, H * 0.86, 18,  7, GOLD),
        (W * 0.90, H * 0.84, 12,  4, SKY_BLUE),
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

    pill_w = min(920, len(header) * 30 + 100)
    solid_pill(canvas, (W - pill_w) // 2, _pill_top,
               (W + pill_w) // 2, _pill_top + _pill_h, r=34,
               fill=(*D_LAV[:3], 210))
    txt_c(d, header.upper(), W * 0.5, _pill_cy,
          F(FONT_XB, 42), (*WHITE[:3], 255))

    _row_h  = 118
    _v_pad  = 36
    card_h  = _v_pad + len(rows) * _row_h + _v_pad
    cx0 = (W - 920) // 2
    cy0 = _card_top
    glass_card(canvas, cx0, cy0, cx0 + 920, cy0 + card_h, r=40,
               tint=LAVENDER, ta=0.25, blur=18, border=D_LAV)

    for i, (label, benefit, tint, accent) in enumerate(rows):
        ry = cy0 + _v_pad + i * _row_h + _row_h // 2

        badge_w = max(200, len(label) * 22 + 40)
        bx0 = cx0 + 30
        solid_pill(canvas, bx0, ry - 30, bx0 + badge_w, ry + 30, r=30,
                   fill=(*accent[:3], 210))
        txt_c(d, label, bx0 + badge_w // 2, ry,
              F(FONT_B, 38), (*WHITE[:3], 255))

        txt_x = bx0 + badge_w + 22
        txt_c(d, benefit, (txt_x + cx0 + 890) // 2, ry,
              F(FONT_R, 36), (*CREAM[:3], 220), shadow=(0, 0, 0), sd=2)

        if i < len(rows) - 1:
            sep_y = cy0 + _v_pad + (i + 1) * _row_h
            ImageDraw.Draw(canvas).line(
                [(cx0 + 40, sep_y), (cx0 + 880, sep_y)],
                fill=(*WHITE[:3], 30), width=1)

    card_bottom = cy0 + card_h
    villager_y  = int(card_bottom + (H * 0.870 - card_bottom) * 0.40)
    rabbit = load_img('images/villagers/rabbit/rabbit_villager.png', w=380)
    paste_c(canvas, rabbit, W * 0.5, villager_y)

    glass_card(canvas, (W - 660) // 2, int(H * 0.870),
               (W + 660) // 2, int(H * 0.870) + 80, r=40,
               tint=PINK, ta=0.28, blur=12, border=D_PINK)
    txt_c(d, cta, W * 0.5, H * 0.870 + 40,
          F(FONT_R, 52), (*WHITE[:3], 255), shadow=(180, 180, 220), sd=3)

    out = os.path.join(_OUT, f'who_should_read_{lang}.png')
    canvas.convert('RGB').save(out)
    print(f'Saved: {out}')


def main():
    run()


if __name__ == '__main__':
    main()
