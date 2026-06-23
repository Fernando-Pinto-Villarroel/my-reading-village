#!/usr/bin/env python3
"""
My Reading Village — Countdown Story
~10 s vertical story (9:16): mystery silhouette villager teaser + countdown.
Usage: .venv/bin/python3 templates/video/countdown_story.py [--villager fox] [--lang en]
"""
import sys, os, math
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))
from PIL import Image, ImageDraw, ImageFilter
from utils import *
import assets as _assets

_OUT      = _assets.OUTPUT_DIR
_DURATION = 10.0
os.makedirs(_OUT, exist_ok=True)

_COMING = {
    'en': 'Coming soon...',
    'es': 'Próximamente...',
    'pt': 'Em breve...',
    'fr': 'Bientôt...',
    'it': 'Prossimamente...',
}
_MYSTERY = {
    'en': 'Who could it be?',
    'es': '¿Quién será?',
    'pt': 'Quem será?',
    'fr': 'Qui pourrait-ce être ?',
    'it': 'Chi sarà?',
}
_FOLLOW = {
    'en': 'Follow us to find out!',
    'es': '¡Síguenos para descubrirlo!',
    'pt': 'Siga-nos para descobrir!',
    'fr': 'Suis-nous pour le découvrir !',
    'it': 'Seguici per scoprirlo!',
}

_VILLAGER  = 'fox'
_LANG      = 'en'
_RARITY    = ('godly', GEM_PURP, (130, 60, 185))
_BGS       = [1, 2]


def preload(villager, lang, bg=1):
    global _VILLAGER, _LANG, _RARITY, _BGS
    _VILLAGER = villager
    _LANG     = lang
    _RARITY   = SPECIES.get(villager, ('common', MINT, D_MINT))
    _BGS      = [((bg - 1 + i) % 6) + 1 for i in range(2)]


def scene_tease(canvas, t, a):
    _, tint, accent = _RARITY
    canvas.alpha_composite(load_bg(f'images/backgrounds/splash_bg_{_BGS[0]}.png',
                                   zoom=lerp(1.10, 1.02, eoc(remap(t, 0, 6.0))),
                                   pan_y=0.40))
    color_ov(canvas, (12, 6, 26), 0.65 * a)

    pl = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw_particles(pl, t, 0.55 * a)
    canvas.alpha_composite(pl)

    draw_sparkles(canvas, t, [
        (W * 0.14, H * 0.08, 26, 10, GOLD),
        (W * 0.86, H * 0.07, 20,  8, tint),
        (W * 0.09, H * 0.28, 14,  5, LAVENDER),
        (W * 0.91, H * 0.26, 16,  6, tint),
        (W * 0.12, H * 0.78, 18,  7, GOLD),
        (W * 0.88, H * 0.76, 12,  4, PINK),
    ], a)

    ct = eoc(clamp(remap(t, 0.3, 1.6)))
    if ct > 0:
        vi_src = load_img(
            f'images/villagers/{_VILLAGER}/{_VILLAGER}_villager.png', w=500)
        vi_sil = silhouette(vi_src.copy())

        if a < 1.0:
            vi_sil = set_alpha(vi_sil, ct * a)
        else:
            vi_sil = set_alpha(vi_sil, ct)

        halo = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        for rad, oa in [(260, 0.08), (190, 0.14), (130, 0.10)]:
            ImageDraw.Draw(halo).ellipse(
                [W // 2 - rad, int(H * 0.435) - rad,
                 W // 2 + rad, int(H * 0.435) + rad],
                fill=(*tint[:3], int(oa * 255 * ct * a)))
        halo = halo.filter(ImageFilter.GaussianBlur(28))
        canvas.alpha_composite(halo)

        canvas.paste(vi_sil,
                     (W // 2 - vi_sil.width // 2,
                      int(H * 0.435) - vi_sil.height // 2),
                     vi_sil)

    d  = ImageDraw.Draw(canvas)
    t1 = eoc(clamp(remap(t, 0.8, 1.6)))
    if t1 > 0:
        txt_c(d, _COMING.get(_LANG, _COMING['en']),
              W * 0.5, H * 0.135 - (1 - t1) * 40,
              F(FONT_SB, 70), (*CREAM[:3], int(240 * t1 * a)), shadow=(0, 0, 0))

    t2 = eob(clamp(remap(t, 1.3, 2.2)))
    if t2 > 0:
        txt_c(d, _MYSTERY.get(_LANG, _MYSTERY['en']),
              W * 0.5, H * 0.755 + (1 - t2) * 40,
              F(FONT_XB, 78), (*WHITE[:3], int(255 * t2 * a)),
              stroke_fill=(0, 0, 0), stroke_width=5)

    if t > 2.0:
        qt = eob(clamp(remap(t, 2.0, 2.8)))
        txt_c(d, '?', W * 0.5, H * 0.435 + (1 - qt) * 30,
              F(FONT_XB, 200), (*WHITE[:3], int(200 * qt * a * 0.55)),
              stroke_fill=(0, 0, 0), stroke_width=8)

    solid_pill(canvas, (W - 700) // 2, int(H * 0.840),
               (W + 700) // 2, int(H * 0.840) + 76, r=38,
               fill=(*accent[:3], int(eoc(clamp(remap(t, 1.8, 2.6))) * 220 * a)))
    ft = eoc(clamp(remap(t, 1.8, 2.6)))
    if ft > 0:
        txt_c(d, _FOLLOW.get(_LANG, _FOLLOW['en']),
              W * 0.5, H * 0.840 + 38,
              F(FONT_B, 42), (*WHITE[:3], int(255 * ft * a)))

    txt_c(d, '@myreadingvillage', W * 0.5, H * 0.940,
          F(FONT_SB, 48), (*D_LAV[:3],
          int(eoc(clamp(remap(t, 2.2, 3.0))) * 255 * a)),
          shadow=(220, 220, 240), sd=3)


def scene_reveal_tease(canvas, t, a):
    _, tint, accent = _RARITY
    canvas.alpha_composite(load_bg(f'images/backgrounds/splash_bg_{_BGS[1]}.png',
                                   zoom=1.04, pan_y=0.42))
    color_ov(canvas, tint, 0.18 * a)
    color_ov(canvas, (8, 4, 20), 0.50 * a)

    draw_sparkles(canvas, t, [
        (W * 0.16, H * 0.10, 28, 11, GOLD),
        (W * 0.84, H * 0.08, 22,  9, tint),
        (W * 0.10, H * 0.30, 16,  6, LAVENDER),
        (W * 0.90, H * 0.28, 18,  7, tint),
    ], a)

    vi_src = load_img(
        f'images/villagers/{_VILLAGER}/{_VILLAGER}_villager.png', w=500)
    reveal = clamp(remap(t, 5.5, 8.5))

    sil_img   = silhouette(vi_src.copy())
    color_img = vi_src.copy()

    blended = Image.blend(
        sil_img.convert('RGB'), color_img.convert('RGB'), reveal
    ).convert('RGBA')
    alpha_ch = vi_src.split()[3]
    blended.putalpha(alpha_ch)
    blended = set_alpha(blended, a)

    halo = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    for rad, oa in [(280, 0.12), (210, 0.18), (150, 0.14)]:
        ImageDraw.Draw(halo).ellipse(
            [W // 2 - rad, int(H * 0.42) - rad,
             W // 2 + rad, int(H * 0.42) + rad],
            fill=(*tint[:3], int(oa * 255 * a)))
    halo = halo.filter(ImageFilter.GaussianBlur(28))
    canvas.alpha_composite(halo)

    canvas.paste(blended,
                 (W // 2 - blended.width // 2,
                  int(H * 0.42) - blended.height // 2),
                 blended)

    d  = ImageDraw.Draw(canvas)
    rt = eoc(clamp(remap(t, 5.3, 6.2)))
    if rt > 0:
        rarity, _, _ = _RARITY
        rlabel = RARITY_LABEL.get(_LANG, RARITY_LABEL['en'])[rarity]
        rw  = max(280, len(rlabel) * 24 + 80)
        rx0 = (W - rw) // 2
        solid_pill(canvas, rx0, int(H * 0.735), rx0 + rw, int(H * 0.735) + 58, r=29,
                   fill=(*accent[:3], int(220 * rt * a)))
        txt_c(d, rlabel.upper(), W * 0.5, H * 0.735 + 29,
              F(FONT_XB, 36), (*WHITE[:3], int(255 * rt * a)),
              stroke_fill=(0, 0, 0), stroke_width=2)

    nt = eoc(clamp(remap(t, 5.8, 7.0)))
    if nt > 0:
        n = species_name(_VILLAGER, _LANG) if reveal > 0.85 else '???'
        txt_c(d, n, W * 0.5, H * 0.820 + (1 - nt) * 35,
              F(FONT_XB, 100), (*WHITE[:3], int(255 * nt * a)),
              stroke_fill=(0, 0, 0), stroke_width=6)

    txt_c(d, '@myreadingvillage', W * 0.5, H * 0.930,
          F(FONT_SB, 46), (*D_LAV[:3],
          int(eoc(clamp(remap(t, 6.5, 7.2))) * 255 * a)),
          shadow=(220, 220, 240), sd=3)


_TIMELINE = [
    (0.0,  5.5, scene_tease),
    (5.5, 10.0, scene_reveal_tease),
]


def run(villager='fox', lang='en', bg=1):
    preload(villager, lang, bg)
    mf  = make_video_frame(_TIMELINE, _DURATION)
    out = os.path.join(_OUT, f'countdown_story_{villager}_{lang}.mp4')
    print(f'Rendering countdown story ({villager}, {lang})…')
    render_video(mf, _DURATION, out,
                 _assets.asset('audios/my-reading-village-main.wav'))


def main():
    run()


if __name__ == '__main__':
    main()
