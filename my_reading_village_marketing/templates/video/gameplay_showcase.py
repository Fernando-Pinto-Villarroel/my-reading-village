#!/usr/bin/env python3
"""
My Reading Village — Gameplay Showcase
~15 s vertical video (9:16): village building showcase + villager parade + CTA.
Usage: .venv/bin/python3 templates/video/gameplay_showcase.py [--lang en]
"""
import sys, os, math
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))
from PIL import Image, ImageDraw, ImageFilter
from utils import *
import assets as _assets

_OUT      = _assets.OUTPUT_DIR
_DURATION = 15.0
os.makedirs(_OUT, exist_ok=True)

_HOOK = {
    'en': ('Build your', 'Reading Village!'),
    'es': ('¡Construye tu', 'Pueblo Lector!'),
    'pt': ('Construa sua', 'Vila Leitora!'),
    'fr': ('Construis ton', 'Village Lecteur !'),
    'it': ('Costruisci il tuo', 'Villaggio Lettore!'),
}
_BUILD_LABEL = {
    'en': 'Build & upgrade', 'es': 'Construye y mejora',
    'pt': 'Construa e melhore', 'fr': 'Construis et améliore',
    'it': 'Costruisci e migliora',
}
_VILLAGER_LABEL = {
    'en': 'Collect all 41 villagers', 'es': 'Colecciona los 41 aldeanos',
    'pt': 'Colecione todos os 41 aldeões', 'fr': 'Collecte les 41 villageois',
    'it': 'Colleziona tutti i 41 abitanti',
}
_DL = {
    'en': ('Download it', 'FOR FREE!'),
    'es': ('¡Descárgalo', 'GRATIS!'),
    'pt': ('Baixe', 'GRÁTIS!'),
    'fr': ('Télécharge', 'GRATUIT!'),
    'it': ('Scaricalo', 'GRATIS!'),
}
_SOON = {
    'en': 'Coming soon to the Play Store! 🌸 📚',
    'es': '¡Próximamente en la Play Store! 🌸 📚',
    'pt': 'Em breve na Play Store! 🌸 📚',
    'fr': 'Bientôt sur le Play Store ! 🌸 📚',
    'it': 'Prossimamente nel Play Store! 🌸 📚',
}

_LANG = 'en'

_BUILDINGS = [
    ('images/buildings/library.png',     'Library'),
    ('images/buildings/school.png',      'School'),
    ('images/buildings/park.png',        'Park'),
    ('images/buildings/house.png',       'House'),
    ('images/buildings/hospital.png',    'Hospital'),
    ('images/buildings/restaurant.png',  'Restaurant'),
]
_VILLAGER_SHOWCASE = ['cat', 'rabbit', 'fox', 'panda_bear', 'koala', 'hedgehog']


def preload_lang(lang):
    global _LANG
    _LANG = lang


def scene_hook(canvas, t, a):
    zoom = lerp(1.10, 1.00, eoc(remap(t, 0.0, 3.5)))
    canvas.alpha_composite(load_bg('images/backgrounds/splash_bg_1.png',
                                   zoom=zoom, pan_y=0.38))
    color_ov(canvas, (12, 6, 22), 0.58 * a)

    pl = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw_particles(pl, t, 0.65 * a)
    canvas.alpha_composite(pl)

    draw_sparkles(canvas, t, [
        (W * 0.18, H * 0.12, 24, 9, GOLD),
        (W * 0.82, H * 0.10, 20, 8, LAVENDER),
        (W * 0.10, H * 0.30, 14, 5, MINT),
        (W * 0.90, H * 0.28, 16, 6, PINK),
    ], a)

    lt = eob(clamp(remap(t, 0.1, 1.0)))
    if lt > 0:
        logo = load_img('images/logos/my_reading_village_icon_rounded.png', w=230)
        paste_c(canvas, logo, W * 0.5, H * 0.24, scale=lt, alpha=lt * a)

    d = ImageDraw.Draw(canvas)
    l1, l2 = _HOOK.get(_LANG, _HOOK['en'])

    t1 = eoc(clamp(remap(t, 0.7, 1.5)))
    if t1 > 0:
        txt_c(d, l1, W * 0.5, H * 0.445 + (1 - t1) * 50,
              F(FONT_SB, 72), (*CREAM[:3], int(240 * t1 * a)), shadow=(0, 0, 0))
    t2 = eob(clamp(remap(t, 1.1, 2.0)))
    if t2 > 0:
        txt_c(d, l2, W * 0.5, H * 0.540 + (1 - t2) * 50,
              F(FONT_XB, 86), (*WHITE[:3], int(255 * t2 * a)),
              stroke_fill=(0, 0, 0), stroke_width=5)


def scene_buildings(canvas, t, a):
    bg = load_bg('images/backgrounds/splash_bg_2.png', zoom=1.05, pan_y=0.45)
    bg = bg.filter(ImageFilter.GaussianBlur(6))
    canvas.alpha_composite(bg)
    color_ov(canvas, MINT, 0.12 * a)
    color_ov(canvas, (8, 4, 16), 0.42 * a)

    pl = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw_particles(pl, t, 0.40 * a)
    canvas.alpha_composite(pl)

    d = ImageDraw.Draw(canvas)
    ht = eoc(clamp(remap(t, 3.1, 3.8)))
    if ht > 0:
        lbl = _BUILD_LABEL.get(_LANG, _BUILD_LABEL['en'])
        txt_c(d, lbl, W * 0.5, H * 0.095 - (1 - ht) * 40,
              F(FONT_XB, 66), (*WHITE[:3], int(255 * ht * a)),
              stroke_fill=(0, 0, 0), stroke_width=4)

    cols, rows = 2, 3
    bw, bh = 380, 340
    gap_x, gap_y = 60, 40
    grid_w = cols * bw + (cols - 1) * gap_x
    grid_h = rows * bh + (rows - 1) * gap_y
    ox = (W - grid_w) // 2
    oy = int(H * 0.160)

    for idx, (bpath, bname) in enumerate(_BUILDINGS[:6]):
        col, row = idx % cols, idx // cols
        ct  = eob(clamp(remap(t, 3.3 + idx * 0.18, 3.3 + idx * 0.18 + 0.7)))
        if ct <= 0:
            continue
        ca  = min(ct, 1.0) * a
        x0  = ox + col * (bw + gap_x)
        y0  = oy + row * (bh + gap_y)

        glass_card(canvas, x0, y0, x0 + bw, y0 + bh, r=24,
                   tint=MINT, ta=0.26, blur=12, border=D_MINT)
        try:
            bi = load_img(bpath, w=220)
            paste_c(canvas, bi, x0 + bw // 2, y0 + bh // 2 - 20,
                    scale=ct, alpha=ca)
        except Exception:
            pass
        txt_c(ImageDraw.Draw(canvas), bname,
              x0 + bw // 2, y0 + bh - 38,
              F(FONT_B, 32), (*WHITE[:3], int(220 * ca)))


def scene_villagers(canvas, t, a):
    bg = load_bg('images/backgrounds/splash_bg_3.png', zoom=1.04, pan_y=0.40)
    bg = bg.filter(ImageFilter.GaussianBlur(5))
    canvas.alpha_composite(bg)
    color_ov(canvas, LAVENDER, 0.14 * a)
    color_ov(canvas, (8, 4, 18), 0.44 * a)

    pl = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw_particles(pl, t, 0.42 * a)
    canvas.alpha_composite(pl)

    d = ImageDraw.Draw(canvas)
    ht = eoc(clamp(remap(t, 7.1, 7.8)))
    if ht > 0:
        lbl = _VILLAGER_LABEL.get(_LANG, _VILLAGER_LABEL['en'])
        txt_c(d, lbl, W * 0.5, H * 0.095 - (1 - ht) * 40,
              F(FONT_XB, 58), (*WHITE[:3], int(255 * ht * a)),
              stroke_fill=(0, 0, 0), stroke_width=4)

    cols, rows = 2, 3
    vw, vh = 340, 380
    gap_x, gap_y = 80, 30
    grid_w = cols * vw + (cols - 1) * gap_x
    ox  = (W - grid_w) // 2
    oy  = int(H * 0.155)

    for idx, vname in enumerate(_VILLAGER_SHOWCASE):
        col, row = idx % cols, idx // cols
        ct  = eob(clamp(remap(t, 7.3 + idx * 0.20, 7.3 + idx * 0.20 + 0.75)))
        if ct <= 0:
            continue
        ca  = min(ct, 1.0) * a
        _, tint, accent = SPECIES.get(vname, ('common', MINT, D_MINT))
        x0  = ox + col * (vw + gap_x)
        y0  = oy + row * (vh + gap_y)

        glass_card(canvas, x0, y0, x0 + vw, y0 + vh, r=28,
                   tint=tint, ta=0.28, blur=12, border=accent)
        try:
            vi = load_img(f'images/villagers/{vname}/{vname}_villager.png', w=220)
            paste_c(canvas, vi, x0 + vw // 2, y0 + vh // 2 - 10,
                    scale=ct, alpha=ca)
        except Exception:
            pass
        vn_text = species_name(vname, _LANG)
        txt_c(ImageDraw.Draw(canvas), vn_text,
              x0 + vw // 2, y0 + vh - 36,
              F(FONT_B, 30), (*WHITE[:3], int(220 * ca)))


def scene_cta(canvas, t, a):
    from utils import gradient_img as _grad
    bg = _grad([PINK, LAVENDER, MINT])
    canvas.alpha_composite(bg)
    color_ov(canvas, (255, 255, 255), 0.06 * a)

    pl = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw_particles(pl, t, a)
    canvas.alpha_composite(pl)

    draw_sparkles(canvas, t, [
        (W * 0.14, H * 0.06, 28, 11, GOLD),
        (W * 0.86, H * 0.06, 22,  9, WHITE),
        (W * 0.07, H * 0.93, 18,  7, LAVENDER),
        (W * 0.93, H * 0.93, 20,  8, MINT),
    ], a)

    la = eoc(clamp(remap(t, 11.0, 11.6)))
    if la > 0:
        lo = load_img('images/logos/my_reading_village_icon_rounded.png', w=280)
        paste_c(canvas, lo, W * 0.5, H * 0.200, scale=la, alpha=la * a)

    d  = ImageDraw.Draw(canvas)
    dt = eob(clamp(remap(t, 11.3, 11.9)))
    if dt > 0:
        yo  = (1 - dt) * 55
        dl1, dl2 = _DL.get(_LANG, _DL['en'])
        txt_c(d, dl1, W * 0.5, H * 0.360 + yo,
              F(FONT_XB, 96), (*WHITE[:3], int(255 * dt * a)),
              shadow=(100, 50, 80), sd=6)
        txt_c(d, dl2, W * 0.5, H * 0.455 + yo,
              F(FONT_XB, 108), (*GOLD[:3], int(255 * dt * a)),
              shadow=(100, 80, 0), sd=7)

    bt = eoc(clamp(remap(t, 11.6, 12.1)))
    if bt > 0:
        txt_emoji(canvas, _SOON.get(_LANG, _SOON['en']),
                  W * 0.5, H * 0.585, 44, DARK_TEXT, bt * a)

    st = eoc(clamp(remap(t, 11.9, 12.4)))
    if st > 0:
        txt_c(d, '@myreadingvillage', W * 0.5, H * 0.690,
              F(FONT_SB, 48), (*D_LAV[:3], int(255 * st * a)),
              shadow=(220, 220, 240), sd=3)


_TIMELINE = [
    ( 0.0,  4.0, scene_hook),
    ( 3.5,  8.5, scene_buildings),
    ( 8.0, 12.0, scene_villagers),
    (11.5, 15.0, scene_cta),
]


def run(lang='en', **_):
    preload_lang(lang)
    mf  = make_video_frame(_TIMELINE, _DURATION)
    out = os.path.join(_OUT, f'gameplay_showcase_{lang}.mp4')
    print(f'Rendering gameplay showcase ({lang})…')
    render_video(mf, _DURATION, out,
                 _assets.asset('audios/my-reading-village-main.wav'))


def main():
    run()


if __name__ == '__main__':
    main()
