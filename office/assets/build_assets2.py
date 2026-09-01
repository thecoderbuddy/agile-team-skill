#!/usr/bin/env python3
"""v2 asset pipeline: 32px LPC office tiles + 64px human characters.
Builds office/tiles.png (packed sprite atlas), office/agents.png (10 cols x 4 dirs
per agent: walk frames 0-8 + sit), office/map.json, z_preview2.png for QA.
Sources: office/assets/lpc/ (OpenGameArt LPC packs — see CREDITS.md). Run from office/assets/."""
from PIL import Image, ImageDraw
import json

T = 32
L = "lpc/tiles/"
walls  = Image.open(L + "walls/lpc-walls/walls.png").convert("RGBA")
floors = Image.open(L + "floors/lpc-floors/floors.png").convert("RGBA")
furn   = Image.open(L + "furniture-dark-wood.png").convert("RGBA")
appl   = Image.open(L + "office-appliances.png").convert("RGBA")
prop = lambda n: Image.open(L + "office/" + n + ".png").convert("RGBA")
laptop, cooler_s = prop("Laptop"), prop("Water Cooler")
copier, portraits, tv = prop("Copy Machine"), prop("Office Portraits"), prop("TV, Widescreen")
desk_ornate, card, coffee_mk = prop("Desk, Ornate"), prop("Card Table"), prop("Coffee Maker")

def crop(sheet, c, r, w=1, h=1):
    return sheet.crop((c * T, r * T, (c + w) * T, (r + h) * T))

def colorize(im, rgb, lift=1.0):
    g = im.convert("L")
    if lift != 1.0:
        g = g.point(lambda v: min(255, int(v * lift)))
    a = im.split()[3]
    ch = [g.point(lambda v, k=k: v * k // 255) for k in rgb]
    return Image.merge("RGBA", (*ch, a))

def cool(im):
    """Slight cool cast, keeps texture."""
    r, g, b, a = im.split()
    r = r.point(lambda v: int(v * 0.94))
    g = g.point(lambda v: int(v * 0.99))
    b = b.point(lambda v: min(255, int(v * 1.08)))
    return Image.merge("RGBA", (r, g, b, a))

def draw_door():
    """32x64 modern office door for the plaster wall (no clean door in the LPC walls sheet)."""
    im = Image.new("RGBA", (32, 64), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    d.rectangle([1, 0, 30, 63], fill=(94, 86, 80, 255))        # frame
    d.rectangle([4, 3, 27, 61], fill=(122, 138, 148, 255))     # door slab (grey-teal)
    d.rectangle([4, 3, 27, 5], fill=(140, 156, 166, 255))      # top light edge
    d.rectangle([7, 8, 24, 26], fill=(163, 186, 196, 255))     # window inset
    d.rectangle([8, 9, 23, 25], fill=(196, 216, 224, 255))
    d.rectangle([7, 32, 24, 56], outline=(104, 120, 130, 255)) # lower panel
    d.rectangle([22, 38, 25, 41], fill=(228, 224, 210, 255))   # handle
    return im

def draw_partition():
    """32x32 solid interior wall tile (the LPC cap strips read as floor mats)."""
    im = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    d.rectangle([0, 0, 31, 31], fill=(150, 150, 161, 255))
    d.rectangle([0, 0, 31, 4], fill=(114, 114, 127, 255))    # top cap
    d.line([(0, 5), (31, 5)], fill=(174, 174, 186, 255))     # highlight under cap
    d.rectangle([0, 27, 31, 31], fill=(128, 128, 140, 255))  # base shading
    return im

def draw_conf_table(w=192, h=64):
    """Long slate conference table (slicing the card table leaves mid-table legs)."""
    im = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    d.rectangle([6, 46, 11, 58], fill=(96, 102, 118, 255))         # legs
    d.rectangle([w - 12, 46, w - 7, 58], fill=(96, 102, 118, 255))
    d.rounded_rectangle([2, 8, w - 3, 40], radius=6, fill=(172, 178, 194, 255))   # top
    d.rounded_rectangle([2, 8, w - 3, 40], radius=6, outline=(140, 146, 162, 255), width=1)
    d.rectangle([4, 40, w - 5, 48], fill=(132, 138, 154, 255))     # front skirt
    d.rectangle([4, 10, w - 5, 12], fill=(196, 202, 216, 255))     # top highlight
    return im

def draw_rug(w_px, h_px, fill=(171, 162, 189), outline=(152, 143, 172)):
    """Soft rounded area rug baked over the floor."""
    base = Image.new("RGBA", (w_px, h_px), (0, 0, 0, 0))
    ft = crop(floors, 21, 59)
    for y in range(0, h_px, T):
        for x in range(0, w_px, T):
            base.alpha_composite(ft, (x, y))
    d = ImageDraw.Draw(base)
    d.rounded_rectangle([2, 2, w_px - 3, h_px - 3], radius=13, fill=fill + (255,))
    d.rounded_rectangle([8, 8, w_px - 9, h_px - 9], radius=10, outline=outline + (255,), width=2)
    return base

def draw_whiteboard():
    """64x28 wall whiteboard with scribbles."""
    im = Image.new("RGBA", (64, 32), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    d.rounded_rectangle([1, 2, 62, 26], radius=2, fill=(120, 120, 132, 255))   # frame
    d.rectangle([4, 5, 59, 22], fill=(238, 240, 244, 255))                     # board
    d.line([(7, 9), (26, 9)], fill=(70, 110, 200, 255))
    d.line([(7, 13), (34, 13)], fill=(70, 110, 200, 255))
    d.line([(7, 17), (20, 17)], fill=(210, 80, 80, 255))
    d.arc([38, 8, 54, 20], 200, 340, fill=(80, 150, 90, 255))
    d.rectangle([22, 26, 42, 28], fill=(104, 104, 116, 255))                   # marker tray
    return im

# ── Sprite atlas (variable sizes, packed in one row) ─────────────────────
SPRITES = {
    "floor":      crop(floors, 21, 59),          # flat cool-grey concrete
    "wall_cap":   cool(crop(walls, 29, 4)),
    "wall_top":   cool(crop(walls, 57, 20)),
    "wall_bot":   cool(crop(walls, 57, 22)),
    "door":       draw_door(),
    "desk":       colorize(crop(desk_ornate, 0, 0, 3, 2), (150, 155, 168), 1.35),  # slate executive desk
    "chair_s":    colorize(crop(furn, 12, 17), (110, 114, 126), 1.25),
    "chair_n":    colorize(crop(furn, 13, 17), (110, 114, 126), 1.25),
    "shelf":      crop(appl, 0, 0),             # metal filing cabinet (CC0 appliances)
    "table":      colorize(crop(card, 0, 2, 3, 2), (150, 156, 170), 1.2),  # slate meeting table
    "plant":      crop(appl, 1, 3),
    "board":      crop(appl, 3, 3),
    "cooler":     crop(cooler_s, 1, 0, 1, 2),
    "copier":     crop(copier, 0, 0, 2, 2),
    "laptop_on":  crop(laptop, 1, 0).crop((6, 6, 25, 28)),   # content-tight so the base sits on the desk
    "laptop_off": crop(laptop, 0, 0).crop((6, 6, 25, 28)),
    "portrait":   crop(portraits, 1, 1),
    "tv":         crop(tv, 0, 0, 3, 2).crop((0, 0, 96, 44)),  # trim the stand — it's wall-mounted
    "rug":        draw_rug(5 * T, 4 * T),
    "couch":        colorize(crop(furn, 4, 5, 3, 3), (168, 174, 192), 1.95),
    "coffee_table": colorize(crop(card, 3, 0, 1, 2), (150, 156, 170), 1.2),
    "coffee":       crop(coffee_mk, 0, 1),
    "trash":        crop(appl, 2, 3),
    "partition":    draw_partition(),
    "whiteboard":   draw_whiteboard(),
    "rug2":         draw_rug(3 * T, 3 * T, fill=(158, 178, 160), outline=(140, 160, 142)),
}
SPRITES["conf_table"] = draw_conf_table()
atlas_h = max(im.height for im in SPRITES.values())
atlas = Image.new("RGBA", (sum(im.width for im in SPRITES.values()), atlas_h), (0, 0, 0, 0))
index = {}
x = 0
for name, im in SPRITES.items():
    atlas.paste(im, (x, 0))
    index[name] = [x, 0, im.width, im.height]
    x += im.width
atlas.save("../tiles.png")

# ── Characters: custom chibi illustrations (custom-chars/) ───────────────
# Per agent frames: cols 0-5 walk (from gif), 6-7 seated (chair incl., 2 gif
# frames), 8 half-body (behind desks). "manager" wears the CEO art (user call);
# "guest" is a ghosted dev for unknown agent types.
from PIL import ImageSequence, ImageOps

CH_DIR = "custom-chars"
AGENT_ART = {  # display name -> art file basename
    "manager": "ceo-agent",
    "cto-agent": "cto-agent",
    "po-agent": "po-agent", "pm-agent": "pm-agent",
    "tech-lead-agent": "tech-lead-agent",
    "principal-engineer-agent": "principal-engineer-agent",
    "senior-engineer-agent": "senior-engineer-agent",
    "dev-agent": "dev-agent", "ai-engineer-agent": "ai-engineer-agent",
    "qa-agent": "qa-agent", "design-lead-agent": "design-lead-agent",
    "pr-reviewer-agent": "pr-reviewer-agent",
    "security-analyst-agent": "security-analyst-agent",
    "guest": "dev-agent",   # ghosted below
}
# Frames are baked at 2x (charScale 0.5 at render) so the art stays crisp.
CH_SCALE = 0.68            # standing art 200px -> 136 baked -> 68 world px
HALF_SCALE = 0.92          # waist-up art is drawn larger so the torso clears the desk
FRAME_W, FRAME_H = 112, 152
COLS = 9
FOOT = FRAME_H - 2

def gif_frames(path, n=6):
    g = Image.open(path)
    fr = [f.convert("RGBA") for f in ImageSequence.Iterator(g)]
    return (fr + [fr[-1]] * n)[:n]

def ghost(im):
    g = ImageOps.grayscale(im)
    a = im.split()[3].point(lambda v: v * 3 // 4)
    return Image.merge("RGBA", (g, g, g.point(lambda v: min(255, int(v * 1.08))), a))

def fit(im, scale=CH_SCALE):
    """Scale, anchor bottom-center in the frame box."""
    w, h = max(1, round(im.width * scale)), max(1, round(im.height * scale))
    im = im.resize((w, h), Image.LANCZOS)
    out = Image.new("RGBA", (FRAME_W, FRAME_H), (0, 0, 0, 0))
    out.alpha_composite(im, ((FRAME_W - w) // 2, FRAME_H - 2 - h))
    return out

order = list(AGENT_ART)
agents_img = Image.new("RGBA", (FRAME_W * COLS * len(order), FRAME_H), (0, 0, 0, 0))
for idx, (name, art) in enumerate(AGENT_ART.items()):
    walk = gif_frames(f"{CH_DIR}/{art}.gif")
    seated = gif_frames(f"{CH_DIR}/seated/{art}-seated.gif")
    half = Image.open(f"{CH_DIR}/half/{art}-half.png").convert("RGBA")
    frames = [fit(f) for f in walk] + [fit(seated[0]), fit(seated[3]), fit(half, HALF_SCALE)]
    if name == "guest":
        frames = [ghost(f) for f in frames]
    for col, f in enumerate(frames):
        agents_img.paste(f, ((idx * COLS + col) * FRAME_W, 0))
agents_img.save("../agents.png")

# ── Office map (26 x 17 tiles of 32px) ───────────────────────────────────
# Floor plan: big conference room top-left, exec cabins (CEO, CTO) right side,
# manager on the rug, 6 desk pods center, lounge bottom-left, huddle room
# bottom-right, couch booth + whiteboard corner as extra collab zones.
W, H = 26, 17
WALL_ROWS = 3
SEAT_DY = 16       # waist-up art bottom sits just below the desk's top edge
DESK_POS = {       # 3x2 desks (anchor = top-left tile)
    "mgr": (11, 4),
    "ceoD": (22, 3), "ctoD": (22, 8),
    "A1": (10, 7), "A2": (14, 7),
    "B1": (10, 10), "B2": (14, 10),
    "C1": (10, 13), "C2": (14, 13),
}
SEATING = {        # agent -> (desk, x offset within the 96px desk)
    "manager": ("mgr", 48),                                  # wears the CEO art
    "cto-agent": ("ceoD", 48),                               # upper cabin
    "principal-engineer-agent": ("ctoD", 48),                # lower cabin
    "po-agent": ("A1", 24), "pm-agent": ("A1", 72),
    "tech-lead-agent": ("A2", 24), "design-lead-agent": ("A2", 72),
    "senior-engineer-agent": ("B1", 24), "dev-agent": ("B1", 72),
    "ai-engineer-agent": ("B2", 24), "qa-agent": ("B2", 72),
    "pr-reviewer-agent": ("C1", 24), "security-analyst-agent": ("C1", 72),
    "guest": ("C2", 24),
}
# hallway waypoints: x=560 vertical hall (col 17.5), per-row corridors above desks
VIAS = {
    "cto-agent": [560, 170], "principal-engineer-agent": [560, 304],
    "po-agent": [560, 208], "pm-agent": [560, 208],
    "tech-lead-agent": [560, 208], "design-lead-agent": [560, 208],
    "senior-engineer-agent": [560, 304], "dev-agent": [560, 304],
    "ai-engineer-agent": [560, 304], "qa-agent": [560, 304],
    "pr-reviewer-agent": [560, 400], "security-analyst-agent": [560, 400],
    "guest": [560, 400],
}
RUGS = [
    {"name": "rug", "c": 10, "r": 3},    # lavender, under the manager desk
    {"name": "rug2", "c": 17, "r": 3},   # sage, whiteboard collab corner
]
WALL_DECO = [
    {"name": "portrait", "c": 5, "r": 1},
    {"name": "door", "c": 9, "r": 1},
    {"name": "tv", "c": 12, "r": 1},
    {"name": "whiteboard", "c": 17, "r": 1, "dy": 16},
    {"name": "board", "c": 20, "r": 1},
]
# interior partitions: solid wall tiles with door gaps
PARTITIONS = []
for r in range(3, 10):           # conference east wall (col 8), gap rows 6-7
    if r not in (6, 7):
        PARTITIONS.append([8, r])
for c in range(0, 9):            # conference south wall (row 9), gap cols 4-5
    if c not in (4, 5):
        PARTITIONS.append([c, 9])
PARTITIONS += [[20, 3], [20, 6]]             # CEO cabin west wall, door gap rows 4-5
PARTITIONS += [[c, 6] for c in range(21, 26)]   # CEO cabin south wall
PARTITIONS += [[c, 7] for c in range(20, 26)]   # CTO cabin north wall
PARTITIONS += [[20, 8], [20, 10], [20, 11]]     # CTO west wall, door gap row 9
PARTITIONS += [[c, 11] for c in range(21, 26)]  # CTO cabin south wall
PARTITIONS += [[c, 12] for c in range(20, 26) if c != 22]  # huddle north wall, door col 22
PARTITIONS += [[20, r] for r in range(13, 17)]  # huddle west wall

OBJECTS = [  # y-sorted furniture (zIndex = visual bottom + optional dz)
    # conference room
    {"name": "conf_table", "c": 1, "r": 5},
    {"name": "plant", "c": 0, "r": 3},
    {"name": "shelf", "c": 7, "r": 3},
    # exec cabins
    {"name": "plant", "c": 25, "r": 3, "dx": -6},
    {"name": "plant", "c": 25, "r": 8, "dx": -6},
    # huddle room (bottom-right)
    {"name": "table", "c": 21, "r": 14},
    {"name": "chair_s", "c": 21, "r": 13, "dy": 8},
    {"name": "chair_s", "c": 22, "r": 13, "dy": 8},
    {"name": "chair_s", "c": 23, "r": 13, "dy": 8},
    {"name": "chair_n", "c": 21, "r": 16, "dy": -10},
    {"name": "chair_n", "c": 22, "r": 16, "dy": -10},
    # lounge / hangout bottom-left
    {"name": "couch", "c": 0, "r": 12},
    {"name": "coffee_table", "c": 5, "r": 12},
    {"name": "coffee", "c": 5, "r": 12, "dy": -8, "dz": 44},
    {"name": "cooler", "c": 6, "r": 12},
    {"name": "trash", "c": 7, "r": 14},
    {"name": "plant", "c": 3, "r": 15, "dy": -8},
    # couch booth collab zone (center-right bottom)
    {"name": "couch", "c": 17, "r": 13},
    {"name": "plant", "c": 16, "r": 15},
    # workspace decor
    {"name": "copier", "c": 0, "r": 10},
]
for pos in DESK_POS.values():
    OBJECTS.append({"name": "desk", "c": pos[0], "r": pos[1]})
# no drawn chairs around the conference table — the seated character art
# includes its own chair

seats, laptops, desks_by_agent = {}, {}, {}
for agent, (dk, off) in SEATING.items():
    dc, dr = DESK_POS[dk]
    seats[agent] = [dc * T + off, dr * T + SEAT_DY]
    laptops[agent] = [dc * T + off - 9, dr * T + 8]   # content-tight sprite, base on the desk top
    desks_by_agent[agent] = [dc, dr]

# conference seats: [x, y, sitDir] — dir rows: 0 up, 1 left, 2 down, 3 right.
# Interleave north/south so arrivals spread around the table instead of one side.
_north = [[c * T + 16, 5 * T + 20, 2] for c in range(1, 7)]  # facing south
_south = [[c * T + 16, 7 * T + 24, 0] for c in range(1, 7)]  # facing north
CONF_SEATS = [[16, 6 * T + 4, 3]]                            # head of the table (west end)
for _n, _s in zip(_north, _south):
    CONF_SEATS += [_n, _s]
CONF_SEATS.append([7 * T + 16, 6 * T + 4, 1])                # east end

meta = {
    "tile": T, "w": W, "h": H, "scale": 2,
    "atlas": index, "agents": order,
    "charW": FRAME_W, "charH": FRAME_H, "charCols": COLS, "foot": FOOT, "charScale": 0.5,
    "walkFrames": 6, "sitCol": 6, "sitAltCol": 7, "halfCol": 8,
    "aliases": {"ceo-agent": "manager"},
    "wallRows": WALL_ROWS, "wallTiles": ["wall_cap", "wall_top", "wall_bot"],
    "rugs": RUGS, "wallDeco": WALL_DECO, "partitions": PARTITIONS, "objects": OBJECTS,
    "desks": desks_by_agent, "seats": seats, "laptops": laptops, "vias": VIAS,
    "confSeats": CONF_SEATS,
    "confDoor": [160, 308],                  # waypoint in the conference door gap
    "hangout": [[64, 506], [110, 510], [176, 452], [592, 520]],  # lounge + booth spots
    "hangVia": [300, 520],                   # corridor waypoint down to the lounge
    "door": [304, 118],                      # foot px below the entrance
    "report": [400, 212],                    # foot px in front of the manager desk
}
with open("../map.json", "w") as f:
    json.dump(meta, f)

# ── Preview render for visual QA ─────────────────────────────────────────
SCALE = 2
pv = Image.new("RGBA", (W * T, H * T), (0, 0, 0, 255))
def blit(name, px, py):
    sx, sy, sw, sh = index[name]
    pv.alpha_composite(atlas.crop((sx, sy, sx + sw, sy + sh)), (px, py))
for r in range(WALL_ROWS, H):
    for c in range(W):
        blit("floor", c * T, r * T)
for rg in RUGS:
    blit(rg["name"], rg["c"] * T, rg["r"] * T)
for c in range(W):
    blit("wall_cap", c * T, 0)
    blit("wall_top", c * T, T)
    blit("wall_bot", c * T, 2 * T)
sh = Image.new("RGBA", pv.size, (0, 0, 0, 0))
ImageDraw.Draw(sh).rectangle([0, WALL_ROWS * T, W * T, WALL_ROWS * T + 6], fill=(0, 0, 0, 70))
pv.alpha_composite(sh)
for d in WALL_DECO:
    blit(d["name"], d["c"] * T + d.get("dx", 0), d["r"] * T + d.get("dy", 0))
for c, r in PARTITIONS:
    blit("partition", c * T, r * T)

draws = []
for o in OBJECTS:
    px, py = o["c"] * T + o.get("dx", 0), o["r"] * T + o.get("dy", 0)
    draws.append((py + index[o["name"]][3] + o.get("dz", 0), 0, "tile", (o["name"], px, py)))
for name in order:
    sx0, sy0 = seats[name]
    draws.append((sy0, 0, "char", (name, sx0, sy0)))
for name in order:
    lx, ly = laptops[name]
    dc, dr = desks_by_agent[name]
    draws.append((dr * T + index["desk"][3], 1, "tile", ("laptop_on", lx, ly)))
for _, _, kind, o in sorted(draws, key=lambda t: (t[0], t[1])):
    if kind == "tile":
        blit(o[0], o[1], o[2])
    else:
        name, sx0, sy0 = o
        i = order.index(name)
        fx = (i * COLS + 8) * FRAME_W   # half-body frame, used behind desks
        fr = agents_img.crop((fx, 0, fx + FRAME_W, FRAME_H))
        fr = fr.resize((FRAME_W // 2, FRAME_H // 2), Image.LANCZOS)  # charScale 0.5
        pv.alpha_composite(fr, (sx0 - FRAME_W // 4, sy0 - FOOT // 2))
pv = pv.resize((pv.width * SCALE, pv.height * SCALE), Image.NEAREST)
pv.convert("RGB").save("z_preview2.png")
print(f"atlas: {len(SPRITES)} sprites {atlas.size} | agents: {len(order)} x {COLS}c4r | map {W}x{H}@{T}px | preview: z_preview2.png")
