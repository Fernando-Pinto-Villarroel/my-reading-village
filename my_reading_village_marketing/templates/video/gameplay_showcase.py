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
_DURATION = 16.5
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
_SPOILER = {
    'en': "Here's a spoiler on how your village works",
    'es': 'Aquí un adelanto de cómo funciona tu pueblo',
    'pt': 'Um spoiler de como sua vila funciona',
    'fr': 'Un spoiler sur le fonctionnement de ton village',
    'it': 'Ecco un anticipazione su come funziona il tuo villaggio',
}
_AND_MORE = {
    'en': 'And many more!!',
    'es': '¡Y muchos más!!',
    'pt': 'E muito mais!!',
    'fr': 'Et bien plus encore !!',
    'it': 'E molti altri!!',
}

_LANG = 'en'
_BGS  = [1, 2, 3]

_BUILDINGS = [
    ('images/buildings/library.png',      'Library'),
    ('images/buildings/school.png',       'School'),
    ('images/buildings/park.png',         'Park'),
    ('images/buildings/house.png',        'House'),
    ('images/buildings/hospital.png',     'Hospital'),
    ('images/buildings/restaurant.png',   'Restaurant'),
    ('images/buildings/water_plant.png',  'Water Plant'),
    ('images/buildings/power_plant.png',  'Power Plant'),
]
_VILLAGER_SHOWCASE = [
    'cat',       'rabbit',    # Common
    'panda_bear', 'hedgehog', # Rare
    'kangaroo',  'bat',       # Extraordinary
    'fox',       'lion',      # Godly
]


def preload_lang(lang, bg=1):
    global _LANG, _BGS
    _LANG = lang
    _BGS  = [((bg - 1 + i) % 6) + 1 for i in range(3)]


def scene_hook(canvas, t, a):
    zoom = lerp(1.10, 1.00, eoc(remap(t, 0.0, 3.5)))
    canvas.alpha_composite(load_bg(f'images/backgrounds/splash_bg_{_BGS[2]}.png',
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
        paste_c(canvas, logo, W * 0.5, H * 0.20, scale=lt, alpha=lt * a)

    d = ImageDraw.Draw(canvas)
    l1, l2 = _HOOK.get(_LANG, _HOOK['en'])

    t1 = eoc(clamp(remap(t, 0.7, 1.5)))
    if t1 > 0:
        txt_c(d, l1, W * 0.5, H * 0.420 + (1 - t1) * 50,
              F(FONT_SB, 88), (*CREAM[:3], int(240 * t1 * a)), shadow=(0, 0, 0))
    t2 = eob(clamp(remap(t, 1.1, 2.0)))
    if t2 > 0:
        txt_c(d, l2, W * 0.5, H * 0.500 + (1 - t2) * 50,
              F(FONT_XB, 104), (*WHITE[:3], int(255 * t2 * a)),
              stroke_fill=(0, 0, 0), stroke_width=5)

    t3 = eoc(clamp(remap(t, 2.0, 2.8)))
    if t3 > 0:
        sp = _SPOILER.get(_LANG, _SPOILER['en'])
        txt_c(d, sp, W * 0.5, H * 0.600 + (1 - t3) * 35,
              F(FONT_SB, 48), (*CREAM[:3], int(210 * t3 * a)), shadow=(0, 0, 0), sd=3)

    t4 = eoc(clamp(remap(t, 2.4, 3.1)))
    if t4 > 0:
        _pw, _ph = 640, 72
        _py = int(H * 0.880) - _ph // 2
        solid_pill(canvas, (W - _pw) // 2, _py, (W + _pw) // 2, _py + _ph, r=36,
                   fill=(*D_LAV[:3], int(215 * t4 * a)))
        txt_c(ImageDraw.Draw(canvas), '@myreadingvillage', W * 0.5, H * 0.880,
              F(FONT_SB, 46), (*WHITE[:3], int(255 * t4 * a)))


def scene_buildings(canvas, t, a):
    bg = load_bg(f'images/backgrounds/splash_bg_{_BGS[1]}.png', zoom=1.05, pan_y=0.45)
    bg = bg.filter(ImageFilter.GaussianBlur(6))
    canvas.alpha_composite(bg)
    color_ov(canvas, MINT, 0.12 * a)
    color_ov(canvas, (8, 4, 16), 0.42 * a)

    pl = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw_particles(pl, t, 0.40 * a)
    canvas.alpha_composite(pl)

    d = ImageDraw.Draw(canvas)
    ht = eoc(clamp(remap(t, 4.6, 5.3)))
    if ht > 0:
        lbl = _BUILD_LABEL.get(_LANG, _BUILD_LABEL['en'])
        txt_c(d, lbl, W * 0.5, H * 0.082 - (1 - ht) * 40,
              F(FONT_XB, 76), (*WHITE[:3], int(255 * ht * a)),
              stroke_fill=(0, 0, 0), stroke_width=4)

    cols, rows = 2, 4
    bw, bh = 480, 385
    gap_x, gap_y = 50, 20
    grid_w = cols * bw + (cols - 1) * gap_x
    ox = (W - grid_w) // 2
    oy = int(H * 0.122)

    for idx, (bpath, bname) in enumerate(_BUILDINGS):
        col, row = idx % cols, idx // cols
        ct  = eob(clamp(remap(t, 4.8 + idx * 0.16, 4.8 + idx * 0.16 + 0.65)))
        if ct <= 0:
            continue
        ca  = min(ct, 1.0) * a
        x0  = ox + col * (bw + gap_x)
        y0  = oy + row * (bh + gap_y)

        glass_card(canvas, x0, y0, x0 + bw, y0 + bh, r=24,
                   tint=MINT, ta=0.26, blur=12, border=D_MINT)
        try:
            bi = load_img(bpath, w=265)
            paste_c(canvas, bi, x0 + bw // 2, y0 + bh // 2 - 20,
                    scale=ct, alpha=ca)
        except Exception:
            pass
        txt_c(ImageDraw.Draw(canvas), bname,
              x0 + bw // 2, y0 + bh - 43,
              F(FONT_B, 41), (*WHITE[:3], int(220 * ca)))


_GODLY_TINT   = (255, 130, 130, 255)
_GODLY_BORDER = (210, 70,  70,  255)


def scene_villagers(canvas, t, a):
    bg = load_bg(f'images/backgrounds/splash_bg_{_BGS[0]}.png', zoom=1.04, pan_y=0.40)
    bg = bg.filter(ImageFilter.GaussianBlur(5))
    canvas.alpha_composite(bg)
    color_ov(canvas, LAVENDER, 0.14 * a)
    color_ov(canvas, (8, 4, 18), 0.44 * a)

    pl = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw_particles(pl, t, 0.42 * a)
    canvas.alpha_composite(pl)

    d = ImageDraw.Draw(canvas)
    ht = eoc(clamp(remap(t, 8.6, 9.3)))
    if ht > 0:
        lbl = _VILLAGER_LABEL.get(_LANG, _VILLAGER_LABEL['en'])
        txt_c(d, lbl, W * 0.5, H * 0.082 - (1 - ht) * 40,
              F(FONT_XB, 68), (*WHITE[:3], int(255 * ht * a)),
              stroke_fill=(0, 0, 0), stroke_width=4)

    cols, rows = 2, 4
    vw, vh    = 400, 350
    gap_x, gap_y = 55, 28
    _IMG_W    = 210
    _IMG_MAX_H = vh - 115
    grid_w = cols * vw + (cols - 1) * gap_x
    ox  = (W - grid_w) // 2
    oy  = int(H * 0.120)

    for idx, vname in enumerate(_VILLAGER_SHOWCASE):
        col, row = idx % cols, idx // cols
        ct  = eob(clamp(remap(t, 8.8 + idx * 0.18, 8.8 + idx * 0.18 + 0.70)))
        if ct <= 0:
            continue
        ca  = min(ct, 1.0) * a
        rarity, tint, accent = SPECIES.get(vname, ('common', MINT, D_MINT))
        if rarity == 'godly':
            tint, accent = _GODLY_TINT, _GODLY_BORDER
        x0  = ox + col * (vw + gap_x)
        y0  = oy + row * (vh + gap_y)

        glass_card(canvas, x0, y0, x0 + vw, y0 + vh, r=28,
                   tint=tint, ta=0.30, blur=12, border=accent)
        try:
            vi_ref = load_img(f'images/villagers/{vname}/{vname}_villager.png', w=_IMG_W)
            if vi_ref.height > _IMG_MAX_H:
                cw = max(1, int(_IMG_W * _IMG_MAX_H / vi_ref.height))
                vi = load_img(f'images/villagers/{vname}/{vname}_villager.png', w=cw)
            else:
                vi = vi_ref
            img_cy = y0 + _IMG_MAX_H // 2 + 12
            paste_c(canvas, vi, x0 + vw // 2, img_cy, scale=ct, alpha=ca)
        except Exception:
            pass
        vn_text  = species_name(vname, _LANG)
        rar_raw  = RARITY_LABEL.get(_LANG, RARITY_LABEL['en']).get(rarity, rarity.title())
        rar_text = f'({rar_raw})'
        d_card = ImageDraw.Draw(canvas)
        txt_c(d_card, vn_text,
              x0 + vw // 2, y0 + vh - 62,
              F(FONT_B, 37), (*WHITE[:3], int(225 * ca)),
              shadow=(0, 0, 0), sd=3)
        txt_c(d_card, rar_text,
              x0 + vw // 2, y0 + vh - 28,
              F(FONT_SB, 30), (*WHITE[:3], int(210 * ca)),
              shadow=(0, 0, 0), sd=2)

    mm_t = eoc(clamp(remap(t, 10.8, 11.4)))
    if mm_t > 0:
        grid_bottom = oy + rows * vh + (rows - 1) * gap_y
        mm_lbl = _AND_MORE.get(_LANG, _AND_MORE['en'])
        txt_c(d, mm_lbl, W * 0.5, grid_bottom + 76,
              F(FONT_XB, 52), (*GOLD[:3], int(245 * mm_t * a)),
              stroke_fill=(0, 0, 0), stroke_width=3)


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

    la = eoc(clamp(remap(t, 12.5, 13.1)))
    if la > 0:
        lo = load_img('images/logos/my_reading_village_icon_rounded.png', w=280)
        paste_c(canvas, lo, W * 0.5, H * 0.200, scale=la, alpha=la * a)

    d  = ImageDraw.Draw(canvas)
    dt = eob(clamp(remap(t, 12.8, 13.4)))
    if dt > 0:
        yo  = (1 - dt) * 55
        dl1, dl2 = _DL.get(_LANG, _DL['en'])
        txt_c(d, dl1, W * 0.5, H * 0.360 + yo,
              F(FONT_XB, 96), (*WHITE[:3], int(255 * dt * a)),
              shadow=(100, 50, 80), sd=6)
        txt_c(d, dl2, W * 0.5, H * 0.455 + yo,
              F(FONT_XB, 108), (*GOLD[:3], int(255 * dt * a)),
              shadow=(100, 80, 0), sd=7)

    bt = eoc(clamp(remap(t, 13.1, 13.6)))
    if bt > 0:
        txt_emoji(canvas, _SOON.get(_LANG, _SOON['en']),
                  W * 0.5, H * 0.585, 54, DARK_TEXT, bt * a)

    st = eoc(clamp(remap(t, 13.4, 13.9)))
    if st > 0:
        txt_c(d, '@myreadingvillage', W * 0.5, H * 0.700,
              F(FONT_SB, 58), (*D_LAV[:3], int(255 * st * a)),
              shadow=(220, 220, 240), sd=3)


_TIMELINE = [
    ( 0.0,  5.0, scene_hook),
    ( 5.0,  9.5, scene_buildings),
    ( 9.5, 13.0, scene_villagers),
    (13.0, 16.5, scene_cta),
]


def run(lang='en', bg=1):
    preload_lang(lang, bg)
    mf  = make_video_frame(_TIMELINE, _DURATION)
    out = os.path.join(_OUT, f'gameplay_showcase_{lang}.mp4')
    print(f'Rendering gameplay showcase ({lang})…')
    render_video(mf, _DURATION, out,
                 _assets.asset('audios/my-reading-village-main.wav'))


def main():
    run()


if __name__ == '__main__':
    main()
