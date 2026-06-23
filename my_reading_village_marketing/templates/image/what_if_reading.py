#!/usr/bin/env python3
"""
My Reading Village — What if Reading Was a Game?
Static 1080x1920: aspirational "What if" questions revealing the app.
Usage: .venv/bin/python3 templates/image/what_if_reading.py [--lang en]
"""
import sys, os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))
from PIL import Image, ImageDraw, ImageFilter
from utils import *
import assets as _assets

_OUT = _assets.OUTPUT_DIR
os.makedirs(_OUT, exist_ok=True)

_HEADER = {
    'en': 'What if...',
    'es': '¿Y si...',
    'pt': 'E se...',
    'fr': 'Et si...',
    'it': 'E se...',
}

_QUESTIONS = {
    'en': [
        'Finishing a book\nunlocked a new villager?',
        'Reading 10 pages\ngave you gems to build?',
        'Your streak\nbuilt a real world?',
        'The habit finally\nfelt like a reward?',
    ],
    'es': [
        '¿Terminar un libro\ndesbloquease un aldeano?',
        '¿Leer 10 páginas\nte diera gemas para construir?',
        '¿Tu racha\nconstruyera un mundo real?',
        '¿El hábito por fin\nse sintiera como recompensa?',
    ],
    'pt': [
        'Terminar um livro\ndesbloqueasse um aldeão?',
        'Ler 10 páginas\nte desse gemas para construir?',
        'Sua sequência\nconstruísse um mundo real?',
        'O hábito finalmente\nparecesse uma recompensa?',
    ],
    'fr': [
        'Finir un livre\ndéverrouillait un villageois ?',
        'Lire 10 pages\nte donnait des gemmes ?',
        'Ton streak\nconstruisait un vrai monde ?',
        'L\'habitude te semblait\nenfin une récompense ?',
    ],
    'it': [
        'Finire un libro\nsblocasse un abitante ?',
        'Leggere 10 pagine\nti desse gemme per costruire ?',
        'La tua serie\ncostruisse un mondo reale ?',
        'L\'abitudine finalmente\nsembrasse una ricompensa ?',
    ],
}

_ANSWER = {
    'en': 'That\'s My Reading Village.',
    'es': 'Eso es My Reading Village.',
    'pt': 'Isso é My Reading Village.',
    'fr': 'C\'est My Reading Village.',
    'it': 'Questo è My Reading Village.',
}

_SOON = {
    'en': 'Coming soon · FREE',
    'es': 'Próximamente · GRATIS',
    'pt': 'Em breve · GRÁTIS',
    'fr': 'Bientôt · GRATUIT',
    'it': 'Prossimamente · GRATIS',
}

_CTA = {
    'en': '@myreadingvillage',
    'es': '@myreadingvillage',
    'pt': '@myreadingvillage',
    'fr': '@myreadingvillage',
    'it': '@myreadingvillage',
}

_TINTS = [PINK, LAVENDER, MINT, SKY_BLUE]
_ACCENTS = [D_PINK, D_LAV, D_MINT, (60, 100, 180, 255)]


def run(lang='en', bg=4):
    header    = _HEADER.get(lang, _HEADER['en'])
    questions = _QUESTIONS.get(lang, _QUESTIONS['en'])
    answer    = _ANSWER.get(lang, _ANSWER['en'])
    soon      = _SOON.get(lang, _SOON['en'])
    cta       = _CTA.get(lang, _CTA['en'])

    canvas = Image.new('RGBA', (W, H), (0, 0, 0, 255))

    bg_img = load_bg(f'images/backgrounds/splash_bg_{bg}.png', zoom=1.06, pan_y=0.40)
    bg_img = bg_img.filter(ImageFilter.GaussianBlur(7))
    canvas.alpha_composite(bg_img)
    color_ov(canvas, LAVENDER, 0.08)
    color_ov(canvas, (8, 4, 18), 0.54)

    pl = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw_particles(pl, 5.0, 0.45)
    canvas.alpha_composite(pl)

    draw_sparkles(canvas, 3.0, [
        (W * 0.12, H * 0.08, 30, 12, GOLD),
        (W * 0.88, H * 0.07, 24, 10, LAVENDER),
        (W * 0.08, H * 0.30, 16,  6, PINK),
        (W * 0.92, H * 0.28, 18,  7, MINT),
        (W * 0.10, H * 0.84, 20,  8, GOLD),
        (W * 0.90, H * 0.82, 14,  5, SKY_BLUE),
    ], 0.88)

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

    solid_pill(canvas, (W - 400) // 2, _pill_top,
               (W + 400) // 2, _pill_top + _pill_h, r=34,
               fill=(*D_LAV[:3], 210))
    txt_c(d, header.upper(), W * 0.5, _pill_cy,
          F(FONT_XB, 46), (*GOLD[:3], 255))

    _q_h  = 172
    _v_pad = 30
    card_h = _v_pad + len(questions) * _q_h + _v_pad
    cx0 = (W - 920) // 2
    cy0 = _card_top
    glass_card(canvas, cx0, cy0, cx0 + 920, cy0 + card_h, r=40,
               tint=LAVENDER, ta=0.25, blur=18, border=D_LAV)

    for i, q in enumerate(questions):
        qy0 = cy0 + _v_pad + i * _q_h
        qy1 = qy0 + _q_h - 10
        tint   = _TINTS[i % len(_TINTS)]
        accent = _ACCENTS[i % len(_ACCENTS)]
        glass_card(canvas, cx0 + 20, qy0, cx0 + 900, qy1, r=24,
                   tint=tint, ta=0.22, blur=10, border=accent)
        solid_pill(canvas, cx0 + 28, qy0 + 8, cx0 + 28 + 54, qy0 + 8 + 54, r=27,
                   fill=(*accent[:3], 200))
        txt_c(d, str(i + 1), cx0 + 28 + 27, qy0 + 8 + 27,
              F(FONT_XB, 30), (*WHITE[:3], 255))
        qlines = q.split('\n')
        for li, ql in enumerate(qlines):
            txt_c(d, ql, cx0 + 500, qy0 + 26 + li * 52,
                  F(FONT_SB, 46), (*CREAM[:3], 235), shadow=(0, 0, 0), sd=2)

    card_bottom = cy0 + card_h
    ans_y = card_bottom + 56
    txt_c(d, answer, W * 0.5, ans_y,
          F(FONT_XB, 60), (*GOLD[:3], 255), shadow=(60, 40, 0), sd=5)

    fox = load_img('images/villagers/fox/fox_villager.png', w=340)
    fox_y = int(ans_y + 70 + 170)
    paste_c(canvas, fox, W * 0.5, fox_y)

    soon_y = fox_y + 180
    txt_c(d, soon, W * 0.5, soon_y,
          F(FONT_SB, 48), (*CREAM[:3], 220), shadow=(0, 0, 0), sd=3)

    glass_card(canvas, (W - 660) // 2, int(H * 0.920),
               (W + 660) // 2, int(H * 0.920) + 72, r=36,
               tint=MINT, ta=0.28, blur=12, border=D_MINT)
    txt_c(d, cta, W * 0.5, H * 0.920 + 36,
          F(FONT_R, 48), (*WHITE[:3], 255), shadow=(180, 220, 200), sd=3)

    out = os.path.join(_OUT, f'what_if_reading_{lang}.png')
    canvas.convert('RGB').save(out)
    print(f'Saved: {out}')


def main():
    run()


if __name__ == '__main__':
    main()
