#!/usr/bin/env python3
"""
My Reading Village — Feature Highlight
Static 1080x1920: "Did you know?" glassmorphism card with a reading fact.
Usage: .venv/bin/python3 templates/image/feature_highlight.py [--lang en]
"""
import sys, os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))
from PIL import Image, ImageDraw, ImageFilter
from utils import *
import assets as _assets

_OUT = _assets.OUTPUT_DIR
os.makedirs(_OUT, exist_ok=True)

_FACTS = {
    'en': [
        ('1.8M', 'Words per year', 'Reading 20 min a day\nexposes you to around\n1.8 million words yearly.'),
        ('5', 'Rarity tiers', 'My Reading Village has\n5 rarity tiers —\nCommon to Godly.'),
        ('🌙', 'Better sleep', 'A calming bedtime\nreading routine signals\nyour brain to wind down.'),
        ('1 book', 'Per month', 'Setting a reading goal —\neven 1 book a month —\nbuilds a powerful habit.'),
    ],
    'es': [
        ('1.8M', 'Palabras por año', 'Leer 20 min al día\nte expone a alrededor\nde 1.8 millones de palabras.'),
        ('5', 'Niveles de rareza', 'My Reading Village tiene\n5 niveles de rareza —\nde Común a Divino.'),
        ('🌙', 'Mejor sueño', 'Una rutina de lectura\nnocturna le indica\nal cerebro que descanse.'),
        ('1 libro', 'Al mes', 'Fijarse una meta —\nincluso 1 libro al mes —\ncrea un hábito poderoso.'),
    ],
    'pt': [
        ('1.8M', 'Palavras por ano', 'Ler 20 min por dia\nexpõe você a cerca de\n1,8 milhão de palavras.'),
        ('5', 'Níveis de raridade', 'My Reading Village tem\n5 níveis de raridade —\nde Comum a Divino.'),
        ('🌙', 'Melhor sono', 'Uma rotina de leitura\nnoturna sinaliza ao\ncérebro que descanse.'),
        ('1 livro', 'Por mês', 'Definir uma meta —\naté 1 livro por mês —\ncria um hábito poderoso.'),
    ],
    'fr': [
        ('1.8M', 'Mots par an', 'Lire 20 min par jour\nvous expose à environ\n1,8 million de mots.'),
        ('5', 'Niveaux de rareté', 'My Reading Village a\n5 niveaux de rareté —\nde Commun à Divin.'),
        ('🌙', 'Meilleur sommeil', 'Une routine de lecture\nnocturne signale à\nvotre cerveau de se calmer.'),
        ('1 livre', 'Par mois', 'Se fixer un objectif —\nmême 1 livre par mois —\nconstruit une habitude.'),
    ],
    'it': [
        ('1.8M', "Parole all'anno", 'Leggere 20 min al giorno\nti espone a circa\n1,8 milioni di parole.'),
        ('5', 'Livelli di rarità', 'My Reading Village ha\n5 livelli di rarità —\nda Comune a Divino.'),
        ('🌙', 'Sonno migliore', 'Una routine di lettura\nserale segnala al\ncervello di rilassarsi.'),
        ('1 libro', 'Al mese', "Fissarsi un obiettivo —\nalso 1 libro al mese —\ncrea un'abitudine solida."),
    ],
}

_HEADER = {
    'en': 'Did you know?',
    'es': '¿Sabías que...?',
    'pt': 'Você sabia?',
    'fr': 'Le saviez-vous ?',
    'it': 'Lo sapevi?',
}

_CTA = {
    'en': 'Read. Build. Grow.',
    'es': 'Lee. Construye. Crece.',
    'pt': 'Leia. Construa. Cresça.',
    'fr': 'Lis. Construis. Grandis.',
    'it': 'Leggi. Costruisci. Cresci.',
}


def run(lang='en', bg=1, fact=0, villager='rabbit'):
    facts = _FACTS.get(lang, _FACTS['en'])
    stat, title, body = facts[min(fact, len(facts) - 1)]
    header = _HEADER.get(lang, _HEADER['en'])
    cta    = _CTA.get(lang, _CTA['en'])

    canvas = Image.new('RGBA', (W, H), (0, 0, 0, 255))

    bg_img = load_bg(f'images/backgrounds/splash_bg_{bg}.png', zoom=1.05, pan_y=0.35)
    bg_img = bg_img.filter(ImageFilter.GaussianBlur(7))
    canvas.alpha_composite(bg_img)
    color_ov(canvas, (12, 6, 22), 0.58)

    pl = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw_particles(pl, 4.0, 0.5)
    canvas.alpha_composite(pl)

    draw_sparkles(canvas, 2.0, [
        (W * 0.14, H * 0.07, 30, 12, GOLD),
        (W * 0.86, H * 0.07, 24, 10, LAVENDER),
        (W * 0.08, H * 0.22, 16,  6, MINT),
        (W * 0.92, H * 0.25, 18,  7, PINK),
        (W * 0.12, H * 0.80, 20,  8, GOLD),
        (W * 0.88, H * 0.78, 14,  5, SKY_BLUE),
        (W * 0.50, H * 0.95, 16,  6, LAVENDER),
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

    solid_pill(canvas, (W - 500) // 2, _pill_top,
               (W + 500) // 2, _pill_top + _pill_h, r=34,
               fill=(*D_LAV[:3], 210))
    txt_c(d, header.upper(), W * 0.5, _pill_cy,
          F(FONT_XB, 46), (*WHITE[:3], 255))

    cw, ch = 860, 640
    cx0 = (W - cw) // 2
    cy0 = _card_top
    glass_card(canvas, cx0, cy0, cx0 + cw, cy0 + ch, r=40,
               tint=LAVENDER, ta=0.28, blur=20, border=D_LAV)

    txt_c(d, stat, W * 0.5, cy0 + 150,
          F(FONT_XB, 160), (*GOLD[:3], 255), shadow=(60, 40, 0), sd=8)

    txt_c(d, title, W * 0.5, cy0 + 300,
          F(FONT_B, 58), (*WHITE[:3], 255), shadow=(0, 0, 0), sd=4)

    for i, line in enumerate(body.split('\n')):
        txt_c(d, line, W * 0.5, cy0 + 400 + i * 62,
              F(FONT_R, 52), (*CREAM[:3], 220), shadow=(0, 0, 0), sd=3)

    villager_img = load_img(f'images/villagers/{villager}/{villager}_villager.png', w=360)
    paste_c(canvas, villager_img, W * 0.5, H * 0.710)

    glass_card(canvas, (W - 700) // 2, int(H * 0.855),
               (W + 700) // 2, int(H * 0.855) + 90, r=45,
               tint=MINT, ta=0.30, blur=12, border=D_MINT)
    txt_c(d, cta, W * 0.5, H * 0.855 + 45,
          F(FONT_B, 52), (*WHITE[:3], 255), shadow=(0, 0, 0), sd=3)

    out = os.path.join(_OUT, f'feature_highlight_{lang}_{fact}.png')
    canvas.convert('RGB').save(out)
    print(f'Saved: {out}')


def main():
    run()


if __name__ == '__main__':
    main()
