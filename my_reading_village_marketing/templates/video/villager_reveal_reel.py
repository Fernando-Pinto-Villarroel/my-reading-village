#!/usr/bin/env python3
"""
My Reading Village — Villager Reveal Reel
~12 s vertical video (9:16): intro → dramatic villager reveal → CTA.
Usage: .venv/bin/python3 templates/video/villager_reveal_reel.py [--villager cat] [--lang en]
"""
import sys, os, math
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))
from PIL import Image, ImageDraw, ImageFilter
from utils import *
import assets as _assets

_OUT      = _assets.OUTPUT_DIR
_DURATION = 12.0
os.makedirs(_OUT, exist_ok=True)

_MEET = {
    'en': ('Meet your', 'new villager!'),
    'es': ('¡Conoce a tu', 'nuevo aldeano!'),
    'pt': ('Conheça seu', 'novo aldeão!'),
    'fr': ('Rencontrez votre', 'nouveau villageois !'),
    'it': ('Incontra il tuo', 'nuovo abitante!'),
}
_JOIN = {
    'en': 'joins the village!',
    'es': '¡se une al pueblo!',
    'pt': 'se junta à aldeia!',
    'fr': 'rejoint le village !',
    'it': 'si unisce al villaggio!',
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

_VILLAGER  = 'cat'
_LANG      = 'en'
_RARITY    = ('common', MINT, D_MINT)
_NAME      = 'Cat'


def preload(villager, lang):
    global _VILLAGER, _LANG, _RARITY, _NAME
    _VILLAGER = villager
    _LANG     = lang
    _RARITY   = SPECIES.get(villager, ('common', MINT, D_MINT))
    _NAME     = species_name(villager, lang)


def scene_intro(canvas, t, a):
    canvas.alpha_composite(load_bg('images/backgrounds/splash_bg_1.png',
                                   zoom=lerp(1.08, 1.0, eoc(remap(t, 0, 3.5))),
                                   pan_y=0.35))
    color_ov(canvas, (12, 6, 22), 0.60 * a)

    pl = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw_particles(pl, t, 0.70 * a)
    canvas.alpha_composite(pl)

    draw_sparkles(canvas, t, [
        (W * 0.20, H * 0.18, 22, 9, GOLD),
        (W * 0.80, H * 0.16, 18, 7, LAVENDER),
        (W * 0.12, H * 0.40, 14, 5, PINK),
        (W * 0.88, H * 0.38, 16, 6, MINT),
    ], a)

    lt = eob(clamp(remap(t, 0.1, 1.0)))
    if lt > 0:
        logo = load_img('images/logos/my_reading_village_icon_rounded.png', w=200)
        paste_c(canvas, logo, W * 0.5, H * 0.28, scale=lt, alpha=lt * a)

    d = ImageDraw.Draw(canvas)
    line1, line2 = _MEET.get(_LANG, _MEET['en'])

    t1 = eoc(clamp(remap(t, 0.6, 1.4)))
    if t1 > 0:
        txt_c(d, line1, W * 0.5, H * 0.455 + (1 - t1) * 50,
              F(FONT_SB, 68), (*CREAM[:3], int(240 * t1 * a)), shadow=(0, 0, 0))

    t2 = eob(clamp(remap(t, 1.0, 1.9)))
    if t2 > 0:
        txt_c(d, line2, W * 0.5, H * 0.545 + (1 - t2) * 50,
              F(FONT_XB, 84), (*WHITE[:3], int(255 * t2 * a)),
              stroke_fill=(0, 0, 0), stroke_width=5)


def scene_reveal(canvas, t, a):
    _, tint, accent = _RARITY
    canvas.alpha_composite(
        load_bg('images/backgrounds/splash_bg_2.png', zoom=1.04, pan_y=0.42))
    color_ov(canvas, tint, 0.16 * a)
    color_ov(canvas, (8, 4, 18), 0.46 * a)

    draw_sparkles(canvas, t, [
        (W * 0.16, H * 0.10, 26, 10, GOLD),
        (W * 0.84, H * 0.08, 22,  9, tint),
        (W * 0.10, H * 0.28, 16,  6, LAVENDER),
        (W * 0.90, H * 0.25, 18,  7, tint),
        (W * 0.14, H * 0.72, 20,  8, GOLD),
        (W * 0.86, H * 0.70, 14,  5, PINK),
    ], a)

    ha = eoc(clamp(remap(t, 3.2, 4.2))) * a
    if ha > 0:
        halo = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        for rad, oa in [(280, 0.12), (210, 0.18), (150, 0.14)]:
            ImageDraw.Draw(halo).ellipse(
                [W // 2 - rad, int(H * 0.40) - rad,
                 W // 2 + rad, int(H * 0.40) + rad],
                fill=(*tint[:3], int(oa * 255 * ha)))
        halo = halo.filter(ImageFilter.GaussianBlur(28))
        canvas.alpha_composite(halo)

    vt = eob(clamp(remap(t, 3.0, 4.2)))
    if vt > 0:
        vi = load_img(f'images/villagers/{_VILLAGER}/{_VILLAGER}_villager.png', w=500)
        paste_c(canvas, vi, W * 0.5, H * 0.40 + (1 - vt) * 80,
                scale=vt, alpha=min(vt, 1.0) * a)

    d = ImageDraw.Draw(canvas)

    nt = eoc(clamp(remap(t, 3.8, 4.6)))
    if nt > 0:
        txt_c(d, _NAME, W * 0.5, H * 0.720 + (1 - nt) * 40,
              F(FONT_XB, 110), (*WHITE[:3], int(255 * nt * a)),
              stroke_fill=(0, 0, 0), stroke_width=6)

    rt = eoc(clamp(remap(t, 4.3, 5.0)))
    if rt > 0:
        rarity, _, _ = _RARITY
        rlabel = RARITY_LABEL.get(_LANG, RARITY_LABEL['en'])[rarity]
        rw = max(280, len(rlabel) * 24 + 80)
        rx0 = (W - rw) // 2
        solid_pill(canvas, rx0, int(H * 0.800), rx0 + rw, int(H * 0.800) + 58, r=29,
                   fill=(*accent[:3], int(220 * rt * a)))
        txt_c(d, rlabel.upper(), W * 0.5, H * 0.800 + 29,
              F(FONT_XB, 36), (*WHITE[:3], int(255 * rt * a)),
              stroke_fill=(0, 0, 0), stroke_width=2)

    jt = eoc(clamp(remap(t, 4.8, 5.5)))
    if jt > 0:
        txt_c(d, f'{_NAME} {_JOIN.get(_LANG, _JOIN["en"])}',
              W * 0.5, H * 0.880 + (1 - jt) * 30,
              F(FONT_SB, 44), (*CREAM[:3], int(220 * jt * a)), shadow=(0, 0, 0))


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

    la = eoc(clamp(remap(t, 8.0, 8.6)))
    if la > 0:
        lo = load_img('images/logos/my_reading_village_icon_rounded.png', w=280)
        paste_c(canvas, lo, W * 0.5, H * 0.195, scale=la, alpha=la * a)

    d   = ImageDraw.Draw(canvas)
    dt  = eob(clamp(remap(t, 8.3, 8.9)))
    if dt > 0:
        yo = (1 - dt) * 55
        dl1, dl2 = _DL.get(_LANG, _DL['en'])
        txt_c(d, dl1, W * 0.5, H * 0.355 + yo,
              F(FONT_XB, 96), (*WHITE[:3], int(255 * dt * a)),
              shadow=(100, 50, 80), sd=6)
        txt_c(d, dl2, W * 0.5, H * 0.450 + yo,
              F(FONT_XB, 108), (*GOLD[:3], int(255 * dt * a)),
              shadow=(100, 80, 0), sd=7)

    bt = eoc(clamp(remap(t, 8.6, 9.1)))
    if bt > 0:
        txt_emoji(canvas, _SOON.get(_LANG, _SOON['en']),
                  W * 0.5, H * 0.585, 46, DARK_TEXT, bt * a)

    st = eoc(clamp(remap(t, 8.9, 9.4)))
    if st > 0:
        txt_c(d, '@myreadingvillage', W * 0.5, H * 0.690,
              F(FONT_SB, 50), (*D_LAV[:3], int(255 * st * a)),
              shadow=(220, 220, 240), sd=3)


_TIMELINE = [
    (0.0,  4.5,  scene_intro),
    (4.0,  9.5,  scene_reveal),
    (9.0, 12.0,  scene_cta),
]


def run(villager='cat', lang='en'):
    preload(villager, lang)
    mf  = make_video_frame(_TIMELINE, _DURATION)
    out = os.path.join(_OUT, f'villager_reveal_reel_{villager}_{lang}.mp4')
    print(f'Rendering villager reveal reel ({villager}, {lang})…')
    render_video(mf, _DURATION, out,
                 _assets.asset('audios/my-reading-village-main.wav'))


def main():
    run()


if __name__ == '__main__':
    main()
