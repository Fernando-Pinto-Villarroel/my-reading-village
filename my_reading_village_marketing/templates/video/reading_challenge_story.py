#!/usr/bin/env python3
"""
My Reading Village — Reading Challenge Story
~10 s vertical story (9:16): weekly reading challenge CTA + product bridge.
Usage: .venv/bin/python3 templates/video/reading_challenge_story.py [--lang en]
"""
import sys, os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))
from PIL import Image, ImageDraw, ImageFilter
from utils import *
import assets as _assets

_OUT      = _assets.OUTPUT_DIR
_DURATION = 10.0
os.makedirs(_OUT, exist_ok=True)

_HEADER = {
    'en': "This week's challenge",
    'es': 'El reto de esta semana',
    'pt': 'O desafio desta semana',
    'fr': 'Le défi de cette semaine',
    'it': 'La sfida di questa settimana',
}

_CHALLENGE = {
    'en': 'Can you read\n20 pages every day?',
    'es': '¿Puedes leer\n20 páginas cada día?',
    'pt': 'Você consegue ler\n20 páginas por dia?',
    'fr': 'Peux-tu lire\n20 pages chaque jour ?',
    'it': 'Riesci a leggere\n20 pagine al giorno?',
}

_STREAK = {
    'en': '7-day reading streak',
    'es': 'Racha de lectura de 7 días',
    'pt': 'Sequência de leitura de 7 dias',
    'fr': 'Série de lecture de 7 jours',
    'it': 'Serie di lettura di 7 giorni',
}

_CTA = {
    'en': 'Drop your daily goal\nbelow 👇',
    'es': 'Escribe tu meta\ndiaria abajo 👇',
    'pt': 'Escreva sua meta\ndiária abaixo 👇',
    'fr': 'Écris ton objectif\nquotidien ci-dessous 👇',
    'it': 'Scrivi il tuo obiettivo\nquotidiano qui sotto 👇',
}

_BRIDGE = {
    'en': 'My Reading Village turns\nyour habit into rewards.',
    'es': 'My Reading Village convierte\ntu hábito en recompensas.',
    'pt': 'My Reading Village transforma\nseu hábito em recompensas.',
    'fr': 'My Reading Village transforme\nton habitude en récompenses.',
    'it': 'My Reading Village trasforma\nla tua abitudine in premi.',
}

_SOON = {
    'en': 'Coming soon · FREE',
    'es': 'Próximamente · GRATIS',
    'pt': 'Em breve · GRÁTIS',
    'fr': 'Bientôt · GRATUIT',
    'it': 'Prossimamente · GRATIS',
}

_LANG = 'en'
_BGS  = [1, 2]


def preload(lang, bg=1):
    global _LANG, _BGS
    _LANG = lang
    _BGS  = [((bg - 1 + i) % 6) + 1 for i in range(2)]


def scene_challenge(canvas, t, a):
    canvas.alpha_composite(load_bg(
        f'images/backgrounds/splash_bg_{_BGS[0]}.png',
        zoom=lerp(1.08, 1.02, eoc(remap(t, 0, 5.5))),
        pan_y=0.40))
    color_ov(canvas, (10, 5, 22), 0.62 * a)

    pl = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw_particles(pl, t, 0.50 * a)
    canvas.alpha_composite(pl)

    draw_sparkles(canvas, t, [
        (W * 0.12, H * 0.08, 28, 11, GOLD),
        (W * 0.88, H * 0.07, 22,  9, LAVENDER),
        (W * 0.08, H * 0.28, 16,  6, PINK),
        (W * 0.92, H * 0.26, 18,  7, MINT),
        (W * 0.10, H * 0.78, 20,  8, GOLD),
        (W * 0.90, H * 0.76, 14,  5, SKY_BLUE),
    ], a)

    d = ImageDraw.Draw(canvas)

    logo = load_img('images/logos/my_reading_village_icon_rounded.png', w=160)
    lt   = eoc(clamp(remap(t, 0.2, 1.0)))
    paste_c(canvas, set_alpha(logo, lt * a), W * 0.5, int(H * 0.095))

    ht = eoc(clamp(remap(t, 0.5, 1.3)))
    if ht > 0:
        header = _HEADER.get(_LANG, _HEADER['en'])
        solid_pill(canvas, (W - 760) // 2, int(H * 0.188),
                   (W + 760) // 2, int(H * 0.188) + 68, r=34,
                   fill=(*D_PINK[:3], int(210 * ht * a)))
        txt_c(d, header.upper(), W * 0.5, H * 0.188 + 34,
              F(FONT_XB, 42), (*WHITE[:3], int(255 * ht * a)))

    ct = eob(clamp(remap(t, 1.0, 2.0)))
    if ct > 0:
        challenge = _CHALLENGE.get(_LANG, _CHALLENGE['en'])
        for i, line in enumerate(challenge.split('\n')):
            txt_c(d, line, W * 0.5, H * 0.360 + i * 105 - (1 - ct) * 40,
                  F(FONT_XB, 76), (*WHITE[:3], int(255 * ct * a)),
                  stroke_fill=(0, 0, 0), stroke_width=4)

    dt = eoc(clamp(remap(t, 1.8, 2.8)))
    if dt > 0:
        streak = _STREAK.get(_LANG, _STREAK['en'])
        txt_c(d, streak, W * 0.5, H * 0.558,
              F(FONT_SB, 40), (*CREAM[:3], int(200 * dt * a)))

        dot_r   = 26
        dot_gap = 70
        total_w = 7 * dot_gap
        dot_x0  = (W - total_w) // 2 + dot_gap // 2
        dot_y   = int(H * 0.604)
        for i in range(7):
            frac = eoc(clamp(remap(t - i * 0.07, 1.8, 2.6)))
            if frac <= 0:
                continue
            cx     = dot_x0 + i * dot_gap
            filled = i < 5
            fill_c = (*GOLD[:3], int(255 * frac * dt * a)) if filled else \
                     (*CREAM[:3], int(80 * frac * dt * a))
            ImageDraw.Draw(canvas).ellipse(
                [cx - dot_r, dot_y - dot_r, cx + dot_r, dot_y + dot_r],
                fill=fill_c)
            if not filled:
                ImageDraw.Draw(canvas).ellipse(
                    [cx - dot_r, dot_y - dot_r, cx + dot_r, dot_y + dot_r],
                    outline=(*CREAM[:3], int(120 * frac * dt * a)), width=2)

    ctat = eoc(clamp(remap(t, 2.6, 3.5)))
    if ctat > 0:
        cta = _CTA.get(_LANG, _CTA['en'])
        for i, line in enumerate(cta.split('\n')):
            txt_c(d, line, W * 0.5, H * 0.700 + i * 72,
                  F(FONT_B, 58), (*MINT[:3], int(255 * ctat * a)),
                  shadow=(0, 0, 0), sd=3)

    at = eoc(clamp(remap(t, 3.2, 4.0)))
    txt_c(d, '@myreadingvillage', W * 0.5, H * 0.895,
          F(FONT_SB, 46), (*D_LAV[:3], int(at * 255 * a)),
          shadow=(220, 220, 240), sd=3)
    soon = _SOON.get(_LANG, _SOON['en'])
    txt_c(d, soon, W * 0.5, H * 0.948,
          F(FONT_R, 38), (*CREAM[:3], int(at * 170 * a)))


def scene_bridge(canvas, t, a):
    canvas.alpha_composite(load_bg(
        f'images/backgrounds/splash_bg_{_BGS[1]}.png',
        zoom=1.04, pan_y=0.38))
    color_ov(canvas, PINK, 0.10 * a)
    color_ov(canvas, (8, 4, 20), 0.54 * a)

    draw_sparkles(canvas, t, [
        (W * 0.15, H * 0.10, 26, 10, GOLD),
        (W * 0.85, H * 0.08, 20,  8, PINK),
        (W * 0.10, H * 0.82, 18,  7, LAVENDER),
        (W * 0.90, H * 0.80, 14,  5, MINT),
    ], a)

    d = ImageDraw.Draw(canvas)

    logo = load_img('images/logos/my_reading_village_icon_rounded.png', w=180)
    lt   = eoc(clamp(remap(t, 5.3, 6.0)))
    paste_c(canvas, set_alpha(logo, lt * a), W * 0.5, int(H * 0.105))

    vt = eob(clamp(remap(t, 5.2, 6.2)))
    if vt > 0:
        cat = load_img('images/villagers/cat/cat_villager.png', w=400)
        paste_c(canvas, set_alpha(cat, vt * a), W * 0.5, int(H * 0.480))

    bt = eob(clamp(remap(t, 5.6, 6.6)))
    if bt > 0:
        bridge = _BRIDGE.get(_LANG, _BRIDGE['en'])
        for i, line in enumerate(bridge.split('\n')):
            txt_c(d, line, W * 0.5, H * 0.265 + i * 80 - (1 - bt) * 40,
                  F(FONT_XB, 60), (*WHITE[:3], int(255 * bt * a)),
                  stroke_fill=(0, 0, 0), stroke_width=3)

    ct = eoc(clamp(remap(t, 6.2, 7.0)))
    if ct > 0:
        glass_card(canvas, (W - 720) // 2, int(H * 0.735),
                   (W + 720) // 2, int(H * 0.735) + 150, r=40,
                   tint=LAVENDER, ta=0.28 * ct * a, blur=14, border=D_LAV)
        txt_c(d, 'My Reading Village', W * 0.5, H * 0.762,
              F(FONT_XB, 50), (*WHITE[:3], int(255 * ct * a)),
              shadow=(0, 0, 0), sd=3)
        soon = _SOON.get(_LANG, _SOON['en'])
        txt_c(d, soon, W * 0.5, H * 0.830,
              F(FONT_R, 40), (*CREAM[:3], int(ct * 200 * a)))

    txt_c(d, '@myreadingvillage', W * 0.5, H * 0.930,
          F(FONT_SB, 46), (*D_LAV[:3],
          int(eoc(clamp(remap(t, 6.8, 7.5))) * 255 * a)),
          shadow=(220, 220, 240), sd=3)


_TIMELINE = [
    (0.0, 5.0, scene_challenge),
    (5.0, 10.0, scene_bridge),
]


def run(lang='en', bg=1):
    preload(lang, bg)
    mf  = make_video_frame(_TIMELINE, _DURATION)
    out = os.path.join(_OUT, f'reading_challenge_story_{lang}.mp4')
    print(f'Rendering reading challenge story ({lang})…')
    render_video(mf, _DURATION, out,
                 _assets.asset('audios/my-reading-village-main.wav'))


def main():
    run()


if __name__ == '__main__':
    main()
