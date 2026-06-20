import os, math
import numpy as np
from PIL import Image, ImageDraw, ImageFilter, ImageFont
import assets as _assets
from palette import (PINK, LAVENDER, MINT, CREAM, PEACH, SKY_BLUE, GOLD,
                     GEM_PURP, WHITE, DARK_TEXT, D_PINK, D_LAV, D_MINT, D_PEACH)

_LATO   = '/usr/share/fonts/truetype/lato'
FONT_XB = os.path.join(_LATO, 'Lato-Black.ttf')
FONT_B  = os.path.join(_LATO, 'Lato-Bold.ttf')
FONT_SB = os.path.join(_LATO, 'Lato-Semibold.ttf')
FONT_R  = os.path.join(_LATO, 'Lato-Regular.ttf')
FONT_LI = os.path.join(_LATO, 'Lato-LightItalic.ttf')
FONT_I  = os.path.join(_LATO, 'Lato-Italic.ttf')

W, H = 1080, 1920
FPS  = 30

def F(path, size): return ImageFont.truetype(path, size)

# ── Easing ────────────────────────────────────────────────────────────────────
def clamp(v, lo=0.0, hi=1.0): return max(lo, min(hi, v))
def remap(v, a, b): return clamp((v - a) / (b - a)) if b > a else 0.0
def eoc(t):  return 1 - (1 - t) ** 3
def eob(t):
    c = 2.70158
    return 1 + c * (t - 1) ** 3 + (c - 1) * (t - 1) ** 2
def eio(t):  return t * t * (3 - 2 * t)
def lerp(a, b, t): return a + (b - a) * t

# ── Asset cache ───────────────────────────────────────────────────────────────
_CACHE: dict = {}

def load_img(rel, w=None):
    key = (rel, w)
    if key not in _CACHE:
        img = Image.open(_assets.asset(rel)).convert('RGBA')
        if w:
            ratio = w / img.width
            img = img.resize((w, max(1, int(img.height * ratio))), Image.LANCZOS)
        _CACHE[key] = img
    return _CACHE[key]

def load_bg(rel, zoom=1.0, pan_y=0.5):
    key = ('bg', rel)
    if key not in _CACHE:
        _CACHE[key] = Image.open(_assets.asset(rel)).convert('RGBA')
    src = _CACHE[key]
    sc  = max(W / src.width, H / src.height) * zoom
    nw, nh = int(src.width * sc), int(src.height * sc)
    img = src.resize((nw, nh), Image.LANCZOS)
    l   = (nw - W) // 2
    t2  = max(0, min(nh - H, int((nh - H) * pan_y)))
    return img.crop((l, t2, l + W, t2 + H))

# ── Drawing helpers ───────────────────────────────────────────────────────────
def set_alpha(img, a):
    if a >= 1.0: return img
    r, g, b, al = img.split()
    al = al.point(lambda x: int(x * a))
    return Image.merge('RGBA', (r, g, b, al))

def paste_c(base, img, cx, cy, scale=1.0, alpha=1.0):
    if scale != 1.0 and scale > 0.0:
        nw = max(1, int(img.width * scale))
        nh = max(1, int(img.height * scale))
        img = img.resize((nw, nh), Image.LANCZOS)
    if alpha < 1.0:
        img = set_alpha(img, alpha)
    base.paste(img, (int(cx - img.width / 2), int(cy - img.height / 2)), img)

def color_ov(canvas, rgb, a):
    ov = Image.new('RGBA', (W, H), (*rgb[:3], int(a * 255)))
    canvas.alpha_composite(ov)

def solid_pill(canvas, x0, y0, x1, y1, r, fill, border=None, bw=3):
    tmp = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    d   = ImageDraw.Draw(tmp)
    d.rounded_rectangle([x0, y0, x1, y1], radius=r,
                        fill=(*fill[:3], fill[3] if len(fill) > 3 else 255))
    if border:
        d.rounded_rectangle([x0, y0, x1, y1], radius=r,
                             outline=(*border[:3], 200), width=bw)
    canvas.alpha_composite(tmp)

def glass_card(canvas, x0, y0, x1, y1, r, tint=None, ta=0.22, blur=18, border=None):
    if tint is None: tint = WHITE
    crop = canvas.crop((x0, y0, x1, y1)).convert('RGBA')
    blr  = crop.filter(ImageFilter.GaussianBlur(blur))
    msk  = Image.new('L', blr.size, 0)
    ImageDraw.Draw(msk).rounded_rectangle(
        [0, 0, blr.width - 1, blr.height - 1], radius=r, fill=255)
    tl   = Image.new('RGBA', blr.size, (*tint[:3], int(ta * 255)))
    comp = Image.alpha_composite(blr, tl)
    comp.putalpha(msk)
    canvas.paste(comp, (x0, y0), comp)
    if border:
        tmp = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        ImageDraw.Draw(tmp).rounded_rectangle(
            [x0, y0, x1, y1], radius=r,
            outline=(*border[:3], 190), width=2)
        canvas.alpha_composite(tmp)

def txt_c(draw, text, cx, cy, fnt, fill,
          shadow=None, sd=5, stroke_fill=None, stroke_width=0):
    bb = draw.textbbox((0, 0), text, font=fnt)
    x  = cx - (bb[2] - bb[0]) / 2 - bb[0]
    y  = cy - (bb[3] - bb[1]) / 2 - bb[1]
    if shadow:
        draw.text((x + sd, y + sd), text, font=fnt, fill=(*shadow[:3], 75))
    if stroke_fill and stroke_width > 0:
        draw.text((x, y), text, font=fnt, fill=fill,
                  stroke_width=stroke_width,
                  stroke_fill=(*stroke_fill[:3], fill[3] if len(fill) > 3 else 255))
    else:
        draw.text((x, y), text, font=fnt, fill=fill)

def txt_emoji(canvas, text, cx, cy, size, fill, a):
    from pilmoji import Pilmoji
    fnt = F(FONT_SB, size)
    tmp = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    with Pilmoji(tmp) as pj:
        tw, th = pj.getsize(text, fnt)
        pj.text((int(cx - tw / 2), int(cy - th / 2)),
                text, (*fill[:3], int(255 * a)), fnt)
    if a < 1.0:
        tmp = set_alpha(tmp, a)
    canvas.alpha_composite(tmp)

def gradient_img(colors):
    img = Image.new('RGBA', (W, H))
    pix = img.load()
    n   = len(colors) - 1
    for y in range(H):
        t2    = y / H * n
        i     = min(int(t2), n - 1)
        f     = t2 - i
        c0, c1 = colors[i][:3], colors[i + 1][:3]
        r = int(lerp(c0[0], c1[0], f))
        g = int(lerp(c0[1], c1[1], f))
        b = int(lerp(c0[2], c1[2], f))
        for x in range(W):
            pix[x, y] = (r, g, b, 255)
    return img

def silhouette(img):
    result = img.copy()
    data   = result.load()
    for yy in range(result.height):
        for xx in range(result.width):
            r, g, b, a = data[xx, yy]
            if a > 0:
                data[xx, yy] = (20, 15, 30, a)
    return result

# ── Particles & sparkles ──────────────────────────────────────────────────────
_PARTICLES = [
    {'xf': 0.12, 'vy': 52, 'ph': 0.0, 'r': 11, 'c': PINK},
    {'xf': 0.27, 'vy': 38, 'ph': 1.2, 'r': 7,  'c': LAVENDER},
    {'xf': 0.50, 'vy': 62, 'ph': 0.6, 'r': 9,  'c': MINT},
    {'xf': 0.70, 'vy': 45, 'ph': 2.1, 'r': 6,  'c': PEACH},
    {'xf': 0.86, 'vy': 56, 'ph': 0.9, 'r': 10, 'c': SKY_BLUE},
    {'xf': 0.06, 'vy': 32, 'ph': 1.8, 'r': 5,  'c': GOLD},
    {'xf': 0.94, 'vy': 48, 'ph': 0.4, 'r': 8,  'c': GEM_PURP},
]

def draw_particles(layer, t, a=1.0):
    d = ImageDraw.Draw(layer)
    for p in _PARTICLES:
        cycle = H + 40
        yy    = (H + 20) - (t * p['vy']) % cycle
        xx    = W * p['xf'] + math.sin(t * 1.1 + p['ph']) * 20
        r     = p['r']
        al    = int(200 * a)
        d.ellipse([xx - r, yy - r, xx + r, yy + r], fill=(*p['c'], al))

def draw_star(draw, cx, cy, ro, ri, pts, fill, rot=0.0):
    pts_list = []
    for i in range(pts * 2):
        ang = math.pi * i / pts + rot - math.pi / 2
        r   = ro if i % 2 == 0 else ri
        pts_list.append((cx + r * math.cos(ang), cy + r * math.sin(ang)))
    if len(pts_list) >= 3:
        draw.polygon(pts_list, fill=fill)

def draw_sparkles(canvas, t, positions, a=1.0):
    layer = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    for i, (px, py, ro, ri, c) in enumerate(positions):
        pulse = 0.72 + 0.28 * math.sin(t * 2.4 + i * 1.1)
        rot   = t * 0.55 + i * 0.7
        al    = int(230 * a * pulse)
        draw_star(d, px, py, ro * pulse, ri * pulse, 4, (*c[:3], al), rot)
    canvas.alpha_composite(layer)

# ── Video compositor helper ───────────────────────────────────────────────────
def make_video_frame(timeline, duration, cf=0.50):
    def _make_frame(t):
        active = []
        for s0, s1, fn in timeline:
            in_a  = eio(clamp(remap(t, s0 - cf, s0)))
            out_a = eio(clamp(remap(t, s1, s1 + cf)))
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
        ga *= 1.0 - eio(clamp(remap(t, duration - 0.50, duration)))
        if ga < 1.0:
            blk = Image.new('RGBA', (W, H), (0, 0, 0, int((1 - ga) * 255)))
            canvas.alpha_composite(blk)
        return np.array(canvas.convert('RGB'))
    return _make_frame

def render_video(make_frame_fn, duration, out_path, audio_path=None):
    from moviepy.editor import VideoClip, AudioFileClip
    clip = VideoClip(make_frame_fn, duration=duration)
    if audio_path and os.path.exists(audio_path):
        raw   = AudioFileClip(audio_path)
        dur   = min(duration, raw.duration)
        audio = raw.subclip(0, dur).audio_fadein(0.4).audio_fadeout(0.7)
        clip  = clip.set_audio(audio)
    clip.write_videofile(out_path, fps=FPS, codec='libx264', audio_codec='aac',
                         preset='medium', bitrate='6000k', logger='bar')
    print(f'\nSaved: {out_path}')

# ── Species data ──────────────────────────────────────────────────────────────
_D_GOLD  = (180, 130,  0)
_D_PURP  = (130,  60, 185)

SPECIES = {
    'cat':         ('common',        MINT,     D_MINT),
    'dog':         ('common',        MINT,     D_MINT),
    'rabbit':      ('common',        MINT,     D_MINT),
    'koala':       ('common',        MINT,     D_MINT),
    'hamster':     ('common',        MINT,     D_MINT),
    'elephant':    ('common',        MINT,     D_MINT),
    'duck':        ('common',        MINT,     D_MINT),
    'pig':         ('common',        PINK,     D_PINK),
    'raccoon':     ('common',        MINT,     D_MINT),
    'platypus':    ('common',        SKY_BLUE, (60, 130, 200)),
    'grizzly_bear':('rare',          LAVENDER, D_LAV),
    'polar_bear':  ('rare',          LAVENDER, D_LAV),
    'panda_bear':  ('rare',          LAVENDER, D_LAV),
    'red_panda':   ('rare',          LAVENDER, D_LAV),
    'sloth':       ('rare',          LAVENDER, D_LAV),
    'hedgehog':    ('rare',          LAVENDER, D_LAV),
    'capybara':    ('rare',          LAVENDER, D_LAV),
    'cow':         ('rare',          LAVENDER, D_LAV),
    'sheep':       ('rare',          LAVENDER, D_LAV),
    'bull':        ('extraordinary', PEACH,    D_PEACH),
    'otter':       ('extraordinary', PEACH,    D_PEACH),
    'kangaroo':    ('extraordinary', PEACH,    D_PEACH),
    'reindeer':    ('extraordinary', PEACH,    D_PEACH),
    'ferret':      ('extraordinary', PEACH,    D_PEACH),
    'mole':        ('extraordinary', PEACH,    D_PEACH),
    'bat':         ('extraordinary', PEACH,    D_PEACH),
    'donkey':      ('extraordinary', PEACH,    D_PEACH),
    'turkey':      ('extraordinary', PEACH,    D_PEACH),
    'monkey':      ('legendary',     GOLD,     _D_GOLD),
    'gorilla':     ('legendary',     GOLD,     _D_GOLD),
    'zebra':       ('legendary',     GOLD,     _D_GOLD),
    'horse':       ('legendary',     GOLD,     _D_GOLD),
    'skunk':       ('legendary',     GOLD,     _D_GOLD),
    'hyena':       ('legendary',     GOLD,     _D_GOLD),
    'mouse':       ('legendary',     GOLD,     _D_GOLD),
    'lion':        ('godly',         GEM_PURP, _D_PURP),
    'armadillo':   ('godly',         GEM_PURP, _D_PURP),
    'beaver':      ('godly',         GEM_PURP, _D_PURP),
    'fox':         ('godly',         GEM_PURP, _D_PURP),
    'tiger':       ('godly',         GEM_PURP, _D_PURP),
    'leopard':     ('godly',         GEM_PURP, _D_PURP),
}

RARITY_LABEL = {
    'en': {'common': 'Common', 'rare': 'Rare', 'extraordinary': 'Extraordinary',
            'legendary': 'Legendary', 'godly': 'Godly'},
    'es': {'common': 'Común', 'rare': 'Raro', 'extraordinary': 'Extraordinario',
            'legendary': 'Legendario', 'godly': 'Divino'},
    'pt': {'common': 'Comum', 'rare': 'Raro', 'extraordinary': 'Extraordinário',
            'legendary': 'Lendário', 'godly': 'Divino'},
    'fr': {'common': 'Commun', 'rare': 'Rare', 'extraordinary': 'Extraordinaire',
            'legendary': 'Légendaire', 'godly': 'Divin'},
    'it': {'common': 'Comune', 'rare': 'Raro', 'extraordinary': 'Straordinario',
            'legendary': 'Leggendario', 'godly': 'Divino'},
}

def species_name(villager, lang):
    import json
    data = json.load(open(_assets.asset(f'messages/{lang}/{lang}.json')))
    return data.get(f'species_{villager}', villager.replace('_', ' ').title())

def species_desc(villager, lang):
    import json
    data = json.load(open(_assets.asset(f'messages/{lang}/{lang}.json')))
    raw  = data.get(f'species_desc_{villager}', '')
    return raw.split('.')[0] + '.' if '.' in raw else raw

def wrap_text(text, max_chars=30):
    words  = text.split()
    lines, current = [], ''
    for w in words:
        test = (current + ' ' + w).strip()
        if len(test) > max_chars and current:
            lines.append(current)
            current = w
        else:
            current = test
    if current:
        lines.append(current)
    return lines
