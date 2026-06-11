#!/usr/bin/env python3
"""
My Reading Village — Benefits of Reading Story
~20 s vertical story (9:16). Supports all 5 app languages.
Usage: .venv/bin/python3 templates/video/reading_benefits_story.py [--lang en]
"""
import sys, os, math
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))
import numpy as np
from PIL import Image, ImageDraw, ImageFilter
from utils import *
import assets as _assets

_OUT      = _assets.OUTPUT_DIR
DURATION  = 20.0
os.makedirs(_OUT, exist_ok=True)

_STRINGS = {
    'en': {
        'hook_intro':      'Did you know...',
        'hook_l2':         'reading just',
        'hook_l3':         '6 minutes',
        'hook_l4':         'reduces stress',
        'hook_l5':         'by  68%?',
        'benefits_title':  'The benefits of reading',
        'benefits_outro1': 'Reading transforms',
        'benefits_outro2': 'your life',
        'app_tagline':     'Read  ·  Build  ·  Grow',
        'app_cta':         'Make reading your superpower!',
        'cta_dl1':         'Download it',
        'cta_dl2':         'FOR FREE!',
        'cta_store':       'Coming soon to the Play Store! 🌸 📚',
        'cta_end':         'Your reading adventure starts here!',
        'cards': [
            {'num': '01', 'title': 'Reduces stress',
             'sub1': '68% in just 6 minutes', 'sub2': 'of daily reading',
             'tint': PINK, 'accent': D_PINK, 'start': 5.5},
            {'num': '02', 'title': 'Strengthens memory',
             'sub1': 'New neural connections', 'sub2': 'with every page',
             'tint': LAVENDER, 'accent': D_LAV, 'start': 7.8},
            {'num': '03', 'title': 'Expands your world',
             'sub1': 'Vocabulary, empathy', 'sub2': 'and critical thinking',
             'tint': MINT, 'accent': D_MINT, 'start': 10.2},
        ],
    },
    'es': {
        'hook_intro':      '¿Sabías que...',
        'hook_l2':         'leer solo',
        'hook_l3':         '6 minutos',
        'hook_l4':         'reduce el estrés',
        'hook_l5':         'un  68%?',
        'benefits_title':  'Los beneficios de leer',
        'benefits_outro1': 'Leer transforma',
        'benefits_outro2': 'tu vida',
        'app_tagline':     'Lee  ·  Construye  ·  Crece',
        'app_cta':         '¡Haz de la lectura tu superpoder!',
        'cta_dl1':         '¡Descárgalo',
        'cta_dl2':         'GRATIS!',
        'cta_store':       '¡Próximamente en la Play Store! 🌸 📚',
        'cta_end':         '¡Tu aventura lectora comienza aquí!',
        'cards': [
            {'num': '01', 'title': 'Reduce el estrés',
             'sub1': '68% en solo 6 minutos', 'sub2': 'de lectura diaria',
             'tint': PINK, 'accent': D_PINK, 'start': 5.5},
            {'num': '02', 'title': 'Fortalece la memoria',
             'sub1': 'Nuevas conexiones', 'sub2': 'neuronales cada página',
             'tint': LAVENDER, 'accent': D_LAV, 'start': 7.8},
            {'num': '03', 'title': 'Expande tu mundo',
             'sub1': 'Vocabulario, empatía', 'sub2': 'y pensamiento crítico',
             'tint': MINT, 'accent': D_MINT, 'start': 10.2},
        ],
    },
    'pt': {
        'hook_intro':      'Você sabia...',
        'hook_l2':         'ler apenas',
        'hook_l3':         '6 minutos',
        'hook_l4':         'reduz o estresse',
        'hook_l5':         'em  68%?',
        'benefits_title':  'Os benefícios da leitura',
        'benefits_outro1': 'Ler transforma',
        'benefits_outro2': 'sua vida',
        'app_tagline':     'Leia  ·  Construa  ·  Cresça',
        'app_cta':         'Faça da leitura seu superpoder!',
        'cta_dl1':         'Baixe',
        'cta_dl2':         'GRÁTIS!',
        'cta_store':       'Em breve na Play Store! 🌸 📚',
        'cta_end':         'Sua aventura de leitura começa aqui!',
        'cards': [
            {'num': '01', 'title': 'Reduz o estresse',
             'sub1': '68% em só 6 minutos', 'sub2': 'de leitura diária',
             'tint': PINK, 'accent': D_PINK, 'start': 5.5},
            {'num': '02', 'title': 'Fortalece a memória',
             'sub1': 'Novas conexões', 'sub2': 'neurais a cada página',
             'tint': LAVENDER, 'accent': D_LAV, 'start': 7.8},
            {'num': '03', 'title': 'Expande seu mundo',
             'sub1': 'Vocabulário, empatia', 'sub2': 'e pensamento crítico',
             'tint': MINT, 'accent': D_MINT, 'start': 10.2},
        ],
    },
    'fr': {
        'hook_intro':      'Le saviez-vous...',
        'hook_l2':         'lire seulement',
        'hook_l3':         '6 minutes',
        'hook_l4':         'réduit le stress',
        'hook_l5':         'de  68%?',
        'benefits_title':  'Les bienfaits de la lecture',
        'benefits_outro1': 'Lire transforme',
        'benefits_outro2': 'ta vie',
        'app_tagline':     'Lis  ·  Construis  ·  Grandis',
        'app_cta':         'Fais de la lecture ton superpouvoir!',
        'cta_dl1':         'Télécharge',
        'cta_dl2':         'GRATUIT!',
        'cta_store':       'Bientôt sur le Play Store ! 🌸 📚',
        'cta_end':         'Ton aventure lecture commence ici!',
        'cards': [
            {'num': '01', 'title': 'Réduit le stress',
             'sub1': '68% en 6 minutes', 'sub2': 'de lecture quotidienne',
             'tint': PINK, 'accent': D_PINK, 'start': 5.5},
            {'num': '02', 'title': 'Renforce la mémoire',
             'sub1': 'Nouvelles connexions', 'sub2': 'neuronales par page',
             'tint': LAVENDER, 'accent': D_LAV, 'start': 7.8},
            {'num': '03', 'title': 'Élargit ton univers',
             'sub1': 'Vocabulaire, empathie', 'sub2': 'et pensée critique',
             'tint': MINT, 'accent': D_MINT, 'start': 10.2},
        ],
    },
    'it': {
        'hook_intro':      'Lo sapevi...',
        'hook_l2':         'leggere solo',
        'hook_l3':         '6 minuti',
        'hook_l4':         'riduce lo stress',
        'hook_l5':         'del  68%?',
        'benefits_title':  'I benefici della lettura',
        'benefits_outro1': 'Leggere trasforma',
        'benefits_outro2': 'la tua vita',
        'app_tagline':     'Leggi  ·  Costruisci  ·  Cresci',
        'app_cta':         'Fai della lettura il tuo superpotere!',
        'cta_dl1':         'Scaricalo',
        'cta_dl2':         'GRATIS!',
        'cta_store':       'Prossimamente nel Play Store! 🌸 📚',
        'cta_end':         'La tua avventura di lettura inizia qui!',
        'cards': [
            {'num': '01', 'title': 'Riduce lo stress',
             'sub1': '68% in soli 6 minuti', 'sub2': 'di lettura quotidiana',
             'tint': PINK, 'accent': D_PINK, 'start': 5.5},
            {'num': '02', 'title': 'Rafforza la memoria',
             'sub1': 'Nuove connessioni', 'sub2': 'neurali ad ogni pagina',
             'tint': LAVENDER, 'accent': D_LAV, 'start': 7.8},
            {'num': '03', 'title': 'Espande il tuo mondo',
             'sub1': 'Vocabolario, empatia', 'sub2': 'e pensiero critico',
             'tint': MINT, 'accent': D_MINT, 'start': 10.2},
        ],
    },
}

_S:     dict = _STRINGS['en']
_CARDS: list = _S['cards']

_CW  = 780
_CH  = 205
_CX0 = (W - _CW) // 2
_CYS = [int(H * 0.285), int(H * 0.455), int(H * 0.625)]

CAT    = None
RABBIT = None
FOX    = None
LOGO   = None
BOOK_I = None


def setup(lang: str):
    global _S, _CARDS
    _S     = _STRINGS.get(lang, _STRINGS['en'])
    _CARDS = _S['cards']


def preload():
    global CAT, RABBIT, FOX, LOGO, BOOK_I
    CAT    = load_img('images/villagers/cat/cat_villager.png',    w=380)
    RABBIT = load_img('images/villagers/rabbit/rabbit_villager.png', w=310)
    FOX    = load_img('images/villagers/fox/fox_villager.png',    w=290)
    LOGO   = load_img('images/logos/my_reading_village_icon_rounded.png', w=350)
    BOOK_I = load_img('images/items/book_item.png', w=68)


def scene_hook(canvas, t, a):
    zoom = lerp(1.10, 1.00, eoc(remap(t, 0.0, 5.0)))
    canvas.alpha_composite(load_bg('images/backgrounds/splash_bg_1.png',
                                   zoom=zoom, pan_y=0.40))
    color_ov(canvas, (12, 6, 22), 0.55 * a)

    pl = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw_particles(pl, t, 0.80 * a)
    canvas.alpha_composite(pl)

    ct    = eob(clamp(remap(t, 1.0, 2.3)))
    cat_x = lerp(W + 220, W * 0.76, ct)
    cat_y = H * 0.81 + math.sin(t * 1.9) * 14
    if ct > 0:
        paste_c(canvas, CAT, cat_x, cat_y, alpha=min(ct, 1.0) * a)

    if t > 1.9:
        sa = clamp(remap(t, 1.9, 2.8)) * a
        draw_sparkles(canvas, t, [
            (W * 0.77, H * 0.655, 22, 8, GOLD),
            (W * 0.65, H * 0.680, 14, 5, PINK),
            (W * 0.88, H * 0.700, 16, 6, LAVENDER),
        ], sa)

    d = ImageDraw.Draw(canvas)

    t1 = eoc(clamp(remap(t, 0.15, 0.85)))
    if t1 > 0:
        txt_c(d, _S['hook_intro'], W * 0.5,
              H * 0.165 - (1 - t1) * 55,
              F(FONT_SB, 64), (*CREAM[:3], int(240 * t1 * a)),
              shadow=(0, 0, 0))

    t2 = eob(clamp(remap(t, 0.55, 1.30)))
    if t2 > 0:
        txt_c(d, _S['hook_l2'],
              W * 0.5, H * 0.268 + (1 - t2) * 70,
              F(FONT_XB, 106), (*WHITE[:3], int(255 * t2 * a)),
              shadow=(0, 0, 0), sd=6)

    t3 = eob(clamp(remap(t, 0.95, 1.70)))
    if t3 > 0:
        txt_c(d, _S['hook_l3'],
              W * 0.5, H * 0.352 + (1 - t3) * 70,
              F(FONT_XB, 118), (*GOLD[:3], int(255 * t3 * a)),
              shadow=(90, 55, 0), sd=7)

    t4 = eob(clamp(remap(t, 1.35, 2.10)))
    if t4 > 0:
        txt_c(d, _S['hook_l4'],
              W * 0.5, H * 0.440 + (1 - t4) * 70,
              F(FONT_XB, 90), (*WHITE[:3], int(255 * t4 * a)),
              shadow=(0, 0, 0), sd=5)

    t5 = eob(clamp(remap(t, 1.70, 2.50)))
    if t5 > 0:
        txt_c(d, _S['hook_l5'],
              W * 0.5, H * 0.535 + (1 - t5) * 70,
              F(FONT_XB, 136), (*D_PINK[:3], int(255 * t5 * a)),
              shadow=(80, 0, 20), sd=8)

    if t > 2.9:
        bt  = eoc(clamp(remap(t, 2.9, 3.6)))
        bw2 = int(480 * bt)
        bx  = (W - bw2) // 2
        by  = int(H * 0.593)
        tmp = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        ImageDraw.Draw(tmp).rounded_rectangle(
            [bx, by, bx + bw2, by + 8], radius=4,
            fill=(*D_PINK[:3], int(230 * a)))
        canvas.alpha_composite(tmp)

    if t > 3.2:
        sa = int(200 * eoc(clamp(remap(t, 3.2, 3.9))) * a)
        txt_c(d, '(University of Sussex, 2009)',
              W * 0.5, H * 0.632,
              F(FONT_R, 38), (*CREAM[:3], sa))


def scene_benefits(canvas, t, a):
    bgimg = load_bg('images/backgrounds/splash_bg_2.png', zoom=1.06, pan_y=0.45)
    bgimg = bgimg.filter(ImageFilter.GaussianBlur(7))
    canvas.alpha_composite(bgimg)
    color_ov(canvas, LAVENDER, 0.18 * a)
    color_ov(canvas, (8, 4, 18), 0.42 * a)

    pl = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw_particles(pl, t, 0.45 * a)
    canvas.alpha_composite(pl)

    d = ImageDraw.Draw(canvas)

    ht = eoc(clamp(remap(t, 5.00, 5.60)))
    if ht > 0:
        txt_c(d, _S['benefits_title'],
              W * 0.5, H * 0.18 - (1 - ht) * 50,
              F(FONT_XB, 70), (*WHITE[:3], int(255 * ht * a)),
              shadow=(0, 0, 0))
        for xf, c2 in ((0.38, PINK), (0.50, LAVENDER), (0.62, MINT)):
            ImageDraw.Draw(canvas).ellipse(
                [W * xf - 9, H * 0.232 - 9, W * xf + 9, H * 0.232 + 9],
                fill=(*c2, int(230 * ht * a)))

    for i, card in enumerate(_CARDS):
        ct      = eob(clamp(remap(t, card['start'], card['start'] + 0.65)))
        if ct <= 0:
            continue
        ca      = min(ct, 1.0) * a
        slide_x = int((1 - ct) * (W + _CW))
        cx0     = _CX0 + slide_x
        cx1     = cx0 + _CW
        cy0     = _CYS[i]
        cy1     = cy0 + _CH

        glass_card(canvas, cx0, cy0, cx1, cy1, r=30,
                   tint=card['tint'], ta=0.30, blur=15, border=card['accent'])
        solid_pill(canvas, cx0 + 16, cy0 + 18, cx0 + 28, cy1 - 18,
                   r=6, fill=(*card['accent'], int(240 * ca)))

        badge_cx = cx0 + 92
        badge_cy = cy0 + _CH // 2
        solid_pill(canvas,
                   badge_cx - 40, badge_cy - 34, badge_cx + 40, badge_cy + 34,
                   r=20, fill=(*card['accent'], int(220 * ca)))
        txt_c(ImageDraw.Draw(canvas), card['num'],
              badge_cx, badge_cy,
              F(FONT_XB, 36), (*WHITE[:3], int(255 * ca)))

        bi = BOOK_I.copy()
        if ca < 1.0:
            bi = set_alpha(bi, ca)
        canvas.paste(bi, (cx0 + 148, cy0 + (_CH - BOOK_I.height) // 2), bi)

        tx_cx = (cx0 + 250 + cx1) // 2
        txt_c(ImageDraw.Draw(canvas), card['title'],
              tx_cx, cy0 + 62,
              F(FONT_B, 52), (*WHITE[:3], int(255 * ca)),
              shadow=(60, 60, 80), sd=3)
        txt_c(ImageDraw.Draw(canvas), card['sub1'],
              tx_cx, cy0 + 116,
              F(FONT_R, 34), (*WHITE[:3], int(200 * ca)),
              shadow=(40, 40, 60), sd=2)
        txt_c(ImageDraw.Draw(canvas), card['sub2'],
              tx_cx, cy0 + 154,
              F(FONT_R, 34), (*WHITE[:3], int(200 * ca)),
              shadow=(40, 40, 60), sd=2)

    rt = eob(clamp(remap(t, 5.05, 6.05)))
    rx = lerp(-200, W * 0.13, rt)
    ry = H * 0.845 + math.sin(t * 1.55) * 13
    if rt > 0:
        paste_c(canvas, RABBIT, rx, ry, scale=0.88, alpha=min(rt, 1.0) * a)

    if t > 12.5:
        tgt = eoc(clamp(remap(t, 12.5, 13.2)))
        dw  = ImageDraw.Draw(canvas)
        txt_c(dw, _S['benefits_outro1'],
              W * 0.6, H * 0.82,
              F(FONT_XB, 66), (*D_PINK[:3], int(255 * tgt * a)),
              shadow=(0, 0, 0))
        txt_c(dw, _S['benefits_outro2'],
              W * 0.6, H * 0.87,
              F(FONT_XB, 66), (*D_PINK[:3], int(255 * tgt * a)),
              shadow=(0, 0, 0))


def scene_app(canvas, t, a):
    canvas.alpha_composite(load_bg('images/backgrounds/splash_bg_3.png',
                                   zoom=1.04, pan_y=0.35))
    color_ov(canvas, CREAM, 0.25 * a)
    color_ov(canvas, (0, 0, 0), 0.18 * a)

    draw_sparkles(canvas, t, [
        (W * 0.16, H * 0.10, 26, 10, GOLD),
        (W * 0.84, H * 0.08, 20,  8, LAVENDER),
        (W * 0.08, H * 0.28, 15,  6, MINT),
        (W * 0.92, H * 0.32, 17,  7, PINK),
        (W * 0.20, H * 0.58, 22,  9, GOLD),
        (W * 0.80, H * 0.54, 13,  5, SKY_BLUE),
    ], a)

    if t > 14.15:
        ha   = eoc(clamp(remap(t, 14.15, 14.80))) * a
        halo = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        for rad, oa in [(160, 0.18), (120, 0.26), (85, 0.20)]:
            ImageDraw.Draw(halo).ellipse(
                [W // 2 - rad, int(H * 0.22) - rad,
                 W // 2 + rad, int(H * 0.22) + rad],
                fill=(*PINK[:3], int(oa * 255 * ha)))
        halo = halo.filter(ImageFilter.GaussianBlur(22))
        canvas.alpha_composite(halo)

    lt = eob(clamp(remap(t, 14.0, 14.80)))
    if lt > 0:
        paste_c(canvas, LOGO, W * 0.5, H * 0.22, scale=lt, alpha=a)

    d = ImageDraw.Draw(canvas)

    nt = eoc(clamp(remap(t, 14.4, 15.10)))
    if nt > 0:
        txt_c(d, 'My Reading Village',
              W * 0.5, H * 0.390 + (1 - nt) * 55,
              F(FONT_XB, 96), (*WHITE[:3], int(255 * nt * a)),
              stroke_fill=(0, 0, 0), stroke_width=6)

    tgt = eoc(clamp(remap(t, 14.8, 15.50)))
    if tgt > 0:
        txt_c(d, _S['app_tagline'],
              W * 0.5, H * 0.468 + (1 - tgt) * 40,
              F(FONT_SB, 52), (*WHITE[:3], int(255 * tgt * a)),
              shadow=(0, 0, 0), sd=3)

    if t > 15.2:
        bt = eoc(clamp(remap(t, 15.2, 15.80)))
        txt_c(d, _S['app_cta'],
              W * 0.5, H * 0.85 + (1 - bt) * 40,
              F(FONT_B, 64), (*WHITE[:3], int(255 * bt * a)),
              stroke_fill=(0, 0, 0), stroke_width=4)


_CTA_GRAD = None


def get_cta_grad():
    global _CTA_GRAD
    if _CTA_GRAD is None:
        _CTA_GRAD = gradient_img([PINK, LAVENDER, MINT])
    return _CTA_GRAD.copy()


def scene_cta(canvas, t, a):
    canvas.alpha_composite(get_cta_grad())
    color_ov(canvas, (255, 255, 255), 0.06 * a)

    pl = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw_particles(pl, t, a)
    canvas.alpha_composite(pl)

    draw_sparkles(canvas, t, [
        (W * 0.14, H * 0.06, 30, 12, GOLD),
        (W * 0.86, H * 0.06, 24, 10, WHITE),
        (W * 0.07, H * 0.93, 20,  8, LAVENDER),
        (W * 0.93, H * 0.93, 22,  9, MINT),
        (W * 0.50, H * 0.04, 16,  6, PINK),
    ], a)

    la = eoc(clamp(remap(t, 18.0, 18.50)))
    if la > 0:
        lo = load_img('images/logos/my_reading_village_icon_rounded.png', w=310)
        paste_c(canvas, lo, W * 0.5, H * 0.195, scale=la, alpha=la * a)

    d  = ImageDraw.Draw(canvas)
    dt = eob(clamp(remap(t, 18.2, 18.70)))
    if dt > 0:
        yo = (1 - dt) * 65
        txt_c(d, _S['cta_dl1'],
              W * 0.5, H * 0.345 + yo,
              F(FONT_XB, 100), (*WHITE[:3], int(255 * dt * a)),
              shadow=(100, 50, 80), sd=6)
        txt_c(d, _S['cta_dl2'],
              W * 0.5, H * 0.440 + yo,
              F(FONT_XB, 112), (*GOLD[:3], int(255 * dt * a)),
              shadow=(100, 80, 0), sd=7)

    bt = eoc(clamp(remap(t, 18.4, 18.90)))
    if bt > 0:
        txt_emoji(canvas, _S['cta_store'],
                  W * 0.5, H * 0.580, 48, DARK_TEXT, bt * a)

    st = eoc(clamp(remap(t, 18.6, 19.10)))
    if st > 0:
        txt_c(d, '@myreadingvillage',
              W * 0.5, H * 0.685,
              F(FONT_SB, 52), (*D_LAV[:3], int(255 * st * a)),
              shadow=(220, 220, 240), sd=3)

    if t > 18.8:
        ft = eoc(clamp(remap(t, 18.8, 19.30)))
        txt_c(d, _S['cta_end'],
              W * 0.5, H * 0.775,
              F(FONT_R, 40), (*DARK_TEXT[:3], int(200 * ft * a)))


_TIMELINE = [
    ( 0.0,  5.0, scene_hook),
    ( 5.0, 14.0, scene_benefits),
    (14.0, 18.0, scene_app),
    (18.0, 20.0, scene_cta),
]
_CF = 0.50


def make_frame(t):
    active = []
    for s0, s1, fn in _TIMELINE:
        in_a  = eio(clamp(remap(t, s0 - _CF, s0)))
        out_a = eio(clamp(remap(t, s1, s1 + _CF)))
        a     = in_a * (1.0 - out_a)
        if a > 0:
            active.append((fn, a))

    if not active:
        return np.zeros((H, W, 3), dtype=np.uint8)

    if len(active) == 1:
        canvas = Image.new('RGBA', (W, H), (0, 0, 0, 255))
        active[0][0](canvas, t, active[0][1])
    else:
        c1 = Image.new('RGBA', (W, H), (0, 0, 0, 255))
        c2 = Image.new('RGBA', (W, H), (0, 0, 0, 255))
        active[0][0](c1, t, 1.0)
        active[1][0](c2, t, 1.0)
        total = active[0][1] + active[1][1]
        blend = active[1][1] / total if total > 0 else 0.5
        canvas = Image.blend(c1.convert('RGB'), c2.convert('RGB'),
                             blend).convert('RGBA')

    ga = eio(clamp(remap(t, 0.0, 0.35)))
    ga *= 1.0 - eio(clamp(remap(t, DURATION - 0.50, DURATION)))
    if ga < 1.0:
        blk = Image.new('RGBA', (W, H), (0, 0, 0, int((1 - ga) * 255)))
        canvas.alpha_composite(blk)

    return np.array(canvas.convert('RGB'))


def run(lang='en'):
    setup(lang)
    preload()
    out = os.path.join(_OUT, f'reading_benefits_story_{lang}.mp4')
    print(f'Rendering "Benefits of Reading" story ({lang})…')
    render_video(make_frame, DURATION, out,
                 _assets.asset('audios/my-reading-village-main.wav'))


def main():
    run()


if __name__ == '__main__':
    main()
