#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
╔══════════════════════════════════════════════════════════════════════════╗
║         NAKSHTRALOGY v2 — Complete Edition                               ║
║   + D-1 to D-60 divisional chart positions (all 20 charts per BPHS)     ║
║   + North-Indian style Lagna Kundli grid (text art)                      ║
║   + Moola Dasha = Lagna Kendradi GRAHA Dasha (PVR / Sanjay Rath method) ║
║     - Goes through planets in Kendras → Panapharas → Apoklimas of D-60  ║
║     - Period = Vimsottari years with Moolatrikona correction              ║
║   Source: "Vedic Astrology: An Integrated Approach" — P.V.R. Narasimha  ║
╚══════════════════════════════════════════════════════════════════════════╝
"""

try:
    import swisseph as swe
    SWE_AVAILABLE = True
except ImportError:
    SWE_AVAILABLE = False

import math

# ═══════════════════════════════════════════════════════════════════
#  CLASSICAL CONSTANTS
# ═══════════════════════════════════════════════════════════════════

EXALT_DEG = {
    "Sun": 10.0, "Moon": 33.0, "Mars": 298.0,
    "Mercury": 165.0, "Jupiter": 95.0, "Venus": 357.0, "Saturn": 200.0,
}
DEBIL_DEG = {p: (d + 180) % 360 for p, d in EXALT_DEG.items()}

# Moolatrikona sign index (0=Ar) and degree range within sign
# Used for Moola Dasha period calculation
MOOLA_TRIKONA = {
    "Sun":     {"sign": 4,  "start": 0,  "end": 20},   # Leo 0-20°
    "Moon":    {"sign": 1,  "start": 3,  "end": 30},   # Taurus 3-30°
    "Mars":    {"sign": 0,  "start": 0,  "end": 12},   # Aries 0-12°
    "Mercury": {"sign": 5,  "start": 15, "end": 20},   # Virgo 15-20°
    "Jupiter": {"sign": 8,  "start": 0,  "end": 10},   # Sagittarius 0-10°
    "Venus":   {"sign": 6,  "start": 0,  "end": 15},   # Libra 0-15°
    "Saturn":  {"sign": 10, "start": 0,  "end": 20},   # Aquarius 0-20°
    "Rahu":    {"sign": 2,  "start": 0,  "end": 30},   # Gemini (by convention)
    "Ketu":    {"sign": 7,  "start": 0,  "end": 30},   # Scorpio (by convention)
}

SWE_PLANETS = {
    "Sun":     swe.SUN      if SWE_AVAILABLE else 0,
    "Moon":    swe.MOON     if SWE_AVAILABLE else 1,
    "Mercury": swe.MERCURY  if SWE_AVAILABLE else 2,
    "Venus":   swe.VENUS    if SWE_AVAILABLE else 3,
    "Mars":    swe.MARS     if SWE_AVAILABLE else 4,
    "Jupiter": swe.JUPITER  if SWE_AVAILABLE else 5,
    "Saturn":  swe.SATURN   if SWE_AVAILABLE else 6,
    "Rahu":    swe.MEAN_NODE if SWE_AVAILABLE else 10,
}

RASHIS = [
    "Mesh (Aries)", "Vrishabh (Taurus)", "Mithun (Gemini)",
    "Kark (Cancer)", "Simha (Leo)", "Kanya (Virgo)",
    "Tula (Libra)", "Vrishchik (Scorpio)", "Dhanu (Sagittarius)",
    "Makar (Capricorn)", "Kumbh (Aquarius)", "Meen (Pisces)"
]
RASHI_SHORT = ["Ar","Ta","Ge","Cn","Le","Vi","Li","Sc","Sg","Cp","Aq","Pi"]
RASHI_FULL  = ["Aries","Taurus","Gemini","Cancer","Leo","Virgo",
               "Libra","Scorpio","Sagittarius","Capricorn","Aquarius","Pisces"]
RASHI_LORDS = ["Mars","Venus","Mercury","Moon","Sun","Mercury",
               "Venus","Mars","Jupiter","Saturn","Saturn","Jupiter"]
# Dual lords: Sc → Mars/Ketu, Aq → Saturn/Rahu
RASHI_LORDS2 = {7: "Ketu", 10: "Rahu"}  # second lord for Sc and Aq

NAKSHATRAS = [
    ("Ashwini","Ketu",0.0),("Bharani","Venus",13.3333),
    ("Krittika","Sun",26.6667),("Rohini","Moon",40.0),
    ("Mrigashira","Mars",53.3333),("Ardra","Rahu",66.6667),
    ("Punarvasu","Jupiter",80.0),("Pushya","Saturn",93.3333),
    ("Ashlesha","Mercury",106.6667),("Magha","Ketu",120.0),
    ("Purva Phalguni","Venus",133.3333),("Uttara Phalguni","Sun",146.6667),
    ("Hasta","Moon",160.0),("Chitra","Mars",173.3333),
    ("Swati","Rahu",186.6667),("Vishakha","Jupiter",200.0),
    ("Anuradha","Saturn",213.3333),("Jyeshtha","Mercury",226.6667),
    ("Mula","Ketu",240.0),("Purva Ashadha","Venus",253.3333),
    ("Uttara Ashadha","Sun",266.6667),("Shravana","Moon",280.0),
    ("Dhanishtha","Mars",293.3333),("Shatabhisha","Rahu",306.6667),
    ("Purva Bhadrapada","Jupiter",320.0),
    ("Uttara Bhadrapada","Saturn",333.3333),
    ("Revati","Mercury",346.6667),
]

OWN_SIGN = {
    "Sun":[4],"Moon":[3],"Mars":[0,7],"Mercury":[2,5],
    "Jupiter":[8,11],"Venus":[1,6],"Saturn":[9,10],
}
COMBUST_ORB = {
    "Moon":12.0,"Mars":17.0,"Mercury":14.0,
    "Jupiter":11.0,"Venus":10.0,"Saturn":15.0,
}

VIMSH_ORDER = ["Ketu","Venus","Sun","Moon","Mars","Rahu","Jupiter","Saturn","Mercury"]
VIMSH_YEARS = {"Ketu":7,"Venus":20,"Sun":6,"Moon":10,"Mars":7,
               "Rahu":18,"Jupiter":16,"Saturn":19,"Mercury":17}
NAK_LORD_SEQ = ["Ketu","Venus","Sun","Moon","Mars","Rahu","Jupiter","Saturn","Mercury"] * 3

PLANETS_ORDER = ["Lagna","Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]

# ═══════════════════════════════════════════════════════════════════
#  UTILITY
# ═══════════════════════════════════════════════════════════════════

def norm(deg): return deg % 360
def norm180(deg):
    d = deg % 360
    return d - 360 if d > 180 else d

def dms(deg):
    d = int(deg); m = int((deg-d)*60); s = ((deg-d)*60-m)*60
    return f"{d:3d}° {m:02d}' {s:05.2f}\""

def jd_to_date(jd):
    jd = jd + 0.5; z = int(jd)
    a = int((z-1867216.25)/36524.25)
    a = z+1+a-int(a/4); b = a+1524
    c = int((b-122.1)/365.25); d2 = int(365.25*c)
    e = int((b-d2)/30.6001)
    day = b-d2-int(30.6001*e)
    month = e-1 if e<14 else e-13
    year = c-4716 if month>2 else c-4715
    return f"{day:02d}/{month:02d}/{year}"

def to_julian_day(year, month, day, hour_ut):
    if SWE_AVAILABLE:
        return swe.julday(year, month, day, hour_ut)
    if month <= 2: year -= 1; month += 12
    A = int(year/100); B = 2-A+int(A/4)
    return int(365.25*(year+4716))+int(30.6001*(month+1))+day+hour_ut/24+B-1524.5

# ═══════════════════════════════════════════════════════════════════
#  POSITIONS
# ═══════════════════════════════════════════════════════════════════

def get_all_positions(jd_ut):
    if not SWE_AVAILABLE:
        return _fallback_positions(jd_ut)
    swe.set_sid_mode(swe.SIDM_LAHIRI)
    flags = swe.FLG_SIDEREAL | swe.FLG_SPEED
    positions = {}
    for name, pid in SWE_PLANETS.items():
        result, _ = swe.calc_ut(jd_ut, pid, flags)
        positions[name] = {"lon": result[0], "lat": result[1], "speed": result[3]}
    rahu_lon = positions["Rahu"]["lon"]
    positions["Ketu"] = {"lon": norm(rahu_lon+180), "lat": -positions["Rahu"]["lat"],
                          "speed": positions["Rahu"]["speed"]}
    return positions

def get_lagna(jd_ut, lat, lon_deg):
    if not SWE_AVAILABLE:
        return _fallback_lagna(jd_ut, lat, lon_deg)
    swe.set_sid_mode(swe.SIDM_LAHIRI)
    ayan = swe.get_ayanamsa_ut(jd_ut)
    cusps, ascmc = swe.houses(jd_ut, lat, lon_deg, b'P')
    sid_asc = norm(ascmc[0] - ayan)
    sid_cusps = [norm(c - ayan) for c in cusps[1:13]]
    return sid_asc, sid_cusps, ayan

def _fallback_lagna(jd_ut, lat, lon_deg):
    T = (jd_ut-2451545.0)/36525.0
    th0 = 280.46061837+360.98564736629*(jd_ut-2451545.0)+0.000387933*T*T
    LAST = norm(th0+lon_deg); eps = 23.439291111-0.013004167*T
    RAMC_r = math.radians(LAST); lat_r = math.radians(lat); eps_r = math.radians(eps)
    y = -math.cos(RAMC_r)
    x = math.sin(eps_r)*math.tan(lat_r)+math.cos(eps_r)*math.sin(RAMC_r)
    asc = norm(math.degrees(math.atan2(y, x)))
    ayan = (jd_ut-2396758.0)/365.25*(50.2888/3600.0)-0.00464
    return norm(asc-ayan), [], ayan

def _fallback_positions(jd_ut):
    T = (jd_ut-2451545.0)/36525.0
    ayan = (jd_ut-2396758.0)/365.25*(50.2888/3600.0)-0.00464
    def sid(trop): return norm(trop-ayan)
    def r(a): return math.radians(a)
    L0=norm(280.46646+36000.76983*T); M=norm(357.52911+35999.05029*T)
    sun_t=norm(L0+(1.914602-0.004817*T)*math.sin(r(M))+0.019993*math.sin(r(2*M)))
    L1=norm(218.3164477+481267.88123421*T); D=norm(297.8501921+445267.1114034*T)
    Mm=norm(134.9633964+477198.8675055*T); F=norm(93.2950+483202.0175233*T)
    SL=(6288774*math.sin(r(Mm))+1274027*math.sin(r(2*D-Mm))+658314*math.sin(r(2*D))
       +213618*math.sin(r(2*Mm))-185116*math.sin(r(M)))
    moon_t=norm(L1+SL/1000000)
    def p(L0c,L0r,Mc,Mr,*terms):
        L=norm(L0c+L0r*T); M2=norm(Mc+Mr*T)
        return norm(L+sum(a*math.sin(r(n*M2)) for a,n in terms))
    mars_t   =p(355.433,19140.2993,319.511,19140.300,(10.691,1),(0.623,2))
    merc_t   =p(252.251,149472.675,174.795,149472.516,(23.44,1),(2.982,2))
    venus_t  =p(181.980,58517.816, 212.250,58517.804, (0.776,1))
    jup_t    =p(34.352,3034.906,   20.9,3034.906,    (5.555,1),(0.168,2))
    sat_t    =p(50.077,1222.114,   317.020,1222.114, (6.359,1),(0.220,2))
    rahu_t   =norm(125.04452-1934.136261*T)
    raw={"Sun":sun_t,"Moon":moon_t,"Mars":mars_t,"Mercury":merc_t,
         "Venus":venus_t,"Jupiter":jup_t,"Saturn":sat_t,"Rahu":rahu_t}
    res={}
    for n,t in raw.items(): res[n]={"lon":sid(t),"speed":0.0,"lat":0.0}
    res["Ketu"]={"lon":norm(res["Rahu"]["lon"]+180),"speed":0.0,"lat":0.0}
    return res

# ═══════════════════════════════════════════════════════════════════
#  BASIC CHART HELPERS
# ═══════════════════════════════════════════════════════════════════

def get_nakshatra(sid_lon):
    ns=360.0/27.0; ps=ns/4.0; idx=min(int(sid_lon/ns),26)
    dn=sid_lon-idx*ns; pada=min(int(dn/ps)+1,4)
    name,lord,_=NAKSHATRAS[idx]
    return idx,pada,dn,name,lord

def get_rashi(sid_lon):
    r=int(sid_lon/30)%12; return r, sid_lon%30

def get_navamsha_rashi(sid_lon):
    ri=int(sid_lon/30); dr=sid_lon%30
    ni=int(dr/(30.0/9.0)); start=[0,9,6,3][ri%4]
    return (start+ni)%12

def is_vargottam(sid_lon):
    return int(sid_lon/30)%12==get_navamsha_rashi(sid_lon)

def get_dignity(planet, sid_lon):
    ri,_=get_rashi(sid_lon)
    if planet in OWN_SIGN and ri in OWN_SIGN[planet]: return "Swakshetra 🏠"
    if planet in EXALT_DEG:
        du=abs(norm180(sid_lon-EXALT_DEG[planet]))
        dn=abs(norm180(sid_lon-DEBIL_DEG[planet]))
        if du<=1.0: return f"Uch — Deep Exalt ⬆⬆"
        if du<=6.0: return f"Uch (Exalted) ⬆"
        if dn<=1.0: return f"Neech — Deep Debil ⬇⬇"
        if dn<=6.0: return f"Neech (Debilitated) ⬇"
    return "Normal"

def is_vakri(speed, planet):
    if planet in ("Rahu","Ketu"): return True
    if planet in ("Sun","Moon"): return False
    return speed < 0

def is_ast(planet, planet_lon, sun_lon):
    if planet not in COMBUST_ORB: return False
    return abs(norm180(planet_lon-sun_lon)) <= COMBUST_ORB[planet]


# ═══════════════════════════════════════════════════════════════════
#  D-1 TO D-60: ALL DIVISIONAL CHART CONVERSIONS
#  Source: PVR Narasimha Rao "Vedic Astrology: An Integrated Approach"
#  Ch. 6.2.1 through 6.2.20
# ═══════════════════════════════════════════════════════════════════

def get_part(deg_in_sign, n_parts):
    """
    Find which part# (1-indexed) a longitude falls in when sign is divided into n_parts.
    Each part = 30° / n_parts
    """
    part_size = 30.0 / n_parts
    return min(int(deg_in_sign / part_size) + 1, n_parts)

def count_from(start_sign, count):
    """Count 'count' rasis forward from start_sign (0-indexed). Wraps at 12."""
    return (start_sign + count - 1) % 12


def divisional_sign(sid_lon, d):
    """
    Returns the sign index (0-11) for a planet in divisional chart D-d.
    Implements all 20 divisional charts per PVR's book.

    Returns: (sign_idx: int, part_num: int)
    """
    base_sign = int(sid_lon / 30) % 12
    deg = sid_lon % 30

    # ── D-1: Rasi ────────────────────────────────────────────────
    if d == 1:
        return base_sign, 1

    # ── D-2: Hora ────────────────────────────────────────────────
    elif d == 2:
        # Odd sign: 0-15° → Sun (Leo=4), 15-30° → Moon (Cancer=3)
        # Even sign: 0-15° → Moon (Cancer=3), 15-30° → Sun (Leo=4)
        is_odd = (base_sign % 2 == 0)  # Ar=0(odd),Ta=1(even)...
        first_half = (deg < 15)
        if is_odd:
            return (4 if first_half else 3), (1 if first_half else 2)
        else:
            return (3 if first_half else 4), (1 if first_half else 2)

    # ── D-3: Drekkana ────────────────────────────────────────────
    elif d == 3:
        p = get_part(deg, 3)
        # p=1 → same sign; p=2 → 5th from sign; p=3 → 9th from sign
        offsets = {1: 0, 2: 4, 3: 8}
        return (base_sign + offsets[p]) % 12, p

    # ── D-4: Chaturthamsa ────────────────────────────────────────
    elif d == 4:
        p = get_part(deg, 4)
        # 1→1st, 2→4th, 3→7th, 4→10th from sign
        offsets = {1: 0, 2: 3, 3: 6, 4: 9}
        return (base_sign + offsets[p]) % 12, p

    # ── D-5: Panchamsa ───────────────────────────────────────────
    elif d == 5:
        p = get_part(deg, 5)
        is_odd = (base_sign % 2 == 0)
        # Odd: Ar(0), Aq(10), Sg(8), Ge(2), Li(6)
        # Even: Ta(1), Vi(5), Pi(11), Cp(9), Sc(7)
        odd_map  = {1:0, 2:10, 3:8, 4:2, 5:6}
        even_map = {1:1, 2:5,  3:11,4:9, 5:7}
        return (odd_map if is_odd else even_map)[p], p

    # ── D-6: Shashthamsa ─────────────────────────────────────────
    elif d == 6:
        p = get_part(deg, 6)
        is_odd = (base_sign % 2 == 0)
        start = 0 if is_odd else 6  # Ar=0, Li=6
        return count_from(start, p), p

    # ── D-7: Saptamsa ────────────────────────────────────────────
    elif d == 7:
        p = get_part(deg, 7)
        is_odd = (base_sign % 2 == 0)
        start = base_sign if is_odd else (base_sign + 6) % 12
        return count_from(start, p), p

    # ── D-8: Ashtamsa ────────────────────────────────────────────
    elif d == 8:
        p = get_part(deg, 8)
        # Movable→Ar(0), Fixed→Sg(8), Dual→Le(4)
        sign_type = base_sign % 3  # 0=movable(Ar,Cn,Li,Cp), 1=fixed, 2=dual
        # Ar=0(mov), Ta=1(fix), Ge=2(dual), Cn=3(mov), Le=4(fix), Vi=5(dual)
        # Li=6(mov), Sc=7(fix), Sg=8(dual), Cp=9(mov), Aq=10(fix), Pi=11(dual)
        starts = {0: 0, 1: 8, 2: 4}  # movable→Ar, fixed→Sg, dual→Le
        start = starts[base_sign % 3]
        return count_from(start, p), p

    # ── D-9: Navamsha ────────────────────────────────────────────
    elif d == 9:
        p = get_part(deg, 9)
        # Fire(Ar,Le,Sg)→Ar(0), Earth(Ta,Vi,Cp)→Cp(9),
        # Air(Ge,Li,Aq)→Li(6), Water(Cn,Sc,Pi)→Cn(3)
        elements = {0:0,1:9,2:6,3:3, 4:0,5:9,6:6,7:3, 8:0,9:9,10:6,11:3}
        start = elements[base_sign]
        return count_from(start, p), p

    # ── D-10: Dasamsha ───────────────────────────────────────────
    elif d == 10:
        p = get_part(deg, 10)
        is_odd = (base_sign % 2 == 0)
        start = base_sign if is_odd else (base_sign + 8) % 12  # odd→same, even→9th
        return count_from(start, p), p

    # ── D-11: Rudramsha / Ekadasamsha ────────────────────────────
    elif d == 11:
        p = get_part(deg, 11)
        # Count n rasis from Ar zodiacally to base_sign → n = base_sign+1
        # Then count n anti-zodiacally from Ar → start = (12 - base_sign) % 12
        # Anti-zodiacal from Ar: Ar(0),Pi(11),Aq(10),Cp(9)...
        n = base_sign + 1  # rasis from Ar to sign (zodiacal, 1-based)
        start = (12 - base_sign) % 12  # n-th anti-zodiacal from Ar
        return count_from(start, p), p

    # ── D-12: Dwadasamsha ────────────────────────────────────────
    elif d == 12:
        p = get_part(deg, 12)
        return count_from(base_sign, p), p

    # ── D-16: Shodasamsha ────────────────────────────────────────
    elif d == 16:
        p = get_part(deg, 16)
        # Movable→Ar(0), Fixed→Le(4), Dual→Sg(8)
        starts = {0:0, 1:4, 2:8}
        start = starts[base_sign % 3]
        return count_from(start, p), p

    # ── D-20: Vimsamsa ───────────────────────────────────────────
    elif d == 20:
        p = get_part(deg, 20)
        # Movable→Ar(0), Fixed→Sg(8), Dual→Le(4)
        starts = {0:0, 1:8, 2:4}
        start = starts[base_sign % 3]
        return count_from(start, p), p

    # ── D-24: Chaturvimsamsa / Siddhamsa ─────────────────────────
    elif d == 24:
        p = get_part(deg, 24)
        # Odd sign → Le(4), Even sign → Cn(3)
        is_odd = (base_sign % 2 == 0)
        start = 4 if is_odd else 3
        return count_from(start, p), p

    # ── D-27: Nakshatramsa / Bhamsa ──────────────────────────────
    elif d == 27:
        p = get_part(deg, 27)
        # Fire→Ar(0), Earth→Cn(3), Air→Li(6), Water→Cp(9)
        elements = {0:0,1:3,2:6,3:9, 4:0,5:3,6:6,7:9, 8:0,9:3,10:6,11:9}
        # Actually: Fire(Ar,Le,Sg)→Ar, Earth(Ta,Vi,Cp)→Cn,
        #           Air(Ge,Li,Aq)→Li, Water(Cn,Sc,Pi)→Cp
        fire_earth_air_water = {
            0:0, 4:0, 8:0,   # Fire → Ar
            1:3, 5:3, 9:3,   # Earth → Cn
            2:6, 6:6, 10:6,  # Air → Li
            3:9, 7:9, 11:9,  # Water → Cp
        }
        start = fire_earth_air_water[base_sign]
        return count_from(start, p), p

    # ── D-30: Trimsamsa ──────────────────────────────────────────
    elif d == 30:
        is_odd = (base_sign % 2 == 0)
        if is_odd:
            # 0-5→Ar(0), 5-10→Aq(10), 10-18→Sg(8), 18-25→Ge(2), 25-30→Li(6)
            if   deg < 5:  return 0,  1
            elif deg < 10: return 10, 2
            elif deg < 18: return 8,  3
            elif deg < 25: return 2,  4
            else:          return 6,  5
        else:
            # 0-5→Ta(1), 5-12→Vi(5), 12-20→Pi(11), 20-25→Cp(9), 25-30→Sc(7)
            if   deg < 5:  return 1,  1
            elif deg < 12: return 5,  2
            elif deg < 20: return 11, 3
            elif deg < 25: return 9,  4
            else:          return 7,  5

    # ── D-40: Khavedamsha ────────────────────────────────────────
    elif d == 40:
        p = get_part(deg, 40)
        is_odd = (base_sign % 2 == 0)
        start = 0 if is_odd else 6  # Odd→Ar(0), Even→Li(6)
        return count_from(start, p), p

    # ── D-45: Akshavedamsha ──────────────────────────────────────
    elif d == 45:
        p = get_part(deg, 45)
        # Movable→Ar(0), Fixed→Le(4), Dual→Sg(8)
        starts = {0:0, 1:4, 2:8}
        start = starts[base_sign % 3]
        return count_from(start, p), p

    # ── D-60: Shashtyamsha ───────────────────────────────────────
    elif d == 60:
        # PVR formula: floor(deg * 2) + 1 = part#; count from same sign
        p = int(deg * 2) + 1
        p = min(p, 60)
        return count_from(base_sign, p), p

    else:
        # Generic fallback
        p = get_part(deg, d)
        return count_from(base_sign, p), p


def compute_all_divisionals(sid_lon):
    """
    Compute planet's sign in all 20 divisional charts.
    Returns dict: {D: sign_idx}
    """
    charts = [1,2,3,4,5,6,7,8,9,10,11,12,16,20,24,27,30,40,45,60]
    result = {}
    for d in charts:
        sign, part = divisional_sign(sid_lon, d)
        result[d] = sign
    return result


# ═══════════════════════════════════════════════════════════════════
#  NORTH-INDIAN LAGNA KUNDLI (Text Art)
#  Layout:  12 | 1 | 2 | 3
#           11 |   |   | 4
#           10 |   |   | 5
#            9 | 8 | 7 | 6
# ═══════════════════════════════════════════════════════════════════

def make_kundli_grid(base_rashi_idx, planets_by_rashi, label="LAGNA KUNDLI"):
    """
    Draw a North-Indian style 4×4 kundli in text.
    base_rashi_idx: 0-11, the sign that goes in H1 (top-center-left cell)
    planets_by_rashi: dict {rashi_idx: [planet_names]}
    """
    # Map house number → rashi index
    # House 1 = base_rashi_idx, House 2 = next, etc.
    def h2r(h): return (base_rashi_idx + h - 1) % 12

    # North Indian fixed layout: which house goes in which cell (row, col) 0-indexed
    # 4×4 grid. Center 4 cells are empty.
    LAYOUT = {
        (0,0): 12, (0,1):  1, (0,2):  2, (0,3):  3,
        (1,0): 11,             (1,3):  4,
        (2,0): 10,             (2,3):  5,
        (3,0):  9, (3,1):  8, (3,2):  7, (3,3):  6,
    }
    CENTER_CELLS = [(1,1),(1,2),(2,1),(2,2)]

    W = 14  # cell width
    H = 4   # cell height

    def cell_content(house):
        ri = h2r(house)
        planets = planets_by_rashi.get(ri, [])
        sign_str = f"H{house:02d} {RASHI_SHORT[ri]}"
        lines = [sign_str]
        # pack planets 2 per line
        chunk = []
        for p in planets:
            abbr = p[:3] if p != "Lagna" else "ASC"
            chunk.append(abbr)
            if len(chunk) == 2:
                lines.append(" ".join(chunk)); chunk = []
        if chunk: lines.append(" ".join(chunk))
        return lines

    def center_content(row, col):
        if (row,col) == (1,1): return ["", f"  {label[:12]}", ""]
        if (row,col) == (1,2): return ["", "  Vedic Chart", ""]
        if (row,col) == (2,1): return ["", f"  Base: {RASHI_SHORT[base_rashi_idx]}", ""]
        if (row,col) == (2,2): return ["", "  Kundli ✦", ""]
        return ["","",""]

    def pad_lines(lines, width, height):
        padded = []
        for l in lines[:height]:
            padded.append(l[:width].ljust(width))
        while len(padded) < height:
            padded.append(" " * width)
        return padded

    # Build grid row by row
    output = []
    border_h = "+" + (("-" * W + "+") * 4)
    output.append(border_h)

    for row in range(4):
        # Build H lines for this grid row
        row_lines = []
        for r_line in range(H):
            row_lines.append([])

        for col in range(4):
            if (row,col) in LAYOUT:
                house = LAYOUT[(row,col)]
                lines = cell_content(house)
                padded = pad_lines(lines, W, H)
            elif (row,col) in CENTER_CELLS:
                lines = center_content(row,col)
                padded = pad_lines(lines, W, H)
            else:
                padded = [" "*W]*H

            for r_line in range(H):
                row_lines[r_line].append(padded[r_line])

        for r_line in range(H):
            output.append("|" + "|".join(row_lines[r_line]) + "|")
        output.append(border_h)

    return "\n".join(output)


# ═══════════════════════════════════════════════════════════════════
#  GOCHAR — PLANETARY TRANSIT SCORING
#
#  Scores all 12 rashis based on current (or specified) planetary
#  transit positions using classic Vedic Gochar Phala rules.
#
#  SOURCE: Traditional Gochar rules from BPHS / Phaladeepika:
#  Each planet gives different results transiting different houses
#  counted from the native's Moon sign (Chandra Lagna).
#
#  Special indicators:
#  · Chandrashtama: Moon transiting 8th from rashi → very inauspicious
#  · Sade Sati:     Saturn in 12th/1st/2nd from rashi (7.5yr ordeal)
#  · Kantaka Shani: Saturn in 4th/7th/10th → obstacles
#  · Guru Balam:    Jupiter in 2nd/5th/9th/11th → extra protection
# ═══════════════════════════════════════════════════════════════════

# Gochar good-house tables (from natal Moon / reference rashi)
_GOCHAR_GOOD = {
    "Sun":     {3,6,10,11},
    "Moon":    {1,3,6,7,10,11},
    "Mars":    {3,6,11},
    "Mercury": {2,4,6,8,10,11},
    "Jupiter": {2,5,7,9,11},
    "Venus":   {1,2,3,4,5,8,9,11,12},
    "Saturn":  {3,6,11},
    "Rahu":    {3,6,10,11},
    "Ketu":    {3,6,10,11},
}

_GOCHAR_WEIGHT = {
    "Sun":1.0, "Moon":1.5, "Mars":1.2, "Mercury":0.8,
    "Jupiter":2.0, "Venus":1.0, "Saturn":2.0, "Rahu":1.2, "Ketu":1.0
}

def gochar_score_rashi(transit_signs, ref_rashi):
    """
    Score a rashi for a given transit configuration.
    transit_signs: dict {planet_name: sign_idx (0-11)}
    ref_rashi: reference rashi index (0-11)
    Returns: (score, planet_detail_dict, special_flags_list)
    """
    score = 0.0
    details = {}
    flags   = []

    for p, sign in transit_signs.items():
        house  = (sign - ref_rashi) % 12 + 1
        good   = house in _GOCHAR_GOOD.get(p, set())
        weight = _GOCHAR_WEIGHT.get(p, 1.0)
        contrib = weight * (1.0 if good else -1.0)
        score  += contrib
        details[p] = {"house": house, "good": good, "contrib": round(contrib, 2)}

        # Special modifiers
        if p == "Moon" and house == 8:
            score -= 2.0
            flags.append("☽ Chandrashtama")
        elif p == "Saturn":
            if   house == 1:  score -= 2.0; flags.append("♄ Sade Sati Peak")
            elif house == 12: score -= 1.0; flags.append("♄ Sade Sati Start")
            elif house == 2:  score -= 1.0; flags.append("♄ Sade Sati End")
            elif house == 4:  score -= 1.0; flags.append("♄ Kantaka H4")
            elif house == 7:  score -= 1.0; flags.append("♄ Kantaka H7")
            elif house == 10: score -= 1.0; flags.append("♄ Kantaka H10")
        if p == "Jupiter" and house in (2, 5, 9, 11):
            score += 0.5
            flags.append("♃ Guru Balam")

    return round(score, 2), details, flags


def gochar_grade(score):
    """Return (label, stars, bar_char) for a score."""
    if   score >  6.5: return "Excellent",  "⭐⭐⭐⭐⭐"
    elif score >  4.5: return "Very Good",  "⭐⭐⭐⭐ "
    elif score >  2.5: return "Good     ",  "⭐⭐⭐  "
    elif score >  0.5: return "Normal   ",  "⭐⭐   "
    elif score > -1.5: return "Caution  ",  "⭐    "
    elif score > -3.5: return "Bad      ",  "✗✗   "
    elif score > -5.5: return "Very Bad ",  "✗✗✗  "
    else:              return "Critical ",  "✗✗✗✗ "


def _gochar_bar(score, width=22):
    """ASCII bar chart centered at 0, range ±12."""
    MAX = 12.0
    mid = width // 2
    filled = int(((score + MAX) / (2 * MAX)) * width)
    filled = max(0, min(width - 1, filled))
    bar = []
    for i in range(width):
        if i == mid:
            bar.append("│")
        elif i < filled:
            bar.append("█")
        else:
            bar.append("░")
    return "".join(bar)


def gochar_chart(date_str=None, native_moon_sign=None, show_detail=False):
    """
    Display Gochar (planetary transit) scores for all 12 rashis.

    Parameters
    ----------
    date_str : str or None
        Date in DD/MM/YYYY format, or 'today', 'yesterday', 'tomorrow'.
        Defaults to today (noon IST).
    native_moon_sign : int or None
        0-11 index of native's natal Moon sign. If provided, highlights that row.
    show_detail : bool
        If True, shows per-planet house breakdown for native's Moon sign.
    """
    from datetime import date, timedelta

    # ── Parse date ────────────────────────────────────────────────
    if date_str is None or str(date_str).strip().lower() in ("", "today"):
        d = date.today()
    elif str(date_str).strip().lower() == "yesterday":
        d = date.today() - timedelta(days=1)
    elif str(date_str).strip().lower() == "tomorrow":
        d = date.today() + timedelta(days=1)
    else:
        parts = str(date_str).replace("-", "/").split("/")
        if len(parts) == 3:
            if len(parts[0]) == 4:        # YYYY/MM/DD
                d = date(int(parts[0]), int(parts[1]), int(parts[2]))
            else:                          # DD/MM/YYYY
                d = date(int(parts[2]), int(parts[1]), int(parts[0]))
        else:
            d = date.today()

    date_label = d.strftime("%d/%m/%Y (%A)")

    # ── Get transit positions (noon IST = 06:30 UTC) ──────────────
    jd = to_julian_day(d.year, d.month, d.day, 6.5)
    raw_pos = get_all_positions(jd)

    transit_signs  = {}
    transit_detail = {}
    for p in ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]:
        if p not in raw_pos: continue
        pp  = raw_pos[p]
        lon = pp["lon"] if isinstance(pp, dict) else pp
        sign_idx  = int(lon / 30)
        deg_sign  = lon - sign_idx * 30
        nak_idx   = int(lon / (360.0/27.0))
        transit_signs[p]  = sign_idx
        transit_detail[p] = {
            "lon": round(lon, 2), "sign": sign_idx,
            "deg": round(deg_sign, 2), "nak": nak_idx,
            "nak_lord": NAK_LORD_SEQ[nak_idx],
        }

    # ── Score all 12 rashis ───────────────────────────────────────
    results = []
    for r in range(12):
        sc, det, flags = gochar_score_rashi(transit_signs, r)
        results.append({
            "rashi": r, "score": sc, "detail": det,
            "flags": flags, "grade": gochar_grade(sc),
        })

    # ── Display ──────────────────────────────────────────────────
    SEP = "  " + "═" * 76
    print(f"\n{SEP}")
    print(f"  ║  GOCHAR — Planetary Transit Score  │  {date_label}")
    print(f"  ║  Scoring: classic Gochar Phala (BPHS rules)  │  Ayanamsha: Lahiri")
    print(f"  ╠{'═'*76}")
    print(f"  ║  Current Transit Positions (sidereal Lahiri):")

    planets_in_sign = {}
    for p, si in transit_signs.items():
        planets_in_sign.setdefault(si, []).append(p[:3])

    for p, info in transit_detail.items():
        nak_name_short = f"N{info['nak']+1:02d}"
        vakri_marker = " ℞" if raw_pos[p].get("speed", 1) < 0 else "  "
        print(f"  ║    {p:<10} {RASHI_FULL[info['sign']]:<14}"
              f" {info['deg']:>5.2f}°  {nak_name_short}({info['nak_lord']:<7}){vakri_marker}")

    print(f"  ╠{'═'*76}")

    # Ranking header
    sorted_results = sorted(results, key=lambda x: x["score"], reverse=True)
    rank_map = {r["rashi"]: i+1 for i, r in enumerate(sorted_results)}

    print(f"  ║  {'#':>2}  {'Rashi':<13} {'Score':>6}  {'neg◄────── 0 ──────►pos':^24}  {'Grade':<10}  {'Notes'}")
    print(f"  ╠{'═'*76}")

    for r_data in results:
        r     = r_data["rashi"]
        sc    = r_data["score"]
        gr, stars = r_data["grade"]
        flags = r_data["flags"]
        rank  = rank_map[r]
        is_native = (native_moon_sign is not None and r == native_moon_sign)
        bar   = _gochar_bar(sc, 24)
        flags_str = "  ".join(flags[:2])
        marker = " ◄ MOON" if is_native else "       "

        print(f"  ║  {rank:>2}. {RASHI_FULL[r]:<13} {sc:>+6.2f}  [{bar}]  "
              f"{gr} {stars}  {flags_str}{marker}")

    print(f"  ╠{'═'*76}")

    # Summary
    best  = sorted_results[0]
    worst = sorted_results[-1]
    print(f"  ║  BEST  : {RASHI_FULL[best['rashi']]:<13}  {best['score']:>+6.2f}  {best['grade'][0]}")
    print(f"  ║  WORST : {RASHI_FULL[worst['rashi']]:<13}  {worst['score']:>+6.2f}  {worst['grade'][0]}")
    if native_moon_sign is not None:
        n_data = results[native_moon_sign]
        print(f"  ║  NATIVE Moon ({RASHI_FULL[native_moon_sign]}): {n_data['score']:>+6.2f}  "
              f"{n_data['grade'][0]}  "
              f"{'  '.join(n_data['flags'][:3]) if n_data['flags'] else 'No special alerts'}")

    # ── Per-planet detail for native Moon sign ────────────────────
    if show_detail and native_moon_sign is not None:
        print(f"  ╠{'═'*76}")
        print(f"  ║  Detail for {RASHI_FULL[native_moon_sign]} (your Moon sign):")
        print(f"  ║    {'Planet':<10} {'In Sign':<14} {'House':>6}  {'Effect':>8}  {'Score':>7}")
        print(f"  ║    {'─'*10} {'─'*14} {'─'*6}  {'─'*8}  {'─'*7}")
        nd = results[native_moon_sign]["detail"]
        for p in ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]:
            if p not in nd: continue
            info = nd[p]
            effect = "✓ Good  " if info["good"] else "✗ Bad   "
            print(f"  ║    {p:<10} {RASHI_FULL[transit_signs[p]]:<14} "
                  f"H{info['house']:>2}    {effect}  {info['contrib']:>+7.2f}")

    print(f"  ╠{'═'*76}")
    print(f"  ║  Grade scale:  Excellent>6.5  Very Good>4.5  Good>2.5  Normal>0.5")
    print(f"  ║               Caution>-1.5   Bad>-3.5   Very Bad>-5.5   Critical≤-5.5")
    print(f"  ║  Weights: ♃Jupiter×2  ♄Saturn×2  ☽Moon×1.5  ♂Mars×1.2  ☊Rahu×1.2")
    print(f"  ╚{'═'*76}\n")

    return results


# ═══════════════════════════════════════════════════════════════════
#  VIMSHOTTARI DASHA
# ═══════════════════════════════════════════════════════════════════

def vimshottari_dasha(moon_sid_lon, birth_jd):
    nak_idx = int(moon_sid_lon / (360.0/27.0))
    lord    = NAK_LORD_SEQ[nak_idx]
    deg_in  = moon_sid_lon % (360.0/27.0)
    elapsed = (deg_in / (360.0/27.0)) * VIMSH_YEARS[lord]
    balance = VIMSH_YEARS[lord] - elapsed
    start_idx = VIMSH_ORDER.index(lord)
    order = VIMSH_ORDER[start_idx:] + VIMSH_ORDER[:start_idx]
    total = 120
    YR    = 365.25

    def _sub(parent_planet, parent_start, parent_yrs):
        """Build one level of sub-periods starting from parent_planet."""
        idx = VIMSH_ORDER.index(parent_planet)
        seq = VIMSH_ORDER[idx:] + VIMSH_ORDER[:idx]
        subs, cur = [], parent_start
        for sp in seq:
            dur = (VIMSH_YEARS[sp] / total) * parent_yrs
            end = cur + dur * YR
            subs.append({"planet": sp, "years": dur, "months": dur*12,
                          "start_jd": cur, "end_jd": end})
            cur = end
        return subs

    dashas = []
    md_start = birth_jd - elapsed * YR
    for i, md_planet in enumerate(order):
        md_yrs = VIMSH_YEARS[md_planet] if i > 0 else balance
        md_end = md_start + md_yrs * YR

        # AD level: always proportional to FULL MD years, not balance
        # (balance only affects when the MD starts, not the AD durations)
        ads = _sub(md_planet, md_start, VIMSH_YEARS[md_planet])
        for ad in ads:
            pds = _sub(ad["planet"], ad["start_jd"], ad["years"])
            for pd_d in pds:
                sds = _sub(pd_d["planet"], pd_d["start_jd"], pd_d["years"])
                for sd_d in sds:
                    pads = _sub(sd_d["planet"], sd_d["start_jd"], sd_d["years"])
                    for pad_d in pads:
                        dehas = _sub(pad_d["planet"], pad_d["start_jd"], pad_d["years"])
                        pad_d["sub"] = dehas
                    sd_d["sub"] = pads
                pd_d["sub"] = sds
            ad["sub"] = pds
        dashas.append({
            "planet": md_planet, "years": VIMSH_YEARS[md_planet],
            "start_jd": md_start, "end_jd": md_start + VIMSH_YEARS[md_planet]*YR,
            "antardashas": ads, "sub": ads,
        })
        md_start = md_start + VIMSH_YEARS[md_planet] * YR
    return dashas, balance, lord


# ═══════════════════════════════════════════════════════════════════
#  MOOLA DASHA — LAGNA KENDRADI GRAHA DASHA
#
#  EXACT JHora-matching algorithm (reverse-engineered from screenshots):
#  ─────────────────────────────────────────────────────────────────
#  SOURCE: PVR Narasimha Rao "Vedic Astrology: An Integrated Approach" Ch.19
#  "Kendradi Graha Dasa / Moola Dasa — Vimsottari dasa years with
#   moolatrikona correction — from the stronger of Lagna and Moon
#   (some authors include Sun)"
#
#  PERIOD FORMULA (proven by matching JHora output):
#    raw_dist = (MT_sign_idx - D1_sign_idx) % 12  [always forward/zodiacal]
#    if raw_dist == 0:  C1 = Vimsottari_years  (planet already in its MT)
#    if raw_dist  > 0:  C1 = Vimsottari_years - raw_dist
#    C2 = Vimsottari_years - C1 = raw_dist (or 0 if planet in MT)
#
#  MOOLATRIKONA CORRECTION OPTION (JHora "0 or 12 years"):
#    "0 years"  = when planet in MT: C1=Vimsottari, C2=0  (default)
#    "12 years" = when planet in MT: C1=Vimsottari-12, C2=12
#
#  CORRECT MT SIGNS (matching JHora):
#    Sun=Le, Moon=Ta, Mars=Ar, Mercury=Vi, Jupiter=Sg,
#    Venus=Li, Saturn=Aq, Rahu=Ge, Ketu=Pi  ← Ketu=PISCES (not Scorpio)
#
#  REFERENCE (candidate):
#    Uses D-1 sign of Lagna / Moon / Sun as grouping reference
#    NOT D-60 positions for period calculation
#
#  GROUPING: Kendra(1,4,7,10) / Panapara(2,5,8,11) / Apoklima(3,6,9,12)
#    from reference sign, counted in the DIRECTION of the reference sign:
#    ODD reference sign  → forward  (zodiacal)   → K→P→A
#    EVEN reference sign → backward (anti-zodial) → K→A→P
#    Saturn in ref sign  → always K→P→A
#    Ketu in ref sign    → always K→A→P
#
#  ORDERING within each group:
#    Planets ordered by house number of their sign from reference,
#    within same sign by raw_dist ASC (closest to MT first = strongest)
#
#  BALANCE at birth:
#    = (1 - deg_in_ref_sign/30) × C1_of_first_planet
# ═══════════════════════════════════════════════════════════════════

# Correct Moolatrikona sign indices (0=Ar...11=Pi) matching JHora
# KEY: Ketu = Pisces (11), NOT Scorpio!
MOOLA_TRIKONA_JHORA = {
    "Sun":     4,   # Leo
    "Moon":    1,   # Taurus
    "Mars":    0,   # Aries
    "Mercury": 5,   # Virgo
    "Jupiter": 8,   # Sagittarius
    "Venus":   6,   # Libra
    "Saturn":  10,  # Aquarius
    "Rahu":    10,  # Aquarius  ← CONFIRMED from Achal chart (9/9 match)
    "Ketu":    9,   # Capricorn ← CONFIRMED from Achal chart (9/9 match)
}

# Sign type for ordering: 0=movable, 1=fixed, 2=dual
SIGN_TYPE = {0:0,3:0,6:0,9:0, 1:1,4:1,7:1,10:1, 2:2,5:2,8:2,11:2}


def moola_dasha_period(planet, d1_sign, mt_correction_yrs=0):
    """
    Calculate Moola Dasha Cycle-1 and Cycle-2 years for a planet.

    Parameters:
      planet           : planet name string
      d1_sign          : planet's D-1 (natal rasi) sign index 0-11
      mt_correction_yrs: 0 or 12 (JHora option for planet-in-MT case)

    Returns: (cycle1_years, cycle2_years)

    Formula (proven by matching JHora output exactly):
      raw_dist = (MT_sign - D1_sign) % 12   [forward/zodiacal]
      if raw_dist == 0  →  C1 = Vim - mt_correction_yrs
                           C2 = mt_correction_yrs
      if raw_dist  > 0  →  C1 = Vim - raw_dist
                           C2 = raw_dist
    """
    vim = VIMSH_YEARS.get(planet, 7)
    mt  = MOOLA_TRIKONA_JHORA.get(planet, d1_sign)

    raw = (mt - d1_sign) % 12

    if raw == 0:
        # Planet is in its own Moolatrikona sign
        c1 = vim - mt_correction_yrs
        c2 = mt_correction_yrs
    else:
        c1 = vim - raw
        c2 = raw

    # Safety clamp (shouldn't be needed but prevents negatives)
    c1 = max(0, c1)
    c2 = max(0, c2)
    return round(c1, 4), round(c2, 4)


def moola_dasha(pdata, birth_jd,
                use_lagna=True, use_moon=False, use_sun=False,
                mt_correction_yrs=0):
    """
    Lagna Kendradi GRAHA Dasha (Moola Dasha).

    Parameters:
      pdata             : planet data dict from calculate_chart (D-1 positions)
      birth_jd          : birth Julian Day number
      use_lagna         : use Lagna sign as reference candidate
      use_moon          : use Moon sign as reference candidate
      use_sun           : use Sun sign as reference candidate
      mt_correction_yrs : 0 or 12 (JHora "moolatrikona correction" option)

    Note: If multiple candidates checked, JHora picks the STRONGER sign.
    We implement: Lagna > Moon > Sun as priority when multiple are checked.

    Returns:
      (dashas_list, balance_years, info_dict)
    """
    PLANETS_9 = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]

    # ── Step 1: Determine reference sign ──────────────────────────
    candidates = []
    if use_lagna and "Lagna" in pdata:
        candidates.append(("Lagna", pdata["Lagna"]["rashi_idx"]))
    if use_moon and "Moon" in pdata:
        candidates.append(("Moon",  pdata["Moon"]["rashi_idx"]))
    if use_sun and "Sun" in pdata:
        candidates.append(("Sun",   pdata["Sun"]["rashi_idx"]))

    if not candidates:
        # Default: Moon (PVR's primary reference)
        candidates.append(("Moon", pdata["Moon"]["rashi_idx"]))

    # ── Pick strongest candidate using PVR Ch.15.5.2 (6 rules) ────
    def rasi_aspect(sa, sb):
        diff = abs(sa - sb) % 12
        if diff == 6: return True
        ta, tb = SIGN_TYPE.get(sa,0), SIGN_TYPE.get(sb,0)
        if diff in (1,11): return False
        return (ta==0 and tb==1) or (tb==0 and ta==1) or                (ta==1 and tb==2) or (tb==1 and ta==2) or                (ta==2 and tb==0) or (tb==2 and ta==0)

    def sign_strength_key(sign_idx):
        """PVR 6-rule sign strength for selecting the stronger candidate."""
        planets_in = [p for p in PLANETS_9
                      if p in pdata and pdata[p]["rashi_idx"] == sign_idx]
        # Rule 1: planet count
        r1 = len(planets_in)
        # Rule 2: Jupiter/Mercury/lord aspect or occupy
        lord = RASHI_LORDS[sign_idx]
        r2 = sum(1 for chk in ["Jupiter","Mercury",lord]
                 if chk in pdata and
                 (pdata[chk]["rashi_idx"]==sign_idx or
                  rasi_aspect(pdata[chk]["rashi_idx"], sign_idx)))
        # Rule 3: exalted planet present
        EXALT_SIGN = {"Sun":0,"Moon":1,"Mars":9,"Mercury":5,
                      "Jupiter":3,"Venus":11,"Saturn":6}
        r3 = 1 if any(EXALT_SIGN.get(p,-1)==sign_idx for p in planets_in) else 0
        # Rule 4: lord in sign of different oddity
        ls = pdata[lord]["rashi_idx"] if lord in pdata else sign_idx
        r4 = 1 if (sign_idx%2==0) != (ls%2==0) else 0
        # Rule 5: natural sign strength Dual>Fixed>Movable
        r5 = SIGN_TYPE.get(sign_idx, 0)
        # Rule 6: lord advancement in its sign
        ld = pdata[lord]["deg_rashi"] if lord in pdata else 0
        if lord in ("Rahu","Ketu"): ld = 30.0 - ld
        return (r1, r2, r3, r4, r5, ld)

    ref_label, ref_sign = max(candidates, key=lambda x: sign_strength_key(x[1]))

    # ── Step 2: Direction (odd/even sign) ─────────────────────────
    is_odd_sign = (ref_sign % 2 == 0)   # Ar=0(odd), Ta=1(even) ...

    # Check Saturn/Ketu in reference sign
    ref_planets = [p for p in PLANETS_9
                   if p in pdata and pdata[p]["rashi_idx"] == ref_sign]
    saturn_in_ref = "Saturn" in ref_planets
    ketu_in_ref   = "Ketu"   in ref_planets

    # Determine the 12-sign sequence from ref_sign in chosen direction
    if saturn_in_ref:
        # Always forward
        signs_seq = [(ref_sign + i) % 12 for i in range(12)]
    elif ketu_in_ref:
        # Always backward
        signs_seq = [(ref_sign - i) % 12 for i in range(12)]
    elif is_odd_sign:
        # Forward
        signs_seq = [(ref_sign + i) % 12 for i in range(12)]
    else:
        # Backward
        signs_seq = [(ref_sign - i) % 12 for i in range(12)]

    # House number of each sign from reference (1-indexed)
    sign_to_house = {signs_seq[i]: i+1 for i in range(12)}

    KENDRA   = {1, 4, 7, 10}
    PANAPARA = {2, 5, 8, 11}
    APOKLIMA = {3, 6, 9, 12}

    # ── Step 3: Group order (Kendra/Panapara/Apoklima) ────────────
    if saturn_in_ref:
        group_order_names = ["Kendra", "Panapara", "Apoklima"]
    elif ketu_in_ref:
        group_order_names = ["Kendra", "Apoklima", "Panapara"]
    elif is_odd_sign:
        group_order_names = ["Kendra", "Panapara", "Apoklima"]
    else:
        group_order_names = ["Kendra", "Apoklima", "Panapara"]

    group_sets = {"Kendra": KENDRA, "Panapara": PANAPARA, "Apoklima": APOKLIMA}

    # ── Step 4: Classify planets into groups ──────────────────────
    # Build: group_name → {sign → [planets]}
    groups = {g: {} for g in group_order_names}
    for planet in PLANETS_9:
        if planet not in pdata: continue
        d1_sign = pdata[planet]["rashi_idx"]
        house   = sign_to_house.get(d1_sign, 0)
        for gname in group_order_names:
            if house in group_sets[gname]:
                groups[gname].setdefault(d1_sign, []).append(planet)
                break

    # ── Step 5: Build ordered planet sequence ─────────────────────
    # PVR Book Ch.15.5.2 — Rules applied in order:
    #
    # SIGN ordering within each group (strongest sign goes FIRST):
    #   R1: Sign with more planets is stronger
    #   R2: Sign occupied/aspected by more of (Jupiter, Mercury, sign-lord) is stronger
    #   R3: Sign containing an exalted planet is stronger
    #   R4: Sign whose lord is in a sign of DIFFERENT oddity is stronger
    #   R5: Dual > Fixed > Movable (natural sign strength)
    #   R6: Sign whose lord is more advanced in its sign is stronger
    #
    # PLANET ordering within the same sign (strongest planet goes FIRST):
    #   P1: Planet with more co-planets in same sign is stronger
    #   P2: Planet conjoined/aspected by more of (Jupiter, Mercury, dispositor)
    #   P3: Exalted planet > Moolatrikona > Own sign > Normal
    #   P4: Vargottam and Vakri add strength; Combust/Ast reduces strength
    #   P5: Dual sign > Fixed > Movable (sign of the planet)
    #   P6: Planet more advanced in its sign (Rahu/Ketu from end)
    #
    # CRITICAL — within same sign, after all strength rules:
    #   FINAL TIE-BREAK: sort by C1 years ASCENDING
    #   (planet closest to its MT runs first — confirmed from JHora analysis)

    planet_sequence = []  # list of (planet, d1_sign, group_name, house)

    # Exaltation signs (0-based rasi index)
    EXALT_SIGN = {
        "Sun": 0, "Moon": 1, "Mars": 9, "Mercury": 5,
        "Jupiter": 3, "Venus": 11, "Saturn": 6
    }

    def rasi_asp(sa, sb):
        """True if sign sa aspects sign sb via rasi drishti."""
        diff = abs(sa - sb) % 12
        if diff == 6: return True          # 7th aspect (all signs)
        ta, tb = SIGN_TYPE.get(sa, 0), SIGN_TYPE.get(sb, 0)
        if diff in (1, 11): return False   # adjacent — no special aspect
        # Movable ↔ Fixed (except adjacent already handled)
        if (ta == 0 and tb == 1) or (tb == 0 and ta == 1): return True
        # Fixed ↔ Dual
        if (ta == 1 and tb == 2) or (tb == 1 and ta == 2): return True
        # Dual ↔ Movable
        if (ta == 2 and tb == 0) or (tb == 2 and ta == 0): return True
        return False

    def sign_sort_key(sign_idx, gname):
        """Higher tuple = stronger sign = goes first (reverse=True sort)."""
        planets_in = groups[gname].get(sign_idx, [])
        lord = RASHI_LORDS[sign_idx]

        # R1 — planet count
        r1 = len(planets_in)

        # R2 — Jupiter / Mercury / lord occupy or aspect this sign
        r2 = 0
        for chk in ["Jupiter", "Mercury", lord]:
            if chk not in pdata: continue
            cs = pdata[chk]["rashi_idx"]
            if cs == sign_idx or rasi_asp(cs, sign_idx):
                r2 += 1

        # R3 — exalted planet present
        r3 = 1 if any(EXALT_SIGN.get(p, -1) == sign_idx
                      for p in planets_in) else 0

        # R4 — lord's sign has different oddity
        ls = pdata[lord]["rashi_idx"] if lord in pdata else sign_idx
        r4 = 1 if (sign_idx % 2 == 0) != (ls % 2 == 0) else 0

        # R5 — natural sign strength: dual=2, fixed=1, movable=0
        r5 = SIGN_TYPE.get(sign_idx, 0)

        # R6 — lord advancement in its sign
        ld = pdata[lord]["deg_rashi"] if lord in pdata else 0
        if lord in ("Rahu", "Ketu"):
            ld = 30.0 - ld

        return (r1, r2, r3, r4, r5, ld)

    def planet_sort_key(planet, sign_idx):
        """Higher tuple = stronger planet = goes first (reverse=True sort)."""
        if planet not in pdata:
            return (0,) * 8

        lord = RASHI_LORDS[sign_idx]

        # P1 — co-planets in same sign
        p1 = sum(1 for q in PLANETS_9
                 if q != planet and q in pdata
                 and pdata[q]["rashi_idx"] == sign_idx)

        # P2 — aspected/conjoined by Jupiter / Mercury / dispositor
        p2 = 0
        for chk in ["Jupiter", "Mercury", lord]:
            if chk == planet or chk not in pdata: continue
            cs = pdata[chk]["rashi_idx"]
            if cs == sign_idx or rasi_asp(cs, sign_idx):
                p2 += 1

        # P3 — dignity hierarchy: exalt(3) > MT(2) > own(1) > normal(0)
        ps = pdata[planet]["rashi_idx"]
        if EXALT_SIGN.get(planet, -1) == ps:
            p3 = 3
        elif MOOLA_TRIKONA_JHORA.get(planet, -1) == ps:
            p3 = 2
        elif planet in OWN_SIGN and ps in OWN_SIGN[planet]:
            p3 = 1
        else:
            p3 = 0

        # P4 — Vargottam / Vakri boost; Combust penalty
        p4 = 0
        if pdata[planet].get("vargottam", False): p4 += 1
        if pdata[planet].get("vakri", False) and planet not in ("Sun","Moon"): p4 += 1
        if pdata[planet].get("combust", False): p4 -= 2

        # P5 — sign type of the planet's own sign
        p5 = SIGN_TYPE.get(ps, 0)

        # P6 — advancement in sign (Rahu/Ketu from end)
        deg = pdata[planet]["deg_rashi"]
        p6 = (30.0 - deg) if planet in ("Rahu","Ketu") else deg

        # Final tie-break: LOWER C1 runs first (raw_dist smallest = closest to MT)
        raw = (MOOLA_TRIKONA_JHORA.get(planet, ps) - ps) % 12
        c1  = VIMSH_YEARS.get(planet, 7) if raw == 0               else VIMSH_YEARS.get(planet, 7) - raw
        tie = -c1   # negate so smallest C1 → largest key → appears first

        return (p1, p2, p3, p4, p5, p6, tie)

    for gname in group_order_names:
        gdict = groups[gname]

        # Sort signs: strongest first
        sorted_signs = sorted(
            gdict.keys(),
            key=lambda s: sign_sort_key(s, gname),
            reverse=True
        )

        for sign_idx in sorted_signs:
            house = sign_to_house[sign_idx]

            # Sort planets within sign: strongest first
            planets_sorted = sorted(
                gdict[sign_idx],
                key=lambda p: planet_sort_key(p, sign_idx),
                reverse=True
            )

            for p in planets_sorted:
                planet_sequence.append((p, sign_idx, gname, house))

    if not planet_sequence:
        return [], 0, {}

    # ── Step 6: Balance at birth ───────────────────────────────────
    # Balance = fraction of reference sign remaining × C1 of first planet
    ref_deg_in_sign = pdata["Lagna"]["deg_rashi"] if ref_label == "Lagna" \
                      else pdata[ref_label]["deg_rashi"] if ref_label in pdata \
                      else pdata["Moon"]["deg_rashi"]
    frac_elapsed   = ref_deg_in_sign / 30.0
    frac_remaining = 1.0 - frac_elapsed

    first_p, first_sign, _, _ = planet_sequence[0]
    first_c1, _ = moola_dasha_period(first_p, first_sign, mt_correction_yrs)
    balance = frac_remaining * first_c1

    # ── Step 7: Build dasha timeline ──────────────────────────────
    dashas = []

    # Cycle 1
    for idx, (planet, d1_sign, gname, house) in enumerate(planet_sequence):
        c1, c2 = moola_dasha_period(planet, d1_sign, mt_correction_yrs)

        if idx == 0:
            md_start = birth_jd - (frac_elapsed * c1 * 365.25)
            md_end   = birth_jd + (balance * 365.25)
            md_yrs   = c1
        else:
            md_start = dashas[-1]["end_jd"]
            md_end   = md_start + c1 * 365.25
            md_yrs   = c1

        # Antardasha: proportional by C1 years of each planet
        total_c1 = sum(moola_dasha_period(p, s, mt_correction_yrs)[0]
                       for p, s, _, _ in planet_sequence)
        if total_c1 <= 0: total_c1 = 120

        ads, ad_cur = [], md_start
        for ad_p, ad_s, ad_g, _ in planet_sequence:
            ad_c1, _ = moola_dasha_period(ad_p, ad_s, mt_correction_yrs)
            ad_yrs   = (ad_c1 / total_c1) * md_yrs
            ad_end   = ad_cur + ad_yrs * 365.25
            ads.append({"planet": ad_p, "years": ad_yrs,
                        "months": round(ad_yrs * 12, 3),
                        "days":   round(ad_yrs * 365.25),
                        "start_jd": ad_cur, "end_jd": ad_end,
                        "group": ad_g})
            ad_cur = ad_end

        dashas.append({"planet": planet, "years": md_yrs, "cycle": 1,
                       "group": gname, "house": house,
                       "d1_sign": d1_sign, "c1_yrs": c1, "c2_yrs": c2,
                       "start_jd": md_start, "end_jd": md_end,
                       "antardashas": ads})

    # Cycle 2 — same order, use C2 years
    total_c2 = sum(moola_dasha_period(p, s, mt_correction_yrs)[1]
                   for p, s, _, _ in planet_sequence)
    if total_c2 <= 0: total_c2 = 1

    for planet, d1_sign, gname, house in planet_sequence:
        c1, c2 = moola_dasha_period(planet, d1_sign, mt_correction_yrs)
        md_start = dashas[-1]["end_jd"]
        md_end   = md_start + c2 * 365.25

        ads, ad_cur = [], md_start
        for ad_p, ad_s, ad_g, _ in planet_sequence:
            _, ad_c2 = moola_dasha_period(ad_p, ad_s, mt_correction_yrs)
            ad_yrs   = (ad_c2 / total_c2) * c2 if total_c2 > 0 else 0
            ad_end   = ad_cur + ad_yrs * 365.25
            ads.append({"planet": ad_p, "years": ad_yrs,
                        "months": round(ad_yrs * 12, 3),
                        "days":   round(ad_yrs * 365.25),
                        "start_jd": ad_cur, "end_jd": ad_end,
                        "group": ad_g})
            ad_cur = ad_end

        dashas.append({"planet": planet, "years": c2, "cycle": 2,
                       "group": gname, "house": house,
                       "d1_sign": d1_sign, "c1_yrs": c1, "c2_yrs": c2,
                       "start_jd": md_start, "end_jd": md_end,
                       "antardashas": ads})

    info = {
        "ref_label":        ref_label,
        "ref_sign":         ref_sign,
        "ref_sign_name":    RASHI_FULL[ref_sign],
        "is_odd_sign":      is_odd_sign,
        "saturn_in_ref":    saturn_in_ref,
        "ketu_in_ref":      ketu_in_ref,
        "group_order":      group_order_names,
        "planet_sequence":  planet_sequence,
        "balance":          balance,
        "mt_correction":    mt_correction_yrs,
        "direction":        "Forward" if (is_odd_sign or saturn_in_ref) else "Backward",
    }
    return dashas, balance, info



def moola_dasha_lagna(pdata, birth_jd, mt_correction_yrs=0):
    """
    LAGNA KENDRADI GRAHA DASHA — Fully verified against JHora (both Achal + Shyamveer).

    CONFIRMED RULES (reverse-engineered from JHora screenshots):
    ─────────────────────────────────────────────────────────────
    Moolatrikona signs:
        Sun=Le(4), Moon=Ta(1), Mars=Ar(0), Mercury=Vi(5), Jupiter=Sg(8),
        Venus=Li(6), Saturn=Aq(10), Rahu=Aq(10), Ketu=Cp(9)

    Period formula (C1, C2):
        raw = (MT_sign − D1_sign) % 12
        if raw == 0         → C1 = Vimsottari_yrs  (planet in MT, no correction)
        if 0 < raw < Vim    → C1 = Vim − raw
        if raw >= Vim       → C1 = raw % Vim        (wraps: e.g. Moon raw=11,Vim=10 → C1=1)
        C2 = Vim − C1
        Exaltation correction: if planet is exalted in D1 sign AND raw > 0 → C1 −= 1yr
        Effective period displayed:  eff = C2 if C1==0, else C1

    Balance at birth (CONFIRMED):
        if first planet C1 == 0 → balance = full C2, dasha starts EXACTLY at birth
        if first planet C1 >  0 → balance = full C1, dasha starts EXACTLY at birth
        NOTE: No fractional lagna-degree deduction. First dasha always starts at birth.

    House groups from Lagna (whole-sign, always forward count):
        house = (planet_sign − lagna_sign) % 12 + 1
        Kendra   = H1, H4, H7, H10
        Panapara = H2, H5, H8, H11
        Apoklima = H3, H6, H9, H12

    Group order:
        ODD lagna  → K → P → A
        EVEN lagna → K → A → P
        Saturn in H1 → always K → P → A
        Ketu in H1   → always K → A → P

    House ordering (strongest house first within group):
        PRIMARY:   house with more planets goes first
        SECONDARY: sum of planet degrees in house (more advanced = stronger)

    Planet ordering within same house (CONFIRMED from JHora):
        1. Non-shadow planets (not Rahu/Ketu) ordered by DEGREE DESC
           (higher degree in sign = more advanced = stronger)
        2. Shadow planets last: Rahu before Ketu
        NOTE: Retrograde, exaltation etc. do NOT affect sequence order.
              Degree alone determines order within the house.
    """
    PLANETS_9 = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]

    MT_SIGN    = MOOLA_TRIKONA_JHORA
    EXALT_SIGN = {"Sun":0,"Moon":1,"Mars":9,"Mercury":5,
                  "Jupiter":3,"Venus":11,"Saturn":6}
    SHADOW     = {"Rahu", "Ketu"}

    lagna_sign = pdata["Lagna"]["rashi_idx"]
    lagna_deg  = pdata["Lagna"]["deg_rashi"]
    is_odd     = (lagna_sign % 2 == 0)   # Ar=0(odd), Ta=1(even) ...

    in_lagna = [p for p in PLANETS_9
                if p in pdata and pdata[p]["rashi_idx"] == lagna_sign]
    saturn_in_h1 = "Saturn" in in_lagna
    ketu_in_h1   = "Ketu"   in in_lagna

    # ── Group order ─────────────────────────────────────────────────
    # Confirmed rules (from 4 charts):
    #   ODD lagna  → K → P → A  (forward)
    #   EVEN lagna → K → A → P  (backward)
    #   Ketu in H1 + ODD lagna → K → A → P  (reverses ODD default)
    #   Saturn in H1 → NO override (Vinay chart: Cp=EVEN, Saturn in H1, JHora still K→A→P)
    #
    # Ketu-in-H1 override only matters for ODD lagna (changes P↔A order).
    # For EVEN lagna, Ketu or Saturn in H1 makes no difference to group order.
    if ketu_in_h1 and is_odd:
        group_order = ["Kendra", "Apoklima", "Panapara"]
    elif is_odd:
        group_order = ["Kendra", "Panapara", "Apoklima"]
    else:
        group_order = ["Kendra", "Apoklima", "Panapara"]

    GROUP_HOUSES = {
        "Kendra":   {1, 4, 7, 10},
        "Panapara": {2, 5, 8, 11},
        "Apoklima": {3, 6, 9, 12},
    }

    # ── Assign planets to bhavas ────────────────────────────────────
    house_planets = {}
    planet_bhava  = {}
    for p in PLANETS_9:
        if p not in pdata: continue
        ps    = pdata[p]["rashi_idx"]
        bhava = (ps - lagna_sign) % 12 + 1
        planet_bhava[p] = bhava
        house_planets.setdefault(bhava, []).append(p)

    # ── Period formula ───────────────────────────────────────────────
    def _rk_mt(planet, d1_sign):
        """
        Rahu & Ketu Moolatrikona — confirmed from 6 Rahu + 5 Ketu chart cases:

        RAHU:
          ODD sign except Li  → MT = Capricorn  (9)
          EVEN sign  OR  Li   → MT = Aquarius   (10)
          [Li(6) behaves as EVEN, confirmed: Ashish Rahu-Li C1=14yr ✓]

        KETU — sign-relative offset:
          Ar(0)               → MT = Aries itself (0)  → raw=0 → C1=max(0,7-12)=0 → eff=C2=7yr
          ODD except Li,Ar    → MT = (sign + 4) % 12   → raw=4 → C1=3yr
          EVEN  or  Li        → MT = (sign + 2) % 12   → raw=2 → C1=5yr

          Special cases (override parity):
          Aq(10)=ODD : MT = (10+2)%12 = Ar(0) → raw=2 → C1=5yr ✓ (Raman)
          Cp(9)=EVEN : MT = (9+4)%12  = Ta(1) → raw=4 → C1=3yr ✓ (Jayendra)

        Confirmed cases:
          Ketu Ge(2)=ODD : MT=Li(6)  raw=4 C1=3 ✓ (Shyamveer)
          Ketu Sc(7)=EVEN: MT=Cp(9)  raw=2 C1=5 ✓ (Achal, Govind)
          Ketu Li(6)=ODD : MT=Sg(8)  raw=2 C1=5 ✓ (Krunal)
          Ketu Vi(5)=EVEN: MT=Sc(7)  raw=2 C1=5 ✓ (Krunal)
          Ketu Ar(0)=ODD : MT=Ar(0)  raw=0 C1=0 eff=7 ✓ (Ashish)
          Ketu Aq(10)=ODD: MT=Ar(0)  raw=2 C1=5 ✓ (Raman)
          Ketu Cp(9)=EVEN: MT=Ta(1)  raw=4 C1=3 ✓ (Jayendra Saraswati)

        Sign parity: is_odd = (sign_index % 2 == 0)
        """
        is_odd = (d1_sign % 2 == 0)
        if planet == "Rahu":
            # Li(6) treated as EVEN for Rahu (confirmed: Ashish Rahu-Li → C1=14)
            if is_odd and d1_sign != 6:
                return 9   # Capricorn
            else:
                return 10  # Aquarius
        else:   # Ketu
            if d1_sign == 0:              # Aries: MT = Aries itself
                return 0
            elif d1_sign == 9:            # Capricorn: uses +4 (confirmed Jayendra)
                return (d1_sign + 4) % 12
            elif d1_sign in (6, 10):      # Libra, Aquarius: use +2 despite being ODD
                return (d1_sign + 2) % 12
            elif is_odd and d1_sign != 6: # ODD but not Li, Aq, Ar
                return (d1_sign + 4) % 12
            else:                          # EVEN (excluding Cp)
                return (d1_sign + 2) % 12

    def c1c2(planet, d1_sign):
        vim = VIMSH_YEARS.get(planet, 7)

        # Rahu/Ketu use parity-based MT; all others use fixed MOOLA_TRIKONA_JHORA
        if planet in ("Rahu", "Ketu"):
            mt = _rk_mt(planet, d1_sign)
        else:
            mt = MT_SIGN.get(planet, d1_sign)

        raw = (mt - d1_sign) % 12

        # ── JHora "12 years" moolatrikona correction ─────────────────
        # When a planet occupies its own MT sign (raw=0), JHora subtracts 12
        # from Vimsottari years to get C1, rather than using the full period.
        # This matches all confirmed charts (Govind Mercury in Vi: 17-12=5yr ✓).
        # For planets with vim<=12: C1=max(0,vim-12)=0 → planet runs its C2 period.
        # For planets with vim>12 (Mercury=17,Jupiter=16,Saturn=19,Rahu=18): C1=vim-12.
        #
        # Confirmed:
        #   Mercury in Vi (vim=17,raw=0): C1=17-12=5yr ✓ (Govind)
        #   Moon in Ta    (vim=10,raw=0): C1=max(0,10-12)=0, eff=C2=10yr ✓ (Govind)
        #   Sun  in Le    (vim=6, raw=0): C1=max(0,6-12)=0,  eff=C2=6yr  ✓ (Govind)
        #   Ketu in Ar    (vim=7, raw=0): C1=max(0,7-12)=0,  eff=C2=7yr  ✓ (Ashish)
        if raw == 0:
            c1 = max(0, vim - 12)     # 12yr moolatrikona correction
        elif raw < vim:
            c1 = vim - raw            # normal forward distance
        elif raw == vim:
            c1 = 0                    # full cycle = runs C2
        else:
            # raw > vim (e.g. Moon vim=10, raw=11)
            c1 = raw % vim
            if c1 == 0:
                c1 = 0                # pure multiple → runs C2

        # ── Exaltation correction ─────────────────────────────────────
        # Applies ONLY when 0 < raw < vim (normal subtraction case).
        # Confirmed: Mars in Cp (exalted, raw=3) → C1=7-3-1=3yr ✓ (Vinay)
        #            Saturn in Li (exalted, raw=4) → C1=19-4-1=14yr ✓ (Govind)
        #            Venus in Vi (debil, raw=1, 0<raw<vim) → NO debil correction ✓ (Ashish)
        if 0 < raw < vim and c1 > 0 and EXALT_SIGN.get(planet, -1) == d1_sign:
            c1 = max(0, c1 - 1)

        # ── Debilitation correction ───────────────────────────────────
        # Applies ONLY when raw > vim (modulo/wrap case: c1 = raw%vim).
        # Confirmed: Mars in Cn (debil, raw=9>vim=7) → C1=9%7-1=1yr ✓ (Govind)
        # Does NOT apply in normal case (0<raw<vim): Venus in Vi debil, raw=1 → C1=19yr ✓
        DEBIL_SIGN = {"Sun":6,"Moon":7,"Mars":3,"Mercury":11,
                      "Jupiter":9,"Venus":5,"Saturn":0}
        if raw > vim and c1 > 0 and DEBIL_SIGN.get(planet, -1) == d1_sign:
            c1 = max(0, c1 - 1)

        c1 = max(0, c1)
        c2 = max(0, vim - c1)
        return int(c1), int(c2)

    # ── Planet strength score (for house ranking ONLY, not sequence order) ──
    def p_score(planet):
        if planet not in pdata: return 0.0
        ps  = pdata[planet]["rashi_idx"]
        sc  = 0.0
        if planet in OWN_SIGN and ps in OWN_SIGN[planet]:          sc += 4.0
        if EXALT_SIGN.get(planet, -1) == ps:                        sc += 3.0
        if MT_SIGN.get(planet, -1) == ps:                           sc += 2.0
        if pdata[planet].get("vargottam", False):                   sc += 2.0
        if pdata[planet].get("vakri", False) and planet not in SHADOW: sc += 1.0
        DEBIL = {"Sun":6,"Moon":7,"Mars":3,"Mercury":11,"Jupiter":9,"Venus":5,"Saturn":0}
        if DEBIL.get(planet, -1) == ps:                             sc -= 3.0
        if pdata[planet].get("combust", False):                     sc -= 2.0
        deg = pdata[planet]["deg_rashi"]
        sc += deg / 300.0
        return sc

    # Nakshatra lords (repeating 9-planet cycle across 27 nakshatras)
    NAK_LORDS = (["Ketu","Venus","Sun","Moon","Mars","Rahu","Jupiter","Saturn","Mercury"] * 3)

    # ── House sort key ───────────────────────────────────────────────
    def h_sort_key(bhava):
        """
        House strength for ordering within each group (strongest first).

        Rules (higher tuple = stronger = goes first):
          (1) Planet count — more planets is stronger
          (2) Has at least one non-shadow planet (regular > shadow-only)
          (3) Total strength score of all planets in house
              (own-sign+4, exalt+3, MT+2, vargottam+2, nak-lord+1, vakri+1, deg/300)
          (4) Total degrees (tiebreak)

        Confirmed: Sun(vargottam,+2.07) beats Saturn(vakri,+1.08)
                   even though Saturn has higher degree in sign.
        """
        planets    = house_planets.get(bhava, [])
        n          = len(planets)
        non_shadow = [p for p in planets if p not in SHADOW]
        has_ns     = 1 if non_shadow else 0

        # Total strength score for all planets in house
        def _planet_strength(planet):
            pd_p  = pdata.get(planet, {})
            ps    = pd_p.get("rashi_idx", 0)
            deg   = pd_p.get("deg_rashi", 0.0)
            nak   = pd_p.get("nak_idx", 0)
            sc    = 0.0
            EXALT_S = {"Sun":0,"Moon":1,"Mars":9,"Mercury":5,"Jupiter":3,"Venus":11,"Saturn":6}
            if planet in OWN_SIGN and ps in OWN_SIGN[planet]:    sc += 4.0
            elif EXALT_S.get(planet, -1) == ps:                   sc += 3.0
            elif MT_SIGN.get(planet, -1) == ps:                   sc += 2.0
            if pd_p.get("vargottam", False):                      sc += 2.0
            if (pd_p.get("vakri", False)
                    and planet not in SHADOW):                     sc += 1.0
            if 0 <= nak < 27 and NAK_LORDS[nak] == planet:       sc += 1.0
            return sc

        # NOTE: degree is NOT used — strength score alone determines house ordering
        score_sum = sum(_planet_strength(p) for p in planets)
        return (n, has_ns, score_sum)

    # ── Planet order within house ────────────────────────────────────
    def planet_sort_key(planet):
        """
        Ordering within same house — confirmed rules:

        Group 0 — Normal non-shadow (first):
          · Not vakri, OR combust-but-own-sign (treated as normal)
          · Sorted by: strength_score DESC, then degree DESC

        Group 1 — Vakri non-shadow (second):
          · Sorted by: strength_score DESC, then degree DESC

        Group 2 — Shadow: Rahu before Ketu

        Strength score:
          Own sign  +4, Exalted +3, Moolatrikona +2, Vargottam +2
          Nakshatra lord of own nakshatra +1 (planet is lord of its nak)
          Degree /300 (tiebreak)

        Confirmed examples:
          Mercury(own-Ge,+4) before Mars(+0) and Moon(+0) in same house
          Mercury(normal,29.7°) before Venus(vakri,29.4°) — vakri rule
          Saturn(normal,28.3°) before Rahu(shadow) — non-shadow rule
        """
        if planet in SHADOW:
            return (2, 0.0, 0 if planet=="Rahu" else 1, 0.0)

        pd_p     = pdata.get(planet, {})
        ps       = pd_p.get("rashi_idx", 0)
        is_vakri = pd_p.get("vakri", False)
        is_ast   = pd_p.get("combust", False)
        deg      = pd_p.get("deg_rashi", 0.0)
        nak_idx  = pd_p.get("nak_idx", 0)

        # Combust in own sign → treated as normal (Group 0, not demoted)
        # Combust in other sign + Sun NOT in same house → Group 1 (demoted, like vakri)
        # Combust in other sign + Sun IS in same house → Group 0 (use degree tiebreak)
        #   Rationale: Sun causes combustion; in a Sun-sharing house, combustion
        #   doesn't demote since Sun itself is Group 0 and degree decides order.
        # Confirmed: Venus(combust,non-own,Le,no Sun in H01) → Group 1 ✓ (Raman H01)
        # Confirmed: Mercury(combust,non-own,Sc,no Sun in H05) → Group 1 after Sun ✓ (Ashish)
        # Confirmed: Mercury(combust,non-own,Aq,WITH Sun in H02) → Group 0, deg→Mercury>Sun ✓ (Vinay)
        bhava_of_planet = (ps - lagna_sign) % 12 + 1
        sun_in_same_house = ("Sun" in house_planets.get(bhava_of_planet, [])
                             and planet != "Sun")
        own_sign_ast = is_ast and (planet in OWN_SIGN and ps in OWN_SIGN[planet])
        # Demote to Group 1: vakri, OR combust-non-own when Sun is NOT co-habiting
        is_demoted   = (is_vakri or
                        (is_ast and not own_sign_ast and not sun_in_same_house))
        order_group  = 1 if (is_demoted and planet not in SHADOW) else 0

        # ── Strength score (higher = runs first) ────────────────────
        # Base: Own(+4) > Exalt(+3) > Moolatrikona(+2) > Normal(0)
        # Bonuses:
        #   Vargottam           +2  (same sign in D1 and D9)
        #
        # Combust (ast) scoring rules (confirmed from Vinay chart):
        #   Combust in OWN sign  → score = own(+4) - combust penalty(2) = +2 net
        #                          Group 0 (not demoted)
        #   Combust in other sign → Group 1 (demoted), score = 0
        #   Non-combust          → normal scoring as above
        #
        # Degree tiebreak: when all dignity scores are equal, higher degree wins.
        # Confirmed: Jupiter(score=0,deg=20.55°) before Mars(score=0,deg=1.25°) ✓ (Jayendra H4)
        # Confirmed: Mercury(combust,non-own,0,23.89°) > Sun(0,21.80°) by degree ✓ (Vinay H2)
        EXALT_S = {"Sun":0,"Moon":1,"Mars":9,"Mercury":5,"Jupiter":3,"Venus":11,"Saturn":6}
        sc = 0.0
        is_own_sign = (planet in OWN_SIGN and ps in OWN_SIGN[planet])

        if is_own_sign and is_ast:
            sc += 2.0           # own-sign combust: +4 - 2 = +2 net
        elif is_own_sign or own_sign_ast:
            sc += 4.0           # own-sign (not combust)
        elif EXALT_S.get(planet, -1) == ps:
            sc += 3.0
        elif MT_SIGN.get(planet, -1) == ps:
            sc += 2.0
        # Combust non-own: score stays 0, degree is tiebreak
        # NOTE: Vargottam NOT included — degree is the tiebreaker after dignity,
        # not vargottam. Confirmed: Jupiter(deg=20.55°) > Mars(vargottam,deg=1.25°) ✓ (Jayendra)

        # Degree as pure tiebreak — NOT separate nak-lord bonuses
        # (nak-lord bonuses were removed: degree alone gives correct ordering,
        #  e.g. Mars/Moon in Krunal H7: Mars deg=11.85° > Moon deg=6.54° ✓)
        deg = pd_p.get("deg_rashi", 0.0)
        return (order_group, -sc, -deg)


    # ── Build planet sequence ────────────────────────────────────────
    #
    # CONFIRMED HOUSE ORDERING RULES (from Govind chart):
    #
    # Within each group (K/P/A), houses are ordered by:
    #   (1) Planet count DESC — more planets = stronger house
    #   (2) TIE on count → H1 (lagna house) wins, then H4, H7, H10 for Kendra
    #       (i.e. prefer H1 over higher-numbered houses on tie)
    #   (3) RAHU-KETU AXIS: if H1 contains Rahu → the OPPOSITE house (H7, which
    #       contains Ketu) goes IMMEDIATELY AFTER H1 in the sequence.
    #       In the Ketu-opposite house: Ketu runs FIRST (before non-shadow planets).
    #   (4) Score tiebreak after lagna-preference
    #
    # Govind example (EVEN Ta lagna, K→A→P):
    #   H1(Moon,Rahu,2pl), H4(Sun,Venus,2pl), H7(Jupiter,Ketu,2pl) all equal.
    #   → H1 first (lagna), H7 second (Rahu→Ketu axis), H4 third.
    #   In H7: Ketu first (Rahu-opposite rule), then Jupiter.

    def h_sort_key_with_lagna(bhava, rahu_house):
        """
        House sort key: lower value = goes first (ascending sort).

        Priority order:
          1. Planet count DESC (more planets = stronger)
          2. Has non-shadow planet (regular planet house beats shadow-only house)
          3a. If houses are SHADOW-ONLY and tied:
              - H1 (lagna house) wins FIRST regardless of Rahu/Ketu content
              - For non-lagna shadow houses: Ketu's house beats Rahu's house
          3b. For non-shadow (or mixed) houses: lagna house first (H1>H4>H7>H10)
          4. Score DESC

        Confirmed:
          India: H1(Rahu,lagna) before H7(Ketu) → lagna priority wins ✓
          Ashish: H10(Ketu) before H4(Rahu), neither is lagna → ketu_pref wins ✓
        """
        sc     = h_sort_key(bhava)
        n_p    = sc[0]
        has_ns = sc[1]
        score  = sc[2]

        planets     = house_planets.get(bhava, [])
        is_shad_only = all(p in SHADOW for p in planets) and len(planets) > 0

        lagna_pref  = 0 if bhava == 1 else (1 if bhava == 4 else (2 if bhava == 7 else 3))
        ketu_pref   = 0 if (ketu_bhava is not None and bhava == ketu_bhava) else 1
        # H1 lagna gets absolute priority even for shadow-only houses
        is_lagna_h  = 0 if bhava == 1 else 1   # 0 = lagna house → sorts first

        # For shadow-only houses: lagna(H1) first, then ketu_pref, then lagna_pref
        if is_shad_only:
            return (-n_p, -has_ns, is_lagna_h, ketu_pref, lagna_pref, -score)
        else:
            return (-n_p, -has_ns, lagna_pref, ketu_pref, -score)

    # Find Rahu's house and its opposite (Ketu's house)
    rahu_bhava = planet_bhava.get("Rahu", None)
    ketu_bhava = planet_bhava.get("Ketu", None)
    # The "opposite" of a house: H1↔H7, H2↔H8, H3↔H9, H4↔H10, H5↔H11, H6↔H12
    def opposite_house(h): return ((h - 1 + 6) % 12) + 1

    planet_sequence = []
    for gname in group_order:
        occupied = sorted(
            {h for h in GROUP_HOUSES[gname] if h in house_planets},
            key=lambda h: h_sort_key_with_lagna(h, rahu_bhava)
        )

        # Apply Rahu-Ketu axis rule within this group:
        # ONLY when Rahu's house is the FIRST in the naturally sorted list
        # AND there is a COUNT TIE between Rahu's house and Ketu's house.
        # Govind: H1(Rahu,2pl) → naturally first, Ketu H7 goes second ✓
        # Ashish: H1(Moon,2pl) → naturally first, Rahu H4 is last → axis rule does NOT apply
        if (occupied                                  # non-empty
                and rahu_bhava == occupied[0]         # Rahu's house is naturally FIRST
                and ketu_bhava is not None
                and ketu_bhava in GROUP_HOUSES[gname]
                and ketu_bhava in occupied
                and ketu_bhava != rahu_bhava
                and opposite_house(rahu_bhava) == ketu_bhava):
            # Only reorder if the two houses have equal planet count (tie condition)
            rahu_count = len(house_planets.get(rahu_bhava, []))
            ketu_count = len(house_planets.get(ketu_bhava, []))
            if rahu_count == ketu_count:
                # Rahu house first, Ketu house second, rest in original order
                reordered = [rahu_bhava, ketu_bhava] + [h for h in occupied
                             if h != rahu_bhava and h != ketu_bhava]
                occupied = reordered

        for bhava in occupied:
            planets_in_house = house_planets[bhava]

            # In the Ketu-opposite house (after Rahu's house): Ketu runs FIRST
            # ONLY when Rahu is in H1 (lagna house) — confirmed from Govind chart.
            # When Rahu is in a non-lagna house, normal planet ordering applies.
            is_ketu_opposite = (rahu_bhava == 1           # Rahu must be in H1 (lagna)
                                and ketu_bhava is not None
                                and opposite_house(rahu_bhava) == bhava
                                and bhava == ketu_bhava)

            if is_ketu_opposite:
                # Ketu first, then non-shadow planets by normal sort
                ketu_list    = [p for p in planets_in_house if p == "Ketu"]
                non_shadow_l = sorted([p for p in planets_in_house if p not in SHADOW],
                                      key=planet_sort_key)
                rahu_list    = [p for p in planets_in_house if p == "Rahu"]
                sorted_planets = ketu_list + non_shadow_l + rahu_list
            else:
                sorted_planets = sorted(planets_in_house, key=planet_sort_key)

            for p in sorted_planets:
                planet_sequence.append(
                    (p, pdata[p]["rashi_idx"], gname, bhava)
                )

    if not planet_sequence:
        return [], 0, {}

    # ── Balance: first dasha starts EXACTLY at birth ─────────────────
    # CONFIRMED: no fractional lagna-degree deduction.
    # The first planet runs its full effective period from birth.
    first_p, first_s, _, _ = planet_sequence[0]
    fc1, fc2 = c1c2(first_p, first_s)
    eff_first = fc2 if fc1 == 0 else fc1
    balance   = eff_first     # full period starting at birth

    # ── Build dasha timeline ─────────────────────────────────────────
    # period_lookup: planet → (d1_sign, c1, c2, eff)
    period_lookup = {}
    for p, s, g, h in planet_sequence:
        pc1, pc2 = c1c2(p, s)
        period_lookup[p] = (s, pc1, pc2, pc2 if pc1==0 else pc1)

    # MD sequence list (ordered)
    md_planets = [p for p,_,_,_ in planet_sequence]
    # total_eff_c1 = cycle-1 total; total_eff_c2 = cycle-2 total
    total_eff_c1 = max(1, sum(period_lookup[p][3] for p in md_planets))
    total_eff_c2 = max(1, sum(
        period_lookup[p][1] if period_lookup[p][1] > 0 else period_lookup[p][2]
        for p in md_planets
    ))

    YR = 365.25  # Julian year in days

    def build_sub_periods(parent_planet, parent_start_jd, parent_eff_yrs,
                          parent_total_eff, md_seq, period_lkp, cycle_id):
        """
        Build one level of sub-periods starting from parent_planet.
        Sub-period sequence: rotate md_seq to start from parent_planet.
        Formula: sub_duration = (parent_eff × sub_eff) / parent_total_eff   (in years)
        """
        idx = md_seq.index(parent_planet) if parent_planet in md_seq else 0
        sub_seq = md_seq[idx:] + md_seq[:idx]
        subs = []
        cur = parent_start_jd
        for sp in sub_seq:
            _, sc1, sc2, s_eff = period_lkp[sp]
            # Use cycle_id to decide which eff to use (1=C1 period, 2=C2 period)
            if cycle_id == 2:
                s_eff_used = sc1 if sc1 > 0 else sc2
            else:
                s_eff_used = s_eff  # C1 period (eff)
            dur_yrs = (parent_eff_yrs * s_eff_used) / parent_total_eff
            end_jd = cur + dur_yrs * YR
            subs.append({
                "planet": sp,
                "years": dur_yrs,
                "months": dur_yrs * 12,
                "days": dur_yrs * YR,
                "start_jd": cur,
                "end_jd": end_jd,
            })
            cur = end_jd
        return subs

    dashas = []

    for cycle_id, total_eff in [(1, total_eff_c1), (2, total_eff_c2)]:
        for planet, d1_sign, gname, bhava in planet_sequence:
            pc1, pc2 = c1c2(planet, d1_sign)
            if cycle_id == 1:
                eff = pc2 if pc1 == 0 else pc1
            else:
                eff = pc1 if pc1 > 0 else pc2

            if not dashas:
                md_start = birth_jd
            else:
                md_start = dashas[-1]["end_jd"]
            md_end = md_start + eff * YR

            # Build 5 levels of sub-periods (AD, PD, SD, PAD, Deha)
            # Level 1 = AD
            ads = build_sub_periods(planet, md_start, eff, total_eff, md_planets, period_lookup, cycle_id)

            for ad in ads:
                ad_total = total_eff  # same total for PD level
                # PD: total = total_eff (proportional to AD eff)
                ad_eff_for_pd = total_eff  # PD sub-divides AD in same ratio
                pds = build_sub_periods(ad["planet"], ad["start_jd"],
                                        ad["years"], total_eff, md_planets, period_lookup, cycle_id)
                for pd_d in pds:
                    sds = build_sub_periods(pd_d["planet"], pd_d["start_jd"],
                                            pd_d["years"], total_eff, md_planets, period_lookup, cycle_id)
                    for sd_d in sds:
                        pads = build_sub_periods(sd_d["planet"], sd_d["start_jd"],
                                                  sd_d["years"], total_eff, md_planets, period_lookup, cycle_id)
                        for pad_d in pads:
                            dehas = build_sub_periods(pad_d["planet"], pad_d["start_jd"],
                                                       pad_d["years"], total_eff, md_planets, period_lookup, cycle_id)
                            pad_d["sub"] = dehas
                        sd_d["sub"] = pads
                    pd_d["sub"] = sds
                ad["sub"] = pds

            dashas.append({
                "planet": planet, "years": eff, "cycle": cycle_id,
                "group": gname, "bhava": bhava, "d1_sign": d1_sign,
                "c1_yrs": pc1, "c2_yrs": pc2, "eff_yrs": eff,
                "start_jd": md_start, "end_jd": md_end,
                "antardashas": ads,   # backward-compat alias
                "sub": ads,
            })

    info = {
        "lagna_sign":      lagna_sign,
        "lagna_sign_name": RASHI_FULL[lagna_sign],
        "lagna_deg":       lagna_deg,
        "is_odd":          is_odd,
        "saturn_in_h1":    saturn_in_h1,
        "ketu_in_h1":      ketu_in_h1,
        "group_order":     group_order,
        "planet_sequence": planet_sequence,
        "balance":         balance,
        "house_planets":   house_planets,
        "planet_bhava":    planet_bhava,
        "p_score_map":     {p: round(p_score(p), 2) for p in PLANETS_9 if p in pdata},
        "h_score_map":     {h: h_sort_key(h) for h in house_planets},
    }
    return dashas, balance, info


# ═══════════════════════════════════════════════════════════════════
#  CITY DATABASE
# ═══════════════════════════════════════════════════════════════════

CITY_DB = {
    "mumbai":(19.0760,72.8777,5.5),"delhi":(28.6139,77.2090,5.5),
    "new delhi":(28.6139,77.2090,5.5),"bangalore":(12.9716,77.5946,5.5),
    "bengaluru":(12.9716,77.5946,5.5),"hyderabad":(17.3850,78.4867,5.5),
    "chennai":(13.0827,80.2707,5.5),"kolkata":(22.5726,88.3639,5.5),
    "pune":(18.5204,73.8567,5.5),"ahmedabad":(23.0225,72.5714,5.5),
    "surat":(21.1702,72.8311,5.5),"jaipur":(26.9124,75.7873,5.5),
    "lucknow":(26.8467,80.9462,5.5),"nagpur":(21.1458,79.0882,5.5),
    "indore":(22.7196,75.8577,5.5),"bhopal":(23.2599,77.4126,5.5),
    "patna":(25.5941,85.1376,5.5),"vadodara":(22.3072,73.1812,5.5),
    "nashik":(20.0059,73.7900,5.5),"varanasi":(25.3176,82.9739,5.5),
    "agra":(27.1767,78.0081,5.5),"amritsar":(31.6340,74.8723,5.5),
    "chandigarh":(30.7333,76.7794,5.5),"coimbatore":(11.0168,76.9558,5.5),
    "kochi":(9.9312,76.2673,5.5),"thiruvananthapuram":(8.5241,76.9366,5.5),
    "visakhapatnam":(17.6868,83.2185,5.5),"bhayandar":(19.3000,72.8500,5.5),
    "thane":(19.2183,72.9781,5.5),"navi mumbai":(19.0368,73.0158,5.5),
    "mira road":(19.2812,72.8726,5.5),"porbandar":(21.6417,69.6293,5.5),
    "rajkot":(22.3039,70.8022,5.5),"jodhpur":(26.2389,73.0243,5.5),
    "udaipur":(24.5854,73.7125,5.5),"goa":(15.2993,74.1240,5.5),
    "panaji":(15.4909,73.8278,5.5),"mysuru":(12.2958,76.6394,5.5),
    "mangaluru":(12.9141,74.8560,5.5),"madurai":(9.9252,78.1198,5.5),
    "dehradun":(30.3165,78.0322,5.5),"shimla":(31.1048,77.1734,5.5),"jaunpur":(25.7464,82.6836,5.5),"allahabad":(25.4358,81.8463,5.5),"prayagraj":(25.4358,81.8463,5.5),"gorakhpur":(26.7606,83.3732,5.5),"kanpur":(26.4499,80.3319,5.5),"meerut":(28.9845,77.7064,5.5),"noida":(28.5355,77.3910,5.5),"ghaziabad":(28.6692,77.4538,5.5),"srinagar":(34.0837,74.7973,5.5),"jammu":(32.7266,74.8570,5.5),"bhubaneswar":(20.2961,85.8245,5.5),"ranchi":(23.3441,85.3096,5.5),"raipur":(21.2514,81.6296,5.5),
    "london":(51.5074,-0.1278,0.0),"new york":(40.7128,-74.0060,-5.0),
    "los angeles":(34.0522,-118.2437,-8.0),"dubai":(25.2048,55.2708,4.0),
    "singapore":(1.3521,103.8198,8.0),"sydney":(-33.8688,151.2093,10.0),
}

def get_city(place):
    key = place.lower().strip()
    if key in CITY_DB: return CITY_DB[key]
    for k, v in CITY_DB.items():
        if key in k or k in key: return v
    return None


# ═══════════════════════════════════════════════════════════════════
#  MAIN CHART CALCULATOR
# ═══════════════════════════════════════════════════════════════════

def calculate_chart(name, gender, dob, tob, place):
    day, month, year = map(int, dob.split("/"))
    hour, minute     = map(int, tob.split(":"))
    local_h = hour + minute / 60.0
    coords  = get_city(place)
    if coords is None:
        print(f"  ⚠ '{place}' not found. Using Mumbai.")
        lat, lon_deg, tz = 19.076, 72.8777, 5.5
    else:
        lat, lon_deg, tz = coords
    ut_hour = local_h - tz
    jd = to_julian_day(year, month, day, ut_hour)

    pos = get_all_positions(jd)
    sid_lagna, cusps, ayan = get_lagna(jd, lat, lon_deg)
    pos["Lagna"] = {"lon": sid_lagna, "speed": 0.0, "lat": 0.0}
    engine = "pyswisseph ✓" if SWE_AVAILABLE else "Built-in VSOP87 (fallback ~0.5°)"

    # ── Build planet details ────────────────────────────────────────
    pdata = {}
    for p in PLANETS_ORDER:
        if p not in pos: continue
        lon = pos[p]["lon"]; spd = pos[p]["speed"]
        ri, dr   = get_rashi(lon)
        ni, pada, dn, nn, nl = get_nakshatra(lon)
        nav_ri   = get_navamsha_rashi(lon)
        dignity  = get_dignity(p, lon) if p != "Lagna" else "—"
        vakri    = is_vakri(spd, p)
        combust  = is_ast(p, lon, pos["Sun"]["lon"]) if p not in ("Sun","Lagna","Rahu","Ketu") else False
        vargo    = is_vargottam(lon)
        pdata[p] = {
            "lon": lon, "speed": spd, "rashi_idx": ri, "deg_rashi": dr,
            "nak_idx": ni, "pada": pada, "deg_nak": dn,
            "nak_name": nn, "nak_lord": nl, "nav_rashi": nav_ri,
            "dignity": dignity, "vakri": vakri, "combust": combust, "vargottam": vargo,
        }

    # ── Compute all divisional charts for each planet ───────────────
    all_divs = {}
    for p in PLANETS_ORDER:
        if p not in pdata: continue
        all_divs[p] = compute_all_divisionals(pdata[p]["lon"])

    SEP = "═" * 78

    # ═══ HEADER ════════════════════════════════════════════════════
    print(f"\n{SEP}")
    print(f"  ✦  NAKSHTRALOGY v2 — Vedic Birth Chart")
    print(SEP)
    print(f"  Name      : {name.upper()}")
    print(f"  Gender    : {gender.capitalize()}")
    print(f"  DOB/TOB   : {dob}  {tob} (local)  |  Place: {place.title()}")
    print(f"  Lat/Lon   : {lat:.4f}°  {lon_deg:.4f}°  |  TZ: +{tz}")
    print(f"  Ayanamsha : Lahiri = {ayan:.6f}°")
    print(f"  Engine    : {engine}")
    print(SEP)

    # ═══ GRAHA POSITIONS ═══════════════════════════════════════════
    print(f"\n  ┌─ GRAHA POSITIONS (Sidereal · Lahiri) {'─'*35}┐")
    print(f"  │  {'Planet':<10} {'Longitude':>14}  {'Rashi':<20} {'Nak':>4} {'P'}  {'Navamsha':<10}│")
    print(f"  ├{'─'*76}┤")
    for p in PLANETS_ORDER:
        if p not in pdata: continue
        d = pdata[p]
        flags = ""
        if d["vakri"]: flags += " ℞"
        if d["combust"]: flags += " 🔥"
        if d["vargottam"]: flags += " ✦"
        print(f"  │  {(p+flags):<13} {dms(d['lon']):>14}  {RASHIS[d['rashi_idx']]:<20} "
              f"{d['nak_idx']+1:>4} {d['pada']}  {RASHI_SHORT[d['nav_rashi']]:<10}│")
    print(f"  └{'─'*76}┘")

    # ═══ LAGNA KUNDLI (D-1) ════════════════════════════════════════
    lagna_ri = pdata["Lagna"]["rashi_idx"]
    planets_by_rashi_d1 = {}
    for p in PLANETS_ORDER:
        if p not in pdata: continue
        ri = pdata[p]["rashi_idx"]
        planets_by_rashi_d1.setdefault(ri, []).append(p)

    print(f"\n  ╔{'═'*60}╗")
    print(f"  ║  LAGNA KUNDLI — D-1 (North Indian Style)")
    print(f"  ║  Lagna: {RASHIS[lagna_ri]}")
    print(f"  ╚{'═'*60}╝")
    grid = make_kundli_grid(lagna_ri, planets_by_rashi_d1, "LAGNA KUNDLI")
    for line in grid.split("\n"):
        print(f"  {line}")

    # ═══ ALL 20 DIVISIONAL CHARTS ══════════════════════════════════
    D_CHARTS = [1,2,3,4,5,6,7,8,9,10,11,12,16,20,24,27,30,40,45,60]
    D_NAMES  = {
        1:"Rasi (D-1)",2:"Hora (D-2)",3:"Drekkana (D-3)",4:"Chaturthamsa (D-4)",
        5:"Panchamsa (D-5)",6:"Shashthamsa (D-6)",7:"Saptamsa (D-7)",
        8:"Ashtamsa (D-8)",9:"Navamsha (D-9)",10:"Dasamsha (D-10)",
        11:"Rudramsha (D-11)",12:"Dwadasamsha (D-12)",16:"Shodasamsha (D-16)",
        20:"Vimsamsha (D-20)",24:"Chaturvimsamsha (D-24)",27:"Nakshatramsha (D-27)",
        30:"Trimsamsha (D-30)",40:"Khavedamsha (D-40)",45:"Akshavedamsha (D-45)",
        60:"Shashtyamsha (D-60)",
    }
    D_PURPOSE = {
        1:"Physical existence, all matters",2:"Wealth, money",
        3:"Siblings, courage",4:"Property, residence, fortune",
        5:"Fame, authority, power",6:"Health troubles",
        7:"Children, grandchildren",8:"Sudden troubles, litigation",
        9:"Marriage, spouse, dharma",10:"Career, profession",
        11:"Death, destruction",12:"Parents, blood-relatives",
        16:"Vehicles, comforts, pleasures",20:"Spiritual matters, religious",
        24:"Learning, knowledge, education",27:"Strengths, weaknesses, nature",
        30:"Evils, sub-conscious, punishment",40:"Auspicious/inauspicious (maternal)",
        45:"All matters (paternal)",60:"Past-life karma — MOST IMPORTANT",
    }

    print(f"\n  ╔{'═'*76}╗")
    print(f"  ║  ALL DIVISIONAL CHART POSITIONS (D-1 to D-60)")
    print(f"  ║  Source: BPHS / PVR Narasimha Rao 'Vedic Astrology: An Integrated Approach'")
    print(f"  ╚{'═'*76}╝")

    # Table header
    p_cols = [p for p in PLANETS_ORDER if p in all_divs]
    col_w = 4
    hdr = f"  {'Chart':<22} {'Purpose':<36} " + " ".join(f"{p[:3]:>{col_w}}" for p in p_cols)
    print(f"\n{hdr}")
    print(f"  {'─'*22} {'─'*36} " + " ".join("─"*col_w for _ in p_cols))

    for d in D_CHARTS:
        chart_name = D_NAMES.get(d, f"D-{d}")
        purpose    = D_PURPOSE.get(d, "")[:35]
        signs_str  = " ".join(
            f"{RASHI_SHORT[all_divs[p].get(d,0)]:>{col_w}}"
            for p in p_cols
        )
        marker = " ◄" if d == 60 else ""
        print(f"  {chart_name:<22} {purpose:<36} {signs_str}{marker}")

    # ═══ D-60 KUNDLI (Visual) ══════════════════════════════════════
    # Build D-60 positions
    d60_lagna_sign = all_divs["Lagna"][60]
    planets_by_rashi_d60 = {}
    for p in PLANETS_ORDER:
        if p not in all_divs: continue
        ri = all_divs[p][60]
        planets_by_rashi_d60.setdefault(ri, []).append(p)

    print(f"\n  ╔{'═'*60}╗")
    print(f"  ║  D-60 SHASHTYAMSHA KUNDLI (North Indian Style)")
    print(f"  ║  D-60 Lagna: {RASHI_FULL[d60_lagna_sign]} ({RASHI_SHORT[d60_lagna_sign]})")
    print(f"  ╚{'═'*60}╝")
    grid60 = make_kundli_grid(d60_lagna_sign, planets_by_rashi_d60, "D-60 KUNDLI")
    for line in grid60.split("\n"):
        print(f"  {line}")

    # ═══ VIMSHOTTARI DASHA ═════════════════════════════════════════
    moon_lon  = pdata["Moon"]["lon"]
    lagna_lon = pdata["Lagna"]["lon"]
    v_dashas, v_balance, v_lord = vimshottari_dasha(moon_lon, jd)

    def _dur_label(days):
        """Format a duration in the most readable unit."""
        if   days >= 30.44:  return f"{days/30.4375:>6.2f}m({int(days):>4}d)"
        elif days >= 1:      return f"{'':>6}  {int(days):>4}d "
        elif days >= 1/24:   return f"{'':>6}  {days*24:>4.1f}h "
        else:                return f"{'':>6}  {days*24*60:>4.0f}′ "

    def _print_sub_vim(subs, indent, prefix="│"):
        """Recursively print Vimshottari sub-periods up to Deha level."""
        for s in subs:
            dur = s["end_jd"] - s["start_jd"]
            if dur < 1e-6: continue
            pad = "  " * indent
            p_str = s["planet"][:3]
            dur_lbl = _dur_label(dur)
            print(f"  {prefix}{pad}  └─ {p_str:<3}  {dur_lbl}  "
                  f"{jd_to_date(s['start_jd'])}─{jd_to_date(s['end_jd'])}")
            if "sub" in s and indent < 4:  # max 5 levels below MD (AD→Deha)
                _print_sub_vim(s["sub"], indent + 1, prefix)

    print(f"\n  ┌─ VIMSHOTTARI DASHA (Moon based · 120 yr) {'─'*33}┐")
    print(f"  │  Moon Nakshatra : {pdata['Moon']['nak_name']:<22}  Lord: {v_lord:<12}         │")
    print(f"  │  Balance at birth: {v_balance:.4f} yrs  ({v_balance*12:.2f} months)                       │")
    print(f"  ├{'─'*76}┤")
    print(f"  │  {'Mahadasha':<12} {'Yrs':>5}  {'Start':>12}  {'End':>14}                    │")
    print(f"  ├{'─'*76}┤")
    for d in v_dashas[:9]:
        print(f"  │  {d['planet']:<12} {d['years']:>5}  "
              f"  {jd_to_date(d['start_jd']):>12}    {jd_to_date(d['end_jd']):>12}             │")
        for ad in d["sub"]:
            dur_ad = ad["end_jd"] - ad["start_jd"]
            if dur_ad < 0.1: continue
            dur_lbl = _dur_label(dur_ad)
            print(f"  │    └─ {ad['planet']:<10} {dur_lbl}  "
                  f"{jd_to_date(ad['start_jd'])}─{jd_to_date(ad['end_jd'])}         │")
    print(f"  └{'─'*76}┘")

    # ═══ MOOLA DASHA — Run all 3 variants ═════════════════════════
    def print_moola(label, use_l, use_m, use_s, mt_corr=0):
        m_dashas, m_balance, m_seq = moola_dasha(
            pdata, jd,
            use_lagna=use_l, use_moon=use_m, use_sun=use_s,
            mt_correction_yrs=mt_corr
        )
        if not m_seq: return

        ref   = m_seq["ref_label"]
        rsign = m_seq["ref_sign"]
        print(f"\n  ╔{'═'*76}╗")
        print(f"  ║  MOOLA DASHA — {label}")
        print(f"  ║  Lagna Kendradi GRAHA Dasha  ·  PVR Narasimha Rao / Sanjay Rath (BPHS)")
        print(f"  ╠{'═'*76}╣")
        print(f"  ║  Reference      : {ref} = {RASHI_FULL[rsign]} ({RASHI_SHORT[rsign]})")
        print(f"  ║  Sign Type      : {'ODD → Forward' if m_seq['is_odd_sign'] else 'EVEN → Backward'}", end="")
        if m_seq['saturn_in_ref']: print(" [Saturn override → Forward]", end="")
        if m_seq['ketu_in_ref']:   print(" [Ketu override → Backward]", end="")
        print()
        print(f"  ║  Group Order    : {' → '.join(m_seq['group_order'])}")
        print(f"  ║  MT Correction  : {mt_corr} years  (when planet in its own MT sign)")
        print(f"  ║  Balance at birth: {m_balance:.4f} yrs  ({m_balance*12:.2f} months)")
        print(f"  ╠{'═'*76}╣")
        print(f"  ║  Planet Sequence (H=house from ref · D1=natal sign · MT=Moolatrikona)")
        SIGNS = RASHI_SHORT
        MT    = MOOLA_TRIKONA_JHORA
        for p, sign, group, house in m_seq["planet_sequence"]:
            c1, c2 = moola_dasha_period(p, sign, mt_corr)
            raw    = (MT.get(p, sign) - sign) % 12
            mt_s   = SIGNS[MT.get(p, sign)]
            print(f"  ║    H{house:02d} [{group:<8}] {p:<10} "
                  f"D1:{SIGNS[sign]:<3} MT:{mt_s:<3} "
                  f"raw={raw:>2}  C1={c1:>5.2f}yr  C2={c2:>5.2f}yr")
        print(f"  ╠{'═'*76}╣")
        print(f"  ║  {'Cy'} {'Planet':<12} {'Group':<8} {'H':>3}  "
              f"{'C1 yrs':>7}  {'C2 yrs':>7}  {'Start':>12}  {'End':>12}  ║")
        print(f"  ╠{'═'*76}╣")
        for d in m_dashas:
            gs = d['group'][:6]
            print(f"  ║  C{d['cycle']} {d['planet']:<12} {gs:<8} H{d['house']:02d} "
                  f"{d['c1_yrs']:>6.2f}y  {d['c2_yrs']:>6.2f}y  "
                  f"{jd_to_date(d['start_jd']):>12}  {jd_to_date(d['end_jd']):>12}  ║")
            for ad in d["antardashas"]:
                if ad["years"] > 0.005:
                    print(f"  ║    └─ {ad['planet']:<10} {ad['months']:>6.2f}m "
                          f"({int(ad['days']):>4}d)  "
                          f"{jd_to_date(ad['start_jd']):>12}─"
                          f"{jd_to_date(ad['end_jd']):>12}             ║")
        print(f"  ╠{'═'*76}╣")
        print(f"  ║  Formula: raw=(MT_sign-D1_sign)%12  ·  C1=Vim-raw  ·  C2=raw")
        print(f"  ║  Special: raw==0 (planet in MT) → C1=Vim-{mt_corr}, C2={mt_corr}")
        print(f"  ╚{'═'*76}╝")

    # ═══ LAGNA MOOLA DASHA — Confirmed Algorithm ══════════════════
    ml_dashas, ml_balance, ml_info = moola_dasha_lagna(pdata, jd, mt_correction_yrs=0)

    if ml_info:
        lg_s  = ml_info["lagna_sign"]
        is_o  = ml_info["is_odd"]
        SIGNS = RASHI_SHORT
        MT    = MOOLA_TRIKONA_JHORA

        print(f"\n  ╔{'═'*76}╗")
        print(f"  ║  MOOLA DASHA — LAGNA (House-Based · PVR BPHS Method)")
        print(f"  ║  Groups counted by BHAVA from Lagna, NOT from Rashi sign")
        print(f"  ╠{'═'*76}╣")
        print(f"  ║  Lagna          : {RASHI_FULL[lg_s]} ({SIGNS[lg_s]}) "
              f"at {pdata['Lagna']['deg_rashi']:.2f}° in sign")
        print(f"  ║  Sign Type      : {'ODD → Forward' if is_o else 'EVEN → Backward'}", end="")
        if ml_info['saturn_in_h1']: print("  [Saturn override → Forward]", end="")
        if ml_info['ketu_in_h1']:   print("  [Ketu override → Backward]", end="")
        print()
        print(f"  ║  Group Order    : {' → '.join(ml_info['group_order'])}")
        print(f"  ║  Balance        : {ml_balance:.4f} yrs  ({ml_balance*12:.2f} months)")
        print(f"  ╠{'═'*76}╣")
        print(f"  ║  HOUSE STRENGTH SCORES  (n=planet count, score=strength)")
        for h in sorted(ml_info["h_score_map"].keys()):
            h_key = ml_info["h_score_map"][h]  # (n, sc_sum, deg_sum)
            n_planets = h_key[0]
            sc_sum    = h_key[1]
            ri = (lg_s + h - 1) % 12
            planets_in = ml_info["house_planets"].get(h, [])
            p_detail = ", ".join(
                f"{p}({ml_info['p_score_map'].get(p,0):+.1f})"
                for p in planets_in
            )
            grp = "K" if h in {1,4,7,10} else ("P" if h in {2,5,8,11} else "A")
            print(f"  ║    H{h:02d}[{grp}] {SIGNS[ri]:<4}  n={n_planets}  score={sc_sum:.2f}"
                  f"  → {p_detail if p_detail else '(empty)'}")
        print(f"  ╠{'═'*76}╣")
        print(f"  ║  Planet Sequence  (H=bhava · D1=natal sign · MT=Moolatrikona · eff=period)")
        for p, sign, group, bhava in ml_info["planet_sequence"]:
            # Use same parity-based MT as _rk_mt() inside moola_dasha_lagna
            if p == "Rahu":
                mt_sign = 9 if (sign % 2 == 0) else 10   # ODD→Cp, EVEN→Aq
            elif p == "Ketu":
                # ODD (except Li=6): (sign+4)%12 → raw=4 → C1=3yr
                # EVEN or Li:        (sign+2)%12 → raw=2 → C1=5yr
                if (sign % 2 == 0) and sign != 6:
                    mt_sign = (sign + 4) % 12
                else:
                    mt_sign = (sign + 2) % 12
            else:
                mt_sign = MT.get(p, sign)
            raw = (mt_sign - sign) % 12
            vim = VIMSH_YEARS.get(p, 7)
            if raw == 0:     c1 = vim
            elif raw < vim:  c1 = vim - raw
            elif raw == vim: c1 = 0
            else:            c1 = raw % vim
            EXALT_D = {"Sun":0,"Moon":1,"Mars":9,"Mercury":5,"Jupiter":3,"Venus":11,"Saturn":6}
            if 0 < raw < vim and EXALT_D.get(p,-1)==sign and c1>0: c1 = max(0,c1-1)
            c2 = max(0, vim - max(0,c1))
            eff = c2 if c1==0 else c1
            sc  = ml_info["p_score_map"].get(p, 0)
            print(f"  ║    H{bhava:02d}[{group[0]}] {p:<10} "
                  f"D1:{SIGNS[sign]:<3} MT:{SIGNS[mt_sign]:<3} "
                  f"raw={raw:>2}  C1={c1:>3}yr  C2={c2:>3}yr  eff={eff:>3}yr  str={sc:+.1f}")
        print(f"  ╠{'═'*76}╣")
        print(f"  ║  Strength Rules: Own(+4) Exalt(+3) MT(+2) Vargottam(+2) "
              f"Vakri(+1) Debil(-3) Ast(-2) + deg/300")
        print(f"  ╠{'═'*76}╣")
        print(f"  ║  {'Cy'} {'Planet':<12} {'Grp':<4} {'H':>3}  "
              f"{'C1yr':>6}  {'C2yr':>6}   {'Start':>12}   {'End':>12}  ║")
        print(f"  ╠{'═'*76}╣")

        # ── Duration label ────────────────────────────────────────────
        def _dl(days):
            """Format duration: months(days) / days / hours / minutes."""
            if   days >= 30.44:  return f"{days/30.4375:>6.2f}m({int(days):>4}d)"
            elif days >= 1:      return f"{'':>6}  {int(days):>4}d "
            elif days >= 1/24:   return f"{'':>6}  {days*24:>4.1f}h "
            else:                return f"{'':>6}  {days*1440:>4.0f}′ "

        LEVEL_NAMES = ["AD", "PD", "SD", "PAD", "Deh"]

        def _print_first_chain(node, depth):
            """Recursively print only the first-planet chain at each depth level."""
            if depth > 4 or "sub" not in node or not node["sub"]:
                return
            first = node["sub"][0]
            dur = first["end_jd"] - first["start_jd"]
            if dur < 1e-6: return
            lv = LEVEL_NAMES[depth]
            indent = "  " * (depth + 1)
            print(f"  ║  {indent}└─[{lv}] {first['planet']:<9} "
                  f"{_dl(dur)}  "
                  f"{jd_to_date(first['start_jd'])}─{jd_to_date(first['end_jd'])}  ║")
            _print_first_chain(first, depth + 1)

        first_md = True
        for d in ml_dashas:
            gs = d["group"][0]
            print(f"  ║  C{d['cycle']} {d['planet']:<12} {gs:<4} H{d['bhava']:02d} "
                  f"{d['c1_yrs']:>5.2f}y  {d['c2_yrs']:>5.2f}y  "
                  f"{jd_to_date(d['start_jd']):>12}  {jd_to_date(d['end_jd']):>12}  ║")
            if d.get("sub"):
                for i, ad in enumerate(d["sub"]):
                    dur_ad = ad["end_jd"] - ad["start_jd"]
                    if dur_ad < 1e-6: continue
                    print(f"  ║    └─[AD] {ad['planet']:<9} "
                          f"{_dl(dur_ad)}  "
                          f"{jd_to_date(ad['start_jd'])}─{jd_to_date(ad['end_jd'])}  ║")
                    # For first MD's first AD, show PD→SD→PAD→Deha chain (first planet only)
                    if first_md and i == 0:
                        _print_first_chain(ad, depth=1)
            if first_md:
                print(f"  ║  {'·'*74}  ║")
                first_md = False
        print(f"  ╠{'═'*76}╣")
        print(f"  ║  Confirmed rules (from JHora matching):")
        print(f"  ║  · MT formula: raw=(MT-D1)%12; raw=0→C1=Vim; 0<raw<Vim→C1=Vim-raw")
        print(f"  ║    raw=Vim→C1=0,runs C2; raw>Vim→C1=raw%Vim; exalted planet→C1-=1")
        print(f"  ║  · Rahu MT: Cp if D1 sign ODD, Aq if EVEN")
        print(f"  ║  · Ketu MT: (sign+4)%12 if ODD(except Li); (sign+2)%12 if EVEN or Li")
        print(f"  ║  · First dasha starts at birth (no lagna-degree balance deduction)")
        print(f"  ║  · Within house: non-shadow by degree DESC, then shadow (Ra before Ke)")
        print(f"  ╚{'═'*76}╝")

    # ═══ GOCHAR — CURRENT TRANSIT SCORE ═══════════════════════════
    # Show today's gochar with native's Moon sign highlighted
    native_moon_sign = pdata["Moon"]["rashi_idx"]
    gochar_chart(date_str=None,
                 native_moon_sign=native_moon_sign,
                 show_detail=True)

    # ═══ FOOTER ════════════════════════════════════════════════════
    print(f"\n{SEP}")
    print(f"  ✦  Nakshtralogy v2  |  Lahiri Ayanamsha  |  Engine: {engine}")
    print(f"  ✦  Divisional Charts: D-1 to D-60 (20 charts)  |  Source: BPHS / PVR Rao")
    print(f"{SEP}\n")

    return pdata, all_divs


# ═══════════════════════════════════════════════════════════════════
#  INPUT
# ═══════════════════════════════════════════════════════════════════

def get_input():
    print("\n╔══════════════════════════════════════════════════════════════════════╗")
    print("║       ✦  NAKSHTRALOGY v2 — Vedic Astrology (pyswisseph)  ✦          ║")
    print("╚══════════════════════════════════════════════════════════════════════╝\n")
    name   = input("  Full Name       : ").strip() or "Unknown"
    gender = input("  Gender (M/F/O)  : ").strip() or "M"
    while True:
        dob = input("  Date of Birth   : (DD/MM/YYYY) ").strip()
        try:
            d,m,y = map(int, dob.split("/")); assert 1<=d<=31 and 1<=m<=12 and 1800<=y<=2100; break
        except: print("  ⚠ Use DD/MM/YYYY")
    while True:
        tob = input("  Time of Birth   : (HH:MM 24h)  ").strip()
        try:
            h,mn = map(int, tob.split(":")); assert 0<=h<=23 and 0<=mn<=59; break
        except: print("  ⚠ Use HH:MM")
    place = input("  Place of Birth  : ").strip() or "Mumbai"
    return name, gender, dob, tob, place


if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1 and sys.argv[1] == "--demo":
        print("  [DEMO — Mahatma Gandhi, 02/10/1869, 07:33, Porbandar]")
        calculate_chart("Mahatma Gandhi", "Male", "02/10/1869", "07:33", "Porbandar")
    elif len(sys.argv) > 1 and sys.argv[1] == "--gochar":
        # Standalone gochar: python nakshtralogy_v2.py --gochar [DD/MM/YYYY]
        date_arg = sys.argv[2] if len(sys.argv) > 2 else "today"
        gochar_chart(date_str=date_arg)
    else:
        try:
            args = get_input()
        except (KeyboardInterrupt, EOFError):
            print("\n  Using demo data.")
            args = ("Mahatma Gandhi","Male","02/10/1869","07:33","Porbandar")
        calculate_chart(*args)


# ═══════════════════════════════════════════════════════════════════
#  CONVENIENCE: Run both test charts from the images
# ═══════════════════════════════════════════════════════════════════

def run_test_charts():
    """Run Achal and Krunal charts to compare with JHora screenshots."""
    SEP = "─" * 70
    print(f"\n{'═'*70}")
    print("  TEST CHART 1 — Achal (matches JHora Image 1)")
    print(f"{'═'*70}")
    calculate_chart("Achal","Male","01/03/2003","23:55","Jaunpur")

    print(f"\n{'═'*70}")
    print("  TEST CHART 2 — Krunal (matches JHora Image 2)")
    print(f"{'═'*70}")
    calculate_chart("Krunal","Male","29/05/1987","20:55","Mumbai")