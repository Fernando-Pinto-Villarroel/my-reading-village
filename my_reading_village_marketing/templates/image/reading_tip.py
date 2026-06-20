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

_TIP_SOURCES = {
    0:  'Scholastic Reading Report (2015)',
    1:  'Charles W. Eliot',
    2:  'Dr. Seuss, I Can Read With My Eyes Shut! (1978)',
    3:  'Kidd & Castano, Science (2013)',
    10: 'Univ. of Sussex, Dr. David Lewis (2009)',
}


def run(lang='en'):
    tips_path = _assets.asset(f'messages/{lang}/reading_tips.json')
    if not os.path.exists(tips_path):
        tips_path = _assets.asset('messages/en/reading_tips.json')
    tips       = json.load(open(tips_path))['tips']
    tip_index  = 0
    tip        = tips[tip_index]
    source     = _TIP_SOURCES.get(tip_index)

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

    _logo_size = 220
    _pill_h    = 68
    _gap       = 46
    _logo_cy   = int(H * 0.083)
    _pill_top  = _logo_cy + _logo_size // 2 + _gap
    _pill_cy   = _pill_top + _pill_h // 2
    _card_top  = _pill_top + _pill_h + _gap

    logo = load_img('images/logos/my_reading_village_icon_rounded.png', w=_logo_size)
    paste_c(canvas, logo, W * 0.5, _logo_cy)

    solid_pill(canvas, (W - 460) // 2, _pill_top,
               (W + 460) // 2, _pill_top + _pill_h, r=34,
               fill=(*D_PINK[:3], 210))
    txt_c(d, header.upper(), W * 0.5, _pill_cy,
          F(FONT_XB, 46), (*WHITE[:3], 255))

    _text_font   = 60
    _src_font    = 48
    _src_sep     = 68
    _v_pad       = 54

    lines        = textwrap.wrap(f'"{tip}"', width=26)
    content_h    = (len(lines) - 1) * 82 + _text_font + (_src_sep + _src_font if source else 0)
    card_h       = content_h + _v_pad * 2
    cy0          = _card_top
    glass_card(canvas, (W - 920) // 2, cy0,
               (W + 920) // 2, cy0 + card_h, r=40,
               tint=PINK, ta=0.25, blur=18, border=D_PINK)

    first_y = cy0 + _v_pad + _text_font // 2
    for i, line in enumerate(lines):
        txt_c(d, line, W * 0.5, first_y + i * 82,
              F(FONT_SB, _text_font), (*WHITE[:3], 245), shadow=(0, 0, 0), sd=3)

    if source:
        src_y = first_y + (len(lines) - 1) * 82 + _text_font // 2 + _src_sep + _src_font // 2
        txt_c(d, f'— {source}', W * 0.5, src_y,
              F(FONT_I, _src_font), (*WHITE[:3], 255), shadow=(0, 0, 0), sd=2)

    cat = load_img('images/villagers/cat/cat_villager.png', w=420)
    paste_c(canvas, cat, W * 0.5, int(H * 0.700))

    glass_card(canvas, (W - 660) // 2, int(H * 0.860),
               (W + 660) // 2, int(H * 0.860) + 80, r=40,
               tint=LAVENDER, ta=0.28, blur=12, border=D_LAV)
    txt_c(d, _CTA.get(lang, '@myreadingvillage'),
          W * 0.5, H * 0.860 + 40,
          F(FONT_R, 52), (*WHITE[:3], 255), shadow=(180, 180, 220), sd=3)

    out = os.path.join(_OUT, f'reading_tip_{lang}.png')
    canvas.convert('RGB').save(out)
    print(f'Saved: {out}')


def main():
    run()


if __name__ == '__main__':
    main()
