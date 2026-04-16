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

# Alias used by the helper layer (keeps helper code unchanged)
_USE_SWEPH = SWE_AVAILABLE

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


# ═══════════════════════════════════════════════════════════════════
#  DOSH ANALYSIS MODULE
#  Calculates 33 dosha presence as a probability (0–100%)
#  Sources: BPHS, Phaladeepika, Muhurta Chintamani, Saravali
#
#  SCORE BANDS:
#    0%      = Dosh completely absent
#    1–30%   = Mild / trace presence
#    31–60%  = Moderate (standard dosh)
#    61–80%  = Strong (significant impact)
#    81–100% = Severe (full dosh, no cancellations)
# ═══════════════════════════════════════════════════════════════════

_MRITYU_BHAGA = {
    "Sun":     {0:20,1:9, 2:12,3:6, 4:3, 5:27,6:25,7:18,8:22,9:2, 10:26,11:15},
    "Moon":    {0:26,1:12,2:13,3:25,4:24,5:11,6:26,7:14,8:13,9:25,10:5, 11:12},
    "Mars":    {0:2, 1:28,2:10,3:17,4:3, 5:28,6:2, 7:18,8:19,9:28,10:3, 11:22},
    "Mercury": {0:18,1:9, 2:17,3:22,4:3, 5:8, 6:20,7:19,8:15,9:25,10:7, 11:13},
    "Jupiter": {0:17,1:11,2:22,3:6, 4:13,5:6, 6:23,7:20,8:14,9:28,10:14,11:13},
    "Venus":   {0:23,1:11,2:17,3:11,4:22,5:4, 6:24,7:21,8:18,9:14,10:19,11:6},
    "Saturn":  {0:23,1:9, 2:9, 3:3, 4:9, 5:12,6:24,7:22,8:19,9:3, 10:19,11:3},
}
_GANDMOOL_NAK  = {0, 9, 10, 17, 18, 26}
_GANDANTA_NAK  = {9, 17, 26}
_NADI = {}
for _n in [0,7,9,13,14,20,21,22,26]: _NADI[_n] = 0
for _n in [1,6,10,12,15,19,23,25]:   _NADI[_n] = 1
for _n in [2,3,4,5,8,11,16,17,18,24]: _NADI[_n] = 2

def _dh(ps, rs): return (ps - rs) % 12 + 1
def _jup_asp(js, ts): return _dh(ts, js) in {5, 7, 9}
def _sat_asp(ss, ts): return _dh(ts, ss) in {3, 7, 10}
def _mar_asp(ms, ts): return _dh(ts, ms) in {4, 7, 8}
def _clp(v): return max(0.0, min(100.0, v))
def _gs(pd, p): return pd.get(p, {}).get("rashi_idx", 0)
def _gd(pd, p): return pd.get(p, {}).get("deg_rashi", 0.0)
def _dig(pd, p): return pd.get(p, {}).get("dignity", "Normal")

def _in_arc(sign, start, end):
    s, e = start % 12, end % 12
    if s < e: return s <= sign <= e
    return sign >= s or sign <= e

def _orb_between(pd, p1, p2):
    l1 = pd.get(p1,{}).get("lon",0); l2 = pd.get(p2,{}).get("lon",0)
    d = abs(l1-l2); return min(d, 360-d)

SIGN_LORD_D = {0:"Mars",1:"Venus",2:"Mercury",3:"Moon",4:"Sun",5:"Mercury",
               6:"Venus",7:"Mars",8:"Jupiter",9:"Saturn",10:"Saturn",11:"Jupiter"}

def _res(name, cat, score, desc, factors, cancels):
    sev = ("None" if score < 5 else "Mild" if score < 31 else
           "Moderate" if score < 61 else "Strong" if score < 81 else "Severe")
    return {"name":name,"category":cat,"score":round(_clp(score),1),
            "present":score>5,"severity":sev,"description":desc,
            "factors":factors,"cancels":cancels}


def analyze_all_dosh(pdata: dict) -> list:
    """
    Analyze 33 doshas from pdata dict.
    Each planet key must have: rashi_idx, deg_rashi, lon, dignity, vakri, combust, nak_idx, pada
    Returns list of dosh result dicts.
    """
    L  = _gs(pdata,"Lagna"); Su = _gs(pdata,"Sun");  Mo = _gs(pdata,"Moon")
    Ma = _gs(pdata,"Mars");  Me = _gs(pdata,"Mercury"); Ju = _gs(pdata,"Jupiter")
    Ve = _gs(pdata,"Venus"); Sa = _gs(pdata,"Saturn");  Ra = _gs(pdata,"Rahu")
    Ke = _gs(pdata,"Ketu")
    mo_nak = pdata.get("Moon",{}).get("nak_idx",0)
    mo_pada = pdata.get("Moon",{}).get("pada",1)
    H = {p: _dh(_gs(pdata,p), L)
         for p in ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]}
    SS = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi']
    res = []

    # ── 1. KAAL SARP DOSH ────────────────────────────────────────
    p7 = [Su,Mo,Ma,Me,Ju,Ve,Sa]
    arc_rk = [_in_arc(p,Ra,Ke) for p in p7]
    arc_kr = [_in_arc(p,Ke,Ra) for p in p7]
    in_one = all(arc_rk) or all(arc_kr)
    n_trap = min(sum(arc_rk), sum(arc_kr))
    ks_f, ks_c, ks_s = [], [], 0.0
    if in_one: ks_s=85.0; ks_f.append("All 7 planets between Rahu–Ketu")
    elif n_trap>=6: ks_s=55.0; ks_f.append(f"{n_trap}/7 planets in arc")
    elif n_trap>=4: ks_s=25.0; ks_f.append(f"{n_trap}/7 planets in arc (partial)")
    if ks_s>0:
        if _in_arc(L,Ra,Ke) or _in_arc(L,Ke,Ra): ks_s+=10; ks_f.append("Lagna inside arc")
        if _in_arc(Mo,Ra,Ke) or _in_arc(Mo,Ke,Ra): ks_s+=8; ks_f.append("Moon inside arc")
        if not (_in_arc(Ju,Ra,Ke) or _in_arc(Ju,Ke,Ra)): ks_s-=15; ks_c.append("Jupiter outside arc (protection)")
    res.append(_res("Kaal Sarp Dosh","Karmic/Rahu-Ketu",ks_s,"All planets hemmed between Rahu–Ketu",ks_f,ks_c))

    # ── 2. PITRA DOSH ────────────────────────────────────────────
    pt_f,pt_c,pt_s=[], [],0.0
    if Su==Ra: pt_s+=50; pt_f.append("Sun conjunct Rahu")
    elif Su==Ke: pt_s+=45; pt_f.append("Sun conjunct Ketu")
    if H["Sun"] in {8,12}: pt_s+=20; pt_f.append(f"Sun in H{H['Sun']}")
    for p in ["Rahu","Ketu","Saturn","Mars"]:
        if H[p]==9: pt_s+=25; pt_f.append(f"9th house: {p}")
    if _sat_asp(Sa,Su): pt_s+=15; pt_f.append("Saturn aspects Sun")
    if _jup_asp(Ju,Su): pt_s-=20; pt_c.append("Jupiter aspects Sun")
    res.append(_res("Pitra Dosh","Karmic/Rahu-Ketu",pt_s,"Ancestral karma: Sun/9th afflicted",pt_f,pt_c))

    # ── 3. GRAHAN DOSH ───────────────────────────────────────────
    gr_f,gr_c,gr_s=[],[],0.0
    for lum in ["Sun","Moon"]:
        for nd in ["Rahu","Ketu"]:
            if _gs(pdata,lum)==_gs(pdata,nd):
                orb=_orb_between(pdata,lum,nd)
                if orb<=6: gr_s+=55; gr_f.append(f"{lum}+{nd} orb={orb:.1f}° (tight)")
                elif orb<=12: gr_s+=30; gr_f.append(f"{lum}+{nd} orb={orb:.1f}°")
    if _jup_asp(Ju,Mo): gr_s-=20; gr_c.append("Jupiter aspects Moon")
    res.append(_res("Grahan Dosh","Karmic/Rahu-Ketu",gr_s,"Sun/Moon conjunct Rahu or Ketu",gr_f,gr_c))

    # ── 4. GURU CHANDAL DOSH ─────────────────────────────────────
    gc_f,gc_c,gc_s=[],[],0.0
    if Ju==Ra: gc_s=70; gc_f.append("Jupiter conjunct Rahu")
    elif Ju==Ke: gc_s=65; gc_f.append("Jupiter conjunct Ketu")
    elif _dh(Ju,Ra)==7 or _dh(Ju,Ke)==7: gc_s=30; gc_f.append("Jupiter aspected by Ra/Ke")
    if gc_s>0:
        dg=_dig(pdata,"Jupiter")
        if dg=="Debilitated": gc_s+=20; gc_f.append("Jupiter debilitated")
        elif dg in ("Exalted","Own"): gc_s-=20; gc_c.append(f"Jupiter {dg}")
    res.append(_res("Guru Chandal Dosh","Karmic/Rahu-Ketu",gc_s,"Jupiter corrupted by Rahu/Ketu",gc_f,gc_c))

    # ── 5. SHRAPIT DOSH ──────────────────────────────────────────
    sr_f,sr_c,sr_s=[],[],0.0
    if Sa==Ra: sr_s=75; sr_f.append("Saturn conjunct Rahu")
    elif _dh(Sa,Ra)==7: sr_s=30; sr_f.append("Saturn opposite Rahu")
    if sr_s>0 and H["Saturn"] in {1,7}: sr_s+=15; sr_f.append(f"In H{H['Saturn']}")
    if sr_s>0 and (_jup_asp(Ju,Sa) or Ju==Sa): sr_s-=20; sr_c.append("Jupiter with/aspects Saturn")
    res.append(_res("Shrapit Dosh","Karmic/Rahu-Ketu",sr_s,"Saturn conjunct Rahu",sr_f,sr_c))

    # ── 6. ANGARAK DOSH ──────────────────────────────────────────
    ag_f,ag_c,ag_s=[],[],0.0
    if Ma==Ra: ag_s=70; ag_f.append("Mars conjunct Rahu")
    elif _mar_asp(Ma,Ra): ag_s=25; ag_f.append("Mars aspects Rahu")
    if ag_s>0 and H["Mars"] in {1,4,7,8}: ag_s+=15; ag_f.append(f"In H{H['Mars']}")
    if ag_s>0 and _jup_asp(Ju,Ma): ag_s-=15; ag_c.append("Jupiter aspects Mars")
    res.append(_res("Angarak Dosh","Karmic/Rahu-Ketu",ag_s,"Mars conjunct Rahu: anger, accidents",ag_f,ag_c))

    # ── 7. MANGAL DOSH ───────────────────────────────────────────
    mg_f,mg_c,mg_s=[],[],0.0
    h_ma_L=H["Mars"]; h_ma_Mo=_dh(Ma,Mo); h_ma_Ve=_dh(Ma,Ve)
    if h_ma_L in {1,2,4,7,8,12}:
        mg_s+=50; mg_f.append(f"Mars H{h_ma_L} from Lagna")
        if h_ma_L in {1,7,8}: mg_s+=15; mg_f.append("Worst house (1/7/8)")
    if h_ma_Mo in {2,4,7,8,12}: mg_s+=15; mg_f.append(f"Mars H{h_ma_Mo} from Moon")
    if h_ma_Ve in {2,4,7,8,12}: mg_s+=10; mg_f.append(f"Mars H{h_ma_Ve} from Venus")
    if mg_s>0:
        dg=_dig(pdata,"Mars")
        if dg in ("Own","Exalted"): mg_s*=0.5; mg_c.append(f"Mars {dg} (50% reduction)")
        if L in {0,7,9,3}: mg_s-=15; mg_c.append(f"Lagna {SS[L]} partial cancel")
        if _jup_asp(Ju,Ma): mg_s-=20; mg_c.append("Jupiter aspects Mars")
    res.append(_res("Mangal Dosh","Planet-Based",mg_s,"Mars in 1/2/4/7/8/12 from Lagna",mg_f,mg_c))

    # ── 8. SHANI DOSH ────────────────────────────────────────────
    sn_f,sn_c,sn_s=[],[],0.0
    if H["Saturn"] in {1,3,7,10,12}:
        sn_s+=45; sn_f.append(f"Saturn H{H['Saturn']} from Lagna")
        if H["Saturn"] in {1,7,10}: sn_s+=15; sn_f.append("Angle (worse)")
    dg=_dig(pdata,"Saturn")
    if dg=="Exalted": sn_s-=25; sn_c.append("Saturn exalted (Li)")
    elif dg=="Own": sn_s-=20; sn_c.append("Saturn own sign")
    elif dg=="Debilitated": sn_s+=20; sn_f.append("Saturn debilitated")
    if _jup_asp(Ju,Sa): sn_s-=15; sn_c.append("Jupiter aspects Saturn")
    res.append(_res("Shani Dosh","Planet-Based",sn_s,"Saturn in bad houses: delays, obstacles",sn_f,sn_c))

    # ── 9. CHANDRA DOSH ──────────────────────────────────────────
    cd_f,cd_c,cd_s=[],[],0.0
    if H["Moon"] in {6,8,12}: cd_s+=40; cd_f.append(f"Moon H{H['Moon']}")
    if _dig(pdata,"Moon")=="Debilitated": cd_s+=25; cd_f.append("Moon debilitated (Sc)")
    mal_w_mo=[p for p in ["Saturn","Mars","Rahu","Ketu"] if _gs(pdata,p)==Mo]
    if mal_w_mo: cd_s+=15*len(mal_w_mo); cd_f.append(f"Moon conjunct {'+'.join(mal_w_mo)}")
    if _jup_asp(Ju,Mo): cd_s-=20; cd_c.append("Jupiter aspects Moon")
    if _dig(pdata,"Moon") in ("Exalted","Own"): cd_s-=20; cd_c.append("Moon exalted/own")
    res.append(_res("Chandra Dosh","Planet-Based",cd_s,"Moon afflicted: mind, mother, emotions",cd_f,cd_c))

    # ── 10. SURYA DOSH ───────────────────────────────────────────
    sd_f,sd_c,sd_s=[],[],0.0
    if H["Sun"] in {6,8,12}: sd_s+=40; sd_f.append(f"Sun H{H['Sun']}")
    if _dig(pdata,"Sun")=="Debilitated": sd_s+=25; sd_f.append("Sun debilitated (Li)")
    if Su==Sa or _sat_asp(Sa,Su): sd_s+=20; sd_f.append("Saturn with/aspects Sun")
    if Su==Ra or Su==Ke: sd_s+=15; sd_f.append("Sun with Rahu/Ketu")
    if _dig(pdata,"Sun") in ("Exalted","Own"): sd_s-=20; sd_c.append("Sun exalted/own")
    res.append(_res("Surya Dosh","Planet-Based",sd_s,"Sun afflicted: father, authority, vitality",sd_f,sd_c))

    # ── 11. BUDH DOSH ────────────────────────────────────────────
    bu_f,bu_c,bu_s=[],[],0.0
    if H["Mercury"] in {6,8,12}: bu_s+=35; bu_f.append(f"Mercury H{H['Mercury']}")
    if _dig(pdata,"Mercury")=="Debilitated": bu_s+=25; bu_f.append("Mercury debilitated (Pi)")
    if pdata.get("Mercury",{}).get("combust",False): bu_s+=20; bu_f.append("Mercury combust")
    if Me==Ra or Me==Ke: bu_s+=15; bu_f.append("Mercury with Rahu/Ketu")
    if _dig(pdata,"Mercury") in ("Exalted","Own","Moolatrikona"): bu_s-=20; bu_c.append("Mercury strong sign")
    res.append(_res("Budh Dosh","Planet-Based",bu_s,"Mercury afflicted: intellect, speech, siblings",bu_f,bu_c))

    # ── 12. SHUKRA DOSH ──────────────────────────────────────────
    sk_f,sk_c,sk_s=[],[],0.0
    if H["Venus"] in {6,8,12}: sk_s+=35; sk_f.append(f"Venus H{H['Venus']}")
    if _dig(pdata,"Venus")=="Debilitated": sk_s+=25; sk_f.append("Venus debilitated (Vi)")
    if Ve==Ra or Ve==Ke: sk_s+=20; sk_f.append("Venus with Rahu/Ketu")
    if Sa==Ve: sk_s+=15; sk_f.append("Saturn conjunct Venus")
    if _dig(pdata,"Venus") in ("Exalted","Own"): sk_s-=20; sk_c.append("Venus strong sign")
    res.append(_res("Shukra Dosh","Planet-Based",sk_s,"Venus afflicted: love, marriage, luxury",sk_f,sk_c))

    # ── 13. GURU DOSH ────────────────────────────────────────────
    gd_f,gd_c,gd_s=[],[],0.0
    if H["Jupiter"] in {6,8,12}: gd_s+=35; gd_f.append(f"Jupiter H{H['Jupiter']}")
    if _dig(pdata,"Jupiter")=="Debilitated": gd_s+=30; gd_f.append("Jupiter debilitated (Cp)")
    if Ju==Ra or Ju==Ke: gd_s+=20; gd_f.append("Jupiter with Rahu/Ketu")
    if pdata.get("Jupiter",{}).get("vakri",False) and gd_s>0: gd_s+=10; gd_f.append("Jupiter retrograde")
    if _dig(pdata,"Jupiter") in ("Exalted","Own"): gd_s-=25; gd_c.append("Jupiter exalted/own")
    res.append(_res("Guru Dosh","Planet-Based",gd_s,"Jupiter afflicted: wisdom, children, husband",gd_f,gd_c))

    # ── 14. KEMADRUMA DOSH ───────────────────────────────────────
    km_f,km_c,km_s=[],[],0.0
    p2m=(Mo+1)%12; p12m=(Mo-1)%12
    p_non_rk={p:_gs(pdata,p) for p in ["Sun","Mars","Mercury","Jupiter","Venus","Saturn"]}
    in2=any(s==p2m for s in p_non_rk.values())
    in12=any(s==p12m for s in p_non_rk.values())
    in_same=any(s==Mo for s in p_non_rk.values())
    if not in2 and not in12:
        km_s=60; km_f.append("No planet in 2nd or 12th from Moon")
        if in_same: km_s-=20; km_c.append("Planet conjunct Moon")
    elif not in2 or not in12: km_s=25; km_f.append("Planet only on one side of Moon")
    if H["Moon"] in {1,4,7,10}: km_s-=20; km_c.append("Moon in Kendra from Lagna")
    if _jup_asp(Ju,Mo): km_s-=20; km_c.append("Jupiter aspects Moon")
    res.append(_res("Kemadruma Dosh","Moon/Mind",km_s,"Moon isolated: no planet in 2nd/12th",km_f,km_c))

    # ── 15. VISH DOSH ────────────────────────────────────────────
    vd_f,vd_c,vd_s=[],[],0.0
    if Mo==Sa: vd_s=70; vd_f.append("Moon conjunct Saturn")
    elif _sat_asp(Sa,Mo): vd_s=30; vd_f.append("Saturn aspects Moon")
    if vd_s>0 and H["Moon"] in {1,6,8,12}: vd_s+=15; vd_f.append(f"In H{H['Moon']}")
    if vd_s>0 and _dig(pdata,"Moon")=="Debilitated": vd_s+=15; vd_f.append("Moon debilitated")
    if _jup_asp(Ju,Mo) and vd_s>0: vd_s-=20; vd_c.append("Jupiter aspects Moon")
    res.append(_res("Vish Dosh","Moon/Mind",vd_s,"Moon+Saturn: poisoned mind, depression",vd_f,vd_c))

    # ── 16. DARIDRA DOSH ─────────────────────────────────────────
    dr_f,dr_c,dr_s=[],[],0.0
    ll=SIGN_LORD_D.get(L,"Sun"); ll_h=_dh(_gs(pdata,ll),L)
    h11l=SIGN_LORD_D.get((L+10)%12,"Sun"); h11l_h=_dh(_gs(pdata,h11l),L)
    if ll_h in {6,8,12}: dr_s+=40; dr_f.append(f"Lagna lord ({ll}) in H{ll_h}")
    if h11l_h in {6,8,12}: dr_s+=30; dr_f.append(f"11th lord ({h11l}) in H{h11l_h}")
    if H["Jupiter"] in {6,8,12}: dr_s+=20; dr_f.append(f"Jupiter in H{H['Jupiter']}")
    if _jup_asp(Ju,L): dr_s-=25; dr_c.append("Jupiter aspects Lagna")
    res.append(_res("Daridra Dosh","Moon/Mind",dr_s,"Poverty yoga: Lagna/11th lords in dusthana",dr_f,dr_c))

    # ── 17. GANDMOOL DOSH ────────────────────────────────────────
    gm_f,gm_c,gm_s=[],[],0.0
    nak_names={0:"Ashwini",9:"Ashlesha",10:"Magha",17:"Jyeshtha",18:"Mula",26:"Revati"}
    if mo_nak in _GANDMOOL_NAK:
        gm_s=55; gm_f.append(f"Moon in {nak_names.get(mo_nak,'')} (Gandmool nakshatra)")
        if mo_nak in _GANDANTA_NAK: gm_s+=20; gm_f.append("Gandanta (sign junction, severe)")
        if mo_pada in {1,4}: gm_s+=10; gm_f.append(f"Pada {mo_pada} (boundary pada)")
    if gm_s>0 and _jup_asp(Ju,Mo): gm_s-=20; gm_c.append("Jupiter aspects Moon")
    res.append(_res("Gandmool Dosh","Misc/Advanced",gm_s,"Moon in Ra/Ke/Me sign-junction nakshatras",gm_f,gm_c))

    # ── 18. PAP KARTARI DOSH ─────────────────────────────────────
    pk_f,pk_c,pk_s=[],[],0.0
    mal_signs={_gs(pdata,p) for p in ["Saturn","Mars","Sun","Rahu","Ketu"]}
    for p in ["Moon","Venus","Jupiter","Mercury"]:
        ps=_gs(pdata,p); bef=(ps-1)%12; aft=(ps+1)%12
        if bef in mal_signs and aft in mal_signs:
            pk_s+=30; pk_f.append(f"{p} hemmed by malefics")
    bl=(L-1)%12; al=(L+1)%12
    if bl in mal_signs and al in mal_signs: pk_s+=35; pk_f.append("Lagna hemmed (Lagna Pap Kartari)")
    pk_s=_clp(pk_s)
    res.append(_res("Pap Kartari Dosh","House/Yoga",pk_s,"Benefic/Lagna hemmed between malefics",pk_f,pk_c))

    # ── 19. SHAKAT DOSH ──────────────────────────────────────────
    sh_f,sh_c,sh_s=[],[],0.0
    h_mo_ju=_dh(Mo,Ju); h_ju_mo=_dh(Ju,Mo)
    if h_mo_ju in {6,8} or h_ju_mo in {6,8}: sh_s=55; sh_f.append("Moon-Jupiter in 6-8 axis")
    elif h_mo_ju in {12,2}: sh_s=25; sh_f.append("Moon-Jupiter in 2-12 axis")
    if sh_s>0 and _jup_asp(Ju,Mo): sh_s-=15; sh_c.append("Jupiter also aspects Moon")
    res.append(_res("Shakat Dosh","House/Yoga",sh_s,"Moon-Jupiter in 6/8 axis",sh_f,sh_c))

    # ── 20. BALARISHTA DOSH ──────────────────────────────────────
    ba_f,ba_c,ba_s=[],[],0.0
    if H["Moon"] in {6,8,12}: ba_s+=40; ba_f.append(f"Moon H{H['Moon']}")
    mal_k=[p for p in ["Saturn","Mars","Rahu","Ketu"] if H[p] in {1,4,7,10}]
    if mal_k: ba_s+=15*len(mal_k); ba_f.append(f"Malefics in Kendra: {', '.join(mal_k)}")
    ben_k=[p for p in ["Jupiter","Venus"] if H[p] in {1,4,7,10}]
    if ben_k: ba_s-=20; ba_c.append(f"Benefics in Kendra: {', '.join(ben_k)}")
    if H["Jupiter"] in {1,4,7,10}: ba_s-=20; ba_c.append("Jupiter in Kendra (strong)")
    res.append(_res("Balarishta Dosh","House/Yoga",ba_s,"Child health: Moon in dusthana + malefics in Kendra",ba_f,ba_c))

    # ── 21. KENDRAADHIPATI DOSH ──────────────────────────────────
    ka_f,ka_c,ka_s=[],[],0.0
    DUAL_L={2,5,8,11}
    if L in DUAL_L:
        kl={SIGN_LORD_D.get((L+h-1)%12,"Sun") for h in [1,4,7,10]}
        nb=kl & {"Jupiter","Venus","Mercury","Moon"}
        if nb: ka_s=30; ka_f.append(f"Natural benefics {nb} rule Kendra for {SS[L]} lagna"); ka_f.append("Mixed results in their dashas")
    res.append(_res("Kendraadhipati Dosh","House/Yoga",ka_s,"Benefics ruling Kendra lose beneficence",ka_f,ka_c))

    # ── 22. MARAKA DOSH ──────────────────────────────────────────
    mk_f,mk_c,mk_s=[],[],0.0
    mk_pl=[p for p in ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn"] if H[p] in {2,7}]
    if mk_pl: mk_s+=20*len(mk_pl); mk_f.append(f"Planets in 2/7: {', '.join(mk_pl)}")
    h2l=SIGN_LORD_D.get((L+1)%12,"Sun"); h7l=SIGN_LORD_D.get((L+6)%12,"Sun")
    if _gs(pdata,h2l)==_gs(pdata,h7l): mk_s+=25; mk_f.append(f"2nd+7th lords ({h2l},{h7l}) together")
    mk_s=_clp(mk_s)
    res.append(_res("Maraka Dosh","House/Yoga",mk_s,"Planets in 2nd/7th: death inflicters",mk_f,mk_c))

    # ── 23. TRIK BHAVA DOSH ──────────────────────────────────────
    tb_f,tb_c,tb_s=[],[],0.0
    for p in ["Saturn","Mars","Sun","Rahu","Ketu"]:
        if H[p] in {6,8,12}:
            add=15 if p in {"Saturn","Rahu"} else 12
            tb_s+=add; tb_f.append(f"{p} in H{H[p]}")
    for p in ["Jupiter","Venus"]:
        if H[p] in {6,8,12}: tb_s+=10; tb_f.append(f"{p} in H{H[p]} (benefic)")
    tb_s=_clp(tb_s)
    res.append(_res("Trik Bhava Dosh","Misc/Advanced",tb_s,"Malefics in 6/8/12 accumulation",tb_f,tb_c))

    # ── 24. MRITYU BHAGA DOSH ────────────────────────────────────
    mb_f,mb_c,mb_s=[],[],0.0
    for p,mb_map in _MRITYU_BHAGA.items():
        ps=_gs(pdata,p); pdeg=_gd(pdata,p); crit=mb_map.get(ps,-99)
        if crit>=0 and abs(pdeg-crit)<=1.0:
            orb=abs(pdeg-crit)
            add=35 if orb<=0.5 else 20
            mb_s+=add; mb_f.append(f"{p} at {pdeg:.1f}° near Mrityu Bhaga {crit}° in {SS[ps]} (orb={orb:.1f}°)")
    mb_s=_clp(mb_s)
    res.append(_res("Mrityu Bhaga Dosh","Misc/Advanced",mb_s,"Planets at critical death degrees",mb_f,mb_c))

    # ── 25. DAINYA DOSH ──────────────────────────────────────────
    dy_f,dy_c,dy_s=[],[],0.0
    for h1 in [6,8,12]:
        l1=SIGN_LORD_D.get((L+h1-1)%12,"Sun"); s1=(L+h1-1)%12
        for h2 in range(1,13):
            if h2==h1: continue
            l2=SIGN_LORD_D.get((L+h2-1)%12,"Sun"); s2=(L+h2-1)%12
            if _gs(pdata,l1)==s2 and _gs(pdata,l2)==s1:
                dy_s+=30; dy_f.append(f"Parivartana H{h1}({l1}) ↔ H{h2}({l2})")
    dy_s=_clp(dy_s)
    res.append(_res("Dainya Dosh","Misc/Advanced",dy_s,"Trik lord in Parivartana with other houses",dy_f,dy_c))

    # ── 26. KHALA DOSH ───────────────────────────────────────────
    kh_f,kh_c,kh_s=[],[],0.0
    for h1,h2 in [(6,8),(6,12),(8,12)]:
        l1=SIGN_LORD_D.get((L+h1-1)%12,"Sun"); l2=SIGN_LORD_D.get((L+h2-1)%12,"Sun")
        s1=(L+h1-1)%12; s2=(L+h2-1)%12
        if _gs(pdata,l1)==s2 and _gs(pdata,l2)==s1:
            kh_s+=50; kh_f.append(f"Khala Parivartana H{h1}({l1}) ↔ H{h2}({l2})")
    kh_s=_clp(kh_s)
    res.append(_res("Khala Dosh","Misc/Advanced",kh_s,"Dusthana lord exchange (6↔8, 6↔12, 8↔12)",kh_f,kh_c))

    # ── 27. VIPREET RAJ YOGA ─────────────────────────────────────
    vr_f,vr_c,vr_s=[],[],0.0
    for h in [6,8,12]:
        lord=SIGN_LORD_D.get((L+h-1)%12,"Sun")
        lh=_dh(_gs(pdata,lord),L)
        if lh in {6,8,12} and lh!=h: vr_s+=33; vr_f.append(f"H{h} lord ({lord}) in H{lh}")
    vr_s=_clp(vr_s)
    res.append(_res("Vipreet Raj Yoga","Misc/Advanced",vr_s,"Trik lords in trik: misfortune reverses to fortune",vr_f,["Higher score = stronger protective yoga"]))

    # ── 28. CHANDAL YOGA (variation) ─────────────────────────────
    cy_f,cy_c,cy_s=[],[],0.0
    for p in ["Moon","Venus","Mercury"]:
        if _gs(pdata,p)==Ra: cy_s+=25; cy_f.append(f"{p} conjunct Rahu")
        elif _gs(pdata,p)==Ke: cy_s+=20; cy_f.append(f"{p} conjunct Ketu")
    cy_s=_clp(cy_s)
    res.append(_res("Chandal Yoga","Karmic/Rahu-Ketu",cy_s,"Benefics (Moon/Venus/Merc) corrupted by Ra/Ke",cy_f,cy_c))

    # ── 29. NADI DOSH (single chart — informational) ─────────────
    nd_nadi=_NADI.get(mo_nak,0)
    nd_nm=["Aadi (Vata)","Madhya (Pitta)","Antya (Kapha)"][nd_nadi]
    nk_n={0:"Ashwini",1:"Bharani",2:"Krittika",3:"Rohini",4:"Mrigashira",5:"Ardra",6:"Punarvasu",
           7:"Pushya",8:"Ashlesha",9:"Magha",10:"P.Phalguni",11:"U.Phalguni",12:"Hasta",
           13:"Chitra",14:"Swati",15:"Vishakha",16:"Anuradha",17:"Jyeshtha",18:"Mula",
           19:"P.Ashadha",20:"U.Ashadha",21:"Sravana",22:"Dhanishtha",23:"Shatabhisha",
           24:"P.Bhadra",25:"U.Bhadra",26:"Revati"}
    res.append(_res("Nadi Dosh","Marriage",0.0,f"Native Nadi: {nd_nm} (Moon nak: {nk_n.get(mo_nak,str(mo_nak))})",
                    [f"Nadi: {nd_nm}","Nadi Dosh requires two charts (marriage compatibility)"],
                    ["Full dosh calculated between couple charts"]))

    # ── 30. BHAKOOT DOSH (informational) ─────────────────────────
    res.append(_res("Bhakoot Dosh","Marriage",0.0,f"Native Moon sign: {RASHI_FULL[Mo]} (for compatibility)",
                    ["Bhakoot Dosh requires partner chart","6-8 axis = severe; 2-12 = moderate"],
                    ["Requires two charts for calculation"]))

    # ── 31. GANA DOSH (informational) ────────────────────────────
    GANA_MAP={0:"Deva",5:"Deva",6:"Deva",8:"Deva",15:"Deva",17:"Deva",22:"Deva",23:"Deva",24:"Deva",
              1:"Manushya",2:"Manushya",3:"Manushya",4:"Manushya",7:"Manushya",10:"Manushya",11:"Manushya",14:"Manushya",18:"Manushya",
              9:"Rakshasa",12:"Rakshasa",13:"Rakshasa",16:"Rakshasa",19:"Rakshasa",20:"Rakshasa",21:"Rakshasa",25:"Rakshasa",26:"Rakshasa"}
    gana=GANA_MAP.get(mo_nak,"Manushya")
    res.append(_res("Gana Dosh","Marriage",0.0,f"Native Gana: {gana}",
                    [f"Gana: {gana}","Gana Dosh requires two charts"],["Requires two charts"]))

    # ── 32. VARNA DOSH (informational) ───────────────────────────
    VARNA_MAP={4:"Brahmin",3:"Brahmin",1:"Kshatriya",0:"Kshatriya",2:"Vaishya",11:"Vaishya",
               5:"Shudra",6:"Shudra",7:"Shudra",8:"Shudra",9:"Shudra",10:"Shudra"}
    varna=VARNA_MAP.get(Mo,"Shudra")
    res.append(_res("Varna Dosh","Marriage",0.0,f"Native Varna: {varna}",
                    [f"Varna: {varna}","Requires two charts"],["Requires two charts"]))

    # ── 33. YONI DOSH (informational) ────────────────────────────
    YONI_NAK={0:"Horse",1:"Elephant",2:"Sheep",3:"Snake",4:"Dog",5:"Cat",6:"Rat",7:"Cow",
              8:"Buffalo",9:"Tiger",10:"Deer",11:"Monkey",12:"Mongoose",13:"Lion",14:"Horse",
              15:"Elephant",16:"Sheep",17:"Deer",18:"Dog",19:"Monkey",20:"Cat",21:"Rat",
              22:"Cow",23:"Buffalo",24:"Tiger",25:"Lion",26:"Mongoose"}
    yoni=YONI_NAK.get(mo_nak,"—")
    res.append(_res("Yoni Dosh","Marriage",0.0,f"Native Yoni: {yoni}",
                    [f"Yoni: {yoni}","Requires two charts"],["Requires two charts"]))

    return res


def display_dosh_analysis(pdata: dict) -> None:
    """
    Print formatted dosh analysis table with probability scores.
    All 33 doshas categorized as per classical Vedic astrology.
    """
    results = analyze_all_dosh(pdata)

    # User-specified category order and names
    CAT_ORDER = [
        "Karmic/Rahu-Ketu",
        "Planet-Based",
        "Moon/Mind",
        "Marriage",
        "House/Yoga",
        "Misc/Advanced",
    ]
    CAT_EMOJI = {
        "Karmic/Rahu-Ketu": "🐍",
        "Planet-Based":     "🔥",
        "Moon/Mind":        "🌙",
        "Marriage":         "💍",
        "House/Yoga":       "🧿",
        "Misc/Advanced":    "⚡",
    }
    CAT_LABEL = {
        "Karmic/Rahu-Ketu": "Karmic / Rahu-Ketu Related",
        "Planet-Based":     "Planet-Based Dosha",
        "Moon/Mind":        "Moon / Mind Related",
        "Marriage":         "Marriage / Compatibility Dosha",
        "House/Yoga":       "House / Yoga Based Dosha",
        "Misc/Advanced":    "Misc / Advanced",
    }
    SEV_BAR_CHAR = {"None":"░","Mild":"█","Moderate":"▓","Strong":"▒","Severe":"▒"}

    def _bar(score, width=22):
        """Color-coded bar: green=low, yellow=mid, red=high."""
        filled = int(score / 100.0 * width)
        if   score < 35:  ch = "█"    # mild   – solid
        elif score < 65:  ch = "▓"    # moderate
        else:              ch = "▒"   # strong/severe
        return ch * filled + "░" * (width - filled)

    def _sev_icon(sev):
        return {"None":"  ·  ","Mild":" ▪   ","Moderate":" ▪▪  ",
                "Strong":" ▪▪▪ ","Severe":" ◆◆◆◆"}.get(sev,"     ")

    # Group by category
    by_cat = {c: [] for c in CAT_ORDER}
    for r in results:
        by_cat.setdefault(r["category"], []).append(r)

    W = 78
    print(f"\n  ╔{'═'*W}╗")
    print(f"  ║{'DOSH ANALYSIS  —  Probability (0–100%) & Intensity':^{W}}║")
    print(f"  ║{'Sources: BPHS · Phaladeepika · Muhurta Chintamani · Saravali':^{W}}║")
    print(f"  ╠{'═'*W}╣")
    print(f"  ║  {'#':<3} {'Dosh Name':<26} {'Score':>6}  {'Severity':<10}  {'[░ mild ── moderate ── severe ░]':^24}  ║")
    print(f"  ╠{'═'*W}╣")

    dosh_num = 1
    for cat in CAT_ORDER:
        items = by_cat.get(cat, [])
        if not items:
            continue
        emoji = CAT_EMOJI.get(cat, "•")
        label = CAT_LABEL.get(cat, cat)
        print(f"  ║  {emoji} {label:<{W-5}}║")
        print(f"  ║  {'─'*W}║")

        for r in items:
            sc  = r["score"]
            sev = r["severity"]
            present_mark = "●" if r["present"] else " "
            bar = _bar(sc)

            # Main dosh row
            print(f"  ║  {present_mark} {dosh_num:>2}. {r['name']:<24} "
                  f"{sc:>5.1f}%  {sev:<10}  [{bar}]  ║")

            # Factors (max 2)
            for fac in r["factors"][:2]:
                print(f"  ║        ↳ {fac[:68]:<68}  ║")

            # Cancellations (max 1, only if dosh present)
            if r["present"] and r["cancels"]:
                print(f"  ║        ✘ {r['cancels'][0][:68]:<68}  ║")

            dosh_num += 1

        print(f"  ╠{'═'*W}╣")

    # ── Summary: only active doshas ────────────────────────────────────
    active = sorted([r for r in results if r["present"]], key=lambda x: -x["score"])
    total_score = sum(r["score"] for r in results if r["present"])

    print(f"  ║  📊 SUMMARY — {len(active)} Active Doshas  (Total intensity: {total_score:.0f} pts){'':<{W-52}}║")
    print(f"  ║  {'─'*W}║")
    print(f"  ║  {'Rank':<5} {'Dosh':<28} {'Score':>6}  {'Severity':<10}  {'Category':<22}  ║")
    print(f"  ║  {'─'*W}║")

    for rank, r in enumerate(active, 1):
        sym = "◆" if r["severity"] == "Severe" else ("▲" if r["severity"] == "Strong" else "●")
        print(f"  ║  {sym} {rank:<3} {r['name']:<28} {r['score']:>5.1f}%  "
              f"{r['severity']:<10}  {r['category']:<22}  ║")

    if not active:
        print(f"  ║  {'✔  No significant doshas found in this chart':<{W}}║")

    print(f"  ╠{'═'*W}╣")
    print(f"  ║  Score bands: Mild 1–30%  │  Moderate 31–60%  │  "
          f"Strong 61–80%  │  Severe 81–100%{'':<{W-73}}║")
    print(f"  ║  💍 Marriage doshas (Nadi/Bhakoot/Gana/Varna/Yoni) require two charts{'':<{W-71}}║")
    print(f"  ║  ✨ Vipreet Raj Yoga: higher score = stronger protective reversal{'':<{W-66}}║")
    print(f"  ╚{'═'*W}╝\n")




# ═══════════════════════════════════════════════════════════════════
#  YOGA ANALYSIS MODULE
#
#  Calculates 48 yoga presence as a probability (0–100%).
#  Sources: BPHS, Phaladeepika, Saravali, Brihat Jataka
#
#  STRENGTH BANDS:
#    0%       = Yoga absent
#    1–25%    = Weak / trace presence
#    26–50%   = Moderate strength
#    51–75%   = Strong yoga
#    76–100%  = Very Strong / Classical full yoga
# ═══════════════════════════════════════════════════════════════════

_Y_OWN = {
    "Sun":{4},"Moon":{3},"Mars":{0,7},"Mercury":{2,5},
    "Jupiter":{8,11},"Venus":{1,6},"Saturn":{9,10},
}
_Y_EXALT = {
    "Sun":0,"Moon":1,"Mars":9,"Mercury":5,"Jupiter":3,"Venus":11,"Saturn":6
}
_Y_DEBI  = {
    "Sun":6,"Moon":7,"Mars":3,"Mercury":11,"Jupiter":9,"Venus":5,"Saturn":0
}
_Y_SIGN_LORD = {
    0:"Mars",1:"Venus",2:"Mercury",3:"Moon",4:"Sun",5:"Mercury",
    6:"Venus",7:"Mars",8:"Jupiter",9:"Saturn",10:"Saturn",11:"Jupiter"
}

KENDRA   = {1,4,7,10}
TRIKONA  = {1,5,9}
DUSTHANA = {6,8,12}
UPACHAYA = {3,6,10,11}

def _y_dig(pdata, p):
    s = pdata.get(p,{}).get("rashi_idx",0)
    if s in _Y_OWN.get(p,set()): return "Own"
    if _Y_EXALT.get(p,-1)==s:     return "Exalted"
    if _Y_DEBI.get(p,-1)==s:      return "Debilitated"
    return "Normal"

def _y_house(ps, lagna): return (ps - lagna) % 12 + 1

def _y_strength(pdata, p):
    """0.5-2.0 multiplier: 2=exalt, 1.5=own, 1=normal, 0.5=debi/combust"""
    d = _y_dig(pdata, p)
    base = 2.0 if d=="Exalted" else (1.5 if d=="Own" else (0.5 if d=="Debilitated" else 1.0))
    if pdata.get(p,{}).get("combust",False): base *= 0.6
    return base

def _y_jup_asp(j_sign, t_sign): return (t_sign - j_sign) % 12 in {4,6,8}
def _y_7th_asp(a_sign, b_sign): return (b_sign - a_sign) % 12 == 6

def _y_connected(pdata, p1, p2):
    """True if p1 and p2 conjunct OR in mutual 7th aspect."""
    s1 = pdata.get(p1,{}).get("rashi_idx",0)
    s2 = pdata.get(p2,{}).get("rashi_idx",0)
    return s1 == s2 or _y_7th_asp(s1, s2)

def _y_malefic_count_in_house(pdata, house, lagna):
    mal = ["Saturn","Mars","Sun","Rahu","Ketu"]
    return sum(1 for p in mal if _y_house(pdata.get(p,{}).get("rashi_idx",0), lagna)==house)

def _y_result(name, cat, score, desc, factors, enhancers=None, reducers=None):
    band = ("Absent" if score < 1 else "Weak" if score < 26 else
            "Moderate" if score < 51 else "Strong" if score < 76 else "Very Strong")
    return {
        "name":name,"category":cat,
        "score":round(max(0.0,min(100.0,score)),1),
        "present":score>=10,
        "strength":band,
        "description":desc,
        "factors":factors or [],
        "enhancers":enhancers or [],
        "reducers":reducers or [],
    }


def analyze_all_yoga(pdata: dict) -> list:
    """
    Analyze 48 yogas from natal chart pdata.
    Returns list of yoga result dicts with probability scores (0-100%).
    """
    L   = pdata.get("Lagna",{}).get("rashi_idx",0)
    Su  = pdata.get("Sun",{}).get("rashi_idx",0)
    Mo  = pdata.get("Moon",{}).get("rashi_idx",0)
    Ma  = pdata.get("Mars",{}).get("rashi_idx",0)
    Me  = pdata.get("Mercury",{}).get("rashi_idx",0)
    Ju  = pdata.get("Jupiter",{}).get("rashi_idx",0)
    Ve  = pdata.get("Venus",{}).get("rashi_idx",0)
    Sa  = pdata.get("Saturn",{}).get("rashi_idx",0)
    Ra  = pdata.get("Rahu",{}).get("rashi_idx",0)
    Ke  = pdata.get("Ketu",{}).get("rashi_idx",0)

    def hs(p): return _y_house(pdata.get(p,{}).get("rashi_idx",0), L)
    def hm(p): return _y_house(pdata.get(p,{}).get("rashi_idx",0), Mo)
    def dig(p): return _y_dig(pdata, p)
    def st(p): return _y_strength(pdata, p)
    def lord(h): return _Y_SIGN_LORD.get((L+h-1)%12, "Sun")
    def lord_sign(h): return pdata.get(lord(h),{}).get("rashi_idx",0)
    def lord_house(h): return _y_house(lord_sign(h), L)
    def conn(p1,p2): return _y_connected(pdata, p1, p2)
    def con2(s1,s2): return s1==s2 or _y_7th_asp(s1,s2)
    SS = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi']

    RES = []

    # ── helper: affliction reducer for a sign/house ──────────────
    def _aff(planet):
        """Extra penalty if planet is in dusthana or with malefics."""
        h = hs(planet); pen = 0.0
        if h in DUSTHANA: pen += 20
        mal_in = [p for p in ["Saturn","Mars","Rahu","Ketu"]
                  if pdata.get(p,{}).get("rashi_idx",0)==pdata.get(planet,{}).get("rashi_idx",0)]
        pen += 8 * len(mal_in)
        return pen

    # ══════════════════════════════════════════════════════════════
    # 👑 1. RAJ YOGA
    # ══════════════════════════════════════════════════════════════
    ry_f, ry_e, ry_r = [], [], []
    ry_score = 0.0
    kendra_lords  = {lord(h) for h in [1,4,7,10]}
    trikona_lords = {lord(h) for h in [1,5,9]}
    pairs_seen = set()
    for kl in kendra_lords:
        for tl in trikona_lords:
            if kl == tl: continue  # H1 lord counts for both but skip self-pair
            pair = tuple(sorted([kl,tl]))
            if pair in pairs_seen: continue
            if conn(kl, tl):
                pairs_seen.add(pair)
                base = 30.0
                s1, s2 = st(kl), st(tl)
                base *= (s1 + s2) / 2.0
                kl_h, tl_h = hs(kl), hs(tl)
                if kl_h in KENDRA|TRIKONA and tl_h in KENDRA|TRIKONA: base *= 1.2
                ry_score += base
                ry_f.append(f"{kl}(H{lord_house(1 if kl==lord(1) else (4 if kl==lord(4) else (7 if kl==lord(7) else 10)))}) + "
                            f"{tl} conjunct/aspecting")
    ry_score = min(ry_score, 100.0)
    if ry_score > 0:
        ry_e.append(f"{len(pairs_seen)} Kendra-Trikona lord pair(s) connected")
    RES.append(_y_result("Raj Yoga","Raj Yoga",ry_score,
        "Kendra lord + Trikona lord conjunct/aspect — power and authority",ry_f,ry_e,ry_r))

    # ══════════════════════════════════════════════════════════════
    # 👑 2. MAHA RAJ YOGA
    # ══════════════════════════════════════════════════════════════
    mr_f, mr_score = [], 0.0
    # 3+ planets in own/exalt sign in Kendra/Trikona
    strong_in_kt = [p for p in ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn"]
                    if dig(p) in ("Own","Exalted") and hs(p) in KENDRA|TRIKONA]
    mr_score = len(strong_in_kt) * 20.0
    for p in strong_in_kt: mr_f.append(f"{p} {dig(p)} in H{hs(p)}")
    # Bonus if multiple Raj Yogas (use ry_score as proxy)
    if ry_score > 50: mr_score += 20; mr_f.append(f"Strong Raj Yoga present ({ry_score:.0f}%)")
    mr_score = min(mr_score, 100.0)
    RES.append(_y_result("Maha Raj Yoga","Raj Yoga",mr_score,
        "Multiple exalted/own planets in Kendra/Trikona — supreme success",mr_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 👑 3. DHARMA KARMA ADHIPATI YOGA
    # ══════════════════════════════════════════════════════════════
    dka_f, dka_score = [], 0.0
    l9 = lord(9); l10 = lord(10)
    if conn(l9, l10):
        base = 60.0
        base *= (st(l9) + st(l10)) / 2.0
        dka_score = min(base, 100.0)
        dka_f.append(f"9th lord ({l9}) + 10th lord ({l10}) connected")
        if hs(l9) in KENDRA|TRIKONA: dka_score = min(dka_score+15, 100); dka_f.append(f"{l9} in Kendra/Trikona")
        if hs(l10) in KENDRA|TRIKONA: dka_score = min(dka_score+15, 100); dka_f.append(f"{l10} in Kendra/Trikona")
    RES.append(_y_result("Dharma Karma Adhipati Yoga","Raj Yoga",dka_score,
        "9th lord + 10th lord united — dharmic career, high authority",dka_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 👑 4-8. PANCHA MAHAPURUSHA YOGAS
    # ══════════════════════════════════════════════════════════════
    PMP = [
        ("Ruchaka Yoga","Mars",{0,7},9),
        ("Bhadra Yoga","Mercury",{2,5},5),
        ("Hamsa Yoga","Jupiter",{8,11},3),
        ("Malavya Yoga","Venus",{1,6},11),
        ("Shasha Yoga","Saturn",{9,10},6),
    ]
    for yname, planet, own_s, exalt_s in PMP:
        pmp_f, pmp_score = [], 0.0
        ps = pdata.get(planet,{}).get("rashi_idx",0)
        ph = hs(planet)
        in_own   = ps in own_s
        in_exalt = ps == exalt_s
        in_kendra = ph in KENDRA
        if (in_own or in_exalt) and in_kendra:
            base = 75.0 if in_exalt else 60.0
            pmp_score = base
            pmp_f.append(f"{planet} in {'exaltation' if in_exalt else 'own sign'} ({SS[ps]}) in H{ph} (Kendra)")
            # Reduce for malefic conjunction
            mal_conj = [p for p in ["Saturn","Mars","Sun","Rahu","Ketu"]
                        if p!=planet and pdata.get(p,{}).get("rashi_idx",0)==ps]
            if mal_conj: pmp_score -= 15*len(mal_conj); pmp_f.append(f"Malefics conjunct: {mal_conj}")
            pmp_score = min(100, max(0, pmp_score))
        elif (in_own or in_exalt):
            pmp_score = 25.0
            pmp_f.append(f"{planet} {'exalted' if in_exalt else 'own sign'} but NOT in Kendra (H{ph})")
        RES.append(_y_result(yname,"Raj Yoga",pmp_score,
            f"Mars/Me/Ju/Ve/Sa in own/exalt in Kendra — great personality traits",pmp_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 👑 9. GAJ KESARI YOGA
    # ══════════════════════════════════════════════════════════════
    gk_f, gk_score = [], 0.0
    ju_from_mo = _y_house(Ju, Mo)
    ju_from_la = hs("Jupiter")
    if ju_from_mo in KENDRA:
        gk_score += 55.0; gk_f.append(f"Jupiter in H{ju_from_mo} from Moon")
    if ju_from_la in KENDRA:
        gk_score += 25.0; gk_f.append(f"Jupiter in H{ju_from_la} from Lagna")
    if gk_score > 0:
        d = dig("Jupiter")
        if d == "Exalted": gk_score = min(gk_score*1.4, 100); gk_f.append("Jupiter exalted")
        elif d == "Own":   gk_score = min(gk_score*1.2, 100); gk_f.append("Jupiter own sign")
        elif d == "Debilitated": gk_score *= 0.4; gk_f.append("Jupiter debilitated (weak)")
        if _aff("Jupiter") > 20: gk_score *= 0.7; gk_f.append("Jupiter afflicted")
    RES.append(_y_result("Gaj Kesari Yoga","Raj Yoga",gk_score,
        "Jupiter in Kendra from Moon/Lagna — wisdom, fame, prosperity",gk_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 👑 10. LAKSHMI YOGA
    # ══════════════════════════════════════════════════════════════
    lx_f, lx_score = [], 0.0
    l1 = lord(1); l9l = lord(9)
    l9_h = lord_house(9)
    l1_dig = dig(l1); l9_dig = dig(l9l)
    if l9_dig in ("Own","Exalted") and l9_h in KENDRA|TRIKONA:
        base = 65.0 if l9_dig=="Exalted" else 50.0
        lx_score += base; lx_f.append(f"9th lord ({l9l}) {l9_dig} in H{l9_h}")
        if l1_dig in ("Own","Exalted"):
            lx_score += 20; lx_f.append(f"Lagna lord ({l1}) also {l1_dig}")
    elif l9_dig in ("Own","Exalted"):
        lx_score = 25.0; lx_f.append(f"9th lord ({l9l}) {l9_dig} but in H{l9_h}")
    lx_score = min(lx_score, 100)
    RES.append(_y_result("Lakshmi Yoga","Raj Yoga",lx_score,
        "9th lord in own/exalt in Kendra/Trikona — wealth and grace of Lakshmi",lx_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 👑 11. CHANDRA MANGAL YOGA
    # ══════════════════════════════════════════════════════════════
    cm_f, cm_score = [], 0.0
    ma_from_mo = _y_house(Ma, Mo)
    if Mo == Ma:
        cm_score = 65.0; cm_f.append("Moon and Mars in same sign (conjunct)")
    elif _y_7th_asp(Mo, Ma):
        cm_score = 40.0; cm_f.append("Moon and Mars in mutual 7th aspect")
    elif ma_from_mo in {2,11}:
        cm_score = 35.0; cm_f.append(f"Mars in H{ma_from_mo} from Moon (wealth axis)")
    if cm_score > 0:
        if dig("Moon") in ("Exalted","Own"): cm_score = min(cm_score+15,100); cm_f.append("Moon strong")
        if dig("Mars") in ("Exalted","Own"): cm_score = min(cm_score+15,100); cm_f.append("Mars strong")
        pen = _aff("Moon") + _aff("Mars")
        if pen > 25: cm_score = max(0, cm_score-20); cm_f.append("Planets afflicted")
    RES.append(_y_result("Chandra Mangal Yoga","Raj Yoga",cm_score,
        "Moon + Mars together — financial enterprise, wealth through effort",cm_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 👑 12. NEECH BHANG RAJ YOGA
    # ══════════════════════════════════════════════════════════════
    nb_f, nb_score = [], 0.0
    for p in ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn"]:
        debi_s = _Y_DEBI.get(p,-1)
        if pdata.get(p,{}).get("rashi_idx",0) == debi_s:
            # Check cancellations
            cancel_count = 0
            dispositor = _Y_SIGN_LORD.get(debi_s, "Sun")
            disp_h = _y_house(pdata.get(dispositor,{}).get("rashi_idx",0), L)
            disp_h_mo = _y_house(pdata.get(dispositor,{}).get("rashi_idx",0), Mo)
            if disp_h in KENDRA: cancel_count += 1; nb_f.append(f"{p} debil: {dispositor} in Kendra from Lagna")
            if disp_h_mo in KENDRA: cancel_count += 1; nb_f.append(f"{p} debil: {dispositor} in Kendra from Moon")
            # Exalt lord in Kendra
            exalt_lord = _Y_SIGN_LORD.get(_Y_EXALT.get(p,-1), "Sun")
            exl_h = _y_house(pdata.get(exalt_lord,{}).get("rashi_idx",0), L)
            if exl_h in KENDRA: cancel_count += 1; nb_f.append(f"Exalt lord of {p} ({exalt_lord}) in Kendra")
            if cancel_count > 0:
                nb_score += 30.0 * cancel_count
                nb_f.append(f"{p} debilitated but CANCELLED ({cancel_count} factors)")
    nb_score = min(nb_score, 100.0)
    RES.append(_y_result("Neech Bhang Raj Yoga","Raj Yoga",nb_score,
        "Debilitated planet's weakness cancelled — reversal to strength",nb_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 👑 13. PARIVARTAN RAJ YOGA (mutual exchange in good houses)
    # ══════════════════════════════════════════════════════════════
    prv_f, prv_score = [], 0.0
    for h1 in range(1,13):
        l1p = lord(h1); s1 = (L+h1-1)%12
        for h2 in range(h1+1,13):
            l2p = lord(h2); s2 = (L+h2-1)%12
            if l1p==l2p: continue
            l1_in_s2 = pdata.get(l1p,{}).get("rashi_idx",0)==s2
            l2_in_s1 = pdata.get(l2p,{}).get("rashi_idx",0)==s1
            if l1_in_s2 and l2_in_s1:
                both_kt = h1 in KENDRA|TRIKONA and h2 in KENDRA|TRIKONA
                neither_dust = h1 not in DUSTHANA and h2 not in DUSTHANA
                if both_kt:
                    prv_score += 45; prv_f.append(f"Exchange H{h1}({l1p}) ↔ H{h2}({l2p}) [KT-KT Raja]")
                elif neither_dust:
                    prv_score += 20; prv_f.append(f"Exchange H{h1}({l1p}) ↔ H{h2}({l2p})")
    prv_score = min(prv_score, 100.0)
    RES.append(_y_result("Parivartan Raj Yoga","Raj Yoga",prv_score,
        "Lords exchange signs in Kendra/Trikona — elevation through karma",prv_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 👑 14. ADHI YOGA
    # ══════════════════════════════════════════════════════════════
    adhi_f, adhi_score = [], 0.0
    BENEFICS_NAT = ["Jupiter","Venus","Mercury"]
    # From Moon: benefics in 6,7,8 from Moon
    bens_from_mo = [p for p in BENEFICS_NAT if hm(p) in {6,7,8}]
    bens_from_la = [p for p in BENEFICS_NAT if hs(p) in {6,7,8}]
    if len(bens_from_mo) == 3:
        adhi_score += 70; adhi_f.append(f"All 3 benefics in 6/7/8 from Moon: {bens_from_mo}")
    elif len(bens_from_mo) == 2:
        adhi_score += 40; adhi_f.append(f"2 benefics in 6/7/8 from Moon: {bens_from_mo}")
    elif len(bens_from_mo) == 1:
        adhi_score += 20; adhi_f.append(f"1 benefic in 6/7/8 from Moon: {bens_from_mo}")
    if len(bens_from_la) >= 2:
        adhi_score += 20; adhi_f.append(f"{len(bens_from_la)} benefics in 6/7/8 from Lagna")
    adhi_score = min(adhi_score, 100.0)
    RES.append(_y_result("Adhi Yoga","Raj Yoga",adhi_score,
        "Natural benefics in 6/7/8 from Moon — minister/leader qualities",adhi_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 💰 15. DHAN YOGA
    # ══════════════════════════════════════════════════════════════
    dh_f, dh_score = [], 0.0
    l2 = lord(2); l11 = lord(11); l5 = lord(5)
    # 2nd lord + 11th lord connected
    if conn(l2, l11):
        base = 50.0 * (st(l2)+st(l11))/2; dh_score += base
        dh_f.append(f"2nd lord ({l2}) + 11th lord ({l11}) connected")
    # 2nd or 11th with lagna lord
    if conn(l2, lord(1)): dh_score += 20; dh_f.append(f"2nd lord ({l2}) + Lagna lord connected")
    if conn(l11, lord(1)): dh_score += 20; dh_f.append(f"11th lord ({l11}) + Lagna lord connected")
    # 2nd or 11th with 5th/9th lord
    if conn(l2, l5): dh_score += 15; dh_f.append(f"2nd lord ({l2}) + 5th lord ({l5})")
    if conn(l11, lord(9)): dh_score += 15; dh_f.append(f"11th lord ({l11}) + 9th lord ({lord(9)})")
    dh_score = min(dh_score, 100.0)
    RES.append(_y_result("Dhan Yoga","Dhan Yoga",dh_score,
        "2nd/11th lords connected with 1st/5th/9th — wealth accumulation",dh_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 💰 16. MAHA DHAN YOGA
    # ══════════════════════════════════════════════════════════════
    mdh_f, mdh_score = [], 0.0
    # Jupiter + Venus + 2nd lord all in Kendra or strong
    strong_wealth = [(p, dig(p)) for p in ["Jupiter","Venus",l2,l11]
                     if dig(p) in ("Exalted","Own") and hs(p) in KENDRA|TRIKONA]
    if len(strong_wealth) >= 3:
        mdh_score = 70 + (len(strong_wealth)-3)*10
        for p,d in strong_wealth: mdh_f.append(f"{p} {d} in H{hs(p)}")
    elif len(strong_wealth) == 2:
        mdh_score = 35
        for p,d in strong_wealth: mdh_f.append(f"{p} {d}")
    mdh_score = min(mdh_score, 100.0)
    RES.append(_y_result("Maha Dhan Yoga","Dhan Yoga",mdh_score,
        "3+ wealth planets exalted/own in Kendra — enormous wealth",mdh_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 💰 17. VASUMATI YOGA
    # ══════════════════════════════════════════════════════════════
    vs_f, vs_score = [], 0.0
    bens_in_upa_la = [p for p in BENEFICS_NAT if hs(p) in UPACHAYA]
    bens_in_upa_mo = [p for p in BENEFICS_NAT if hm(p) in UPACHAYA]
    if len(bens_in_upa_la) == 3:
        vs_score += 70; vs_f.append(f"All 3 benefics in Upachaya from Lagna: {bens_in_upa_la}")
    elif len(bens_in_upa_la) == 2:
        vs_score += 40; vs_f.append(f"2 benefics in Upachaya from Lagna: {bens_in_upa_la}")
    elif len(bens_in_upa_la) == 1:
        vs_score += 20; vs_f.append(f"1 benefic in Upachaya: {bens_in_upa_la}")
    if len(bens_in_upa_mo) >= 2:
        vs_score += 15; vs_f.append(f"{len(bens_in_upa_mo)} benefics in Upachaya from Moon")
    vs_score = min(vs_score, 100.0)
    RES.append(_y_result("Vasumati Yoga","Dhan Yoga",vs_score,
        "Natural benefics in Upachaya houses — self-earned wealth",vs_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 💰 18. DHANA KUBER YOGA
    # ══════════════════════════════════════════════════════════════
    dk_f, dk_score = [], 0.0
    conds = 0
    if dig("Jupiter") in ("Exalted","Own") and hs("Jupiter") in KENDRA|TRIKONA:
        conds += 1; dk_f.append(f"Jupiter {dig('Jupiter')} in H{hs('Jupiter')}")
    if dig(l2) in ("Exalted","Own") and lord_house(2) in KENDRA|TRIKONA:
        conds += 1; dk_f.append(f"2nd lord ({l2}) {dig(l2)}")
    if dig(l11) in ("Exalted","Own") and lord_house(11) in KENDRA|TRIKONA:
        conds += 1; dk_f.append(f"11th lord ({l11}) {dig(l11)}")
    dk_score = [0,30,60,100][min(conds,3)]
    RES.append(_y_result("Dhana Kuber Yoga","Dhan Yoga",dk_score,
        "Jupiter + 2nd lord + 11th lord all strong — billionaire potential",dk_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 💰 19. INDRA YOGA
    # ══════════════════════════════════════════════════════════════
    ind_f, ind_score = [], 0.0
    mo_ve_h = _y_house(Ve, Mo)
    ve_mo_h = _y_house(Mo, Ve)
    if mo_ve_h in {9,11} or ve_mo_h in {9,11}:
        ind_score = 55.0; ind_f.append(f"Moon and Venus in 9/11 axis from each other")
        if dig("Moon") in ("Exalted","Own"): ind_score += 15; ind_f.append("Moon strong")
        if dig("Venus") in ("Exalted","Own"): ind_score += 15; ind_f.append("Venus strong")
    ind_score = min(ind_score, 100.0)
    RES.append(_y_result("Indra Yoga","Dhan Yoga",ind_score,
        "Moon and Venus in 9/11 mutual axis — prosperity and luxury",ind_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 💰 20. PARIJATA YOGA
    # ══════════════════════════════════════════════════════════════
    pj_f, pj_score = [], 0.0
    ll = lord(1); ll_sign = pdata.get(ll,{}).get("rashi_idx",0)
    disp_of_ll = _Y_SIGN_LORD.get(ll_sign, "Sun")
    d_sign = pdata.get(disp_of_ll,{}).get("rashi_idx",0)
    d_h = _y_house(d_sign, L)
    disp_dig = dig(disp_of_ll)
    if disp_dig in ("Own","Exalted"):
        pj_score = 60.0; pj_f.append(f"Dispositor of Lagna lord ({disp_of_ll}) in {disp_dig}")
    if d_h in KENDRA|TRIKONA:
        pj_score = min(pj_score+20,100); pj_f.append(f"{disp_of_ll} in Kendra/Trikona H{d_h}")
    RES.append(_y_result("Parijata Yoga","Dhan Yoga",pj_score,
        "Dispositor of Lagna lord in own/exalt — sustained fortune",pj_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 🧠 21. BUDHADITYA YOGA
    # ══════════════════════════════════════════════════════════════
    ba_f, ba_score = [], 0.0
    if Su == Me:
        ba_score = 65.0; ba_f.append(f"Sun + Mercury in same sign ({SS[Su]})")
        if pdata.get("Mercury",{}).get("combust",False):
            ba_score *= 0.4; ba_f.append("Mercury combust — yoga severely weakened!")
        else:
            ba_f.append("Mercury NOT combust — yoga active")
        d = dig("Mercury")
        if d in ("Exalted","Own"): ba_score = min(ba_score+20,100); ba_f.append(f"Mercury {d}")
        if hs("Mercury") in KENDRA|TRIKONA: ba_score = min(ba_score+15,100); ba_f.append(f"In H{hs('Mercury')} Kendra/Trikona")
    RES.append(_y_result("Budhaditya Yoga","Buddhi Yoga",ba_score,
        "Sun + Mercury conjunct — sharp intellect, fame through knowledge",ba_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 🧠 22. SARASWATI YOGA
    # ══════════════════════════════════════════════════════════════
    sr_f, sr_score = [], 0.0
    good_houses = KENDRA | TRIKONA | {2}
    sv_conds = [(p, dig(p), hs(p)) for p in ["Jupiter","Venus","Mercury"]
                if dig(p) in ("Own","Exalted","Moolatrikona") and hs(p) in good_houses]
    if len(sv_conds) == 3:
        sr_score = 80.0; [sr_f.append(f"{p} {d} in H{h}") for p,d,h in sv_conds]
    elif len(sv_conds) == 2:
        sr_score = 45.0; [sr_f.append(f"{p} {d} in H{h}") for p,d,h in sv_conds]
    elif len(sv_conds) == 1:
        sr_score = 20.0; [sr_f.append(f"{p} {d} in H{h}") for p,d,h in sv_conds]
    RES.append(_y_result("Saraswati Yoga","Buddhi Yoga",sr_score,
        "Jupiter+Venus+Mercury all strong in Kendra/Trikona/2nd — great scholar",sr_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 🧠 23. MEDHA YOGA
    # ══════════════════════════════════════════════════════════════
    mh_f, mh_score = [], 0.0
    if hs("Mercury") in KENDRA|TRIKONA:
        mh_score = 35.0; mh_f.append(f"Mercury in H{hs('Mercury')} (Kendra/Trikona)")
        if dig("Mercury") in ("Own","Exalted"): mh_score += 25; mh_f.append(f"Mercury {dig('Mercury')}")
        if _y_jup_asp(Ju, Me): mh_score += 25; mh_f.append("Jupiter aspects Mercury")
        elif Ju==Me: mh_score += 20; mh_f.append("Jupiter conjunct Mercury")
    mh_score = min(mh_score, 100.0)
    RES.append(_y_result("Medha Yoga","Buddhi Yoga",mh_score,
        "Mercury in Kendra/Trikona + Jupiter aspect — intelligence, memory",mh_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 💼 24. AMALA YOGA
    # ══════════════════════════════════════════════════════════════
    am_f, am_score = [], 0.0
    p_in_10_la = [p for p in pdata if p!="Lagna" and _y_house(pdata.get(p,{}).get("rashi_idx",0),L)==10]
    p_in_10_mo = [p for p in pdata if p!="Lagna" and _y_house(pdata.get(p,{}).get("rashi_idx",0),Mo)==10]
    benef_set = set(BENEFICS_NAT)
    malef_set = {"Saturn","Mars","Sun","Rahu","Ketu"}
    la_10_bens = [p for p in p_in_10_la if p in benef_set]
    la_10_mal  = [p for p in p_in_10_la if p in malef_set]
    if la_10_bens and not la_10_mal:
        am_score += 55; am_f.append(f"Only benefics in 10th from Lagna: {la_10_bens}")
    mo_10_bens = [p for p in p_in_10_mo if p in benef_set]
    mo_10_mal  = [p for p in p_in_10_mo if p in malef_set]
    if mo_10_bens and not mo_10_mal:
        am_score += 30; am_f.append(f"Only benefics in 10th from Moon: {mo_10_bens}")
    am_score = min(am_score, 100.0)
    RES.append(_y_result("Amala Yoga","Career Yoga",am_score,
        "Only benefics in 10th house — spotless reputation",am_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 💼 25. KAHALA YOGA
    # ══════════════════════════════════════════════════════════════
    kh_f, kh_score = [], 0.0
    l4 = lord(4); ll_1 = lord(1)
    if _y_7th_asp(pdata.get(l4,{}).get("rashi_idx",0), Ju) or        pdata.get(l4,{}).get("rashi_idx",0)==Ju:
        kh_score += 40; kh_f.append(f"4th lord ({l4}) in mutual quadrant with Jupiter")
    if dig(ll_1) in ("Exalted","Own"):
        kh_score += 30; kh_f.append(f"Lagna lord ({ll_1}) {dig(ll_1)}")
    if _y_house(pdata.get(l4,{}).get("rashi_idx",0),L) in KENDRA:
        kh_score += 20; kh_f.append(f"4th lord ({l4}) in Kendra")
    kh_score = min(kh_score, 100.0)
    RES.append(_y_result("Kahala Yoga","Career Yoga",kh_score,
        "4th lord + Jupiter united + strong Lagna lord — boldness, authority",kh_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 💼 26. RAJA SAMBANDHA YOGA
    # ══════════════════════════════════════════════════════════════
    rb_f, rb_score = [], 0.0
    # Sun in 10th or 1st, or Sun + 10th lord together
    if hs("Sun") in {1,10}: rb_score += 35; rb_f.append(f"Sun in H{hs('Sun')} (power position)")
    l10 = lord(10)
    if conn("Sun", l10): rb_score += 35; rb_f.append(f"Sun connected with 10th lord ({l10})")
    if dig("Sun") in ("Exalted","Own"): rb_score += 20; rb_f.append(f"Sun {dig('Sun')}")
    rb_score = min(rb_score, 100.0)
    RES.append(_y_result("Raja Sambandha Yoga","Career Yoga",rb_score,
        "Sun + 10th lord connected — royal/government connections",rb_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 💼 27-29. VESI / VASI / UBHAYACHARI YOGA
    # ══════════════════════════════════════════════════════════════
    # Vesi: planet in 2nd from Sun (except Moon)
    vesi_f, vesi_score = [], 0.0
    vasi_f, vasi_score = [], 0.0
    sun_p2 = (Su+1)%12; sun_m1 = (Su-1)%12
    for p in ["Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]:
        ps2 = pdata.get(p,{}).get("rashi_idx",0)
        if ps2 == sun_p2:
            if p in BENEFICS_NAT: vesi_score += 40; vesi_f.append(f"{p} (benefic) in 2nd from Sun → Shubha Vesi")
            else:                  vesi_score += 15; vesi_f.append(f"{p} (malefic) in 2nd from Sun → Papa Vesi")
        if ps2 == sun_m1:
            if p in BENEFICS_NAT: vasi_score += 40; vasi_f.append(f"{p} (benefic) in 12th from Sun → Shubha Vasi")
            else:                  vasi_score += 15; vasi_f.append(f"{p} (malefic) in 12th from Sun → Papa Vasi")
    vesi_score = min(vesi_score, 100)
    vasi_score = min(vasi_score, 100)
    ubh_score  = min((vesi_score + vasi_score)/2 + 20, 100) if vesi_score>0 and vasi_score>0 else 0
    RES.append(_y_result("Vesi Yoga","Career Yoga",vesi_score,"Planet in 2nd from Sun — eloquence, wealth",vesi_f,[],[]))
    RES.append(_y_result("Vasi Yoga","Career Yoga",vasi_score,"Planet in 12th from Sun — comfort, service",vasi_f,[],[]))
    ubh_f = vesi_f + vasi_f
    RES.append(_y_result("Ubhayachari Yoga","Career Yoga",ubh_score,
        "Planets in both 2nd and 12th from Sun — balanced all-round success",ubh_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 🧘 30. SANYASA YOGA
    # ══════════════════════════════════════════════════════════════
    sy_f, sy_score = [], 0.0
    sign_counts = {}
    for p in ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn"]:
        s = pdata.get(p,{}).get("rashi_idx",0); sign_counts[s] = sign_counts.get(s,0)+1
    max_in_sign = max(sign_counts.values()) if sign_counts else 0
    if max_in_sign >= 5:
        sy_score = 80; sy_f.append(f"{max_in_sign} planets in one sign")
    elif max_in_sign == 4:
        sy_score = 50; sy_f.append(f"4 planets in one sign")
    elif max_in_sign == 3:
        sy_score = 20; sy_f.append(f"3 planets in one sign (weak)")
    # Additional: Saturn in 1st/12th/9th, Ketu strong
    if hs("Saturn") in {1,9,12}: sy_score += 15; sy_f.append(f"Saturn in H{hs('Saturn')} (renunciation)")
    sy_score = min(sy_score, 100)
    RES.append(_y_result("Sanyasa Yoga","Spiritual Yoga",sy_score,
        "4+ planets in one sign — tendency toward renunciation/spirituality",sy_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 🧘 31. MOKSHA YOGA
    # ══════════════════════════════════════════════════════════════
    mk_f, mk_score = [], 0.0
    if hs(lord(1)) == 12: mk_score += 30; mk_f.append(f"Lagna lord ({lord(1)}) in 12th")
    if lord_house(12) in KENDRA|TRIKONA: mk_score += 20; mk_f.append(f"12th lord ({lord(12)}) in Kendra/Trikona")
    if hs("Moon") == 12 and _y_jup_asp(Ju, Mo): mk_score += 25; mk_f.append("Moon in 12th aspected by Jupiter")
    if hs("Ketu") in {1,9,12}: mk_score += 15; mk_f.append(f"Ketu in H{hs('Ketu')} (spiritual liberation)")
    mk_score = min(mk_score, 100)
    RES.append(_y_result("Moksha Yoga","Spiritual Yoga",mk_score,
        "Lagna lord in 12th / 12th lord strong — path to liberation",mk_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 🧘 32. PARIVRAJA YOGA
    # ══════════════════════════════════════════════════════════════
    pv_f, pv_score = [], 0.0
    # Saturn or Ketu strong in 9th or 12th
    if hs("Saturn") in {9,12} and dig("Saturn") in ("Own","Exalted"):
        pv_score += 40; pv_f.append(f"Saturn {dig('Saturn')} in H{hs('Saturn')} (ascetic)")
    if hs("Ketu") in {9,12}: pv_score += 30; pv_f.append(f"Ketu in H{hs('Ketu')} (detachment)")
    if max_in_sign >= 4: pv_score += 25; pv_f.append(f"{max_in_sign} planets in one sign")
    pv_score = min(pv_score, 100)
    RES.append(_y_result("Parivraja Yoga","Spiritual Yoga",pv_score,
        "Strong ascetic indicators — wandering ascetic / monk tendency",pv_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 🌙 33. SUNAPHA YOGA
    # ══════════════════════════════════════════════════════════════
    sun_f, sun_score = [], 0.0
    mo_p2 = (Mo+1)%12
    p2_from_mo = [p for p in ["Mars","Mercury","Jupiter","Venus","Saturn"]
                  if pdata.get(p,{}).get("rashi_idx",0)==mo_p2]
    if p2_from_mo:
        sun_score = 50; sun_f.append(f"Planets in 2nd from Moon: {p2_from_mo}")
        bens_p2 = [p for p in p2_from_mo if p in BENEFICS_NAT]
        if bens_p2: sun_score += 20; sun_f.append(f"Benefics in 2nd from Moon: {bens_p2}")
    RES.append(_y_result("Sunapha Yoga","Moon Yoga",sun_score,
        "Planet(s) in 2nd from Moon — self-earned wealth, good mind",sun_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 🌙 34. ANAPHA YOGA
    # ══════════════════════════════════════════════════════════════
    an_f, an_score = [], 0.0
    mo_m1 = (Mo-1)%12
    p12_from_mo = [p for p in ["Mars","Mercury","Jupiter","Venus","Saturn"]
                   if pdata.get(p,{}).get("rashi_idx",0)==mo_m1]
    if p12_from_mo:
        an_score = 50; an_f.append(f"Planets in 12th from Moon: {p12_from_mo}")
        bens_m1 = [p for p in p12_from_mo if p in BENEFICS_NAT]
        if bens_m1: an_score += 20; an_f.append(f"Benefics in 12th from Moon: {bens_m1}")
    RES.append(_y_result("Anapha Yoga","Moon Yoga",an_score,
        "Planet(s) in 12th from Moon — fame, generosity, comforts",an_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 🌙 35. DURUDHARA YOGA
    # ══════════════════════════════════════════════════════════════
    du_score = min((sun_score + an_score)/2 + 15, 100) if sun_score>0 and an_score>0 else 0
    du_f = sun_f + an_f
    RES.append(_y_result("Durudhara Yoga","Moon Yoga",du_score,
        "Planets both in 2nd and 12th from Moon — great all-round personality",du_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 🌙 36. CHANDRA ADHI YOGA
    # ══════════════════════════════════════════════════════════════
    ca_f, ca_score = [], 0.0
    bens_678_mo = [p for p in BENEFICS_NAT if hm(p) in {6,7,8}]
    if len(bens_678_mo) == 3:
        ca_score = 75; ca_f.append(f"All 3 benefics in 6/7/8 from Moon: {bens_678_mo}")
    elif len(bens_678_mo) == 2:
        ca_score = 45; ca_f.append(f"2 benefics in 6/7/8 from Moon: {bens_678_mo}")
    elif len(bens_678_mo) == 1:
        ca_score = 20; ca_f.append(f"1 benefic in 6/7/8 from Moon")
    RES.append(_y_result("Chandra Adhi Yoga","Moon Yoga",ca_score,
        "Benefics in 6/7/8 from Moon — leadership, prosperity (same as Adhi from Moon)",ca_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # ⚡ 37-39. VIPREET RAJ YOGA (Harsha / Sarala / Vimala)
    # ══════════════════════════════════════════════════════════════
    for yname, h_check in [("Harsha Yoga",6),("Sarala Yoga",8),("Vimala Yoga",12)]:
        vr_f, vr_score = [], 0.0
        trik_lord = lord(h_check)
        trik_lord_h = lord_house(h_check)
        if trik_lord_h in DUSTHANA:
            vr_score = 60; vr_f.append(f"H{h_check} lord ({trik_lord}) in H{trik_lord_h} (trik)")
            if dig(trik_lord) in ("Own","Exalted"): vr_score += 15; vr_f.append(f"{trik_lord} {dig(trik_lord)}")
        RES.append(_y_result(yname,"Special Yoga",vr_score,
            f"H{h_check} lord in dusthana — misfortune reverses to fortune",vr_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # ⚡ 40. KALPADRUMA YOGA
    # ══════════════════════════════════════════════════════════════
    kd_f, kd_score = [], 0.0
    ll_sign = pdata.get(lord(1),{}).get("rashi_idx",0)
    disp1 = _Y_SIGN_LORD.get(ll_sign,"Sun")
    disp1_sign = pdata.get(disp1,{}).get("rashi_idx",0)
    disp2 = _Y_SIGN_LORD.get(disp1_sign,"Sun")
    disp2_sign = pdata.get(disp2,{}).get("rashi_idx",0)
    disp2_h = _y_house(disp2_sign,L)
    disp2_dig = dig(disp2)
    if disp2_dig in ("Own","Exalted") and disp2_h in KENDRA|TRIKONA:
        kd_score = 70; kd_f.append(f"2nd dispositor of Lagna lord ({disp2}) {disp2_dig} in H{disp2_h}")
    elif disp2_dig in ("Own","Exalted"):
        kd_score = 35; kd_f.append(f"2nd dispositor ({disp2}) {disp2_dig}")
    RES.append(_y_result("Kalpadruma Yoga","Special Yoga",kd_score,
        "2nd dispositor of Lagna lord strong — wishfulfilling tree (rare yoga)",kd_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # ⚡ 41. CHATUSSAGARA YOGA
    # ══════════════════════════════════════════════════════════════
    cs_f, cs_score = [], 0.0
    kendras_occupied = [h for h in [1,4,7,10]
                        if any(_y_house(pdata.get(p,{}).get("rashi_idx",0),L)==h
                               for p in pdata if p!="Lagna")]
    cs_score = len(kendras_occupied) * 22.0
    if len(kendras_occupied)==4: cs_score = 85; cs_f.append("All 4 Kendras occupied")
    elif len(kendras_occupied)==3: cs_score = 55; cs_f.append(f"3 Kendras occupied: H{kendras_occupied}")
    elif len(kendras_occupied)==2: cs_score = 28; cs_f.append(f"2 Kendras occupied")
    RES.append(_y_result("Chatussagara Yoga","Special Yoga",cs_score,
        "All 4 Kendra houses occupied — powerful, commanding personality",cs_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # ⚡ 42. BRAHMA YOGA
    # ══════════════════════════════════════════════════════════════
    br_f, br_score = [], 0.0
    brahma_conds = [
        ("Jupiter", {1,4,7,10}),
        ("Venus", {1,4,7,10}),
        ("Mercury", {1,4,7,10,11}),
    ]
    bc = sum(1 for p,hs_set in brahma_conds if hs(p) in hs_set)
    br_score = [0,25,55,85][bc]
    for p,hs_set in brahma_conds:
        if hs(p) in hs_set: br_f.append(f"{p} in H{hs(p)}")
    RES.append(_y_result("Brahma Yoga","Special Yoga",br_score,
        "Jupiter in Kendra + Venus in Kendra + Mercury in Kendra/11th — creator energy",br_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # ⚡ 43. VISHNU YOGA
    # ══════════════════════════════════════════════════════════════
    vn_f, vn_score = [], 0.0
    l9s = pdata.get(lord(9),{}).get("rashi_idx",0)
    l9h = _y_house(l9s,L)
    l10s = pdata.get(lord(10),{}).get("rashi_idx",0)
    l10h = _y_house(l10s,L)
    l1s = pdata.get(lord(1),{}).get("rashi_idx",0)
    l1h = _y_house(l1s,L)
    if l9h==2: vn_score+=30; vn_f.append(f"9th lord ({lord(9)}) in H2")
    if l9s==l10s: vn_score+=35; vn_f.append(f"9th lord + 10th lord together")
    if l1s==l9s or l1s==l10s: vn_score+=25; vn_f.append(f"Lagna lord joins 9/10 lords")
    vn_score = min(vn_score, 100)
    RES.append(_y_result("Vishnu Yoga","Special Yoga",vn_score,
        "9th lord in 2nd + 9th+10th lords together + Lagna lord — sustainer energy",vn_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # ⚡ 44. SHIVA YOGA
    # ══════════════════════════════════════════════════════════════
    shv_f, shv_score = [], 0.0
    l5h = lord_house(5); l9h2 = lord_house(9); l10h2 = lord_house(10)
    if l5h==9: shv_score+=35; shv_f.append(f"5th lord ({lord(5)}) in H9")
    if l9h2==10: shv_score+=35; shv_f.append(f"9th lord ({lord(9)}) in H10")
    if l10h2==5: shv_score+=35; shv_f.append(f"10th lord ({lord(10)}) in H5")
    shv_score = min(shv_score, 100)
    RES.append(_y_result("Shiva Yoga","Special Yoga",shv_score,
        "5th→9th, 9th→10th, 10th→5th lords — destroyer of obstacles, divine favor",shv_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 🧿 45. DARIDRA YOGA (negative) — wealth lost
    # ══════════════════════════════════════════════════════════════
    dr2_f, dr2_score = [], 0.0
    if lord_house(2) in DUSTHANA: dr2_score+=30; dr2_f.append(f"2nd lord ({lord(2)}) in dusthana H{lord_house(2)}")
    if lord_house(11) in DUSTHANA: dr2_score+=25; dr2_f.append(f"11th lord ({lord(11)}) in dusthana H{lord_house(11)}")
    if hs("Jupiter") in DUSTHANA: dr2_score+=20; dr2_f.append(f"Jupiter in dusthana H{hs('Jupiter')}")
    dr2_score = min(dr2_score, 100)
    RES.append(_y_result("Daridra Yoga","Negative Yoga",dr2_score,
        "Wealth lords in dusthana — poverty, financial struggles",dr2_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 🧿 46. SHAKAT YOGA (neg) — Moon-Jupiter 6/8
    # ══════════════════════════════════════════════════════════════
    sk2_f, sk2_score = [], 0.0
    if _y_house(Mo,Ju) in {6,8} or _y_house(Ju,Mo) in {6,8}:
        sk2_score=55; sk2_f.append("Moon and Jupiter in 6-8 axis")
    RES.append(_y_result("Shakat Yoga","Negative Yoga",sk2_score,
        "Moon-Jupiter in 6/8 axis — repeated ups and downs in fortune",sk2_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 🧿 47. GRAHAN YOGA (negative) — eclipse energy
    # ══════════════════════════════════════════════════════════════
    gr2_f, gr2_score = [], 0.0
    for lum in ["Sun","Moon"]:
        for nd in ["Rahu","Ketu"]:
            if pdata.get(lum,{}).get("rashi_idx",0)==pdata.get(nd,{}).get("rashi_idx",0):
                gr2_score += 45; gr2_f.append(f"{lum} with {nd}")
    gr2_score = min(gr2_score, 100)
    RES.append(_y_result("Grahan Yoga","Negative Yoga",gr2_score,
        "Luminaries with Rahu/Ketu — eclipse energy, health/mental challenges",gr2_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 🧿 48. GURU CHANDAL YOGA (negative)
    # ══════════════════════════════════════════════════════════════
    gc2_f, gc2_score = [], 0.0
    if Ju==Ra: gc2_score=70; gc2_f.append("Jupiter conjunct Rahu")
    elif Ju==Ke: gc2_score=65; gc2_f.append("Jupiter conjunct Ketu")
    elif _y_7th_asp(Ju,Ra): gc2_score=30; gc2_f.append("Jupiter-Rahu in 7th aspect")
    RES.append(_y_result("Guru Chandal Yoga","Negative Yoga",gc2_score,
        "Jupiter corrupted by Rahu/Ketu — loss of wisdom, unconventional beliefs",gc2_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 💍 49. VIVAHA YOGA
    # ══════════════════════════════════════════════════════════════
    vv_f, vv_score = [], 0.0
    l7 = lord(7); l7h = lord_house(7)
    if dig("Venus") in ("Exalted","Own") and hs("Venus") in KENDRA|TRIKONA:
        vv_score += 35; vv_f.append(f"Venus {dig('Venus')} in H{hs('Venus')}")
    if dig(l7) in ("Exalted","Own") and l7h in KENDRA|TRIKONA:
        vv_score += 35; vv_f.append(f"7th lord ({l7}) {dig(l7)} in H{l7h}")
    if hs("Jupiter") in KENDRA|TRIKONA and _y_jup_asp(Ju, (L+6)%12):
        vv_score += 20; vv_f.append("Jupiter aspects 7th house")
    vv_score = min(vv_score, 100)
    RES.append(_y_result("Vivaha Yoga","Marriage Yoga",vv_score,
        "Strong 7th house + Venus — auspicious marriage yoga",vv_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 💍 50. KUJA DOSHA IMPACT YOGA
    # ══════════════════════════════════════════════════════════════
    kj_f, kj_score = [], 0.0
    ma_h_ve = _y_house(Ma,Ve)
    if hs("Mars") in {1,2,4,7,8,12}:
        kj_score += 40; kj_f.append(f"Mars in H{hs('Mars')} from Lagna (Mangal Dosh axis)")
    if ma_h_ve in {1,2,4,7,8,12}:
        kj_score += 25; kj_f.append(f"Mars in H{ma_h_ve} from Venus")
    kj_score = min(kj_score, 100)
    RES.append(_y_result("Kuja Dosha Impact Yoga","Marriage Yoga",kj_score,
        "Mars in marriage houses — delays or intensity in relationships",kj_f,[],[]))

    # ══════════════════════════════════════════════════════════════
    # 💍 51. KALATRA YOGA
    # ══════════════════════════════════════════════════════════════
    kt_f, kt_score = [], 0.0
    l7_h2 = lord_house(7)
    if dig("Venus") in ("Exalted","Own"): kt_score+=35; kt_f.append(f"Venus {dig('Venus')}")
    if dig(l7) in ("Exalted","Own"): kt_score+=35; kt_f.append(f"7th lord ({l7}) {dig(l7)}")
    if hs("Venus") in KENDRA|TRIKONA: kt_score+=15; kt_f.append(f"Venus in Kendra/Trikona H{hs('Venus')}")
    aff_7th = _malefic_count_in_house(pdata, 7, L)
    if aff_7th > 0: kt_score -= 20*aff_7th; kt_f.append(f"7th house afflicted by {aff_7th} malefic(s)")
    kt_score = min(max(kt_score,0), 100)
    RES.append(_y_result("Kalatra Yoga","Marriage Yoga",kt_score,
        "Strong Venus + 7th lord — blessed spouse, harmonious marriage",kt_f,[],[]))

    return RES


def _malefic_count_in_house(pdata, house, lagna):
    return sum(1 for p in ["Saturn","Mars","Sun","Rahu","Ketu"]
               if _y_house(pdata.get(p,{}).get("rashi_idx",0), lagna)==house)


def display_yoga_analysis(pdata: dict) -> None:
    """Print formatted yoga analysis with probability scores (0–100%)."""
    results = analyze_all_yoga(pdata)

    CAT_ORDER = [
        "Raj Yoga","Dhan Yoga","Buddhi Yoga","Career Yoga",
        "Spiritual Yoga","Moon Yoga","Special Yoga","Negative Yoga","Marriage Yoga",
    ]
    CAT_EMOJI = {
        "Raj Yoga":"👑","Dhan Yoga":"💰","Buddhi Yoga":"🧠","Career Yoga":"💼",
        "Spiritual Yoga":"🧘","Moon Yoga":"🌙","Special Yoga":"⚡",
        "Negative Yoga":"🧿","Marriage Yoga":"💍",
    }
    CAT_LABEL = {
        "Raj Yoga":"Raj Yoga (Power / Success)",
        "Dhan Yoga":"Dhan Yoga (Wealth)",
        "Buddhi Yoga":"Buddhi / Intelligence Yogas",
        "Career Yoga":"Career / Success Yogas",
        "Spiritual Yoga":"Spiritual / Moksha Yogas",
        "Moon Yoga":"Moon-Based Yogas",
        "Special Yoga":"Special / Rare Yogas",
        "Negative Yoga":"Negative Yogas (Dosha-Type)",
        "Marriage Yoga":"Marriage / Relationship Yogas",
    }

    def _bar(score, width=22):
        f = int(score / 100.0 * width)
        ch = "█" if score < 35 else ("▓" if score < 65 else "▒")
        return ch * f + "░" * (width - f)

    by_cat = {c: [] for c in CAT_ORDER}
    for r in results: by_cat.setdefault(r["category"], []).append(r)

    W = 78
    print(f"\n  ╔{'═'*W}╗")
    print(f"  ║{'YOGA ANALYSIS  —  Probability (0–100%) & Strength':^{W}}║")
    print(f"  ║{'Sources: BPHS · Phaladeepika · Saravali · Brihat Jataka':^{W}}║")
    print(f"  ╠{'═'*W}╣")
    print(f"  ║  {'#':<3} {'Yoga Name':<28} {'Score':>6}  {'Strength':<12}  {'[weak ── strong]':^22}  ║")
    print(f"  ╠{'═'*W}╣")

    num = 1
    for cat in CAT_ORDER:
        items = by_cat.get(cat, [])
        if not items: continue
        label = CAT_LABEL.get(cat, cat)
        emoji = CAT_EMOJI.get(cat, "•")
        print(f"  ║  {emoji} {label:<{W-5}}║")
        print(f"  ║  {'─'*W}║")
        for r in items:
            sc = r["score"]; st = r["strength"]
            mark = "●" if r["present"] else " "
            bar = _bar(sc)
            print(f"  ║  {mark} {num:>2}. {r['name']:<27} {sc:>5.1f}%  {st:<12}  [{bar}]  ║")
            for fac in r["factors"][:2]:
                print(f"  ║        ↳ {fac[:68]:<68}  ║")
            num += 1
        print(f"  ╠{'═'*W}╣")

    # Summary: active yogas ranked
    active = sorted([r for r in results if r["present"]], key=lambda x: -x["score"])
    total = sum(r["score"] for r in active)
    print(f"  ║  🌟 ACTIVE YOGAS ({len(active)} present)  ·  Total strength: {total:.0f} pts{'':<{W-52}}║")
    print(f"  ║  {'─'*W}║")
    for rank, r in enumerate(active, 1):
        sym = "◆" if r["strength"]=="Very Strong" else ("▲" if r["strength"]=="Strong" else "●")
        print(f"  ║  {sym} {rank:<3} {r['name']:<28} {r['score']:>5.1f}%  {r['strength']:<12}  {r['category']:<20}  ║")
    if not active:
        print(f"  ║  {'No significant yogas found in this chart':<{W}}║")
    print(f"  ╠{'═'*W}╣")
    footer = f"  ║  Strength: Weak 1-25%  Moderate 26-50%  Strong 51-75%  Very Strong 76-100%"
    print(footer + " " * (W + 4 - len(footer)) + "║")
    print(f"  ╚{'═'*W}╝\n")



# ═══════════════════════════════════════════════════════════════════
#  MODULE A: FULL ASPECT SYSTEM
#  Graha Drishti (Parashari) + Rashi Drishti (Jaimini)
#  Planet-to-Planet Aspect Matrix
# ═══════════════════════════════════════════════════════════════════

# Graha Drishti: each planet aspects 7th from itself.
# Special aspects:
#   Mars: also 4th and 8th
#   Jupiter: also 5th and 9th
#   Saturn: also 3rd and 10th
# Aspect strength by house distance (from Phaladeepika):
_ASPECT_STRENGTH = {1:0,2:0,3:0.25,4:0.5,5:0.5,6:0,7:1.0,8:0.5,9:0.5,10:0.25,11:0,12:0}
_SPECIAL_ASPECTS = {
    "Mars":    {4:0.5, 7:1.0, 8:0.5},
    "Jupiter": {5:0.5, 7:1.0, 9:0.5},
    "Saturn":  {3:0.25,7:1.0,10:0.25},
    "Rahu":    {5:0.5, 7:1.0, 9:0.5},  # Rahu/Ketu like Jupiter aspects (school-dependent)
    "Ketu":    {5:0.5, 7:1.0, 9:0.5},
}

def graha_drishti(from_planet: str, from_sign: int, to_sign: int) -> float:
    """
    Returns aspect strength (0-1) of from_planet aspecting to_sign.
    0 = no aspect, 1 = full aspect (7th house).
    """
    h = (to_sign - from_sign) % 12 + 1
    special = _SPECIAL_ASPECTS.get(from_planet, {7: 1.0})
    return special.get(h, _ASPECT_STRENGTH.get(h, 0))


def rashi_drishti(from_sign: int, to_sign: int) -> bool:
    """
    Jaimini Rashi Drishti:
    - Movable signs (Ar/Cn/Li/Cp) aspect all Fixed signs except adjacent
    - Fixed signs (Ta/Le/Sc/Aq) aspect all Movable signs except adjacent
    - Dual signs (Ge/Vi/Sg/Pi) aspect all other Dual signs
    Returns True if from_sign aspects to_sign.
    """
    MOVABLE = {0,3,6,9}   # Ar,Cn,Li,Cp
    FIXED   = {1,4,7,10}  # Ta,Le,Sc,Aq
    DUAL    = {2,5,8,11}  # Ge,Vi,Sg,Pi

    if from_sign in MOVABLE:
        return to_sign in FIXED and abs(from_sign - to_sign) % 12 != 1
    elif from_sign in FIXED:
        return to_sign in MOVABLE and abs(from_sign - to_sign) % 12 != 1
    elif from_sign in DUAL:
        return to_sign in DUAL and to_sign != from_sign
    return False


def build_aspect_matrix(pdata: dict) -> dict:
    """
    Build complete Graha Drishti aspect matrix.
    Returns dict: {aspector: {aspected: strength (0-1)}}
    Also includes Rashi Drishti for each planet's sign.
    """
    PLANETS = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]
    matrix = {}

    for asp in PLANETS:
        asp_sign = pdata.get(asp, {}).get("rashi_idx", 0)
        matrix[asp] = {}
        for tgt in PLANETS:
            if tgt == asp:
                matrix[asp][tgt] = 0.0
                continue
            tgt_sign = pdata.get(tgt, {}).get("rashi_idx", 0)
            strength = graha_drishti(asp, asp_sign, tgt_sign)
            matrix[asp][tgt] = round(strength, 2)

    # Add Lagna aspects received
    lagna_sign = pdata.get("Lagna", {}).get("rashi_idx", 0)
    matrix["Lagna_received"] = {}
    for asp in PLANETS:
        asp_sign = pdata.get(asp, {}).get("rashi_idx", 0)
        matrix["Lagna_received"][asp] = round(graha_drishti(asp, asp_sign, lagna_sign), 2)

    return matrix


def aspects_on_planet(pdata: dict, target_planet: str) -> dict:
    """
    Return all planets aspecting target_planet with their strength.
    """
    matrix = build_aspect_matrix(pdata)
    tgt_sign = pdata.get(target_planet, {}).get("rashi_idx", 0)
    result = {}
    for asp, aspects in matrix.items():
        if asp in ["Lagna_received"]: continue
        if asp == target_planet: continue
        s = aspects.get(target_planet, 0)
        if s > 0:
            result[asp] = s
    return result


def aspects_on_house(pdata: dict, house: int) -> dict:
    """Return planets aspecting a specific house number from Lagna."""
    lagna = pdata.get("Lagna", {}).get("rashi_idx", 0)
    house_sign = (lagna + house - 1) % 12
    PLANETS = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]
    result = {}
    for asp in PLANETS:
        asp_sign = pdata.get(asp, {}).get("rashi_idx", 0)
        s = graha_drishti(asp, asp_sign, house_sign)
        if s > 0:
            result[asp] = s
    return result


def display_aspect_matrix(pdata: dict) -> None:
    """Print Graha Drishti aspect matrix + Rashi Drishti table."""
    PLANETS = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]
    P_ABBR  = {"Sun":"Su","Moon":"Mo","Mars":"Ma","Mercury":"Me",
                "Jupiter":"Ju","Venus":"Ve","Saturn":"Sa","Rahu":"Ra","Ketu":"Ke"}
    SS = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi']
    NATURE  = {"Sun":"M","Moon":"B","Mars":"M","Mercury":"N",
               "Jupiter":"B","Venus":"B","Saturn":"M","Rahu":"M","Ketu":"M"}
    MOVABLE = {0,3,6,9}; FIXED={1,4,7,10}; DUAL={2,5,8,11}
    SIGN_TYPE = {s:("Mv" if s in MOVABLE else "Fx" if s in FIXED else "Dl") for s in range(12)}

    matrix = build_aspect_matrix(pdata)
    lagna  = pdata.get("Lagna",{}).get("rashi_idx",0)

    print(f"\n  ╔{'═'*76}╗")
    print(f"  ║  GRAHA DRISHTI — Planet Aspect Matrix (Parashari)")
    print(f"  ║  Full=1.0 · Half=0.5 · Quarter=0.25 · None=·")
    print(f"  ╠{'═'*76}╣")

    # Header
    hdr = "  ║  Aspector→ ║ " + " ".join(f"{P_ABBR[p]:>4}" for p in PLANETS) + "  ║"
    print(hdr)
    print(f"  ╠{'═'*76}╣")

    for asp in PLANETS:
        asp_sign = pdata.get(asp,{}).get("rashi_idx",0)
        row_parts = []
        for tgt in PLANETS:
            s = matrix[asp].get(tgt, 0)
            if s == 0:  row_parts.append("   ·")
            elif s == 1.0: row_parts.append("  1·")
            elif s == 0.5: row_parts.append(" ½· ")
            else: row_parts.append(" ¼· ")
        n = NATURE.get(asp,"N")
        print(f"  ║  {P_ABBR[asp]}({SS[asp_sign]})[{n}] ║ {''.join(row_parts)}  ║")

    # Aspects ON lagna
    la_row = []
    for asp in PLANETS:
        s = matrix["Lagna_received"].get(asp, 0)
        if s == 0: la_row.append("   ·")
        elif s == 1.0: la_row.append("  1·")
        elif s == 0.5: la_row.append(" ½· ")
        else: la_row.append(" ¼· ")
    print(f"  ╠{'═'*76}╣")
    print(f"  ║  Lagna({SS[lagna]})   ║ {''.join(la_row)}  ║")

    print(f"  ╠{'═'*76}╣")

    # Summary: who aspects whom (benefic/malefic net)
    print(f"  ║  ASPECT SUMMARY per planet:")
    for tgt in PLANETS:
        tgt_sign = pdata.get(tgt,{}).get("rashi_idx",0)
        asp_from = [(asp, matrix[asp].get(tgt,0)) for asp in PLANETS
                    if asp!=tgt and matrix[asp].get(tgt,0)>0]
        if not asp_from: continue
        ben_sum = sum(s for a,s in asp_from if NATURE.get(a,"M")=="B")
        mal_sum = sum(s for a,s in asp_from if NATURE.get(a,"M")=="M")
        asp_str = ", ".join(f"{P_ABBR[a]}({s})" for a,s in asp_from)
        print(f"  ║    {P_ABBR[tgt]}({SS[tgt_sign]}): aspected by {asp_str}")
        print(f"  ║      → Benefic net: {ben_sum:.2f}  Malefic net: {mal_sum:.2f}  Balance: {ben_sum-mal_sum:+.2f}")

    # Rashi Drishti
    print(f"  ╠{'═'*76}╣")
    print(f"  ║  RASHI DRISHTI (Jaimini Sign Aspects):")
    for s1 in range(12):
        aspected = [SS[s2] for s2 in range(12) if s2!=s1 and rashi_drishti(s1,s2)]
        if aspected:
            stype = SIGN_TYPE[s1]
            print(f"  ║    {SS[s1]}({stype}) aspects: {', '.join(aspected)}")

    print(f"  ╚{'═'*76}╝\n")


# ═══════════════════════════════════════════════════════════════════
#  MODULE B: SHADBALA ENGINE (SIMPLIFIED)
#  6 Sources of Planetary Strength → Total 0-100%
# ═══════════════════════════════════════════════════════════════════

# Natural (Naisargika) Bala — fixed values (in Rupas, normalized)
_NAISARGIKA = {
    "Sun": 60, "Moon": 51.43, "Mars": 17.14, "Mercury": 25.71,
    "Jupiter": 34.29, "Venus": 42.86, "Saturn": 8.57
}

# Dig Bala (directional strength) - strongest house
_DIG_BALA_HOUSE = {
    "Sun": 10, "Mars": 10,    # strong in 10th
    "Moon": 4, "Venus": 4,    # strong in 4th
    "Jupiter": 1, "Mercury": 1,  # strong in 1st
    "Saturn": 7,               # strong in 7th
}

# Friendship table (compact)
_FRIENDS = {
    "Sun":     {"Moon","Mars","Jupiter"},
    "Moon":    {"Sun","Mercury"},
    "Mars":    {"Sun","Moon","Jupiter"},
    "Mercury": {"Sun","Venus"},
    "Jupiter": {"Sun","Moon","Mars"},
    "Venus":   {"Mercury","Saturn"},
    "Saturn":  {"Mercury","Venus"},
}
_ENEMIES = {
    "Sun":     {"Venus","Saturn"},
    "Moon":    {"None"},
    "Mars":    {"Mercury"},
    "Mercury": {"Moon"},
    "Jupiter": {"Mercury","Venus"},
    "Venus":   {"Sun","Moon"},
    "Saturn":  {"Sun","Moon","Mars"},
}

def _sthana_bala(planet: str, sign: int, deg: float, pdata: dict) -> float:
    """Positional/Dignity strength 0-60 (Rupas)."""
    OWN = {"Sun":{4},"Moon":{3},"Mars":{0,7},"Mercury":{2,5},
           "Jupiter":{8,11},"Venus":{1,6},"Saturn":{9,10}}
    EXALT = {"Sun":0,"Moon":1,"Mars":9,"Mercury":5,"Jupiter":3,"Venus":11,"Saturn":6}
    MT    = {"Sun":4,"Moon":1,"Mars":0,"Mercury":5,"Jupiter":8,"Venus":6,"Saturn":10}
    DEBI  = {"Sun":6,"Moon":7,"Mars":3,"Mercury":11,"Jupiter":9,"Venus":5,"Saturn":0}

    if EXALT.get(planet,-1)==sign: return 60.0
    if sign in OWN.get(planet,set()):
        return 45.0 if MT.get(planet,-1)==sign else 30.0
    if DEBI.get(planet,-1)==sign: return 0.0
    # Friend/enemy
    sign_lord = {0:"Mars",1:"Venus",2:"Mercury",3:"Moon",4:"Sun",5:"Mercury",
                 6:"Venus",7:"Mars",8:"Jupiter",9:"Saturn",10:"Saturn",11:"Jupiter"}
    lord = sign_lord.get(sign,"Sun")
    if lord in _FRIENDS.get(planet,set()): return 22.5
    if lord in _ENEMIES.get(planet,set()): return 7.5
    return 15.0  # neutral


def _dig_bala(planet: str, house: int) -> float:
    """Directional strength 0-60 Rupas."""
    best_h = _DIG_BALA_HOUSE.get(planet, 1)
    worst_h = (best_h + 6) % 12 or 12  # opposite house
    if house == best_h: return 60.0
    if house == worst_h: return 0.0
    # Linear interpolation
    dist = min(abs(house - best_h), 12 - abs(house - best_h))
    return max(0.0, 60.0 - dist * (60.0/6.0))


def _chesta_bala(planet: str, speed: float) -> float:
    """Motional strength based on speed. Retrograde = full; fast = reduced."""
    if planet in ("Sun","Moon"): return 30.0  # luminaries use mean motion
    if speed < 0: return 60.0   # retrograde = full Chesta Bala
    if speed == 0: return 45.0  # stationary
    # Mean motions (approx degrees/day)
    MEAN = {"Mars":0.524,"Mercury":1.383,"Jupiter":0.083,"Venus":1.2,"Saturn":0.034}
    mean = MEAN.get(planet, 1.0)
    ratio = min(speed / mean, 2.0)
    return max(0.0, 60.0 * (1.0 - ratio * 0.5))


def _kala_bala_simple(planet: str, pdata: dict) -> float:
    """Simplified temporal strength (day/night, paksha)."""
    # Day planets strong in day: Sun, Jupiter, Saturn
    # Night planets strong at night: Moon, Venus, Mars
    # Mercury: both
    # Simplified: use Moon position (above horizon = day-ish)
    moon_h = (pdata.get("Moon",{}).get("rashi_idx",0) - pdata.get("Lagna",{}).get("rashi_idx",0)) % 12 + 1
    is_day = moon_h in {7,8,9,10,11,12}  # Moon above horizon
    day_planets   = {"Sun","Jupiter","Saturn"}
    night_planets = {"Moon","Venus","Mars"}
    if planet in day_planets:   return 60.0 if is_day else 30.0
    if planet in night_planets: return 30.0 if is_day else 60.0
    return 45.0  # Mercury


def _naisargika_bala(planet: str) -> float:
    """Natural strength (fixed)."""
    return _NAISARGIKA.get(planet, 20.0)


def _drik_bala(planet: str, pdata: dict) -> float:
    """
    Aspect-based strength: benefic aspects add, malefic reduce.
    Range: -60 to +60 Rupas.
    """
    BENEFIC = {"Jupiter","Venus","Mercury","Moon"}
    MALEFIC = {"Saturn","Mars","Sun","Rahu","Ketu"}
    asp = aspects_on_planet(pdata, planet)
    score = 0.0
    for asp_planet, strength in asp.items():
        if asp_planet in BENEFIC: score += 30.0 * strength
        elif asp_planet in MALEFIC: score -= 30.0 * strength
    return max(-60.0, min(60.0, score))


def calculate_shadbala(pdata: dict) -> dict:
    """
    Calculate simplified Shadbala for all 7 planets.
    Returns dict: {planet: {bala_components, total_rupas, score_100}}
    """
    PLANETS = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn"]
    lagna = pdata.get("Lagna",{}).get("rashi_idx",0)
    results = {}

    # Minimum required Rupas for each planet (classical standards)
    MIN_RUPAS = {
        "Sun":140,"Moon":160,"Mars":130,"Mercury":140,
        "Jupiter":150,"Venus":140,"Saturn":110
    }
    MAX_RUPAS = {
        "Sun":320,"Moon":340,"Mars":310,"Mercury":320,
        "Jupiter":340,"Venus":330,"Saturn":300
    }

    for p in PLANETS:
        sign  = pdata.get(p,{}).get("rashi_idx",0)
        deg   = pdata.get(p,{}).get("deg_rashi",0.0)
        house = (sign - lagna) % 12 + 1
        speed = pdata.get(p,{}).get("speed",0.5)

        sth = _sthana_bala(p, sign, deg, pdata)
        dig = _dig_bala(p, house)
        che = _chesta_bala(p, speed)
        kal = _kala_bala_simple(p, pdata)
        nai = _naisargika_bala(p)
        drk = _drik_bala(p, pdata)

        total = sth + dig + che + kal + nai + drk
        min_r = MIN_RUPAS.get(p, 300)
        max_r = MAX_RUPAS.get(p, 540)
        score = round(min(100.0, max(0.0, (total - min_r) / (max_r - min_r) * 100)), 1)

        results[p] = {
            "sthana_bala":    round(sth,1),
            "dig_bala":       round(dig,1),
            "chesta_bala":    round(che,1),
            "kala_bala":      round(kal,1),
            "naisargika_bala":round(nai,1),
            "drik_bala":      round(drk,1),
            "total_rupas":    round(total,1),
            "min_required":   min_r,
            "score_100":      score,
            "house":          house,
        }

    return results


def display_shadbala(pdata: dict) -> None:
    """Display Shadbala table and Dig Bala."""
    sb = calculate_shadbala(pdata)
    SS = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi']
    PLANETS = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn"]
    lagna = pdata.get("Lagna",{}).get("rashi_idx",0)

    def _bar(s, w=15):
        f = int(s/100*w)
        ch = "█" if s<35 else ("▓" if s<65 else "▒")
        return ch*f + "░"*(w-f)

    print(f"\n  ╔{'═'*80}╗")
    print(f"  ║  SHADBALA (Simplified) — 6-Source Planetary Strength")
    print(f"  ║  Sthana(positional) · Dig(directional) · Chesta(motional)")
    print(f"  ║  Kala(temporal) · Naisargika(natural) · Drik(aspect-based)")
    print(f"  ╠{'═'*80}╣")
    print(f"  ║  {'Planet':<10} {'Sign':>4} {'H':>3}  {'Sth':>5} {'Dig':>5} {'Che':>5} "
          f"{'Kal':>5} {'Nai':>5} {'Drk':>6}  {'Total':>6}  {'Score':>5}  {'[strength bar]':^16}  ║")
    print(f"  ╠{'═'*80}╣")

    for p in PLANETS:
        d = sb[p]
        sign = pdata.get(p,{}).get("rashi_idx",0)
        print(f"  ║  {p:<10} {SS[sign]:>4} {d['house']:>3}  "
              f"{d['sthana_bala']:>5.1f} {d['dig_bala']:>5.1f} {d['chesta_bala']:>5.1f} "
              f"{d['kala_bala']:>5.1f} {d['naisargika_bala']:>5.1f} {d['drik_bala']:>6.1f}  "
              f"{d['total_rupas']:>6.1f}  {d['score_100']:>4.0f}%  [{_bar(d['score_100'])}]  ║")

    print(f"  ╠{'═'*80}╣")
    # Dig Bala summary
    print(f"  ║  DIG BALA (Directional Strength):")
    dig_info = {
        "Sun/Mars": ("10th",10), "Moon/Venus": ("4th",4),
        "Jupiter/Mercury": ("1st",1), "Saturn": ("7th",7)
    }
    for grp, (best, bh) in dig_info.items():
        bh_sign = SS[(lagna + bh - 1) % 12]
        print(f"  ║    {grp}: strongest in {best} house ({bh_sign})")
    print(f"  ╚{'═'*80}╝\n")


def planet_strength_score(pdata: dict) -> dict:
    """Return overall 0-100 strength score for each planet."""
    sb = calculate_shadbala(pdata)
    return {p: v["score_100"] for p,v in sb.items()}


# ═══════════════════════════════════════════════════════════════════
#  MODULE C: ASHTAKAVARGA
#  Bhinnashtakavarga (BAV) + Sarvashtakavarga (SAV)
#  Classical 8-source benefic point tables
# ═══════════════════════════════════════════════════════════════════

# BAV contribution tables: for each planet P, from each contributor C,
# which houses (counted from C's natal sign) get a benefic point (rekha)
# Source: Standard classical Ashtakavarga tables (BPHS / Brihat Jataka)
_AV_TABLES = {
    "Sun": {
        "Sun":    {1,2,4,7,8,9,10,11},
        "Moon":   {3,6,10,11},
        "Mars":   {1,2,4,7,8,9,10,11},
        "Mercury":{3,5,6,9,10,11,12},
        "Jupiter":{5,6,9,11},
        "Venus":  {6,7,12},
        "Saturn": {1,2,4,7,8,9,10,11},
        "Lagna":  {3,4,6,10,11,12},
    },
    "Moon": {
        "Sun":    {3,6,7,8,10,11},
        "Moon":   {1,3,6,7,10,11},
        "Mars":   {2,3,5,6,9,10,11},
        "Mercury":{1,3,4,5,7,8,10,11},
        "Jupiter":{1,4,7,8,10,11,12},
        "Venus":  {3,4,5,7,9,10,11},
        "Saturn": {3,5,6,11},
        "Lagna":  {3,6,10,11},
    },
    "Mars": {
        "Sun":    {3,5,6,10,11},
        "Moon":   {3,6,11},
        "Mars":   {1,2,4,7,8,10,11},
        "Mercury":{3,5,6,11},
        "Jupiter":{6,10,11,12},
        "Venus":  {6,8,11,12},
        "Saturn": {1,4,7,8,9,10,11},
        "Lagna":  {1,4,6,8,10,11,12},
    },
    "Mercury": {
        "Sun":    {5,6,9,11,12},
        "Moon":   {2,4,6,8,10,11},
        "Mars":   {1,2,4,7,8,9,10,11},
        "Mercury":{1,3,5,6,9,10,11,12},
        "Jupiter":{6,8,11,12},
        "Venus":  {1,2,3,4,5,8,9,11},
        "Saturn": {1,2,4,7,8,9,10,11},
        "Lagna":  {1,2,4,6,8,10,11},
    },
    "Jupiter": {
        "Sun":    {1,2,3,4,7,8,9,10,11},
        "Moon":   {2,5,7,9,11},
        "Mars":   {1,2,4,7,8,10,11},
        "Mercury":{1,2,4,5,6,9,10,11},
        "Jupiter":{1,2,3,4,5,6,7,8,10,11},
        "Venus":  {2,5,6,9,10,11},
        "Saturn": {3,5,6,12},
        "Lagna":  {1,2,4,5,6,7,9,10,11},
    },
    "Venus": {
        "Sun":    {8,11,12},
        "Moon":   {1,2,3,4,5,8,9,11,12},
        "Mars":   {3,4,6,9,11,12},
        "Mercury":{3,5,6,9,11},
        "Jupiter":{5,8,9,10,11},
        "Venus":  {1,2,3,4,5,8,9,10,11},
        "Saturn": {3,4,5,8,9,10,11},
        "Lagna":  {1,2,3,4,5,8,9,11},
    },
    "Saturn": {
        "Sun":    {1,2,4,7,8,10,11},
        "Moon":   {3,6,11},
        "Mars":   {3,5,6,10,11,12},
        "Mercury":{6,8,9,10,11,12},
        "Jupiter":{5,6,11,12},
        "Venus":  {6,11,12},
        "Saturn": {3,5,6,11},
        "Lagna":  {1,3,4,6,10,11},
    },
}

def calculate_ashtakavarga(pdata: dict) -> dict:
    """
    Calculate Ashtakavarga for all 7 planets.
    Returns:
      {planet: {
          "bav":  [8 rekhaas per sign, indices 0-11],  # Bhinnashtakavarga
          "total": int,  # sum of BAV (should be 56)
          "sign_scores": {sign_idx: rekha_count},
       },
       "sav": [total rekha per sign, 0-11],   # Sarvashtakavarga
       "sav_total": int,   # should be ~337
      }
    """
    PLANETS7 = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn"]
    CONTRIBUTORS = PLANETS7 + ["Lagna"]
    lagna_sign = pdata.get("Lagna",{}).get("rashi_idx",0)

    result = {}
    sav = [0] * 12

    for planet in PLANETS7:
        table = _AV_TABLES.get(planet, {})
        bav = [0] * 12  # rekha count per sign

        for contrib in CONTRIBUTORS:
            if contrib == "Lagna":
                ref_sign = lagna_sign
            else:
                ref_sign = pdata.get(contrib,{}).get("rashi_idx",0)

            rekha_houses = table.get(contrib, set())
            for h in rekha_houses:
                sign_idx = (ref_sign + h - 1) % 12
                bav[sign_idx] += 1

        total = sum(bav)
        sign_scores = {i: bav[i] for i in range(12)}

        result[planet] = {
            "bav": bav,
            "total": total,
            "sign_scores": sign_scores,
        }

        for i in range(12):
            sav[i] += bav[i]

    result["sav"] = sav
    result["sav_total"] = sum(sav)
    return result


def display_ashtakavarga(pdata: dict) -> None:
    """Display Ashtakavarga table."""
    av = calculate_ashtakavarga(pdata)
    SS = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi']
    PLANETS7 = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn"]
    lagna = pdata.get("Lagna",{}).get("rashi_idx",0)
    P3    = {"Sun":"Su","Moon":"Mo","Mars":"Ma","Mercury":"Me",
             "Jupiter":"Ju","Venus":"Ve","Saturn":"Sa"}

    # House numbers from lagna
    house_of = lambda s: (s - lagna) % 12 + 1

    print(f"\n  ╔{'═'*80}╗")
    print(f"  ║  ASHTAKAVARGA — Bhinnashtakavarga (BAV) & Sarvashtakavarga (SAV)")
    print(f"  ║  Rekha (benefic points) per sign  ·  4+ = strong  ·  3 = avg  ·  <3 = weak")
    print(f"  ╠{'═'*80}╣")

    # Sign header
    hdr = "  ║  Planet  " + " ".join(f"{SS[s]:>4}" for s in range(12)) + "  Σ  ║"
    print(hdr)
    hdr2 = "  ║  (H from L) " + " ".join(f"H{house_of(s):02d}" for s in range(12)) + "     ║"
    print(hdr2)
    print(f"  ╠{'═'*80}╣")

    for p in PLANETS7:
        bav = av[p]["bav"]
        total = av[p]["total"]
        ps = pdata.get(p,{}).get("rashi_idx",0)
        # Highlight planet's own sign with brackets
        row = " ".join(
            f"[{bav[s]:1d}]" if s==ps else f"  {bav[s]:1d} "
            for s in range(12)
        )
        print(f"  ║  {P3[p]:<7}  {row}  {total:>2}  ║")

    print(f"  ╠{'═'*80}╣")
    sav = av["sav"]
    sav_row = " ".join(f" {sav[s]:>2} " for s in range(12))
    print(f"  ║  SAV      {sav_row}  {av['sav_total']:>3}  ║")
    print(f"  ╠{'═'*80}╣")

    # Strongest/weakest signs from SAV
    sorted_signs = sorted(range(12), key=lambda s: sav[s], reverse=True)
    print(f"  ║  SAV Strength Ranking:")
    top3 = [(SS[s], house_of(s), sav[s]) for s in sorted_signs[:4]]
    bot3 = [(SS[s], house_of(s), sav[s]) for s in sorted_signs[-4:]]
    print(f"  ║    Best  signs: " + "  ".join(f"{n}(H{h})={v}" for n,h,v in top3))
    print(f"  ║    Weak  signs: " + "  ".join(f"{n}(H{h})={v}" for n,h,v in bot3))

    # Planet BAV in its own transit sign
    print(f"  ╠{'═'*80}╣")
    print(f"  ║  BAV score of planet in its own natal sign:")
    for p in PLANETS7:
        ps = pdata.get(p,{}).get("rashi_idx",0)
        score = av[p]["bav"][ps]
        quality = "Strong (4+)" if score>=4 else ("Average" if score==3 else "Weak (<3)")
        print(f"  ║    {P3[p]:<5} in {SS[ps]}: {score} rekhas — {quality}")

    print(f"  ╚{'═'*80}╝\n")


def ashtakavarga_house_score(pdata: dict, house: int) -> dict:
    """Return SAV + each planet's BAV score for a given house."""
    av  = calculate_ashtakavarga(pdata)
    lagna = pdata.get("Lagna",{}).get("rashi_idx",0)
    house_sign = (lagna + house - 1) % 12
    PLANETS7 = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn"]
    return {
        "house": house,
        "sign": house_sign,
        "sav": av["sav"][house_sign],
        "bav": {p: av[p]["bav"][house_sign] for p in PLANETS7},
    }


# ═══════════════════════════════════════════════════════════════════
#  MODULE D: LIFE AREA SCORING
#  Career · Wealth · Marriage · Health · Spirituality
#  Uses: Shadbala + Ashtakavarga + Yoga/Dosh scores + Aspect engine
# ═══════════════════════════════════════════════════════════════════

def calculate_life_areas(pdata: dict) -> dict:
    """
    Score 5 major life areas on a 0-100 scale.
    Returns dict with area scores + breakdown.
    """
    lagna = pdata.get("Lagna",{}).get("rashi_idx",0)
    SS = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi']
    SIGN_LORD = {0:"Mars",1:"Venus",2:"Mercury",3:"Moon",4:"Sun",5:"Mercury",
                 6:"Venus",7:"Mars",8:"Jupiter",9:"Saturn",10:"Saturn",11:"Jupiter"}

    sb  = calculate_shadbala(pdata)
    av  = calculate_ashtakavarga(pdata)
    mat = build_aspect_matrix(pdata)

    def hs(p): return (pdata.get(p,{}).get("rashi_idx",0) - lagna) % 12 + 1
    def lord(h): return SIGN_LORD.get((lagna+h-1)%12,"Sun")
    def dig(p):
        s = pdata.get(p,{}).get("rashi_idx",0)
        OWN={"Sun":{4},"Moon":{3},"Mars":{0,7},"Mercury":{2,5},"Jupiter":{8,11},"Venus":{1,6},"Saturn":{9,10}}
        EXALT={"Sun":0,"Moon":1,"Mars":9,"Mercury":5,"Jupiter":3,"Venus":11,"Saturn":6}
        if EXALT.get(p,-1)==s: return 2.0
        if s in OWN.get(p,set()): return 1.5
        return 1.0
    def sav_h(h): return av["sav"][(lagna+h-1)%12]
    def ben_asp(house):
        BENEFIC = {"Jupiter","Venus","Mercury","Moon"}
        asp = aspects_on_house(pdata, house)
        return sum(v for p,v in asp.items() if p in BENEFIC)
    def mal_asp(house):
        MALEFIC = {"Saturn","Mars","Sun","Rahu","Ketu"}
        asp = aspects_on_house(pdata, house)
        return sum(v for p,v in asp.items() if p in MALEFIC)
    def strength(p):
        return sb.get(p,{}).get("score_100",50) if p in sb else 50

    areas = {}

    # Each area scored via weighted components, then normalized to 0-100.
    # Max theoretical raw score ~100 before normalization.
    def _norm(raw, mx=100.0): return round(min(100, max(0, raw/mx*100)), 1)

    # ── CAREER (10th, 6th, Sun, Saturn) ──────────────────────────
    l10 = lord(10); l6 = lord(6)
    car  = (sav_h(10)/8 * 35)                     # SAV H10: 0-35
    car += (sav_h(6) /8 * 10)                      # SAV H6:  0-10
    car += strength("Sun")    * 0.15               # Sun:     0-15
    car += strength("Saturn") * 0.15               # Saturn:  0-15
    car += strength(l10)      * 0.12               # 10L:     0-12
    car += ben_asp(10)        * 3                  # Ben asp: 0-9  (max 3 full)
    car -= mal_asp(10)        * 2                  # Mal asp: penalty
    car_factors = [
        f"10th house SAV: {sav_h(10)}/8",
        f"10th lord ({l10}) strength: {strength(l10):.0f}%",
        f"Sun strength: {strength('Sun'):.0f}%",
        f"Benefic aspects on 10th: {ben_asp(10):.1f}",
    ]
    areas["Career"] = {
        "score": _norm(car, 100.0),
        "factors": car_factors,
        "key_planets": ["Sun","Saturn",l10],
        "houses": [6,10],
    }

    # ── WEALTH (2nd, 11th, 5th, Jupiter, Venus) ──────────────────
    l2 = lord(2); l11 = lord(11)
    wlt  = (sav_h(2) /8 * 25) + (sav_h(11)/8 * 25) + (sav_h(5)/8 * 8)
    wlt += strength("Jupiter") * 0.12 + strength("Venus") * 0.08
    wlt += strength(l2) * 0.12  + strength(l11) * 0.10
    wlt -= mal_asp(2)*2 + mal_asp(11)*1.5
    areas["Wealth"] = {
        "score": _norm(wlt, 100.0),
        "factors": [
            f"2nd house SAV: {sav_h(2)}/8",
            f"11th house SAV: {sav_h(11)}/8",
            f"Jupiter strength: {strength('Jupiter'):.0f}%",
            f"2nd lord ({l2}) strength: {strength(l2):.0f}%",
        ],
        "key_planets": ["Jupiter","Venus",l2,l11],
        "houses": [2,5,11],
    }

    # ── MARRIAGE (7th, 5th, Venus, Jupiter) ──────────────────────
    l7 = lord(7); l5 = lord(5)
    mar  = (sav_h(7)/8 * 40) + (sav_h(5)/8 * 12)
    mar += strength("Venus") * 0.20 + strength(l7) * 0.15
    mar += ben_asp(7)*3 - mal_asp(7)*3
    areas["Marriage"] = {
        "score": _norm(mar, 100.0),
        "factors": [
            f"7th house SAV: {sav_h(7)}/8",
            f"Venus strength: {strength('Venus'):.0f}%",
            f"7th lord ({l7}) strength: {strength(l7):.0f}%",
            f"Benefic aspects on 7th: {ben_asp(7):.1f}",
        ],
        "key_planets": ["Venus","Jupiter",l7],
        "houses": [5,7],
    }

    # ── HEALTH (1st, 8th, 6th, Moon, Sun, Lagna lord) ────────────
    l1 = lord(1)
    hlt  = (sav_h(1)/8 * 35) + (sav_h(8)/8 * 10)
    hlt += strength("Moon") * 0.20 + strength("Sun") * 0.10 + strength(l1) * 0.15
    hlt += ben_asp(1)*3 - mal_asp(1)*2 - mal_asp(6)*1.5
    areas["Health"] = {
        "score": _norm(hlt, 100.0),
        "factors": [
            f"Lagna SAV: {sav_h(1)}/8",
            f"Moon strength: {strength('Moon'):.0f}%",
            f"Lagna lord ({l1}) strength: {strength(l1):.0f}%",
            f"Malefic aspects on Lagna: {mal_asp(1):.1f}",
        ],
        "key_planets": ["Moon","Sun",l1],
        "houses": [1,6,8],
    }

    # ── SPIRITUALITY (9th, 12th, Ketu, Jupiter, Moon) ────────────
    l9 = lord(9); l12 = lord(12)
    spr  = (sav_h(9)/8 * 35) + (sav_h(12)/8 * 20)
    spr += strength("Jupiter") * 0.20 + strength("Moon") * 0.10 + strength(l9) * 0.10
    spr += 15 if hs("Ketu") in {9,12,4} else 0
    areas["Spirituality"] = {
        "score": _norm(spr, 100.0),
        "factors": [
            f"9th house SAV: {sav_h(9)}/8",
            f"12th house SAV: {sav_h(12)}/8",
            f"Jupiter strength: {strength('Jupiter'):.0f}%",
            f"Ketu in 9/12/4: {'Yes' if hs('Ketu') in {9,12,4} else 'No'}",
        ],
        "key_planets": ["Jupiter","Moon",l9],
        "houses": [9,12],
    }

    return areas


def display_life_areas(pdata: dict) -> None:
    """Display life area scoring dashboard."""
    areas = calculate_life_areas(pdata)
    EMOJIS = {"Career":"💼","Wealth":"💰","Marriage":"💍","Health":"🏥","Spirituality":"🧘"}

    def _bar(s, w=24):
        f = int(s/100*w)
        ch = "█" if s < 35 else ("▓" if s < 65 else "▒")
        return ch*f + "░"*(w-f)

    print(f"\n  ╔{'═'*76}╗")
    print(f"  ║  LIFE AREA SCORING — Career · Wealth · Marriage · Health · Spirituality")
    print(f"  ║  Based on Shadbala · Ashtakavarga · Aspects · House Analysis")
    print(f"  ╠{'═'*76}╣")

    for area, data in areas.items():
        sc = data["score"]
        emoji = EMOJIS.get(area,"•")
        band = ("Excellent" if sc>=75 else "Good" if sc>=55 else "Average" if sc>=35 else "Challenging")
        print(f"  ║  {emoji} {area:<14} {sc:>5.1f}%  [{_bar(sc)}]  {band}")
        for fac in data["factors"][:2]:
            print(f"  ║      ↳ {fac[:66]:<66}  ║")

    print(f"  ╠{'═'*76}╣")
    print(f"  ║  Scale: Excellent 75-100%  Good 55-74%  Average 35-54%  Challenging <35%")
    print(f"  ╚{'═'*76}╝\n")


# ═══════════════════════════════════════════════════════════════════
#  MODULE E: DASHA ACTIVATION ENGINE
#  Which Yogas/Doshas are active in current Mahadasha/Antardasha?
#  Transit + Dasha Combined Prediction
# ═══════════════════════════════════════════════════════════════════

def get_current_dasha_lords(pdata: dict, birth_jd: float, query_jd: float = None) -> dict:
    """
    Find current MD, AD, PD lords at query_jd (default: today).
    Returns dict with lord names, period dates, and time remaining.
    """
    from datetime import date
    if query_jd is None:
        today = date.today()
        query_jd = to_julian_day(today.year, today.month, today.day, 0)

    moon_lon = pdata.get("Moon",{}).get("lon",0)
    v_dashas, v_balance, v_lord = vimshottari_dasha(moon_lon, birth_jd)
    ml_dashas, ml_balance, ml_info = moola_dasha_lagna(pdata, birth_jd)

    def _find_level(dashas, jd, depth=0):
        for md in dashas:
            if md["start_jd"] <= jd <= md["end_jd"]:
                if depth == 0:
                    # Find AD
                    for ad in md.get("sub", []):
                        if ad["start_jd"] <= jd <= ad["end_jd"]:
                            pd_lord = None
                            for pd in ad.get("sub", []):
                                if pd["start_jd"] <= jd <= pd["end_jd"]:
                                    pd_lord = pd["planet"]
                                    break
                            return {
                                "md": md["planet"],
                                "md_start": jd_to_date(md["start_jd"]),
                                "md_end":   jd_to_date(md["end_jd"]),
                                "ad": ad["planet"],
                                "ad_start": jd_to_date(ad["start_jd"]),
                                "ad_end":   jd_to_date(ad["end_jd"]),
                                "pd": pd_lord,
                            }
        return {}

    vim_lords  = _find_level(v_dashas, query_jd)
    moola_lords = _find_level(ml_dashas, query_jd)

    return {
        "vimshottari": vim_lords,
        "moola":        moola_lords,
        "query_date":   jd_to_date(query_jd),
    }


def _planet_in_yoga(planet: str, yoga_result: dict) -> bool:
    """Check if a planet name appears in a yoga's factor text."""
    text = " ".join(yoga_result.get("factors",[])).lower()
    return planet.lower() in text


def dasha_activated_events(pdata: dict, birth_jd: float, query_jd: float = None) -> dict:
    """
    Find which yogas/doshas are triggered in current MD/AD period.

    Logic:
    - A yoga is "active" if the MD or AD lord is a key planet in that yoga
      OR the MD/AD lord rules a house relevant to that yoga
    - A dosh is "active" if the MD or AD lord is the afflicted/afflicting planet
    - Additional weight if current gochar supports the activation
    """
    from datetime import date
    if query_jd is None:
        today = date.today()
        query_jd = to_julian_day(today.year, today.month, today.day, 0)

    lords = get_current_dasha_lords(pdata, birth_jd, query_jd)
    vim   = lords.get("vimshottari", {})
    moola = lords.get("moola", {})

    md_lord = vim.get("md","")
    ad_lord = vim.get("ad","")
    md_lord_m = moola.get("md","")

    active_lords = {md_lord, ad_lord, md_lord_m}

    # Get all yoga + dosh results
    yogas  = analyze_all_yoga(pdata)
    doshas = analyze_all_dosh(pdata)

    # Gochar today
    today_date = date.today()
    gj = to_julian_day(today_date.year, today_date.month, today_date.day, 6.5)
    gpos = get_all_positions(gj)
    transit_signs = {p: int(gpos.get(p,{}).get("lon",0)/30)
                     for p in ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]
                     if p in gpos}

    # Score gochar for MD lord's natal sign
    md_lord_sign = pdata.get(md_lord,{}).get("rashi_idx",0)
    gochar_for_md, _, gochar_flags = gochar_score_rashi(transit_signs, md_lord_sign)

    activated_yogas  = []
    activated_doshas = []

    for y in yogas:
        if not y["present"]: continue
        # Check if any active lord appears in yoga factors
        triggered = any(l and l in " ".join(y["factors"]) for l in active_lords if l)
        # Also check by yoga category alignment
        if not triggered:
            if md_lord in ("Jupiter","Venus","Moon") and y["category"] in ("Raj Yoga","Dhan Yoga","Buddhi Yoga"):
                triggered = True
            elif md_lord in ("Saturn","Mars") and y["category"] in ("Career Yoga","Special Yoga"):
                triggered = True
            elif md_lord in ("Sun",) and y["category"] in ("Raj Yoga","Career Yoga"):
                triggered = True
        if triggered:
            activation = y["score"] * (1.1 if gochar_for_md > 2 else 0.9)
            activated_yogas.append({
                "name":       y["name"],
                "category":   y["category"],
                "base_score": y["score"],
                "activation": round(min(100,activation),1),
                "strength":   y["strength"],
                "via_lord":   md_lord or ad_lord,
            })

    for d in doshas:
        if not d["present"]: continue
        triggered = any(l and l in " ".join(d["factors"]) for l in active_lords if l)
        if not triggered:
            if md_lord in ("Saturn","Rahu","Ketu") and d["category"] in ("Karmic/Rahu-Ketu","Planet-Based"):
                triggered = True
            elif md_lord == "Mars" and "Mangal" in d["name"]:
                triggered = True
        if triggered:
            activation = d["score"] * (1.1 if gochar_for_md < -2 else 0.9)
            activated_doshas.append({
                "name":       d["name"],
                "category":   d["category"],
                "base_score": d["score"],
                "activation": round(min(100,activation),1),
                "severity":   d["severity"],
                "via_lord":   md_lord or ad_lord,
            })

    return {
        "query_date": lords["query_date"],
        "vimshottari": vim,
        "moola": moola,
        "gochar_score_for_md_lord": round(gochar_for_md,2),
        "gochar_flags": gochar_flags,
        "activated_yogas":  sorted(activated_yogas,  key=lambda x: -x["activation"]),
        "activated_doshas": sorted(activated_doshas, key=lambda x: -x["activation"]),
    }


def display_dasha_activation(pdata: dict, birth_jd: float) -> None:
    """Display current dasha activation analysis — what's happening NOW."""
    ev = dasha_activated_events(pdata, birth_jd)
    vim   = ev["vimshottari"]
    moola = ev["moola"]
    SS    = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi']

    print(f"\n  ╔{'═'*76}╗")
    print(f"  ║  DASHA ACTIVATION ENGINE  —  Current Period Analysis")
    print(f"  ║  Date: {ev['query_date']}")
    print(f"  ╠{'═'*76}╣")

    # Current periods
    if vim:
        print(f"  ║  VIMSHOTTARI:")
        print(f"  ║    Mahadasha : {vim.get('md','?'):<12}  {vim.get('md_start','?')} → {vim.get('md_end','?')}")
        print(f"  ║    Antardasha: {vim.get('ad','?'):<12}  {vim.get('ad_start','?')} → {vim.get('ad_end','?')}")
        if vim.get("pd"): print(f"  ║    Pratyantardasha: {vim['pd']}")
    if moola:
        print(f"  ║  MOOLA DASHA:")
        print(f"  ║    Mahadasha : {moola.get('md','?'):<12}  {moola.get('md_start','?')} → {moola.get('md_end','?')}")
        print(f"  ║    Antardasha: {moola.get('ad','?'):<12}  {moola.get('ad_start','?')} → {moola.get('ad_end','?')}")

    # Gochar context
    gc = ev["gochar_score_for_md_lord"]
    gc_grade = ("Favorable" if gc > 2 else ("Unfavorable" if gc < -2 else "Neutral"))
    print(f"  ╠{'═'*76}╣")
    print(f"  ║  GOCHAR (Transit) for MD Lord's sign: {gc:+.2f} → {gc_grade}")
    if ev["gochar_flags"]:
        print(f"  ║    Alerts: {' | '.join(ev['gochar_flags'][:3])}")

    # Activated Yogas
    print(f"  ╠{'═'*76}╣")
    ay = ev["activated_yogas"]
    print(f"  ║  ✨ ACTIVATED YOGAS in current period ({len(ay)} found):")
    if ay:
        for y in ay[:8]:
            bar_w = int(y["activation"]/100*20)
            bar   = "▒"*bar_w + "░"*(20-bar_w)
            print(f"  ║    {y['name']:<28} {y['activation']:>5.1f}%  [{bar}]  via {y['via_lord']}")
    else:
        print(f"  ║    (No significant yogas activated in current dasha)")

    # Activated Doshas
    ad_ = ev["activated_doshas"]
    print(f"  ╠{'═'*76}╣")
    print(f"  ║  ⚠ ACTIVATED DOSHAS in current period ({len(ad_)} found):")
    if ad_:
        for d in ad_[:6]:
            bar_w = int(d["activation"]/100*20)
            bar   = "█"*bar_w + "░"*(20-bar_w)
            print(f"  ║    {d['name']:<28} {d['activation']:>5.1f}%  [{bar}]  {d['severity']}")
    else:
        print(f"  ║    (No significant doshas activated in current dasha)")

    print(f"  ╠{'═'*76}╣")
    print(f"  ║  Note: Activation = yoga/dosh base score × dasha relevance × gochar factor")
    print(f"  ╚{'═'*76}╝\n")


# ═══════════════════════════════════════════════════════════════════
#  MODULE F: BHAVA CHALITA (Equal House System)
#  House Strength Calculation
# ═══════════════════════════════════════════════════════════════════

def calculate_bhava_strength(pdata: dict) -> dict:
    """
    Calculate strength of each Bhava (house) using:
    1. Planets in the house (occupant strength)
    2. House lord's strength (Shadbala)
    3. SAV rekha count for the house
    4. Benefic/malefic aspects on the house
    Returns dict: {house_num: {"score_100": float, "factors": list}}
    """
    lagna = pdata.get("Lagna",{}).get("rashi_idx",0)
    SIGN_LORD = {0:"Mars",1:"Venus",2:"Mercury",3:"Moon",4:"Sun",5:"Mercury",
                 6:"Venus",7:"Mars",8:"Jupiter",9:"Saturn",10:"Saturn",11:"Jupiter"}
    BENEFIC = {"Jupiter","Venus","Mercury","Moon"}
    MALEFIC = {"Saturn","Mars","Sun","Rahu","Ketu"}
    PLANETS = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]
    SS = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi']

    sb  = calculate_shadbala(pdata)
    av  = calculate_ashtakavarga(pdata)

    house_scores = {}
    for h in range(1, 13):
        h_sign  = (lagna + h - 1) % 12
        h_lord  = SIGN_LORD.get(h_sign, "Sun")
        factors = []

        # 1. SAV score (0-8 points) → weight 35%
        sav_score = av["sav"][h_sign]
        sav_factor = (sav_score / 8.0) * 35
        factors.append(f"SAV: {sav_score}/8 → {sav_factor:.1f}pts")

        # 2. House lord strength → weight 30%
        lord_strength = sb.get(h_lord, {}).get("score_100", 50)
        lord_factor   = lord_strength * 0.30
        factors.append(f"Lord({h_lord}) Shadbala: {lord_strength:.0f}% → {lord_factor:.1f}pts")

        # 3. Occupants strength → weight 25%
        occupants = [p for p in PLANETS
                     if (pdata.get(p,{}).get("rashi_idx",0)-lagna)%12+1 == h]
        occ_score = 0
        if occupants:
            for p in occupants:
                p_strength = sb.get(p, {}).get("score_100", 50)
                modifier   = 1.2 if p in BENEFIC else 0.8
                occ_score += p_strength * modifier
            occ_score = min(occ_score / len(occupants), 100) * 0.25
            factors.append(f"Occupants: {occupants} → {occ_score:.1f}pts")
        else:
            occ_score = 12.5  # empty house gets average
            factors.append("Empty house (avg pts)")

        # 4. Aspect score → weight 10%
        asp_on_h = aspects_on_house(pdata, h)
        ben_asp  = sum(v for p,v in asp_on_h.items() if p in BENEFIC)
        mal_asp  = sum(v for p,v in asp_on_h.items() if p in MALEFIC)
        asp_net  = (ben_asp - mal_asp * 0.5) * 5
        asp_factor = max(-10, min(10, asp_net))
        if asp_on_h:
            factors.append(f"Aspects: ben={ben_asp:.1f} mal={mal_asp:.1f} → {asp_factor:+.1f}pts")

        total = sav_factor + lord_factor + occ_score + asp_factor
        total = max(0, min(100, total))

        house_scores[h] = {
            "score_100":  round(total, 1),
            "sign":       h_sign,
            "lord":       h_lord,
            "sav":        sav_score,
            "occupants":  occupants,
            "factors":    factors,
        }

    return house_scores


def display_bhava_strength(pdata: dict) -> None:
    """Display house strength scores for all 12 bhavas."""
    hs = calculate_bhava_strength(pdata)
    lagna = pdata.get("Lagna",{}).get("rashi_idx",0)
    SS = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi']
    PURPOSES = {
        1:"Self, Body, Personality", 2:"Wealth, Family, Speech",
        3:"Siblings, Courage, Communication", 4:"Home, Mother, Comforts",
        5:"Children, Intelligence, Creativity", 6:"Health, Enemies, Service",
        7:"Marriage, Partnership, Travel", 8:"Longevity, Mysteries, Transformation",
        9:"Dharma, Father, Fortune", 10:"Career, Fame, Authority",
        11:"Income, Gains, Aspirations", 12:"Losses, Moksha, Foreign"
    }

    def _bar(s, w=18):
        f = int(s/100*w)
        ch = "█" if s<35 else ("▓" if s<65 else "▒")
        return ch*f+"░"*(w-f)

    print(f"\n  ╔{'═'*76}╗")
    print(f"  ║  BHAVA STRENGTH — All 12 Houses")
    print(f"  ║  SAV(35%) + Lord Shadbala(30%) + Occupants(25%) + Aspects(10%)")
    print(f"  ╠{'═'*76}╣")
    print(f"  ║  {'H':>2}  {'Sign':>4}  {'Lord':>7}  {'SAV':>4}  "
          f"{'Score':>6}  {'[strength]':^20}  {'Purpose'}")
    print(f"  ╠{'═'*76}╣")

    for h in range(1, 13):
        d = hs[h]
        occ_str = ",".join(p[:2] for p in d["occupants"]) if d["occupants"] else "—"
        band = ("★★★" if d["score_100"]>=75 else "★★ " if d["score_100"]>=50 else "★  " if d["score_100"]>=25 else "·  ")
        print(f"  ║  {h:>2}  {SS[d['sign']]:>4}  {d['lord']:>7}  "
              f"{d['sav']:>4}  {d['score_100']:>5.1f}%  [{_bar(d['score_100'])}]  "
              f"{band} {PURPOSES.get(h,'')[:28]}")
        if d["occupants"]:
            print(f"  ║      Occupants: {occ_str}")

    print(f"  ╠{'═'*76}╣")
    sorted_h = sorted(range(1,13), key=lambda x: hs[x]["score_100"], reverse=True)
    print(f"  ║  STRONGEST: H{sorted_h[0]}({SS[hs[sorted_h[0]]['sign']]})={hs[sorted_h[0]]['score_100']:.0f}%  "
          f"H{sorted_h[1]}={hs[sorted_h[1]]['score_100']:.0f}%  H{sorted_h[2]}={hs[sorted_h[2]]['score_100']:.0f}%")
    print(f"  ║  WEAKEST  : H{sorted_h[-1]}({SS[hs[sorted_h[-1]]['sign']]})={hs[sorted_h[-1]]['score_100']:.0f}%  "
          f"H{sorted_h[-2]}={hs[sorted_h[-2]]['score_100']:.0f}%  H{sorted_h[-3]}={hs[sorted_h[-3]]['score_100']:.0f}%")
    print(f"  ╚{'═'*76}╝\n")


# ═══════════════════════════════════════════════════════════════════
#  MODULE G: CHAKRA-PLANET HEALTH ANALYSIS
#
#  Maps each of the 7 chakras to their ruling planets.
#  Uses Shadbala planet strength (0-100%) to determine:
#    - Health risk probability for each weak-planet condition
#    - Health benefit probability for each strong-planet condition
#    - Per-chakra activation score (0-100%)
#    - Overall health vulnerability score
#
#  Source: Vedic Astrology + Yogic Chakra system
#  JSON Data: user-provided body_mapping with planet weak/strong effects
# ═══════════════════════════════════════════════════════════════════

_CHAKRA_MAP = [
    {
        "name": "Muladhara", "number": 1, "beej": "LAM",
        "body_parts": ["Legs", "Knees", "Feet", "Bones"],
        "planets": {
            "Saturn": {
                "weak":   ["Knee pain","Arthritis","Joint stiffness","Bone weakness","Chronic pain"],
                "strong": ["Strong bones","Stability","Endurance","Discipline"],
            },
            "Mars": {
                "weak":   ["Muscle weakness","Low energy","Lack of movement","Injury risk"],
                "strong": ["Physical strength","Energy","Fast recovery","Good mobility"],
            },
        },
    },
    {
        "name": "Swadhisthana", "number": 2, "beej": "VAM",
        "body_parts": ["Reproductive organs", "Kidneys", "Bladder"],
        "planets": {
            "Venus": {
                "weak":   ["Fertility issues","Sexual problems","Hormonal imbalance","Kidney issues"],
                "strong": ["Healthy reproductive system","Creativity","Emotional balance","Attraction"],
            },
            "Moon": {
                "weak":   ["Emotional instability","Water retention","Urinary problems","Mood swings"],
                "strong": ["Emotional stability","Fluid balance","Mental peace"],
            },
        },
    },
    {
        "name": "Manipura", "number": 3, "beej": "RAM",
        "body_parts": ["Stomach", "Liver", "Pancreas"],
        "planets": {
            "Sun": {
                "weak":   ["Low digestion","Fatigue","Low confidence","Metabolism issues"],
                "strong": ["Strong digestion","Confidence","Leadership","High energy"],
            },
            "Jupiter": {
                "weak":   ["Liver problems","Obesity","Diabetes","Fat metabolism issues"],
                "strong": ["Healthy liver","Wisdom","Growth","Good metabolism"],
            },
        },
    },
    {
        "name": "Anahata", "number": 4, "beej": "YAM",
        "body_parts": ["Heart", "Lungs", "Hands"],
        "planets": {
            "Venus": {
                "weak":   ["Relationship stress","Heart weakness","Lack of emotional balance"],
                "strong": ["Love and harmony","Healthy heart","Emotional warmth"],
            },
            "Mercury": {
                "weak":   ["Respiratory issues","Anxiety","Communication problems"],
                "strong": ["Good communication","Mental clarity","Healthy lungs"],
            },
        },
    },
    {
        "name": "Vishuddha", "number": 5, "beej": "HAM",
        "body_parts": ["Throat", "Thyroid", "Voice"],
        "planets": {
            "Mercury": {
                "weak":   ["Thyroid imbalance","Speech problems","Nervous issues","Throat infections"],
                "strong": ["Clear communication","Sharp mind","Healthy throat"],
            },
        },
    },
    {
        "name": "Ajna", "number": 6, "beej": "OM",
        "body_parts": ["Brain", "Eyes", "Pituitary gland"],
        "planets": {
            "Saturn": {
                "weak":   ["Depression","Mental blockage","Fear","Slow thinking"],
                "strong": ["Focus","Deep thinking","Discipline"],
            },
            "Rahu": {
                "weak":   ["Confusion","Illusion","Anxiety","Overthinking"],
                "strong": ["Innovation","Vision","Analytical power"],
            },
        },
    },
    {
        "name": "Sahasrara", "number": 7, "beej": "Silence",
        "body_parts": ["Crown", "Pineal gland", "Full nervous system"],
        "planets": {
            "Ketu": {
                "weak":   ["Lack of direction","Spiritual disconnection","Confusion"],
                "strong": ["Spiritual awakening","Detachment","Inner peace"],
            },
        },
    },
]

_CHAKRA_ICON = {
    "Muladhara":"🔴","Swadhisthana":"🟠","Manipura":"🟡",
    "Anahata":"🟢","Vishuddha":"🔵","Ajna":"🟣","Sahasrara":"⚪",
}
_CHAKRA_COLOR = {
    "Muladhara":"Red","Swadhisthana":"Orange","Manipura":"Yellow",
    "Anahata":"Green","Vishuddha":"Blue","Ajna":"Indigo","Sahasrara":"Violet",
}


def _rk_proxy_strength(planet: str, pdata: dict) -> float:
    """Proxy Shadbala for Rahu/Ketu using house position + affliction."""
    lagna = pdata.get("Lagna",{}).get("rashi_idx",0)
    h = (pdata.get(planet,{}).get("rashi_idx",0) - lagna) % 12 + 1
    base = 50.0 if h in {1,4,7,10} else (25.0 if h in {6,8,12} else 38.0)
    sign = pdata.get(planet,{}).get("rashi_idx",0)
    mal_conj = sum(1 for p in ["Saturn","Mars","Sun"]
                   if p != planet and pdata.get(p,{}).get("rashi_idx",0) == sign)
    return max(5.0, base - mal_conj * 10)


def analyze_chakra_health(pdata: dict) -> list:
    """
    Analyze all 7 chakras using planet Shadbala strength.

    Returns list of dicts (7 chakras + 1 overall summary):
    Each chakra dict has:
      name, number, beej, color, body_parts,
      chakra_score (0-100), chakra_status,
      planet_data: list of {planet, strength, status, risk_items, benefit_items}

    Risk    probability = (100 - strength) * 0.90
    Benefit probability = strength * 0.95
    """
    sb = calculate_shadbala(pdata)

    def strength(planet):
        if planet in sb:
            return sb[planet]["score_100"]
        return _rk_proxy_strength(planet, pdata)

    results = []
    all_scores = []

    for chakra in _CHAKRA_MAP:
        planet_rows = []
        c_scores    = []

        for planet, effects in chakra["planets"].items():
            st = round(strength(planet), 1)
            c_scores.append(st)

            if st >= 65:
                status = "STRONG"
            elif st >= 35:
                status = "MIXED"
            else:
                status = "WEAK"

            risk_p    = round((100 - st) * 0.90, 1)
            benefit_p = round(st * 0.95, 1)

            # Show risks always (scale by weakness); benefits scale by strength
            risk_items    = [(c, round(risk_p    * (1 - i*0.04), 1))
                             for i,c in enumerate(effects["weak"])]
            benefit_items = [(c, round(benefit_p * (1 - i*0.04), 1))
                             for i,c in enumerate(effects["strong"])]

            planet_rows.append({
                "planet":         planet,
                "strength":       st,
                "status":         status,
                "risk_items":     risk_items,
                "benefit_items":  benefit_items,
            })

        chakra_score = round(sum(c_scores) / len(c_scores), 1) if c_scores else 50
        all_scores.append(chakra_score)

        chakra_status = (
            "Balanced"   if chakra_score >= 65 else
            "Moderate"   if chakra_score >= 40 else
            "Imbalanced" if chakra_score >= 20 else
            "Blocked"
        )

        results.append({
            "name":          chakra["name"],
            "number":        chakra["number"],
            "beej":          chakra["beej"],
            "color":         _CHAKRA_COLOR.get(chakra["name"], "White"),
            "icon":          _CHAKRA_ICON.get(chakra["name"], "•"),
            "body_parts":    chakra["body_parts"],
            "planet_data":   planet_rows,
            "chakra_score":  chakra_score,
            "chakra_status": chakra_status,
        })

    overall = round(sum(all_scores) / len(all_scores), 1)
    results.append({
        "overall_health_score": overall,
        "overall_status": (
            "Excellent"  if overall >= 70 else
            "Good"       if overall >= 50 else
            "Average"    if overall >= 35 else
            "Vulnerable"
        ),
    })
    return results


def display_chakra_health(pdata: dict) -> None:
    """Print the full Chakra-Planet Health Analysis dashboard."""
    results       = analyze_chakra_health(pdata)
    overall       = results[-1]
    chakras       = results[:-1]
    ov_score      = overall["overall_health_score"]
    ov_status     = overall["overall_status"]

    def _bar(s, w=20, risk=False):
        f  = int(s / 100 * w)
        ch = ("█" if risk else "▒") if s >= 65 else ("▓" if s >= 35 else "░" if s == 0 else "█")
        return ch * f + "░" * (w - f)

    def _rbar(p, w=14):          # red-toned risk bar
        f = int(p / 100 * w)
        return "█" * f + "░" * (w - f)

    def _bbar(p, w=14):          # green-toned benefit bar
        f = int(p / 100 * w)
        return "▒" * f + "░" * (w - f)

    def _st_icon(s):
        return ("✅" if s == "STRONG" else "⚡" if s == "MIXED" else "⚠ ")

    W = 78
    print(f"\n  ╔{'═'*W}╗")
    print(f"  ║{'CHAKRA-PLANET HEALTH ANALYSIS':^{W}}║")
    print(f"  ║{'Planet Strength (Shadbala) → Risk & Benefit Probability':^{W}}║")
    print(f"  ╠{'═'*W}╣")
    print(f"  ║  OVERALL HEALTH SCORE: {ov_score:>5.1f}%  "
          f"[{_bar(ov_score)}]  {ov_status:<12}              ║")
    print(f"  ╠{'═'*W}╣")

    for ch in chakras:
        cs  = ch["chakra_score"]
        cst = ch["chakra_status"]
        parts_str = "  ·  ".join(ch["body_parts"])

        print(f"  ║  {ch['icon']} {ch['number']}. {ch['name']:<14} "
              f"Beej:{ch['beej']:<8} Color:{ch['color']:<8} "
              f"Score:{cs:>5.1f}%  [{cst}]")
        print(f"  ║     Body Parts: {parts_str[:60]}")
        print(f"  ║  {'·'*W}║")

        for pd in ch["planet_data"]:
            p   = pd["planet"]
            pst = pd["strength"]
            st  = pd["status"]

            print(f"  ║     {_st_icon(st)} {p:<10}  "
                  f"Shadbala: {pst:>5.1f}%  [{_bar(pst)}]  {st}")

            # Risks
            if pd["risk_items"]:
                print(f"  ║       ⚠  Risks  (if planet weak):")
                for condition, prob in pd["risk_items"][:4]:
                    print(f"  ║          {condition:<36} {prob:>5.1f}%  [{_rbar(prob)}]")

            # Benefits
            if pd["benefit_items"]:
                print(f"  ║       ✨ Benefits (if planet strong):")
                for condition, prob in pd["benefit_items"][:3]:
                    print(f"  ║          {condition:<36} {prob:>5.1f}%  [{_bbar(prob)}]")

        print(f"  ╠{'═'*W}╣")

    # ── Global top risks ───────────────────────────────────────────
    all_risks = []
    all_bens  = []
    for ch in chakras:
        for pd in ch["planet_data"]:
            for cond, prob in pd["risk_items"]:
                all_risks.append((cond, prob, ch["name"], pd["planet"]))
            for cond, prob in pd["benefit_items"]:
                all_bens.append((cond, prob, ch["name"], pd["planet"]))

    all_risks.sort(key=lambda x: -x[1])
    all_bens.sort(key=lambda x:  -x[1])

    print(f"  ║  🩺 TOP 8 HEALTH RISKS  (sorted by probability):")
    print(f"  ║  {'#':<3} {'Condition':<36} {'Prob':>6}  {'Chakra':<14} Planet")
    print(f"  ║  {'─'*W}║")
    for i, (cond, prob, chakra, planet) in enumerate(all_risks[:8], 1):
        bar = "█" * int(prob/100*12) + "░"*(12-int(prob/100*12))
        print(f"  ║  {i:<3} {cond:<36} {prob:>5.1f}%  [{bar}]  {chakra:<13} {planet}")

    print(f"  ╠{'═'*W}╣")
    print(f"  ║  ✨ TOP 5 HEALTH BENEFITS (sorted by probability):")
    print(f"  ║  {'─'*W}║")
    for i, (cond, prob, chakra, planet) in enumerate(all_bens[:5], 1):
        bar = "▒" * int(prob/100*12) + "░"*(12-int(prob/100*12))
        print(f"  ║  {i:<3} {cond:<36} {prob:>5.1f}%  [{bar}]  {chakra:<13} {planet}")

    print(f"  ╠{'═'*W}╣")
    print(f"  ║  Formula:  Risk % = (100 - Shadbala) × 0.90  │  "
          f"Benefit % = Shadbala × 0.95")
    print(f"  ║  Status:   STRONG ≥65%  │  MIXED 35-64%  │  WEAK <35%")
    print(f"  ╚{'═'*W}╝\n")


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

    # ═══ DOSH ANALYSIS ═════════════════════════════════════════════
    display_dosh_analysis(pdata)

    # ═══ YOGA ANALYSIS ═════════════════════════════════════════════
    display_yoga_analysis(pdata)

    # ═══ ASPECT MATRIX ═════════════════════════════════════════════
    display_aspect_matrix(pdata)

    # ═══ SHADBALA ══════════════════════════════════════════════════
    display_shadbala(pdata)

    # ═══ ASHTAKAVARGA ══════════════════════════════════════════════
    display_ashtakavarga(pdata)

    # ═══ BHAVA STRENGTH ════════════════════════════════════════════
    display_bhava_strength(pdata)

    # ═══ LIFE AREA SCORING ═════════════════════════════════════════
    display_life_areas(pdata)

    # ═══ CHAKRA-PLANET HEALTH ANALYSIS ════════════════════════════
    display_chakra_health(pdata)

    # ═══ DASHA ACTIVATION ENGINE ═══════════════════════════════════
    display_dasha_activation(pdata, jd)

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

