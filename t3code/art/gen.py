import random, math
random.seed(42)
W, H = 2560, 1600
LAKE = 1432
out = []
def a(s): out.append(s)

def ridge(base, amp, rough, seed, step=8):
    r = random.Random(seed)
    n = 2**9
    ys = [0.0]*(n+1)
    ys[0] = r.uniform(-1, 1); ys[n] = r.uniform(-1, 1)
    size, scale = n, 1.0
    while size > 1:
        half = size//2
        for i in range(half, n, size):
            ys[i] = (ys[i-half]+ys[i+half])/2 + r.uniform(-1, 1)*scale
        size = half; scale *= rough
    pts = []
    for i in range(n+1):
        x = -40 + i*(W+80)/n
        pts.append((x, base - (ys[i]*0.5+0.5)*amp))
    return pts

def ridge_path(pts, bottom):
    d = f"M{pts[0][0]:.1f},{bottom} " + " ".join(f"L{x:.1f},{y:.1f}" for x, y in pts) + f" L{pts[-1][0]:.1f},{bottom} Z"
    return d

def y_at(pts, x):
    for i in range(len(pts)-1):
        if pts[i][0] <= x <= pts[i+1][0]:
            t = (x-pts[i][0])/(pts[i+1][0]-pts[i][0])
            return pts[i][1]*(1-t)+pts[i+1][1]*t
    return pts[-1][1]

def pine(x, y, h, r):
    w = h*0.34
    tiers = 4
    d = f"M{x:.1f},{y-h:.1f} "
    right, left = [], []
    for t in range(tiers):
        f = (t+1)/tiers
        ty = y - h + h*0.92*f
        tw = w*(0.35+0.65*f)/2
        iw = tw*0.45
        right += [(x+tw, ty), (x+iw, ty-h*0.04)] if t < tiers-1 else [(x+tw, ty)]
        left = ([(x-iw, ty-h*0.04), (x-tw, ty)] if t < tiers-1 else [(x-tw, ty)]) + left
    pts = right + [(x+w*0.06, y), (x-w*0.06, y)] + left
    d += " ".join(f"L{px:.1f},{py:.1f}" for px, py in pts) + " Z"
    return d

import sys
OW, OH = (int(sys.argv[1]), int(sys.argv[2])) if len(sys.argv) > 2 else (W, H)
OUT = sys.argv[3] if len(sys.argv) > 3 else "/tmp/nightfall-art/nightfall.svg"
a(f'<svg xmlns="http://www.w3.org/2000/svg" width="{OW}" height="{OH}" viewBox="0 0 {W} {H}" preserveAspectRatio="xMidYMax slice">')
a('''<defs>
<linearGradient id="sky" x1="0" y1="0" x2="0" y2="1">
 <stop offset="0" stop-color="#04060b"/><stop offset=".38" stop-color="#080c18"/>
 <stop offset=".68" stop-color="#0f1630"/><stop offset=".9" stop-color="#1a2350"/><stop offset="1" stop-color="#202a5c"/>
</linearGradient>
<radialGradient id="horizon" cx=".5" cy=".5" r=".5">
 <stop offset="0" stop-color="#8b9cff" stop-opacity=".22"/><stop offset=".55" stop-color="#6d5cff" stop-opacity=".07"/><stop offset="1" stop-color="#000" stop-opacity="0"/>
</radialGradient>
<radialGradient id="moonhalo" cx=".5" cy=".5" r=".5">
 <stop offset="0" stop-color="#dfe5ff" stop-opacity=".30"/><stop offset=".18" stop-color="#b9c4ff" stop-opacity=".12"/>
 <stop offset=".5" stop-color="#8b9cff" stop-opacity=".04"/><stop offset="1" stop-color="#8b9cff" stop-opacity="0"/>
</radialGradient>
<radialGradient id="moonbody" cx=".38" cy=".36" r=".7">
 <stop offset="0" stop-color="#fffdf6"/><stop offset=".7" stop-color="#ece8dc"/><stop offset="1" stop-color="#cfcbc0"/>
</radialGradient>
<mask id="crescent"><rect width="100%" height="100%" fill="#000"/>
 <circle cx="2050" cy="300" r="58" fill="#fff"/><circle cx="2078" cy="282" r="54" fill="#000"/></mask>
<radialGradient id="starglow" cx=".5" cy=".5" r=".5">
 <stop offset="0" stop-color="#fff" stop-opacity=".9"/><stop offset=".25" stop-color="#cdd6ff" stop-opacity=".25"/><stop offset="1" stop-color="#cdd6ff" stop-opacity="0"/>
</radialGradient>
<linearGradient id="spark" x1="0" y1="0" x2="1" y2="0">
 <stop offset="0" stop-color="#fff" stop-opacity="0"/><stop offset=".5" stop-color="#fff" stop-opacity=".8"/><stop offset="1" stop-color="#fff" stop-opacity="0"/>
</linearGradient>
<linearGradient id="aurA" x1="0" y1="0" x2="0" y2="1">
 <stop offset="0" stop-color="#a78bfa" stop-opacity="0"/><stop offset=".35" stop-color="#8b9cff" stop-opacity=".35"/>
 <stop offset=".75" stop-color="#5eead4" stop-opacity=".75"/><stop offset=".9" stop-color="#99f6e4" stop-opacity=".9"/><stop offset="1" stop-color="#5eead4" stop-opacity="0"/>
</linearGradient>
<linearGradient id="aurB" x1="0" y1="0" x2="0" y2="1">
 <stop offset="0" stop-color="#f0abfc" stop-opacity="0"/><stop offset=".4" stop-color="#c084fc" stop-opacity=".35"/>
 <stop offset=".8" stop-color="#8b9cff" stop-opacity=".7"/><stop offset="1" stop-color="#8b9cff" stop-opacity="0"/>
</linearGradient>
<filter id="rays" x="-20%" y="-120%" width="140%" height="340%">
 <feTurbulence type="fractalNoise" baseFrequency="0.011 0.0007" numOctaves="3" seed="11" result="n"/>
 <feColorMatrix in="n" type="matrix" values="0 0 0 0 1  0 0 0 0 1  0 0 0 0 1  2.6 0 0 0 -0.75" result="na"/>
 <feComposite in="SourceGraphic" in2="na" operator="in" result="streak"/>
 <feGaussianBlur in="streak" stdDeviation="5 16" result="b"/>
 <feGaussianBlur in="SourceGraphic" stdDeviation="34" result="g"/>
 <feComponentTransfer in="g" result="g2"><feFuncA type="linear" slope=".55"/></feComponentTransfer>
 <feMerge><feMergeNode in="g2"/><feMergeNode in="b"/><feMergeNode in="b"/></feMerge>
</filter>
<filter id="milky" x="0" y="0" width="100%" height="100%">
 <feTurbulence type="fractalNoise" baseFrequency="0.007 0.014" numOctaves="5" seed="3" result="n"/>
 <feColorMatrix in="n" type="matrix" values="0 0 0 0 .72  0 0 0 0 .78  0 0 0 0 1  1.4 0 0 0 -0.58"/>
</filter>
<filter id="soft" x="-50%" y="-50%" width="200%" height="200%"><feGaussianBlur stdDeviation="60"/></filter>
<filter id="blur3"><feGaussianBlur stdDeviation="3"/></filter>
<filter id="refl" x="0" y="0" width="100%" height="100%">
 <feTurbulence type="fractalNoise" baseFrequency="0.002 0.06" numOctaves="2" seed="5" result="w"/>
 <feDisplacementMap in="SourceGraphic" in2="w" scale="18" xChannelSelector="R" yChannelSelector="G" result="d"/>
 <feGaussianBlur in="d" stdDeviation="1.5"/>
</filter>
<filter id="grain" x="0" y="0" width="100%" height="100%">
 <feTurbulence type="fractalNoise" baseFrequency=".85" numOctaves="2" seed="9" stitchTiles="stitch"/>
 <feColorMatrix type="matrix" values="0 0 0 0 1  0 0 0 0 1  0 0 0 0 1  0 0 0 .05 0"/>
</filter>
<mask id="milkymask"><rect width="100%" height="100%" fill="#000"/>
 <ellipse cx="900" cy="420" rx="1500" ry="190" fill="#fff" transform="rotate(-24 900 420)" filter="url(#soft)"/></mask>
<linearGradient id="fog" x1="0" y1="0" x2="0" y2="1">
 <stop offset="0" stop-color="#8b9cff" stop-opacity="0"/><stop offset=".6" stop-color="#8b9cff" stop-opacity=".07"/><stop offset="1" stop-color="#5eead4" stop-opacity=".05"/>
</linearGradient>
<linearGradient id="lake" x1="0" y1="0" x2="0" y2="1">
 <stop offset="0" stop-color="#121a3a"/><stop offset=".25" stop-color="#0b1026"/><stop offset="1" stop-color="#05070d"/>
</linearGradient>
<radialGradient id="vignette" cx=".5" cy=".45" r=".75">
 <stop offset=".55" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".55"/>
</radialGradient>
<clipPath id="lakeclip"><rect x="0" y="''' + str(LAKE) + '''" width="2560" height="400"/></clipPath>
</defs>''')

a(f'<rect width="{W}" height="{H}" fill="url(#sky)"/>')
# milky way
a('<g mask="url(#milkymask)" opacity=".38"><rect width="100%" height="100%" filter="url(#milky)"/></g>')
# stars
rs = random.Random(7)
cols = ["#ffffff", "#dfe6ff", "#cdd6ff", "#fff1d6", "#e9ddff"]
stars = []
for _ in range(1400):
    x = rs.uniform(0, W); y = rs.uniform(0, 1250)**1.0
    if rs.random() < y/1500: continue
    stars.append((x, y, rs.uniform(.25, 1.15), rs.uniform(.15, .85), rs.choice(cols)))
# denser in milky band
for _ in range(900):
    t = rs.uniform(-1, 1); off = rs.gauss(0, 70)
    cx, cy = 900 + t*1500*math.cos(math.radians(-24)), 420 + t*1500*math.sin(math.radians(-24))
    x = cx + off*math.sin(math.radians(24)); y = cy + off*math.cos(math.radians(24))
    if 0 < x < W and 0 < y < 1200:
        stars.append((x, y, rs.uniform(.2, .7), rs.uniform(.2, .7), rs.choice(cols)))
a('<g>' + "".join(f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{r:.2f}" fill="{c}" opacity="{o:.2f}"/>' for x, y, r, o, c in stars) + '</g>')
# bright stars
for _ in range(16):
    x, y = rs.uniform(80, W-80), rs.uniform(40, 820)
    if abs(x-2050) < 200 and abs(y-300) < 200: continue
    s = rs.uniform(10, 22)
    a(f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{s*1.6:.1f}" fill="url(#starglow)"/>')
    a(f'<rect x="{x-s*2.2:.1f}" y="{y-.5:.1f}" width="{s*4.4:.1f}" height="1" fill="url(#spark)"/>')
    a(f'<rect x="{x-s*2.2:.1f}" y="{y-.5:.1f}" width="{s*4.4:.1f}" height="1" fill="url(#spark)" transform="rotate(90 {x:.1f} {y:.1f})"/>')
    a(f'<circle cx="{x:.1f}" cy="{y:.1f}" r="1.6" fill="#fff"/>')
# shooting star
a('<g opacity=".7"><line x1="430" y1="170" x2="760" y2="330" stroke="url(#spark)" stroke-width="1.4"/><circle cx="742" cy="321" r="1.8" fill="#fff"/></g>')

# aurora curtains
def curtain(y0, amp, freq, phase, thick, grad, op, seed):
    r = random.Random(seed)
    top, bot = [], []
    for i in range(0, 161):
        x = -100 + i*(W+200)/160
        y = y0 + amp*math.sin(x*freq + phase) + amp*0.4*math.sin(x*freq*2.7 + phase*1.3)
        th = thick*(0.65 + 0.35*math.sin(x*freq*1.9 + phase*0.7)) + r.uniform(-8, 8)
        top.append((x, y - th)); bot.append((x, y))
    d = "M" + " L".join(f"{x:.1f},{y:.1f}" for x, y in top) + " L" + " L".join(f"{x:.1f},{y:.1f}" for x, y in reversed(bot)) + " Z"
    a(f'<path d="{d}" fill="url(#{grad})" opacity="{op}" filter="url(#rays)"/>')
a('<g style="mix-blend-mode:screen">')
a('<ellipse cx="1280" cy="700" rx="1500" ry="150" fill="#5eead4" opacity=".10" filter="url(#soft)"/>')
a('<ellipse cx="1850" cy="660" rx="460" ry="140" fill="#7dd3c0" opacity=".28" filter="url(#soft)"/>')
a('<ellipse cx="1850" cy="560" rx="380" ry="120" fill="#8b9cff" opacity=".18" filter="url(#soft)"/>')
curtain(700, 90, 0.0021, 0.6, 420, "aurB", .55, 1)
curtain(760, 70, 0.0027, 2.1, 340, "aurA", .75, 2)
curtain(640, 55, 0.0034, 4.0, 260, "aurA", .45, 3)
a('</g>')

# moon
a('<circle cx="2050" cy="300" r="420" fill="url(#moonhalo)"/>')
a('<g mask="url(#crescent)"><circle cx="2050" cy="300" r="58" fill="url(#moonbody)"/>')
for cx, cy, cr in [(2018, 290, 9), (2030, 322, 6), (2010, 315, 4), (2025, 268, 5), (2040, 345, 4)]:
    a(f'<circle cx="{cx}" cy="{cy}" r="{cr}" fill="#9d998f" opacity=".18"/>')
a('</g>')

# horizon glow
a('<ellipse cx="1300" cy="1180" rx="1500" ry="380" fill="url(#horizon)"/>')

# mountains
layers = [
  (1030, 380, .56, 101, ("#1f2750", "#121731"), .95),
  (1140, 300, .54, 202, ("#171d3d", "#0e1228"), 1),
  (1260, 230, .52, 303, ("#121731", "#0b0f1f"), 1),
  (1380, 150, .5, 404, ("#0a0d1a", "#06080f"), 1),
]
ridges = []
for i, (base, amp, rough, seed, (c1, c2), op) in enumerate(layers):
    pts = ridge(base, amp, rough, seed)
    ridges.append(pts)
    a(f'<linearGradient id="m{i}" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="{c1}"/><stop offset="1" stop-color="{c2}"/></linearGradient>')
    a(f'<g id="layer{i}"><path d="{ridge_path(pts, LAKE+2)}" fill="url(#m{i})" opacity="{op}"/>')
    if i == 0:
        # moonlit rim on far ridge
        a('<path d="M' + " L".join(f"{x:.1f},{y:.1f}" for x, y in pts) + '" fill="none" stroke="#a8b4ff" stroke-opacity=".18" stroke-width="1.5"/>')
    if i >= 2:
        tr = random.Random(seed)
        col = "#0d1124" if i == 2 else "#04060b"
        trees = []
        x = -20
        while x < W+20:
            y = y_at(pts, x)
            h = tr.uniform(14, 34) if i == 2 else tr.uniform(26, 70)
            trees.append(pine(x, y+3, h, tr))
            x += tr.uniform(5, 14) if i == 3 else tr.uniform(7, 20)
        a(f'<path d="{" ".join(trees)}" fill="{col}"/>')
    a('</g>')
    if i < 3:
        a(f'<rect x="0" y="{base-160}" width="{W}" height="{LAKE-base+160}" fill="url(#fog)"/>')

# lake
a(f'<rect x="0" y="{LAKE}" width="{W}" height="{H-LAKE}" fill="url(#lake)"/>')
a(f'<g clip-path="url(#lakeclip)" opacity=".42" filter="url(#refl)"><g transform="translate(0 {2*LAKE}) scale(1 -1)"><use href="#layer2"/><use href="#layer3"/></g></g>')
# moon glitter
gr = random.Random(5)
for k in range(70):
    y = LAKE + 6 + k*2.4 + gr.uniform(-1, 1)
    w = gr.uniform(8, 46) * (1 + k/60)
    x = 2050 + gr.gauss(0, 10 + k*0.6) - w/2
    a(f'<rect x="{x:.1f}" y="{y:.1f}" width="{w:.1f}" height="1.2" rx=".6" fill="#e6ebff" opacity="{max(.05, .55 - k*.007):.2f}"/>')
a(f'<line x1="0" y1="{LAKE}" x2="{W}" y2="{LAKE}" stroke="#8b9cff" stroke-opacity=".18" stroke-width="1"/>')
# low mist on lake
a(f'<ellipse cx="1280" cy="{LAKE+10}" rx="1600" ry="40" fill="#8b9cff" opacity=".06" filter="url(#soft)"/>')

a(f'<rect width="{W}" height="{H}" fill="url(#vignette)"/>')
a(f'<rect width="{W}" height="{H}" filter="url(#grain)"/>')
a('</svg>')
open(OUT, "w").write("\n".join(out))
print(len("\n".join(out)))
