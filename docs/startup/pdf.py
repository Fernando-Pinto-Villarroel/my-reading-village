import math, os
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib.colors import HexColor
from PIL import Image as PILImage
import io

FONT_DIR = "/home/university/fonts/"
pdfmetrics.registerFont(TTFont("Pop",   FONT_DIR + "Poppins-Regular.ttf"))
pdfmetrics.registerFont(TTFont("PopB",  FONT_DIR + "Poppins-Bold.ttf"))
pdfmetrics.registerFont(TTFont("PopM",  FONT_DIR + "Poppins-Medium.ttf"))
pdfmetrics.registerFont(TTFont("PopL",  FONT_DIR + "Poppins-Light.ttf"))

LAV_D  = HexColor("#7b5ea7"); LAV   = HexColor("#c9b8f5"); LAV_L  = HexColor("#ede7fc")
MNT_D  = HexColor("#3d9970"); MNT   = HexColor("#a8e6cf"); MNT_L  = HexColor("#dff5ec")
PCH_D  = HexColor("#c77c2a"); PCH   = HexColor("#ffd3a5"); PCH_L  = HexColor("#fff0da")
RSE_D  = HexColor("#b5385a"); RSE   = HexColor("#ffb3c6"); RSE_L  = HexColor("#ffe4ec")
SKY_D  = HexColor("#2e7ea8"); SKY   = HexColor("#bde4f4"); SKY_L = HexColor("#dff1fb")
CREAM  = HexColor("#fdfaf5"); SAND  = HexColor("#f5efe0")
TD     = HexColor("#2d2a3e"); TM    = HexColor("#5a5475"); TS     = HexColor("#9490a8")
WHITE  = HexColor("#ffffff")

W, H = letter
MX = 34
MY = 32
CW = W - 2*MX

ICON_NEW = "/home/university/Documents/Projects/jala-university/javascript-projects/OTHERS/my-reading-town/my_reading_town/assets/images/logos/my_reading_town_icon_cropped.png"

def rr(c, x, y, w, h, r=7, fill=None, stroke=None, sw=0.6):
    if fill:   c.setFillColor(fill)
    if stroke: c.setStrokeColor(stroke)
    c.setLineWidth(sw)
    c.roundRect(x, y, w, h, r, stroke=1 if stroke else 0, fill=1 if fill else 0)

def draw_logo_rounded(c, x, y, size=38):
    if not os.path.exists(ICON_NEW):
        return
    rr(c, x, y, size, size, r=10, fill=LAV_L)
    p = c.beginPath()
    r_val = 10
    p.moveTo(x + r_val, y)
    p.lineTo(x + size - r_val, y)
    p.curveTo(x+size-r_val, y, x+size, y, x+size, y+r_val)
    p.lineTo(x+size, y+size-r_val)
    p.curveTo(x+size, y+size-r_val, x+size, y+size, x+size-r_val, y+size)
    p.lineTo(x+r_val, y+size)
    p.curveTo(x+r_val, y+size, x, y+size, x, y+size-r_val)
    p.lineTo(x, y+r_val)
    p.curveTo(x, y+r_val, x, y, x+r_val, y)
    p.close()
    c.saveState()
    c.clipPath(p, stroke=0)
    c.drawImage(ICON_NEW, x, y, width=size, height=size,
                preserveAspectRatio=True, mask='auto')
    c.restoreState()

def wrap_text(c, txt, x, y, max_w, font, sz, color, lh, align="left"):
    c.setFont(font, sz); c.setFillColor(color)
    words = txt.split(); line = ""; lines_out = []
    for w in words:
        test = (line + " " + w).strip()
        if c.stringWidth(test, font, sz) <= max_w: line = test
        else:
            if line: lines_out.append(line)
            line = w
    if line: lines_out.append(line)
    for i, l in enumerate(lines_out):
        xd = x + (max_w - c.stringWidth(l,font,sz))/2 if align=="center" else \
             x + max_w - c.stringWidth(l,font,sz) if align=="right" else x
        c.drawString(xd, y - i*lh, l)
    return len(lines_out)*lh

def wrap_text_rich(c, segs, x, y, max_w, sz, color, lh, align="left"):
    words = []
    for text, bold in segs:
        for w in text.split(' '):
            if w:
                words.append((w, bold))
    sp_w = c.stringWidth(' ', "Pop", sz)
    lines, cur_line, cur_w = [], [], 0
    for word, bold in words:
        ww = c.stringWidth(word, "PopB" if bold else "Pop", sz)
        if cur_line and cur_w + sp_w + ww > max_w:
            lines.append(cur_line); cur_line, cur_w = [(word, bold)], ww
        else:
            cur_w = cur_w + sp_w + ww if cur_line else ww
            cur_line.append((word, bold))
    if cur_line:
        lines.append(cur_line)
    for i, line in enumerate(lines):
        lx = x
        is_last = (i == len(lines) - 1)
        if align == "justify" and not is_last and len(line) > 1:
            total_word_w = sum(c.stringWidth(w, "PopB" if b else "Pop", sz) for w, b in line)
            gap = (max_w - total_word_w) / (len(line) - 1)
            for j, (word, bold) in enumerate(line):
                fn = "PopB" if bold else "Pop"
                c.setFont(fn, sz); c.setFillColor(TD if bold else color)
                c.drawString(lx, y - i * lh, word)
                lx += c.stringWidth(word, fn, sz) + gap
        else:
            for j, (word, bold) in enumerate(line):
                fn = "PopB" if bold else "Pop"
                c.setFont(fn, sz); c.setFillColor(TD if bold else color)
                c.drawString(lx, y - i * lh, word)
                lx += c.stringWidth(word, fn, sz)
                if j < len(line) - 1:
                    lx += sp_w
    return len(lines) * lh

def sec_hdr(c, title, x, y, fg, bg, accent_w=CW):
    rr(c, x, y-3, accent_w, 17, r=5, fill=bg)
    c.setFillColor(fg); c.rect(x, y-3, 4, 17, fill=1, stroke=0)
    c.setFont("PopB", 8); c.setFillColor(fg)
    c.drawString(x+10, y+2.7, title.upper())
    return y - 3 - 8

def hline(c, x, y, w, col=SAND, lw=0.5):
    c.setStrokeColor(col); c.setLineWidth(lw); c.line(x, y, x+w, y)

def dot_bg(c, x, y, w, h, sp=24):
    c.setFillColor(LAV); c.setFillAlpha(0.18)
    xi = x
    while xi <= x+w:
        yi = y
        while yi <= y+h:
            c.circle(xi, yi, 0.9, fill=1, stroke=0)
            yi += sp
        xi += sp
    c.setFillAlpha(1.0)

def top_bar(c):
    segs = [(0, W//3, LAV_D), (W//3, W//3, MNT_D), (2*W//3, W//3, PCH_D)]
    for sx, sw, col in segs:
        c.setFillColor(col); c.rect(sx, H-6, sw, 6, fill=1, stroke=0)

def footer(c, pg):
    hline(c, MX, MY+4, CW, LAV, 0.6)
    c.setFont("Pop", 6.5); c.setFillColor(TS)
    c.drawString(MX, MY-5, "My Reading Town  -  Fernando Pinto Villarroel  -  2026")
    c.setFont("PopB", 6.5); c.setFillColor(LAV_D)
    c.drawRightString(W-MX, MY-5, f"{pg} / 2")


def page1(c):
    c.setFillColor(CREAM); c.rect(0,0,W,H,fill=1,stroke=0)
    dot_bg(c, MX, MY, CW, H-2*MY)
    top_bar(c)

    logo_size = 52
    draw_logo_rounded(c, W-MX-logo_size, H-MY-logo_size-6, logo_size)

    ty = H - MY - 30
    c.setFont("PopB", 25); c.setFillColor(TD)
    c.drawCentredString(W/2, ty, "My Reading Town")
    c.setFont("PopM", 9); c.setFillColor(TM)
    c.drawCentredString(W/2, ty-26, "Resumen Ejecutivo - Tarea 4 - Proyectos de Software y Startups")
    c.setStrokeColor(LAV); c.setLineWidth(2.5)
    c.line(W/2-120, ty-35, W/2+120, ty-35)
    c.setFont("PopL", 8); c.setFillColor(TS)
    c.drawCentredString(W/2, ty-48, "Fernando Pinto Villarroel - Jala University - 31 de mayo, 2026")

    cur = ty - 60
    cur -= 10

    cur = sec_hdr(c, "Declaración del Problema", MX, cur, LAV_D, LAV_L)
    cur -= 8
    prob = [
        ("Hay miles de personas que quieren leer más pero no lo logran, y el problema", False),
        (" no es la falta de voluntad.", True),
        (" La lectura simplemente", False),
        (" no puede competir contra la dopamina inmediata", True),
        (" que ofrecen TikTok, Instagram o los videojuegos casuales en el celular."
         " Cuando alguien lee 10 páginas no pasa nada visible,", False),
        (" no hay recompensa, no hay progresión,", True),
        (" y el cerebro termina prefiriendo la opción que sí le da algo a cambio."
         " Esa diferencia de diseño de experiencia es lo que", False),
        (" mata el hábito lector", True),
        (" antes de que se forme.", False),
    ]
    used = wrap_text_rich(c, prob, MX+6, cur, CW-12, 8.5, TM, 14.5, align="justify")
    cur -= used + 14

    cur = sec_hdr(c, "Solución Propuesta", MX, cur, MNT_D, MNT_L)
    cur -= 8
    sol = [
        ("My Reading Town es una app móvil para Android que convierte cada página leída"
         " en recursos para construir una aldea virtual animada. El usuario registra", False),
        (" en menos de 10 segundos", True),
        (" cuántas páginas leyó, y al instante recibe monedas, madera, gemas y metal"
         " que puede gastar en edificios, habitantes y mejoras de su aldea. Todo", False),
        (" funciona offline, sin cuenta y sin suscripción,", True),
        (" con los datos guardados localmente en el dispositivo."
         " La lectura real se vuelve la", False),
        (" moneda principal de un juego de construcción", True),
        (" con profundidad real, no un simple tracker disfrazado.", False),
    ]
    used = wrap_text_rich(c, sol, MX+6, cur, CW-12, 8.5, TM, 14.5, align="justify")
    cur -= used + 14

    cur = sec_hdr(c, "Propuesta de Valor y Beneficios Clave", MX, cur, PCH_D, PCH_L)
    cur -= 8

    uvp = [
        ("No existe nada parecido en el mercado:", True),
        (" My Reading Town es la", False),
        (" única app", True),
        (" que convierte las páginas que lees en recursos reales para construir una aldea"
         " animada con habitantes propios, edificios mejorables y eventos estacionales."
         " No es un tracker con un skin de juego, es un", False),
        (" juego de construcción con profundidad", True),
        (" donde la moneda de progresión es la lectura real. Todo", False),
        (" offline, sin cuentas ni paywalls", True),
        (" que bloqueen el progreso principal, lo que lo hace accesible y respetuoso"
         " del usuario desde el primer día, pero con modalidad", False),
        (" freemium", True),
        (" en la que el usuario puede adquirir nuevas especies de aldeanos y recursos"
         " extra a través de compras opcionales dentro de la app (IAP) y anuncios breves con recompensa (Rewarded Ads).", False),
    ]
    used = wrap_text_rich(c, uvp, MX+6, cur, CW-12, 8.5, TM, 14.5, align="justify")
    cur -= used - 2

    cards = [
        (LAV_D, LAV_L, LAV,   "Recompensa Inmediata",
         "El usuario obtiene recursos para su aldea al instante cuando registra páginas leídas, "
         "cerrando el habit loop que la lectura sola no puede cerrar."),
        (MNT_D, MNT_L, MNT,   "Progresión Sostenida",
         "43 especies, 8 edificios con 3 niveles cada uno, sistema de misiones por objetivos y 13 eventos garantizan "
         "siempre un objetivo nuevo para retener al usuario a largo plazo."),
        (PCH_D, PCH_L, PCH,   "Cero Fricción",
         "Sin servidor, sin cuenta, sin suscripción. Freemium con 100% del "
         "juego gratis baja la barrera al mínimo. Soporte inicial en 5 idiomas (ES, EN, FR, PT, IT)."),
    ]
    cw = (CW - 12) / 3
    card_h = 72
    for i, (fg, bg, bdr, title, desc) in enumerate(cards):
        cx = MX + i*(cw+6)
        cy = cur - card_h
        rr(c, cx, cy, cw, card_h, r=9, fill=bg)
        c.setStrokeColor(bdr); c.setLineWidth(1); c.roundRect(cx,cy,cw,card_h,9,stroke=1,fill=0)
        c.setFillColor(fg); c.roundRect(cx, cy+card_h/2-14, 4, 28, 2, fill=1, stroke=0)
        c.setFont("PopB", 7.5); c.setFillColor(fg)
        c.drawString(cx+10, cy+card_h-14, title)
        wrap_text(c, desc, cx+10, cy+card_h-26, cw-16, "Pop", 7.3, TM, 12)
    cur -= card_h + 24

    cur = sec_hdr(c, "Métricas de Éxito", MX, cur, SKY_D, SKY_L)
    cur -= 4

    metrics = [
        ("North Star",     "Páginas / usuario activo / semana",   "≥ 80 páginas",        "Si sube, todo lo demás está funcionando"),
        ("Retención D7",   "% usuarios activos el día 7",         "≥ 30%",             "El habit loop (hábito) se está formando"),
        ("Retención D30",  "% usuarios activos el día 30",        "≥ 20%",             "Hábito sostenido en el tiempo"),
        ("DAU / MAU",      "Usuarios activos diarios vs mensuales (frecuencia)",  "≥ 25%",             "Qué tan 'pegajosa' es la app día a día"),
        ("MAU",            "Usuarios activos mensuales",            "1.000 en mes 12",     "Umbral mínimo de sostenibilidad del negocio"),
        ("ARPU",           "Ingreso promedio por usuario / mes",  "≥ $0.30 USD",       "Valida si el modelo freemium genera caja"),
        ("Conversión IAP",      "% usuarios que realizan una compra en la app",  "≥ 2%",              "Disposición real a pagar dentro de la app"),
        ("Rating",         "Calificación en Google Play Store",   "≥ 4.2 estrellas",   "Calidad percibida. Afecta descargas orgánicas"),
    ]

    rh = 17
    cws = [CW*0.16, CW*0.34, CW*0.16, CW*0.34]
    cxs = [MX, MX+cws[0], MX+cws[0]+cws[1], MX+cws[0]+cws[1]+cws[2]]
    hdrs = ["Tipo", "Métrica", "Meta", "Significado"]

    rr(c, MX, cur-rh+2, CW, rh, r=5, fill=SKY_D)
    for j, hd in enumerate(hdrs):
        c.setFont("PopB", 7); c.setFillColor(WHITE)
        c.drawCentredString(cxs[j] + cws[j]/2, cur-rh+8, hd)
    cur -= rh

    acc_cols = [LAV_D, MNT_D, PCH_D, SKY_D, RSE_D, LAV_D, MNT_D, PCH_D]
    for i, row in enumerate(metrics):
        ry = cur - rh + 2
        rr(c, MX, ry, CW, rh, r=0, fill=SKY_L if i%2==0 else WHITE)
        c.setFillColor(acc_cols[i]); c.rect(MX, ry, 3, rh, fill=1, stroke=0)
        for j, cell in enumerate(row):
            fn = "PopB" if j in (0,2) else "Pop"
            fc = acc_cols[i] if j==0 else (MNT_D if j==2 else TM)
            c.setFont(fn, 7.2); c.setFillColor(fc)
            c.drawCentredString(cxs[j] + cws[j]/2, ry+6, cell)
        c.setStrokeColor(SAND); c.setLineWidth(0.3)
        c.line(MX, ry, MX+CW, ry)
        cur -= rh

    footer(c, 1)


def draw_roadmap(c, x, y, w, h):
    quarters = [
        (MNT_D, MNT_L, MNT,   "Q1 - Validación",    "Enero - Marzo",
         ["Registro de lectura", "Recursos al instante", "Aldea básica 3 edificios", "Flujo registro páginas < 10 seg"],
         ["Retención D7 ≥ 30%", "≥ 50 páginas/usuario/semana"]),
        (SKY_D, SKY_L, SKY,   "Q2 - Progresión",    "Abril - Junio",
         ["Sistema de misiones", "8 edificios × 3 niveles cada uno", "Primeras especies", "Eventos iniciales"],
         ["DAU/MAU ≥ 25%", "Retención D30 ≥ 20%"]),
        (PCH_D, PCH_L, PCH,   "Q3 - Monetización",  "Julio - Septiembre",
         ["Anuncios recompensados", "Sistema de gemas", "Primeros IAP (In-App Purchases)", "Test freemium"],
         ["ARPU ≥ $0.30", "Conversión ≥ 2%"]),
        (RSE_D, RSE_L, RSE,   "Q4 - Escala",        "Octubre - Diciembre",
         ["13 eventos estacionales", "Rueda de la suerte", "Minijuegos literarios", "App Store Optimization (ASO)"],
         ["1.000 MAU", "Rating ≥ 4.2 estrellas"]),
    ]
    qw = (w - 12) / 4
    for i, (fg, bg, bdr, title, months, feats, metric) in enumerate(quarters):
        qx = x + i*(qw+4)
        rr(c, qx, y, qw, h, r=9, fill=bg)
        c.setStrokeColor(bdr); c.setLineWidth(0.9); c.roundRect(qx,y,qw,h,9,stroke=1,fill=0)
        stripe_h = 18
        c.setFillColor(fg); c.roundRect(qx, y+h-stripe_h, qw, stripe_h, 9, fill=1, stroke=0)
        c.rect(qx, y+h-stripe_h, qw, stripe_h/2, fill=1, stroke=0)
        c.setFont("PopB", 7); c.setFillColor(WHITE)
        tw = c.stringWidth(title,"PopB",7)
        c.drawString(qx+(qw-tw)/2, y+h-12, title)
        c.setFont("Pop", 6.2); c.setFillColor(fg)
        mw = c.stringWidth(months,"Pop",6.2)
        c.drawString(qx+(qw-mw)/2, y+h-stripe_h-9, months)
        fy = y+h-stripe_h-20
        for feat in feats:
            c.setFillColor(fg); c.circle(qx+9, fy+3, 2.5, fill=1, stroke=0)
            c.setFont("Pop", 6.5); c.setFillColor(TD)
            c.drawString(qx+15, fy, feat)
            fy -= 11
        pill_h = 30; pill_y = y+4
        rr(c, qx+5, pill_y, qw-10, pill_h, r=6, fill=WHITE)
        c.setStrokeColor(bdr); c.setLineWidth(0.6); c.roundRect(qx+5,pill_y,qw-10,pill_h,6,stroke=1,fill=0)
        for mi, ml in enumerate(metric):
            fn = "PopB" if mi==0 else "Pop"; sz = 6.5 if mi==0 else 6
            col = fg if mi==0 else TM
            c.setFont(fn,sz); c.setFillColor(col)
            lw2 = c.stringWidth(ml,fn,sz)
            c.drawString(qx+5+(qw-10-lw2)/2, pill_y+pill_h-12-mi*10, ml)

    spine_y = y + h + 8
    spine_x0 = x + qw / 2
    spine_x1 = x + 3 * (qw + 4) + qw / 2
    c.setStrokeColor(TS); c.setLineWidth(0.7)
    c.setDash([3, 2])
    c.line(spine_x0, spine_y, spine_x1, spine_y)
    c.setDash()

    node_xs = [x + i * (qw + 4) + qw / 2 for i in range(4)]
    quarter_colors = [MNT_D, SKY_D, PCH_D, RSE_D]
    quarter_end_months = ["Marzo", "Junio", "Septiembre", "Diciembre"]

    for i, (nx, fg) in enumerate(zip(node_xs, quarter_colors)):
        d = 4
        c.setFillColor(fg)
        p = c.beginPath()
        p.moveTo(nx, spine_y + d)
        p.lineTo(nx + d, spine_y)
        p.lineTo(nx, spine_y - d)
        p.lineTo(nx - d, spine_y)
        p.close()
        c.drawPath(p, fill=1, stroke=0)
        c.setFont("Pop", 5.2); c.setFillColor(TS)
        lbl = quarter_end_months[i]
        c.drawCentredString(nx, spine_y + d + 4, lbl)


def draw_pie(c, cx, cy, r, data, title, leg_right=None, pie_r_override=None, pie_cy_override=None):
    pr  = pie_r_override  if pie_r_override  is not None else r
    pcy = pie_cy_override if pie_cy_override is not None else cy
    if title:
        c.setFont("PopB", 8); c.setFillColor(TD)
        c.drawString(cx - c.stringWidth(title,"PopB",8)/2, pcy+pr+16, title)
    start = 90
    for row in data:
        label, pct, color, amt = row[0], row[1], row[2], row[3]
        sweep = 360*pct/100; end = start-sweep
        c.setFillColor(color); c.setStrokeColor(WHITE); c.setLineWidth(1.2)
        c.wedge(cx-pr, pcy-pr, cx+pr, pcy+pr, end, sweep, fill=1, stroke=1)
        if pct >= 7:
            mid = math.radians(start - sweep/2)
            lx = cx + pr*0.71*math.cos(mid); ly = pcy + pr*0.71*math.sin(mid)
            c.setFont("PopB", 6); c.setFillColor(WHITE)
            ps = f"{pct}%"
            c.drawString(lx-c.stringWidth(ps,"PopB",6)/2, ly-3, ps)
        start = end
    c.setFillColor(CREAM); c.setStrokeColor(WHITE); c.setLineWidth(1.5)
    ir = pr*0.46; c.circle(cx, pcy, ir, fill=1, stroke=1)
    c.setFont("PopB", 7); c.setFillColor(TD)
    c.drawString(cx-c.stringWidth("$5.015","PopB",7)/2, pcy+2, "$5.015")
    c.setFont("Pop", 6); c.setFillColor(TS)
    c.drawString(cx-c.stringWidth("total año 1","Pop",6)/2, pcy-8, "total año 1")
    leg_x = cx + r + 16
    if leg_right is None:
        leg_right = leg_x + 200
    row_h = 16
    n = len(data)
    leg_y_top = cy + (n - 1) * row_h / 2
    x_name   = leg_x + 14
    x_desc   = x_name + 82
    x_type_r = leg_right - 84
    x_pct_r  = leg_right - 62
    x_amt_r  = leg_right - 20
    type_palette = {"Indirecto": (LAV_D, LAV_L), "Directo": (MNT_D, MNT_L)}
    for i, row in enumerate(data):
        label, pct, col, amt = row[0], row[1], row[2], row[3]
        cost_type = row[4] if len(row) > 4 else None
        time_tag  = row[5] if len(row) > 5 else None
        desc      = row[6] if len(row) > 6 else None
        ly = leg_y_top - i * row_h
        if i % 2 == 0:
            rr(c, leg_x - 3, ly - 3, leg_right - leg_x + 6, row_h, r=4, fill=CREAM)
        c.setFillColor(col); c.roundRect(leg_x, ly + 4, 8, 8, 2, fill=1, stroke=0)
        c.setFont("PopB", 7); c.setFillColor(TD)
        c.drawString(x_name, ly + 6, label)
        pill_txt = ""; pw = 0
        if cost_type:
            pill_txt = f"{cost_type}  -  {time_tag}" if time_tag else cost_type
            pw = c.stringWidth(pill_txt, "PopB", 5.5) + 10
        pill_x = x_type_r - pw
        if desc:
            d = desc
            c.setFont("Pop", 6); c.setFillColor(TS)
            dmax = pill_x - 6 - x_desc
            while d and c.stringWidth(d, "Pop", 6) > dmax:
                d = d[:-4] + "…"
            c.drawString(x_desc, ly + 6, d)
        if cost_type:
            tc_fg, tc_bg = type_palette.get(cost_type, (TS, SAND))
            rr(c, pill_x, ly + 1, pw, 11, r=3, fill=tc_bg)
            c.setFont("PopB", 5.5); c.setFillColor(tc_fg)
            c.drawString(pill_x + 5, ly + 5, pill_txt)
        c.setFont("PopB", 7.5); c.setFillColor(col)
        c.drawRightString(x_pct_r, ly + 6, f"{pct}%")
        c.setFont("PopM", 6.5); c.setFillColor(TM)
        c.drawRightString(x_amt_r, ly + 6, amt)
        if i < n - 1:
            c.setStrokeColor(SAND); c.setLineWidth(0.4)
            c.line(leg_x, ly - 2, leg_right, ly - 2)


def draw_line_chart(c, x, y, w, h, title):
    panel_w = 160
    chart_w = w - panel_w - 14

    rr(c, x-22, y-20, w+30, h+30, r=8, fill=WHITE)
    c.setStrokeColor(SAND); c.setLineWidth(0.5)
    c.roundRect(x-22, y-20, w+30, h+30, 8, stroke=1, fill=0)

    if title:
        c.setFont("PopB", 7.5); c.setFillColor(TD)
        c.drawString(x, y+h+18, title)

    months  = [0,    3,   6,   9,   12,  15,  18,   21,   24]
    revenue = [0,   20,  80, 140, 200, 420, 800, 1400, 2200]
    costs   = [420,380, 360, 350, 340, 380, 420,  460,  500]
    cumrev  = [0,   60, 300, 720, 1320, 2580, 4980, 9180, 15780]
    cumcost = [420,1560,2640,3690, 4710, 5850, 7110, 8490,  9990]
    maxv = 12000
    xs = lambda m: x + m*(chart_w/24)
    ys = lambda v: y + min(v, maxv)*(h/maxv)

    bands = [(0,3,LAV_L),(3,6,MNT_L),(6,9,PCH_L),(9,12,RSE_L),
             (12,15,LAV_L),(15,18,MNT_L),(18,21,PCH_L),(21,24,RSE_L)]
    for b0,b1,bc in bands:
        c.setFillColor(bc); c.setFillAlpha(0.45)
        c.rect(xs(b0), y, (b1-b0)*(chart_w/24), h, fill=1, stroke=0)
    c.setFillAlpha(1)

    for v in [0,3000,6000,9000,12000]:
        c.setStrokeColor(SAND); c.setLineWidth(0.4)
        c.setDash([2,3]); c.line(x, ys(v), x+chart_w, ys(v)); c.setDash()
        c.setFont("Pop", 5.5); c.setFillColor(TS)
        lbl = "$0" if v==0 else f"${v//1000}K"
        c.drawRightString(x-3, ys(v)-2, lbl)

    c.setStrokeColor(TS); c.setLineWidth(0.6); c.setDash()
    c.line(x, y, x, y+h); c.line(x, y, x+chart_w, y)

    for m in [0,6,12,18,24]:
        c.setFont("Pop", 5.5); c.setFillColor(TS)
        c.drawString(xs(m)-6, y-10, f"m{m}")

    c.setFillColor(MNT_L); c.setFillAlpha(0.35)
    p = c.beginPath(); p.moveTo(xs(0), ys(0))
    for i in range(1,9): p.lineTo(xs(months[i]), ys(revenue[i]))
    for i in range(8,-1,-1): p.lineTo(xs(months[i]), y)
    p.close(); c.drawPath(p, fill=1, stroke=0)
    c.setFillAlpha(1)

    line_specs = [
        (cumrev,  LAV_D, [4,3], 1.6),
        (cumcost, PCH_D, [2,4], 1.6),
        (costs,   RSE_D, [],    1.6),
        (revenue, MNT_D, [],    2.0),
    ]
    for vals, col, dash, lw in line_specs:
        c.setStrokeColor(col); c.setLineWidth(lw)
        c.setDash(dash if dash else [])
        p = c.beginPath(); p.moveTo(xs(months[0]), ys(vals[0]))
        for i in range(1,9): p.lineTo(xs(months[i]), ys(vals[i]))
        c.drawPath(p, fill=0, stroke=1)
    c.setDash()

    key_i = [2, 4, 6, 8]
    for vals, col, _, _ in line_specs:
        for i in key_i:
            c.setFillColor(col); c.setStrokeColor(WHITE); c.setLineWidth(0.8)
            c.circle(xs(months[i]), ys(vals[i]), 3.5, fill=1, stroke=1)

    be_x = xs(15)
    c.setStrokeColor(PCH_D); c.setLineWidth(0.7); c.setDash([3,2])
    c.line(be_x, y, be_x, y+h); c.setDash()
    rr(c, be_x-22, y+h-30, 44, 20, r=4, fill=PCH_L)
    c.setFont("PopB", 4.5); c.setFillColor(PCH_D)
    c.drawCentredString(be_x, y+h-15, "Break-even")
    c.drawCentredString(be_x, y+h-21, "mensual")
    c.drawCentredString(be_x, y+h-27, "~mes 15")

    be2_x = xs(20)
    c.setStrokeColor(SKY_D); c.setLineWidth(0.7); c.setDash([3,2])
    c.line(be2_x, y, be2_x, y+h); c.setDash()
    rr(c, be2_x-22, y+h-72, 44, 20, r=4, fill=SKY_L)
    c.setFont("PopB", 4.5); c.setFillColor(SKY_D)
    c.drawCentredString(be2_x, y+h-57, "Break-even")
    c.drawCentredString(be2_x, y+h-63, "acumulado")
    c.drawCentredString(be2_x, y+h-69, "~mes 20")

    panel_x = x + chart_w + 14
    col_gap  = 6
    col_w    = (panel_w - col_gap) // 2

    col1_x  = panel_x
    col2_x  = panel_x + col_w + col_gap
    col1_cx = col1_x + col_w // 2
    col2_cx = col2_x + col_w // 2

    mid_x = panel_x + col_w + col_gap // 2 - 4
    c.setStrokeColor(SAND); c.setLineWidth(0.4)
    c.line(mid_x, y - 18, mid_x, y + h + 8)

    grid_cols = [
        (col1_x, col1_cx, [
            (MNT_D, "Ingreso mensual",   [("m0","$0"),    ("m6","$80"),    ("m12","$200"),   ("m18","$800"),   ("m24","$2,200")]),
            (RSE_D, "Costo mensual",     [("m0","$420"),  ("m6","$360"),   ("m12","$340"),   ("m18","$420"),   ("m24","$500")]),
        ]),
        (col2_x, col2_cx, [
            (LAV_D, "Ingreso acumulado", [("m0","$0"),    ("m6","$300"),   ("m12","$1,320"), ("m18","$4,980"), ("m24","$15,780")]),
            (PCH_D, "Costo acumulado",   [("m0","$420"),  ("m6","$2,640"), ("m12","$4,710"), ("m18","$7,110"), ("m24","$9,990")]),
        ]),
    ]
    p_top     = y + h + 6
    p_bot     = y - 18
    avail_h   = p_top - p_bot
    row_h     = avail_h / 2
    entry_h   = 9 + 5 * 7
    inner_pad = 4

    div_y = p_top - row_h + 1
    c.setStrokeColor(SAND); c.setLineWidth(0.4)
    c.line(panel_x, div_y, panel_x + panel_w, div_y)

    for col_x, col_cx, entries in grid_cols:
        for ei, (col, name, vals) in enumerate(entries):
            py = p_top - ei * row_h - inner_pad
            c.setFillColor(col)
            c.roundRect(col_x, py-5, 6, 6, 2, fill=1, stroke=0)
            c.setFont("PopB", 5.8); c.setFillColor(TD)
            c.drawString(col_x+9, py-4, name)
            py -= 9
            for mv, vl in vals:
                c.setFont("Pop", 5.8); c.setFillColor(TS)
                c.drawCentredString(col_cx - 10, py-3, mv)
                c.setFont("PopB", 5.8); c.setFillColor(col)
                c.drawCentredString(col_cx + 10, py-3, vl)
                py -= 8.3


def page2(c):
    c.setFillColor(CREAM); c.rect(0,0,W,H,fill=1,stroke=0)
    dot_bg(c, MX, MY, CW, H-2*MY)
    top_bar(c)

    logo_size = 42
    draw_logo_rounded(c, W-MX-logo_size, H-MY-logo_size+18, logo_size)

    ty = H - MY - 14
    c.setFont("PopB", 18); c.setFillColor(TD)
    c.drawString(MX, ty, "Implementación e Inversión")
    c.setStrokeColor(MNT); c.setLineWidth(2.5)
    c.line(MX, ty-8, MX+260, ty-8)

    cur = ty - 30

    cur = sec_hdr(c, "Hoja de Ruta - 2026", MX, cur, MNT_D, MNT_L)
    rm_h = 112
    tl_gap = 15
    draw_roadmap(c, MX, cur-rm_h-tl_gap, CW, rm_h)
    cur -= rm_h + tl_gap + 20

    cur = sec_hdr(c, "Financiamiento y Estrategia", MX, cur, LAV_D, LAV_L)

    fin_data = [
        ("Pre-lanzamiento Q1", "$50-100",    "Bootstrapping",        "Registro en Play Store y herramientas",   "App funcional en emulador"),
        ("Lanzamiento Q2-Q3",  "$0",         "Tiempo propio",        "Sin servidor, costos fijos ~$0",       "Publicación en Play Store"),
        ("Validación Q3",      "$200-500",   "IAP iniciales",        "Testing y micro-marketing",            "≥ 100 MAU activos"),
        ("Escala Q4+",         "$1K-3K",     "Ingresos + subvención","Contenido nuevo, traducciones idiomas","ARPU ≥ $0.30 sostenido 2 meses"),
        ("Año 2",              "$10K-30K",   "Ángel / concurso",     "Solo con métricas validadas",          "1.000 MAU + ROI mensual positivo"),
    ]
    frh = 16
    fcws = [CW*0.17, CW*0.10, CW*0.18, CW*0.30, CW*0.25]
    fcxs = [MX,
            MX+fcws[0],
            MX+fcws[0]+fcws[1],
            MX+fcws[0]+fcws[1]+fcws[2],
            MX+fcws[0]+fcws[1]+fcws[2]+fcws[3]]
    fhdrs = ["Etapa", "Capital", "Fuente", "Uso", "Condición / Gatillo"]

    rr(c, MX, cur-frh+2, CW, frh, r=5, fill=LAV_D)
    for j, hd in enumerate(fhdrs):
        c.setFont("PopB", 6.5); c.setFillColor(WHITE)
        c.drawCentredString(fcxs[j] + fcws[j]/2, cur-frh+8, hd)
    cur -= frh

    faccs = [LAV_D, MNT_D, PCH_D, RSE_D, SKY_D]
    for i, row in enumerate(fin_data):
        ry = cur - frh + 2; bg = LAV_L if i%2==0 else WHITE
        rr(c, MX, ry, CW, frh, r=0, fill=bg)
        c.setFillColor(faccs[i]); c.rect(MX, ry, 3, frh, fill=1, stroke=0)
        for j, cell in enumerate(row):
            fn = "PopB" if j==0 else "Pop"
            fc = faccs[i] if j==0 else TM
            c.setFont(fn, 6.5); c.setFillColor(fc)
            c.drawCentredString(fcxs[j] + fcws[j]/2, ry+6, cell)
        c.setStrokeColor(SAND); c.setLineWidth(0.3)
        c.line(MX, ry, MX+CW, ry)
        cur -= frh
    cur -= 10

    cur -= 8
    cur = sec_hdr(c, "Desglose de Costos - Año 1", MX, cur, PCH_D, PCH_L)

    pie_data = [
        ("Desarrollo",  62, LAV_D, "$3.120", "Indirecto", "Tiempo", "~300 h desarrollo + 12 h/mes a $10/h"),
        ("Marketing",   14, RSE_D, "$700",   "Directo",   None,     "ASO, orgánico, micro-influencers"),
        ("Assets",      10, MNT_D, "$500",   "Indirecto", "Tiempo", "Pipeline IA propio; ~50 h a $10/h"),
        ("Soporte",      8, PCH_D, "$400",   "Indirecto", None,     "Bug fixes, reseñas, compatibilidad Android"),
        ("Comisiones",   5, SKY_D, "$270",   "Directo",   None,     "15% Google Play sobre In-App Purchases"),
        ("Admin",        1, TS,    "$25",    "Directo",   None,     "Play Store developer account"),
    ]
    pie_r = 52
    pie_cx = MX + pie_r + 6
    pie_cy = cur - pie_r
    draw_pie(c, pie_cx, pie_cy, pie_r, pie_data, "", leg_right=MX + CW,
             pie_r_override=44, pie_cy_override=pie_cy + 9)
    cur = pie_cy - pie_r - 6

    roi_y_start = cur
    roi_y_start = sec_hdr(c, "Proyección de ROI - 24 meses", MX, roi_y_start, MNT_D, MNT_L)

    chart_h = 88
    draw_line_chart(c, MX+24, roi_y_start - chart_h - 8, CW-36, chart_h, "")
    cur = roi_y_start - chart_h - 42

    cur -= 5
    cur = sec_hdr(c, "Evaluación de Riesgos y Mitigación", MX, cur, RSE_D, RSE_L)

    risks = [
        ("Bug crítico post-lanzamiento",       "Alto", "Alto",  "Rollback en Play Console; canal de reporte visible en la app"),
        ("Habit loop no retiene usuarios D7",  "Media", "Alto",  "Iteración rápida del flujo; encuestas a primeros 50 usuarios activos"),
        ("Burnout del desarrollador",          "Media", "Alto",  "Ritmo sostenible; colaborador en Q3; sin fechas públicas que generen presión"),
        ("BookTok no genera tracción",         "Media", "Medio", "Redirigir a Reddit/Discord; medir costo por instalación por canal"),
        ("Ingresos insuficientes",             "Media", "Medio", "Umbral 500 MAU definido antes del lanzamiento para decidir pivot"),
        ("Rechazo por políticas Google Play",  "Baja",  "Medio",  "Revisar COPPA y Privacy Policy antes del lanzamiento"),
    ]
    rrh = 16
    rcws = [CW*0.28, CW*0.09, CW*0.09, CW*0.54]
    rcxs = [MX, MX+rcws[0], MX+rcws[0]+rcws[1], MX+rcws[0]+rcws[1]+rcws[2]]
    rhdrs = ["Riesgo", "Probabilidad", "Impacto", "Mitigación"]

    rr(c, MX, cur-rrh+2, CW, rrh, r=5, fill=RSE_D)
    for j, hd in enumerate(rhdrs):
        c.setFont("PopB", 6.5); c.setFillColor(WHITE)
        c.drawCentredString(rcxs[j] + rcws[j]/2, cur-rrh+8, hd)
    cur -= rrh

    pbg = {"Alto": RSE_L, "Medio": PCH_L, "Baja": MNT_L, "Media": PCH_L}
    pfc = {"Alto": RSE_D, "Medio": PCH_D, "Baja": MNT_D, "Media": PCH_D}
    for i, row in enumerate(risks):
        ry = cur - rrh + 2; bg = RSE_L if i%2==0 else WHITE
        rr(c, MX, ry, CW, rrh, r=0, fill=bg)
        c.setFillColor(RSE_D); c.rect(MX, ry, 3, rrh, fill=1, stroke=0)
        for j, cell in enumerate(row):
            if j in (1,2):
                pw = c.stringWidth(cell,"PopB",6)+8
                pill_x = rcxs[j] + (rcws[j] - pw) / 2
                rr(c, pill_x, ry+2, pw, rrh-4, r=3, fill=pbg.get(cell,LAV_L))
                c.setFont("PopB",6); c.setFillColor(pfc.get(cell,LAV_D))
                c.drawCentredString(rcxs[j] + rcws[j]/2, ry+6, cell)
            else:
                fn = "PopB" if j==0 else "Pop"
                fc = RSE_D if j==0 else TM
                c.setFont(fn, 6.5); c.setFillColor(fc)
                c.drawCentredString(rcxs[j] + rcws[j]/2, ry+6, cell)
        c.setStrokeColor(SAND); c.setLineWidth(0.3)
        c.line(MX, ry, MX+CW, ry)
        cur -= rrh

    footer(c, 2)


OUT = "/home/university/Documents/Projects/jala-university/javascript-projects/OTHERS/my-reading-town/docs/startup/Assignment4.SoftwareProjectsAndStartups.05.31.2026.FerPinto.pdf"
cv = canvas.Canvas(OUT, pagesize=letter)
cv.setTitle("My Reading Town - Fernando Pinto - Tarea 4 - Proyectos de Software y Startups")
cv.setAuthor("Fernando Pinto Villarroel")

page1(cv); cv.showPage()
page2(cv); cv.save()
print("Done:", OUT)
