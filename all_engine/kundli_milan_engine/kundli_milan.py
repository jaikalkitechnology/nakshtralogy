"""
kundli_milan.py  —  Complete Kundli Milan (Horoscope Matching) Engine
All 8 Guns (Ashtakoot) + probability model + supplementary doshas.

Fixes applied (v2):
  - Validation layer for required planetary data
  - Yoni logic corrected: same-animal check takes priority over YONI_FRIEND set
  - Navamsa _ variable bug fixed (dignity_label1/2 named properly)
  - GANA_SCORE corrected: Deva-Manushya = 5 (not 6) per BPHS
  - Unified compatibility score added
  - Computation cache added (_chart_cache dict)
  - Structured logging throughout
  - Proper exception handling with KundliMilanError
"""
import io, contextlib, logging, functools, hashlib
from typing import Optional, Dict, Any
from datetime import date

# ── Logging setup ──────────────────────────────────────────────────────────────
logging.basicConfig(
    format="%(asctime)s | %(name)s | %(levelname)s | %(message)s",
    datefmt="%H:%M:%S",
)
logger = logging.getLogger("kundli_milan")

# ── Engine import ──────────────────────────────────────────────────────────────
try:
    import nakshtralogy_v2 as _nk
except ImportError:
    raise RuntimeError("nakshtralogy_v2.py not found in path.")

# ── Custom exception ───────────────────────────────────────────────────────────
class KundliMilanError(ValueError):
    """Raised when chart data is invalid or missing required planets."""
    pass

# ── Computation cache (keyed by birth data hash) ───────────────────────────────
_chart_cache: Dict[str, Any] = {}

def _cache_key(*args) -> str:
    return hashlib.md5(str(args).encode()).hexdigest()[:12]

# ── Validation ─────────────────────────────────────────────────────────────────
REQUIRED_PLANETS = {"Lagna", "Moon", "Sun", "Mars", "Mercury",
                    "Jupiter", "Venus", "Saturn", "Rahu", "Ketu"}
REQUIRED_FOR_MILAN = {"Moon", "Lagna", "Venus", "Mars"}

def validate_pdata(pdata: dict, name: str = "Person") -> None:
    """
    Validate that pdata contains all required planets with valid data.
    Raises KundliMilanError with a descriptive message on failure.
    """
    if not isinstance(pdata, dict) or not pdata:
        raise KundliMilanError(f"{name}: pdata is empty or not a dict.")
    missing = REQUIRED_FOR_MILAN - set(pdata.keys())
    if missing:
        raise KundliMilanError(
            f"{name}: Missing required planets: {sorted(missing)}. "
            "Run calculate_chart() first.")
    for planet in REQUIRED_FOR_MILAN:
        entry = pdata.get(planet, {})
        if not isinstance(entry, dict):
            raise KundliMilanError(f"{name}: {planet} data is not a dict.")
        if "rashi_idx" not in entry:
            raise KundliMilanError(
                f"{name}: {planet} missing 'rashi_idx' — chart may be incomplete.")
        ri = entry["rashi_idx"]
        if not isinstance(ri, int) or not (0 <= ri <= 11):
            raise KundliMilanError(
                f"{name}: {planet} rashi_idx={ri!r} is invalid (must be 0-11).")
    moon_nak = pdata.get("Moon",{}).get("nak_idx", None)
    if moon_nak is None or not (0 <= moon_nak <= 26):
        raise KundliMilanError(
            f"{name}: Moon nak_idx={moon_nak!r} invalid (must be 0-26).")
    logger.debug("validate_pdata OK for %s", name)


# ══════════════════════════════════════════════════════════════════
#  CLASSICAL DATA TABLES
# ══════════════════════════════════════════════════════════════════

SS_FULL  = ['Aries','Taurus','Gemini','Cancer','Leo','Virgo',
            'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces']
SS_SHORT = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi']
NAK_NAMES = [
    "Ashwini","Bharani","Krittika","Rohini","Mrigashira","Ardra",
    "Punarvasu","Pushya","Ashlesha","Magha","Purva Phalguni","Uttara Phalguni",
    "Hasta","Chitra","Swati","Vishakha","Anuradha","Jyeshtha",
    "Mula","Purva Ashadha","Uttara Ashadha","Sravana","Dhanishtha",
    "Shatabhisha","Purva Bhadra","Uttara Bhadra","Revati",
]
NAK_LORD = [
    "Ketu","Venus","Sun","Moon","Mars","Rahu","Jupiter","Saturn","Mercury",
    "Ketu","Venus","Sun","Moon","Mars","Rahu","Jupiter","Saturn","Mercury",
    "Ketu","Venus","Sun","Moon","Mars","Rahu","Jupiter","Saturn","Mercury",
]
SIGN_LORD = {0:"Mars",1:"Venus",2:"Mercury",3:"Moon",4:"Sun",5:"Mercury",
             6:"Venus",7:"Mars",8:"Jupiter",9:"Saturn",10:"Saturn",11:"Jupiter"}

# 1. VARNA (from Moon sign)
VARNA = {0:"Kshatriya",1:"Vaishya",2:"Shudra",3:"Brahmin",4:"Brahmin",
         5:"Vaishya",6:"Vaishya",7:"Kshatriya",8:"Brahmin",9:"Vaishya",
         10:"Shudra",11:"Brahmin"}
VARNA_RANK = {"Brahmin":4,"Kshatriya":3,"Vaishya":2,"Shudra":1}

# 2. VASHYA
VASHYA = {0:[1,3],1:[3,11],2:[5,6],3:[8,9],4:[3,7],5:[2,10],
          6:[5,9],7:[3,9],8:[3,9],9:[3,6],10:[3,1],11:[3,9]}

# 3. TARA
TARA_FAV   = {2,4,6,8,9}
TARA_NAMES = {1:"Janma",2:"Sampat ✓",3:"Vipat ✗",4:"Kshema ✓",5:"Pratyak ✗",
              6:"Sadhana ✓",7:"Vadha ✗",8:"Mitra ✓",9:"Parama Mitra ✓"}

# 4. YONI — animal + gender per nakshatra
YONI = {
    0:("Horse","M"),  1:("Elephant","F"),2:("Sheep","F"), 3:("Snake","F"),
    4:("Snake","M"),  5:("Dog","F"),     6:("Cat","M"),   7:("Sheep","M"),
    8:("Cat","F"),    9:("Rat","M"),    10:("Rat","F"),  11:("Cow","M"),
   12:("Buffalo","F"),13:("Tiger","F"), 14:("Buffalo","M"),15:("Tiger","M"),
   16:("Deer","F"),  17:("Deer","M"),  18:("Dog","M"),  19:("Monkey","M"),
   20:("Monkey","F"),21:("Horse","F"), 22:("Lion","M"), 23:("Lion","F"),
   24:("Cow","F"),   25:("Elephant","M"),26:("Mongoose","M"),
}
# FIX: Use animal-name strings (not frozensets) to avoid frozenset deduplication bug.
# Same-animal check is done explicitly in calc_yoni BEFORE checking these sets.
YONI_ENEMY_ANIMALS = {
    frozenset(["Horse","Buffalo"]),  frozenset(["Elephant","Lion"]),
    frozenset(["Sheep","Dog"]),      frozenset(["Snake","Mongoose"]),
    frozenset(["Cat","Rat"]),        frozenset(["Cow","Tiger"]),
    frozenset(["Deer","Dog"]),       frozenset(["Monkey","Lion"]),
}
YONI_FRIEND_ANIMALS = {
    frozenset(["Horse","Deer"]),     frozenset(["Elephant","Cow"]),
}
# Note: same-animal pairs are handled by same==True branch (score 4 or 0)
# Only cross-animal friendship/enmity uses these sets.

# 5. GRAHA MAITRI — natural planetary friendships
_NF = {"Sun":{"Moon","Mars","Jupiter"},"Moon":{"Sun","Mercury"},
       "Mars":{"Sun","Moon","Jupiter"},"Mercury":{"Sun","Venus"},
       "Jupiter":{"Sun","Moon","Mars"},"Venus":{"Mercury","Saturn"},
       "Saturn":{"Mercury","Venus"}}
_NE = {"Sun":{"Venus","Saturn"},"Moon":set(),"Mars":{"Mercury"},
       "Mercury":{"Moon"},"Jupiter":{"Mercury","Venus"},
       "Venus":{"Sun","Moon"},"Saturn":{"Sun","Moon","Mars"}}

def _prel(p1: str, p2: str) -> str:
    if p1 == p2: return "same"
    f1 = p2 in _NF.get(p1, set()); f2 = p1 in _NF.get(p2, set())
    e1 = p2 in _NE.get(p1, set()); e2 = p1 in _NE.get(p2, set())
    if f1 and f2:   return "mutual_friend"
    if e1 and e2:   return "mutual_enemy"
    if f1 or f2:    return "friend"
    if e1 or e2:    return "enemy"
    return "neutral"

# 6. GANA — per nakshatra
GANA = {
    0:"Deva",1:"Manushya",2:"Rakshasa",3:"Manushya",4:"Deva",5:"Manushya",
    6:"Deva",7:"Deva",8:"Rakshasa",9:"Rakshasa",10:"Manushya",11:"Deva",
    12:"Deva",13:"Rakshasa",14:"Deva",15:"Rakshasa",16:"Deva",17:"Rakshasa",
    18:"Rakshasa",19:"Manushya",20:"Manushya",21:"Rakshasa",22:"Rakshasa",
    23:"Rakshasa",24:"Manushya",25:"Deva",26:"Deva",
}
# FIX: BPHS — Deva-Manushya = 5 (not 6); Manushya-Deva = 5
GANA_SCORE = {
    ("Deva","Deva"):6,      ("Manushya","Manushya"):6, ("Rakshasa","Rakshasa"):6,
    ("Deva","Manushya"):5,  ("Manushya","Deva"):5,
    ("Deva","Rakshasa"):1,  ("Rakshasa","Deva"):1,
    ("Manushya","Rakshasa"):0, ("Rakshasa","Manushya"):0,
}

# 7. BHAKOOT
BHAKOOT_BAD = {(6,8),(8,6),(5,9),(9,5),(2,12),(12,2)}

# 8. NADI
_NS  = [0,1,2,2,1,0,0,1,2, 0,1,2,2,1,0,0,1,2, 0,1,2,2,1,0,0,1,2]
NADI = {i:["Aadi","Madhya","Antya"][_NS[i]] for i in range(27)}

# RAJJU
_RAJJU = {"Siro":[4,13,22],"Kantha":[5,14,23],"Udara":[6,15,24],
           "Kati":[7,16,25],"Pada_A":[0,9,18],"Pada_B":[8,17,26],
           "Kati_B":[1,10,19],"Udara_B":[2,11,20],"Kantha_B":[3,12,21]}
NAK_RAJJU = {n:g for g,ns in _RAJJU.items() for n in ns}

# PROBABILITY BANDS per gun score value
GUN_PROB = {
    "Varna":        {1:100, 0:10},
    "Vashya":       {2:100, 1:60, 0:15},
    "Tara":         {3.0:100, 1.5:55, 0.0:10},
    "Yoni":         {4:100, 3:80, 2:55, 1:25, 0:5},
    "Graha Maitri": {5:100, 4:85, 3:65, 2:40, 1:20, 0:5},
    "Gana":         {6:100, 5:88, 1:20, 0:5},
    "Bhakoot":      {7:100, 0:5},
    "Nadi":         {8:100, 0:5},
}
GRADE_TABLE = [
    (88,"Exceptional",   "★★★★★","Rare blessed union. Highly recommended."),
    (75,"Excellent",     "★★★★½","Outstanding compatibility. Highly auspicious."),
    (66,"Very Good",     "★★★★ ","Strong match. Recommended for marriage."),
    (55,"Good",          "★★★½ ","Good compatibility. Most matches fall here."),
    (47,"Average",       "★★★  ","Workable with mutual effort."),
    (38,"Below Average", "★★   ","Caution advised. Remedies recommended."),
    (0, "Not Recommended","★    ","Significant challenges. Expert consultation needed."),
]

# ──────────────────────────────────────────────────────────────────
def _moon_data(pdata: dict) -> dict:
    """Extract Moon-based attributes. Validates Moon data before use."""
    m = pdata.get("Moon")
    if m is None:
        raise KundliMilanError("Moon data missing from pdata. Run validate_pdata() first.")
    s = m.get("rashi_idx", 0)
    n = m.get("nak_idx", 0)
    if not (0 <= n <= 26):
        logger.warning("Invalid nak_idx=%d for Moon, defaulting to 0", n)
        n = 0
    ya = YONI.get(n, ("Horse","M"))
    return {"sign":s,"sign_name":SS_FULL[s],"sign_short":SS_SHORT[s],"nak":n,"nak_name":NAK_NAMES[n],"nak_lord":NAK_LORD[n],"pada":m.get("pada",1),"lon":round(m.get("lon",0),4),"deg_sign":round(m.get("deg_rashi",0),2),"varna":VARNA.get(s,"Vaishya"),"varna_rank":VARNA_RANK.get(VARNA.get(s,"Vaishya"),2),"nadi":NADI.get(n,"Aadi"),"gana":GANA.get(n,"Manushya"),"yoni":ya,"yoni_str":f"{ya[0]} ({ya[1]})","rajju":NAK_RAJJU.get(n,"Unknown"),"sign_lord":SIGN_LORD.get(s,"Jupiter")}

# ──────────────────────────────────────────────────────────────────
def calc_varna(g,b):
    gr,br=g["varna_rank"],b["varna_rank"]; score=1 if gr>=br else 0; prob=GUN_PROB["Varna"].get(score,0)
    return {"gun":"Varna","gun_num":1,"max":1,"score":score,"probability":prob,"groom_val":f"{g['varna']} (rank {gr})","bride_val":f"{b['varna']} (rank {br})","status":"Compatible" if score else "Incompatible","meaning":"Spiritual/social class compatibility","detail":"Groom varna ≥ bride — compatible." if score else "Groom varna lower — social friction possible.","remedy":"" if score else "Varna Shuddhi Puja recommended.","has_dosha":False}

def calc_vashya(g,b):
    s1,s2=g["sign"],b["sign"]; a_c_b=s2 in VASHYA.get(s1,[]); b_c_a=s1 in VASHYA.get(s2,[])
    score=2 if(a_c_b and b_c_a)else(1 if(a_c_b or b_c_a)else 0); prob=GUN_PROB["Vashya"].get(score,0)
    ctrl="Mutual control — excellent"if score==2 else("Groom controls bride"if a_c_b else"Bride controls groom")if score==1 else"No natural affinity"
    return {"gun":"Vashya","gun_num":2,"max":2,"score":score,"probability":prob,"groom_val":g["sign_name"],"bride_val":b["sign_name"],"status":ctrl,"meaning":"Mutual control & natural attraction","detail":ctrl,"remedy":"" if score else "Vashya Nivaran Puja.","has_dosha":False}

def calc_tara(g,b):
    n1,n2=g["nak"],b["nak"]; c1=(n2-n1)%27+1; t1=((c1-1)%9)+1; ok1=t1 in TARA_FAV; c2=(n1-n2)%27+1; t2=((c2-1)%9)+1; ok2=t2 in TARA_FAV
    score=round((1.5 if ok1 else 0)+(1.5 if ok2 else 0),1); prob=GUN_PROB["Tara"].get(score,0)
    return {"gun":"Tara (Dina)","gun_num":3,"max":3,"score":score,"probability":prob,"groom_val":g["nak_name"],"bride_val":b["nak_name"],"tara_bride_from_groom":{"count":c1,"tara":t1,"name":TARA_NAMES.get(t1,""),"favorable":ok1},"tara_groom_from_bride":{"count":c2,"tara":t2,"name":TARA_NAMES.get(t2,""),"favorable":ok2},"status":"Excellent"if score==3 else"Good"if score>=1.5 else"Unfavorable","meaning":"Birth star health & longevity","detail":f"B→G: Tara {t1}({TARA_NAMES.get(t1,'')}) | G→B: Tara {t2}({TARA_NAMES.get(t2,'')})","remedy":""if score>=1.5 else"Tara Shanti Puja recommended.","has_dosha":False}

def calc_yoni(g,b):
    """
    Yoni Koot (max 4 pts).
    FIXED: same-animal check uses explicit string comparison FIRST,
    so frozenset deduplication cannot cause same-animal-opposite-sex
    to be mis-routed to the FRIEND branch.

    BPHS rules:
      Same animal, opposite gender = 4 (best)
      Friendly cross-animal pair   = 3
      Neutral cross-animal         = 2
      Enemy cross-animal pair      = 1
      Same animal, same gender     = 0 (worst)
    """
    a1, gd1 = g["yoni"]
    a2, gd2 = b["yoni"]
    # IMPORTANT: check same-animal BEFORE any frozenset lookup
    if a1 == a2:
        if gd1 != gd2:
            score = 4; st = "Perfect — same animal, complementary gender"
        else:
            score = 0; st = "Same animal, same gender — incompatible"
    else:
        pair = frozenset([a1, a2])
        if pair in YONI_FRIEND_ANIMALS:
            score = 3; st = "Friendly yoni — very good"
        elif pair in YONI_ENEMY_ANIMALS:
            score = 1; st = "Enemy yoni — conflicts possible"
        else:
            score = 2; st = "Neutral yoni — average"
    prob = GUN_PROB["Yoni"].get(score, 0)
    return {"gun":"Yoni","gun_num":4,"max":4,"score":score,"probability":prob,
            "groom_val":f"{a1}({gd1})","bride_val":f"{a2}({gd2})","status":st,
            "meaning":"Physical & sexual compatibility","detail":st,
            "remedy":"" if score>=2 else "Yoni Dosha Shanti Puja.","has_dosha":False}

def calc_graha_maitri(g,b):
    l1,l2=g["sign_lord"],b["sign_lord"]; rel=_prel(l1,l2)
    sm={"same":5,"mutual_friend":5,"friend":4,"neutral":3,"enemy":1,"mutual_enemy":0}; score=sm.get(rel,3)
    dm={5:"Excellent — mutual friendship",4:"Very Good — friendly lords",3:"Good — neutral lords",1:"Weak — one enmity",0:"Incompatible — mutual enemies"}; prob=GUN_PROB["Graha Maitri"].get(score,40)
    return {"gun":"Graha Maitri","gun_num":5,"max":5,"score":score,"probability":prob,"groom_val":f"{g['sign_name']} lord:{l1}","bride_val":f"{b['sign_name']} lord:{l2}","lord_groom":l1,"lord_bride":l2,"relationship":rel,"status":dm.get(score,"Average"),"meaning":"Mental & psychological harmony","detail":f"{l1} & {l2} are {rel.replace('_',' ')}","remedy":""if score>=3 else"Graha Maitri Puja for mental peace.","has_dosha":False}

def calc_gana(g,b):
    g1,g2=g["gana"],b["gana"]; score=GANA_SCORE.get((g1,g2),0); prob=GUN_PROB["Gana"].get(score,10)
    desc={6:"Same gana — perfect harmony",5:"Deva-Manushya — compatible",1:"Deva-Rakshasa — challenging",0:"Incompatible natures"}.get(score,"Average")
    return {"gun":"Gana","gun_num":6,"max":6,"score":score,"probability":prob,"groom_val":f"{g['nak_name']}→{g1}","bride_val":f"{b['nak_name']}→{g2}","groom_gana":g1,"bride_gana":g2,"status":desc,"meaning":"Nature, temperament & attitude","detail":desc,"remedy":""if score>=5 else"Gana Dosha Shanti Havan.","has_dosha":False}

def calc_bhakoot(g,b):
    s1,s2=g["sign"],b["sign"]; c12=(s2-s1)%12+1; c21=(s1-s2)%12+1; bad=(c12,c21)in BHAKOOT_BAD; score=0 if bad else 7
    axis_map={(6,8):"6-8 Shashthaashtaka",(8,6):"6-8 Shashthaashtaka",(5,9):"5-9 Panchama-Navama",(9,5):"5-9 Panchama-Navama",(2,12):"2-12 Dwi-Dwadasha",(12,2):"2-12 Dwi-Dwadasha"}
    axis=axis_map.get((c12,c21),f"{c12}-{c21} axis"); prob=GUN_PROB["Bhakoot"].get(score,0)
    return {"gun":"Bhakoot","gun_num":7,"max":7,"score":score,"probability":prob,"groom_val":g["sign_name"],"bride_val":b["sign_name"],"axis":f"{c12}-{c21}","axis_name":axis,"has_dosha":bad,"status":"Bhakoot Dosha — "+axis if bad else f"Favorable {c12}-{c21} axis","meaning":"Emotional, family & financial harmony","detail":axis if bad else f"Favorable {c12}-{c21} axis — emotional harmony","remedy":"Bhakoot Dosha Shanti Puja essential." if bad else ""}

def calc_nadi(g,b):
    n1,n2=g["nadi"],b["nadi"]; same=(n1==n2); score=0 if same else 8; prob=GUN_PROB["Nadi"].get(score,0)
    return {"gun":"Nadi","gun_num":8,"max":8,"score":score,"probability":prob,"groom_val":f"{g['nak_name']}→{n1} Nadi","bride_val":f"{b['nak_name']}→{n2} Nadi","groom_nadi":n1,"bride_nadi":n2,"has_dosha":same,"status":"Nadi Dosha — same Nadi" if same else f"{n1}×{n2} Nadi — excellent genetic match","meaning":"Genetic, health & progeny compatibility (critical)","detail":"Nadi Dosha: same nadi = health/progeny issues." if same else f"Different nadis ({n1} & {n2}) = genetic diversity & healthy children.","remedy":"Nadi Dosha Nivaran Puja MANDATORY." if same else ""}

# ──────────────────────────────────────────────────────────────────
def check_mangal_dosh(pdata,name="Person"):
    lag=pdata.get("Lagna",{}).get("rashi_idx",0); ms=pdata.get("Mars",{}).get("rashi_idx",0)
    def h(p,r): return(p-r)%12+1
    hl=h(ms,lag); hm=h(ms,pdata.get("Moon",{}).get("rashi_idx",0)); hv=h(ms,pdata.get("Venus",{}).get("rashi_idx",0))
    has=hl in{1,2,4,7,8,12}; sev="Severe"if hl in{7,8}else"Moderate"if hl in{1,4,12}else"Mild"if hl==2 else"None"
    return {"name":name,"has_mangal_dosh":has,"severity":sev if has else"None","mars_h_lagna":hl,"mars_h_moon":hm,"mars_h_venus":hv,"from_lagna":has,"from_moon":hm in{2,4,7,8,12},"from_venus":hv in{2,4,7,8,12},"remedy":"Mangal Dosh Shanti Puja + marry after 28 yrs." if has else ""}

def check_rajju_dosha(g,b):
    r1=NAK_RAJJU.get(g["nak"],"X"); r2=NAK_RAJJU.get(b["nak"],"Y")
    def base(r): return r.replace("_A","").replace("_B","").replace("_b","")
    has=base(r1)==base(r2)
    return {"has_rajju_dosha":has,"groom_rajju":r1,"bride_rajju":r2,"status":"Rajju Dosha — same Rajju group" if has else"No Rajju Dosha","remedy":"Rajju Dosha Shanti Puja recommended." if has else""}

def check_papasamya(p1,p2):
    MALEF=["Saturn","Mars","Sun","Rahu","Ketu"]; BAD={1,2,4,7,8,12}
    def cnt(pd):
        lag=pd.get("Lagna",{}).get("rashi_idx",0); c=0; ps=[]
        for p in MALEF:
            s=pd.get(p,{}).get("rashi_idx",0); hh=(s-lag)%12+1
            if hh in BAD: c+=1; ps.append(f"{p}(H{hh})")
        return c,ps
    c1,pl1=cnt(p1); c2,pl2=cnt(p2); diff=abs(c1-c2); bal=diff<=1
    return {"p1_score":c1,"p2_score":c2,"p1_planets":pl1,"p2_planets":pl2,"balanced":bal,"difference":diff,"result":"Affliction balanced — Mangal Dosha effect reduced" if bal else f"Imbalance ({diff}) — weaker chart more vulnerable"}

# ──────────────────────────────────────────────────────────────────
def compute_probability(guns,doshas,papa):
    MAX=36; wt={g["gun"]:g["max"]/MAX for g in guns}
    base=round(sum(g["probability"]*wt[g["gun"]] for g in guns),1); pen={}
    nadi_g=next((g for g in guns if g["gun"]=="Nadi"),None)
    bhak_g=next((g for g in guns if g["gun"]=="Bhakoot"),None)
    if nadi_g and nadi_g.get("has_dosha"): pen["Nadi Dosha"]=15
    if bhak_g and bhak_g.get("has_dosha"): pen["Bhakoot Dosha"]=10
    if doshas.get("rajju",{}).get("has_rajju_dosha"): pen["Rajju Dosha"]=7
    if doshas.get("groom",{}).get("has_mangal_dosh") and not papa.get("balanced"): pen["Mangal(Groom)"]=8
    if doshas.get("bride",{}).get("has_mangal_dosh") and not papa.get("balanced"): pen["Mangal(Bride)"]=8
    total_pen=sum(pen.values()); adj=round(max(3,base-total_pen),1)
    grade,stars,desc=GRADE_TABLE[-1][1],GRADE_TABLE[-1][2],GRADE_TABLE[-1][3]
    for thresh,g,s,d in GRADE_TABLE:
        if adj>=thresh: grade,stars,desc=g,s,d; break
    return {"base_probability":base,"penalties":pen,"total_penalty":total_pen,"final_probability":adj,"grade":grade,"stars":stars,"grade_description":desc,"gun_probabilities":{g["gun"]:g["probability"] for g in guns}}

# ══════════════════════════════════════════════════════════════════
class KundliMilanEngine:
    """Complete Kundli Milan — Ashtakoot (8 Gun) system with probability model."""

    def match(self, pdata1, pdata2, name1="Person1", name2="Person2", gender1="M", gender2="F"):
        """Run complete Kundli Milan with validation, caching, and logging."""
        logger.info("match() | %s × %s", name1, name2)
        # ── Validate both charts ─────────────────────────────────
        try:
            validate_pdata(pdata1, name1)
            validate_pdata(pdata2, name2)
        except KundliMilanError as e:
            logger.error("Validation failed: %s", e)
            raise
        if gender1=="M": gp,bp,gn,bn=pdata1,pdata2,name1,name2
        else: gp,bp,gn,bn=pdata2,pdata1,name2,name1
        try:
            g=_moon_data(gp); b=_moon_data(bp)
        except KundliMilanError as e:
            logger.error("Moon data extraction failed: %s", e)
            raise
        guns=[calc_varna(g,b),calc_vashya(g,b),calc_tara(g,b),calc_yoni(g,b),calc_graha_maitri(g,b),calc_gana(g,b),calc_bhakoot(g,b),calc_nadi(g,b)]
        ts=round(sum(x["score"] for x in guns),1); raw_pct=round(ts/36*100,1)
        mg=check_mangal_dosh(gp,gn); mb=check_mangal_dosh(bp,bn); raj=check_rajju_dosha(g,b); papa=check_papasamya(gp,bp)
        doshas={"groom":mg,"bride":mb,"rajju":raj}
        prob=compute_probability(guns,doshas,papa)
        active=[]; [active.append(x["gun"]+" Dosha") for x in guns if x.get("has_dosha")]
        if raj["has_rajju_dosha"]: active.append("Rajju Dosha")
        if mg["has_mangal_dosh"]: active.append(f"Mangal Dosh — {gn}")
        if mb["has_mangal_dosh"]: active.append(f"Mangal Dosh — {bn}")
        if papa["balanced"] and any("Mangal" in d for d in active): active.append("→ Papasamya reduces Mangal effect")
        recs=list(dict.fromkeys([x["remedy"] for x in guns if x.get("remedy")]+ [v.get("remedy","") for v in [mg,mb,raj] if v.get("remedy")]))
        if not recs: recs=["No major doshas — auspicious match. Select good muhurta."]
        if ts>=28: recs.insert(0,f"Strong score ({ts}/36) — highly recommended.")
        logger.info("match() complete | score=%s/36 prob=%s%%", ts, prob['final_probability'])
        return {"groom_name":gn,"bride_name":bn,"total_score":ts,"total_max":36,"raw_pct":raw_pct,"final_probability":prob["final_probability"],"base_probability":prob["base_probability"],"grade":prob["grade"],"stars":prob["stars"],"grade_description":prob["grade_description"],"penalties":prob["penalties"],"total_penalty":prob["total_penalty"],"guns":guns,"gun_scores":{x["gun"]:{"score":x["score"],"max":x["max"],"probability":x["probability"],"status":x["status"]} for x in guns},"strong_guns":[x["gun"] for x in guns if x["probability"]>=75],"weak_guns":[x["gun"] for x in guns if x["probability"]<50],"groom_profile":g,"bride_profile":b,"active_doshas":active,"mangal_groom":mg,"mangal_bride":mb,"rajju_dosha":raj,"papasamya":papa,"recommendations":recs}

    def match_from_birth(self,name1,gender1,dob1,tob1,place1,name2,gender2,dob2,tob2,place2):
        """Compute charts (with cache) then run full Kundli Milan."""
        logger.info("match_from_birth | %s (%s) × %s (%s)", name1, dob1, name2, dob2)
        def _c(n,gd,d,t,p):
            key = _cache_key(n,gd,d,t,p)
            if key in _chart_cache:
                logger.debug("Cache hit for %s", n)
                return _chart_cache[key]
            buf=io.StringIO()
            with contextlib.redirect_stdout(buf):
                pdata,_=_nk.calculate_chart(n,gd,d,t,p)
            if pdata is None:
                raise KundliMilanError(f"calculate_chart returned None for {n} — check birth data.")
            _chart_cache[key] = pdata
            logger.debug("Cache stored for %s", n)
            return pdata
        p1=_c(name1,gender1,dob1,tob1,place1); p2=_c(name2,gender2,dob2,tob2,place2)
        res=self.match(p1,p2,name1,name2,gender1,gender2)
        res["person1_birth"]={"name":name1,"gender":gender1,"dob":dob1,"tob":tob1,"place":place1}
        res["person2_birth"]={"name":name2,"gender":gender2,"dob":dob2,"tob":tob2,"place":place2}
        return res

    def display(self, r):
        W=78; g=r["groom_name"]; b=r["bride_name"]
        def bar(p,w=14): f=int(p/100*w); ch="▒"if p>=75 else("▓"if p>=50 else"█"); return ch*f+"░"*(w-f)
        print(f"\n  ╔{'═'*W}╗")
        print(f"  ║{'KUNDLI MILAN  —  Ashtakoot (8 Gun) System':^{W}}║")
        print(f"  ║{f'❤  {g}  ×  {b}  ❤':^{W}}║")
        print(f"  ╠{'═'*W}╣")
        gp=r["groom_profile"]; bp=r["bride_profile"]
        print(f"  ║  {'GROOM':<39}{'BRIDE':<39}║")
        print(f"  ║  {'─'*W}║")
        for lbl,gk,bk in [("Sign","sign_name","sign_name"),("Nakshatra","nak_name","nak_name"),("Pada","pada","pada"),("Nadi","nadi","nadi"),("Gana","gana","gana"),("Varna","varna","varna"),("Yoni","yoni_str","yoni_str"),("Rajju","rajju","rajju"),("Sign Lord","sign_lord","sign_lord")]:
            gv=str(gp.get(gk,"")); bv=str(bp.get(bk,""))
            print(f"  ║  {lbl:<12}{gv:<27}{lbl:<12}{bv:<27}║")
        print(f"  ╠{'═'*W}╣")
        print(f"  ║  {'#':<3}{'Gun':<20}{'Max':>4} {'Score':>6}  {'Prob%':>5}  {'[────────────]':<16}  Status")
        print(f"  ║  {'─'*W}║")
        for gd in r["guns"]:
            sc=gd["score"]; pb=gd["probability"]; icon="✅"if pb>=75 else("⚡"if pb>=50 else"⚠️")
            print(f"  ║  {gd['gun_num']:<3}{gd['gun']:<20}{gd['max']:>4} {sc:>6.1f}  {pb:>4.0f}%  [{bar(pb)}]  {icon}{gd['status'][:25]}")
        print(f"  ╠{'═'*W}╣")
        ts=r["total_score"]; fp=r["final_probability"]
        print(f"  ║  Total  : {ts:>5.1f}/36  Raw={r['raw_pct']}%  [{bar(r['raw_pct'],22)}]")
        if r["total_penalty"]>0:
            print(f"  ║  Penalties: {' | '.join(f'{k}:-{v}%' for k,v in r['penalties'].items())}")
        print(f"  ║  FINAL  : {'':>5}    {fp:>5.1f}%  [{bar(fp,22)}]  {r['stars']}  {r['grade']}")
        print(f"  ║  {r['grade_description']}")
        print(f"  ╠{'═'*W}╣")
        if r["active_doshas"]:
            print(f"  ║  ⚠  DOSHAS: {' · '.join(r['active_doshas'][:4])}")
        else: print(f"  ║  ✅ No major doshas")
        if r["strong_guns"]: print(f"  ║  💪 Strong (≥75%): {', '.join(r['strong_guns'])}")
        if r["weak_guns"]:   print(f"  ║  ⚠️  Weak  (<50%): {', '.join(r['weak_guns'])}")
        print(f"  ╠{'═'*W}╣")
        for rec in r["recommendations"][:4]: print(f"  ║  → {rec[:74]}")
        print(f"  ╠{'═'*W}╣")
        print(f"  ║  36=Perfect 32+=Excellent 28+=VeryGood 24+=Good 18+=Average <18=NotRecommended")
        print(f"  ╚{'═'*W}╝\n")

    def _compute_chart(self, person) -> dict:
        """Compute pdata from a PersonBirth-like object. Uses cache + validation."""
        key = _cache_key(person.name, person.gender, person.dob, person.tob, person.place)
        if key in _chart_cache:
            logger.debug("Cache hit for %s", person.name)
            return _chart_cache[key]
        buf = __import__('io').StringIO()
        import contextlib
        with contextlib.redirect_stdout(buf):
            pdata, _ = _nk.calculate_chart(
                person.name, person.gender, person.dob, person.tob, person.place)
        if pdata is None:
            raise KundliMilanError(
                f"calculate_chart returned None for {person.name}. Check birth data.")
        validate_pdata(pdata, person.name)
        _chart_cache[key] = pdata
        logger.debug("Chart computed and cached for %s", person.name)
        return pdata


milan_engine = KundliMilanEngine()


# ══════════════════════════════════════════════════════════════════
# UNIFIED COMPATIBILITY SCORE
# Combines all three phases into a single authoritative score.
# Weights derived from classical importance (BPHS priority order):
#   Phase 1 Ashtakoot  — 40% (classical 8-gun system, primary)
#   Phase 2 Advanced   — 35% (navamsa, venus, dasha sync)
#   Phase 3 Timing     — 25% (UL, 7th house, transit, dasha timeline)
# ══════════════════════════════════════════════════════════════════

UNIFIED_WEIGHTS = {
    "ashtakoot":  0.40,
    "navamsa":    0.12,
    "venus":      0.10,
    "dasha_sync": 0.08,
    "mangal":     0.05,   # deduction component
    "upapada":    0.08,
    "seventh_h":  0.10,
    "transit":    0.04,
    "dasha_time": 0.03,
}

def compute_unified_score(
    phase1:  dict,
    phase2:  dict,
    phase3:  dict,
) -> dict:
    """
    Compute a final unified compatibility score (0-100) from all three phases.

    Parameters
    ----------
    phase1 : result from KundliMilanEngine.match()
    phase2 : result from match_phase2()
    phase3 : result from match_phase3()

    Returns
    -------
    dict with:
        unified_score  (0-100)
        grade, stars, description
        component_scores  (breakdown per factor)
        marriage_verdict  (narrative)
    """
    # ── Collect component scores ──────────────────────────────────
    p1_prob  = phase1.get("final_probability", 50)
    nav_s    = phase2.get("navamsa",    {}).get("navamsa_score", 50)
    ven_s    = phase2.get("venus",      {}).get("venus_score",   50)
    dash_s   = phase2.get("dasha_sync", {}).get("sync_score",    50)

    # Mangal: score = 100 minus severity of effective doshas
    mg  = phase2.get("mangal_groom", {})
    mb  = phase2.get("mangal_bride",  {})
    papa= phase2.get("papasamya",    {})
    mgS = mg.get("score", 0) if mg.get("has_effective_dosh") else 0
    mbS = mb.get("score", 0) if mb.get("has_effective_dosh") else 0
    if papa.get("final_cancel"): mgS, mbS = 0, 0
    mangal_factor = 100 - max(mgS, mbS)   # higher = less dosha

    ul_s    = phase3.get("upapada",       {}).get("ul_score", 50)
    h7g_s   = phase3.get("seventh_house", {}).get("groom", {}).get("total_score", 50)
    h7b_s   = phase3.get("seventh_house", {}).get("bride",  {}).get("total_score", 50)
    h7_avg  = (h7g_s + h7b_s) / 2

    # Gochar: best window score (max 60) → normalize to 0-100
    gc_best = phase3.get("gochar_windows", {}).get("best_window") or {}
    gc_raw  = gc_best.get("score", 30)
    gc_norm = min(100, gc_raw * 1.67)   # 60 → 100

    # Dasha timeline: best combined window score → normalize
    ow_list = phase3.get("overlapping_windows", [])
    dt_score= ow_list[0].get("combined_score", 50) if ow_list else 50
    dt_norm = min(100, dt_score * 0.8)

    # ── Weighted sum ──────────────────────────────────────────────
    unified = round(
        p1_prob       * UNIFIED_WEIGHTS["ashtakoot"]  +
        nav_s         * UNIFIED_WEIGHTS["navamsa"]     +
        ven_s         * UNIFIED_WEIGHTS["venus"]       +
        dash_s        * UNIFIED_WEIGHTS["dasha_sync"]  +
        mangal_factor * UNIFIED_WEIGHTS["mangal"]      +
        ul_s          * UNIFIED_WEIGHTS["upapada"]     +
        h7_avg        * UNIFIED_WEIGHTS["seventh_h"]   +
        gc_norm       * UNIFIED_WEIGHTS["transit"]     +
        dt_norm       * UNIFIED_WEIGHTS["dasha_time"],
        1
    )

    # ── Grade ─────────────────────────────────────────────────────
    grade, stars, desc = GRADE_TABLE[-1][1], GRADE_TABLE[-1][2], GRADE_TABLE[-1][3]
    for thresh, g, s, d in GRADE_TABLE:
        if unified >= thresh:
            grade, stars, desc = g, s, d
            break

    # ── Marriage verdict ──────────────────────────────────────────
    total_doshas  = len(phase1.get("active_doshas", []))
    p2_doshas     = len([k for k in ["Nadi Dosha","Bhakoot Dosha","Rajju Dosha"]
                         if k in phase1.get("active_doshas",[])])
    best_timing   = phase3.get("recommendation", "")

    if unified >= 75 and total_doshas == 0:
        verdict = f"Highly auspicious match. {desc} No major doshas. {best_timing}"
    elif unified >= 65:
        verdict = f"Good compatibility. {desc} {f'Note: {total_doshas} dosh(as) present.' if total_doshas else ''} {best_timing}"
    elif unified >= 50:
        verdict = f"Average match. Consult priest for remedies. {best_timing}"
    else:
        verdict = f"Challenging match. {p2_doshas} critical dosha(s). Detailed consultation strongly advised."

    component_scores = {
        "ashtakoot_prob": p1_prob,
        "navamsa":        nav_s,
        "venus":          ven_s,
        "dasha_sync":     dash_s,
        "mangal_factor":  mangal_factor,
        "upapada":        ul_s,
        "seventh_house":  round(h7_avg, 1),
        "transit_window": round(gc_norm, 1),
        "dasha_timeline": round(dt_norm, 1),
    }

    logger.info("unified_score=%s grade=%s", unified, grade)
    return {
        "unified_score":     unified,
        "grade":             grade,
        "stars":             stars,
        "grade_description": desc,
        "component_scores":  component_scores,
        "weights":           UNIFIED_WEIGHTS,
        "marriage_verdict":  verdict,
        "total_doshas":      total_doshas,
    }



# ══════════════════════════════════════════════════════════════════
# PHASE 2: NAVAMSA MATCHING + MANGAL CANCELLATION + VENUS ENGINE
# ══════════════════════════════════════════════════════════════════

SS_FULL_P2  = ['Aries','Taurus','Gemini','Cancer','Leo','Virgo',
               'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces']
SS_SHORT_P2 = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi']

SIGN_TYPE = {
    "fire":  {0,4,8},   # Ar, Le, Sg
    "earth": {1,5,9},   # Ta, Vi, Cp
    "air":   {2,6,10},  # Ge, Li, Aq
    "water": {3,7,11},  # Cn, Sc, Pi
    "mars":  {0,7},     # Ar, Sc (own)
    "jupiter":{8,11},   # Sg, Pi (own)
    "venus": {1,6},     # Ta, Li (own)
    "mercury":{2,5},    # Ge, Vi (own)
    "saturn":{9,10},    # Cp, Aq
    "moon":  {3},       # Cn
    "sun":   {4},       # Le
}


# ─── MANGAL DOSHA FULL CANCELLATION ENGINE ────────────────────────────────────

def check_mangal_cancellations(pdata: dict, name: str = "Person") -> dict:
    """
    Full classical Mangal Dosha evaluation with ALL cancellation rules.
    Sources: BPHS, Muhurta Chintamani, Parashara Hora Shastra.

    Returns:
      has_raw_dosh: raw dosha (Mars in H1,2,4,7,8,12 from Lagna)
      cancellations: list of rules that cancel/reduce the dosha
      has_effective_dosh: dosha after applying all cancellations
      severity: None/Mild/Moderate/Severe
      score: 0-100 (0 = no dosha, 100 = severe uncancelled)
    """
    lagna  = pdata.get("Lagna", {}).get("rashi_idx", 0)
    mars   = pdata.get("Mars",  {}).get("rashi_idx", 0)
    moon   = pdata.get("Moon",  {}).get("rashi_idx", 0)
    jup    = pdata.get("Jupiter",{}).get("rashi_idx", 0)
    rahu   = pdata.get("Rahu",  {}).get("rashi_idx", 0)

    def h_from(planet_sign, ref): return (planet_sign - ref) % 12 + 1

    # ── Raw dosha from Lagna ──────────────────────────────────────
    mars_h_lag  = h_from(mars, lagna)
    mars_h_moon = h_from(mars, moon)
    DOSHA_H     = {1, 2, 4, 7, 8, 12}
    raw_dosh    = mars_h_lag in DOSHA_H

    if not raw_dosh:
        return {"name": name, "has_raw_dosh": False, "has_effective_dosh": False,
                "severity": "None", "score": 0, "cancellations": [],
                "mars_house": mars_h_lag, "mars_sign": SS_SHORT_P2[mars],
                "from_moon_house": mars_h_moon}

    # ── Severity (before cancellations) ──────────────────────────
    if mars_h_lag in {7, 8}:   raw_severity = "Severe"
    elif mars_h_lag in {1, 12}: raw_severity = "Moderate"
    else:                        raw_severity = "Mild"

    cancellations = []   # list of (rule_name, description, strength)
    total_cancel  = 0    # 0-100 cancel strength accumulated

    # ── Rule 1: OWN / EXALTED SIGN ───────────────────────────────
    if mars in SIGN_TYPE["mars"]:  # Ar or Sc
        cancellations.append({
            "rule": "Own Sign",
            "desc": f"Mars in {SS_FULL_P2[mars]} (own sign) — Mangal Dosha cancelled",
            "strength": 100, "full_cancel": True
        })
        total_cancel = 100
    elif mars == 9:  # Cp = exalted
        cancellations.append({
            "rule": "Exalted Sign",
            "desc": "Mars exalted in Capricorn — Mangal Dosha cancelled",
            "strength": 100, "full_cancel": True
        })
        total_cancel = 100

    # ── Rule 2: HOUSE-SPECIFIC SIGN EXCEPTIONS ───────────────────
    house_sign_exceptions = {
        1: SIGN_TYPE["fire"],      # H1 in Ar,Le,Sg — no dosha
        4: SIGN_TYPE["mars"],      # H4 in Ar,Sc — no dosha
        7: SIGN_TYPE["mercury"],   # H7 in Ge,Vi — no dosha
        8: SIGN_TYPE["jupiter"],   # H8 in Sg,Pi — no dosha (Jupiter absorbs)
        12: SIGN_TYPE["venus"],    # H12 in Ta,Li — no dosha (Venus sign)
    }
    if mars_h_lag in house_sign_exceptions:
        if lagna in house_sign_exceptions[mars_h_lag]:
            cancellations.append({
                "rule": f"H{mars_h_lag} Sign Exception",
                "desc": f"Mars in H{mars_h_lag} in {SS_FULL_P2[lagna]} (sign exception) — cancels",
                "strength": 90, "full_cancel": True
            })
            total_cancel = max(total_cancel, 90)

    # ── Rule 3: JUPITER CONJUNCTION ──────────────────────────────
    if jup == mars:
        cancellations.append({
            "rule": "Jupiter Conjunction",
            "desc": "Mars conjunct Jupiter — Jupiter neutralizes Mangal Dosha",
            "strength": 80, "full_cancel": False
        })
        total_cancel = min(100, total_cancel + 80)

    # ── Rule 4: JUPITER ASPECT on Mars ───────────────────────────
    # Jupiter aspects 5th, 7th, 9th from itself
    jup_aspects = {(jup + 4) % 12, (jup + 6) % 12, (jup + 8) % 12}
    if mars in jup_aspects and jup != mars:
        cancellations.append({
            "rule": "Jupiter Aspect",
            "desc": f"Jupiter aspects Mars from {SS_SHORT_P2[jup]} — reduces dosha",
            "strength": 60, "full_cancel": False
        })
        total_cancel = min(100, total_cancel + 60)

    # ── Rule 5: JUPITER ASPECTS the DOSHA HOUSE ─────────────────
    dosha_house_sign = (lagna + mars_h_lag - 1) % 12
    if dosha_house_sign in jup_aspects:
        cancellations.append({
            "rule": "Jupiter Aspects Dosha House",
            "desc": f"Jupiter aspects H{mars_h_lag} — significant reduction",
            "strength": 50, "full_cancel": False
        })
        total_cancel = min(100, total_cancel + 50)

    # ── Rule 6: MARS IN JUPITER SIGN ─────────────────────────────
    if mars in SIGN_TYPE["jupiter"]:
        cancellations.append({
            "rule": "Jupiter Sign",
            "desc": f"Mars in {SS_FULL_P2[mars]} (Jupiter's sign) — dosha reduced",
            "strength": 40, "full_cancel": False
        })
        total_cancel = min(100, total_cancel + 40)

    # ── Rule 7: MOON LAGNA / MARS LAGNA NATIVE ───────────────────
    if lagna in SIGN_TYPE["mars"]:
        cancellations.append({
            "rule": "Mars Lagna",
            "desc": f"{SS_FULL_P2[lagna]} lagna — Mars is natural lord, dosha reduced",
            "strength": 35, "full_cancel": False
        })
        total_cancel = min(100, total_cancel + 35)
    if moon in SIGN_TYPE["mars"]:
        cancellations.append({
            "rule": "Mars Moon Sign",
            "desc": f"Moon in {SS_FULL_P2[moon]} — Aries/Scorpio Moon reduces Mangal effect",
            "strength": 25, "full_cancel": False
        })
        total_cancel = min(100, total_cancel + 25)

    # ── Rule 8: DOSHA ALSO FROM MOON (Chandra Mangal) ────────────
    if mars_h_moon in DOSHA_H:
        cancellations.append({
            "rule": "Dosha from Moon Too",
            "desc": f"Mars also in H{mars_h_moon} from Moon — both references affected, Papasamya-like",
            "strength": 20, "full_cancel": False
        })
        total_cancel = min(100, total_cancel + 20)

    # ── Compute effective dosha ───────────────────────────────────
    full_cancels = [c for c in cancellations if c.get("full_cancel")]
    effective    = total_cancel < 90 and raw_dosh

    if not effective:
        eff_severity = "None"
        eff_score    = 0
    else:
        residual = max(0, 100 - total_cancel)
        if residual >= 70:
            eff_severity = raw_severity
            eff_score    = residual
        elif residual >= 40:
            eff_severity = "Moderate"
            eff_score    = residual
        else:
            eff_severity = "Mild"
            eff_score    = residual

    return {
        "name":               name,
        "has_raw_dosh":       raw_dosh,
        "has_effective_dosh": effective,
        "raw_severity":       raw_severity,
        "severity":           eff_severity,
        "score":              round(eff_score, 1),
        "mars_house":         mars_h_lag,
        "mars_sign":          SS_FULL_P2[mars],
        "from_moon_house":    mars_h_moon,
        "cancel_strength":    total_cancel,
        "cancellations":      cancellations,
        "remedy": (
            "No Mangal Dosha after cancellations — auspicious." if not effective
            else "Mangal Dosh present despite partial cancellations. Puja recommended."
        ),
    }


def check_mangal_papasamya(pd1: dict, pd2: dict, name1: str = "P1", name2: str = "P2") -> dict:
    """
    Full Papasamya (affliction balance) for Mangal Dosha cancellation.
    If BOTH partners have effective Mangal Dosha → they cancel each other.
    Also checks equal affliction for other malefics.
    """
    md1 = check_mangal_cancellations(pd1, name1)
    md2 = check_mangal_cancellations(pd2, name2)

    both_have    = md1["has_effective_dosh"] and md2["has_effective_dosh"]
    score_diff   = abs(md1["score"] - md2["score"])
    papa_cancel  = both_have and score_diff <= 30  # within 30 pts = balanced

    # Extended papasamya: count all malefic afflictions
    MALEF = ["Saturn","Mars","Rahu","Ketu","Sun"]
    BAD_H = {1,2,4,7,8,12}
    def aff_count(pdata):
        lag = pdata.get("Lagna",{}).get("rashi_idx",0); c=0
        for p in MALEF:
            s = pdata.get(p,{}).get("rashi_idx",0)
            if (s - lag) % 12 + 1 in BAD_H: c += 1
        return c
    c1, c2   = aff_count(pd1), aff_count(pd2)
    aff_diff = abs(c1 - c2)
    ext_bal  = aff_diff <= 1

    return {
        "person1":           {"name":name1,"dosha":md1},
        "person2":           {"name":name2,"dosha":md2},
        "both_have_mangal":  both_have,
        "mangal_balanced":   papa_cancel,
        "mangal_score_diff": score_diff,
        "ext_aff_p1":        c1,
        "ext_aff_p2":        c2,
        "ext_aff_balanced":  ext_bal,
        "final_cancel":      papa_cancel or (both_have and ext_bal),
        "result":            (
            "Mangal Dosha cancelled by Papasamya — both have matching dosha" if papa_cancel
            else "One partner has Mangal, other does not — caution advised" if (md1["has_effective_dosh"] or md2["has_effective_dosh"])
            else "Neither has effective Mangal Dosha — clean match"
        ),
    }


# ─── NAVAMSA (D-9) MATCHING ENGINE ───────────────────────────────────────────

_EXALT_D9  = {"Sun":0,"Moon":1,"Mars":9,"Mercury":5,"Jupiter":3,"Venus":11,"Saturn":6}
_DEBI_D9   = {"Sun":6,"Moon":7,"Mars":3,"Mercury":11,"Jupiter":9,"Venus":5,"Saturn":0}
_OWN_D9    = {"Sun":{4},"Moon":{3},"Mars":{0,7},"Mercury":{2,5},
              "Jupiter":{8,11},"Venus":{1,6},"Saturn":{9,10}}

def analyze_navamsa_compatibility(pd1: dict, pd2: dict,
                                   name1: str = "P1", name2: str = "P2") -> dict:
    """
    Navamsa (D-9) compatibility analysis for marriage.
    Key indicators from PDF/BPHS:
    - 7th house in D-9 and its lord
    - Venus position in D-9
    - Lagna lord in D-9
    - Mutual planet placement between charts
    - Upapada in D-9

    Returns: compatibility score (0-100), detailed analysis
    """
    from nakshtralogy_v2 import divisional_sign

    def _d9(pdata, planet):
        lon = pdata.get(planet, {}).get("lon", 0)
        return divisional_sign(lon, 9)[0]

    def _d9_lagna(pdata):
        lon = pdata.get("Lagna", {}).get("lon", 0)
        return divisional_sign(lon, 9)[0]

    def _dignity(planet, sign):
        if sign == _EXALT_D9.get(planet,-1): return "Exalted", 100
        if sign == _DEBI_D9.get(planet,-1):  return "Debilitated", 0
        if sign in _OWN_D9.get(planet,set()): return "Own Sign", 90
        sl = SIGN_LORD.get(sign,"Sun")
        if sl in _NF.get(planet,set()): return "Friend Sign", 70
        if sl in _NE.get(planet,set()): return "Enemy Sign", 25
        return "Neutral", 50

    SIGN_LORD_D9 = SIGN_LORD  # same
    _NF = {"Sun":{"Moon","Mars","Jupiter"},"Moon":{"Sun","Mercury"},"Mars":{"Sun","Moon","Jupiter"},
           "Mercury":{"Sun","Venus"},"Jupiter":{"Sun","Moon","Mars"},"Venus":{"Mercury","Saturn"},
           "Saturn":{"Mercury","Venus"}}
    _NE = {"Sun":{"Venus","Saturn"},"Moon":set(),"Mars":{"Mercury"},"Mercury":{"Moon"},
           "Jupiter":{"Mercury","Venus"},"Venus":{"Sun","Moon"},"Saturn":{"Sun","Moon","Mars"}}

    factors = []
    score   = 0

    # ── 1. 7th house in D-9 for each person ──────────────────────
    # (PDF: "7th house from D-9 lagna and its lord show marriage")
    lag1_d9 = _d9_lagna(pd1)
    lag2_d9 = _d9_lagna(pd2)
    h7_sign1 = (lag1_d9 + 6) % 12   # 7th from D-9 lagna
    h7_sign2 = (lag2_d9 + 6) % 12
    h7_lord1 = SIGN_LORD_D9[h7_sign1]
    h7_lord2 = SIGN_LORD_D9[h7_sign2]
    h7_lord1_sign = _d9(pd1, h7_lord1)
    h7_lord2_sign = _d9(pd2, h7_lord2)
    _, str1 = _dignity(h7_lord1, h7_lord1_sign)
    _, str2 = _dignity(h7_lord2, h7_lord2_sign)
    dignity_label1 = _[0] if isinstance(_, str) else _    # capture label before _ is reused
    dignity_label2 = dignity_label1   # will be overwritten below
    # FIX: unpack into named variables so _ is not reused in f-strings
    dignity_label1, str1 = _dignity(h7_lord1, h7_lord1_sign)
    dignity_label2, str2 = _dignity(h7_lord2, h7_lord2_sign)
    score += (str1 + str2) / 2 * 0.20   # 20% weight
    factors.append({
        "factor":  "7th Lord in D-9",
        "groom":   f"7th={SS_SHORT_P2[h7_sign1]}  lord={h7_lord1}  in {SS_SHORT_P2[h7_lord1_sign]} ({dignity_label1})",
        "bride":   f"7th={SS_SHORT_P2[h7_sign2]}  lord={h7_lord2}  in {SS_SHORT_P2[h7_lord2_sign]} ({dignity_label2})",
        "score_1": str1, "score_2": str2,
        "weight":  0.20,
    })

    # ── 2. Venus in D-9 strength ──────────────────────────────────
    # (Venus is karaka of marriage — must be strong in D-9)
    ven1_d9 = _d9(pd1, "Venus")
    ven2_d9 = _d9(pd2, "Venus")
    ven1_dig, ven1_str = _dignity("Venus", ven1_d9)
    ven2_dig, ven2_str = _dignity("Venus", ven2_d9)
    score += (ven1_str + ven2_str) / 2 * 0.20
    factors.append({
        "factor":  "Venus in D-9",
        "groom":   f"Venus in {SS_SHORT_P2[ven1_d9]} ({ven1_dig}) str={ven1_str}",
        "bride":   f"Venus in {SS_SHORT_P2[ven2_d9]} ({ven2_dig}) str={ven2_str}",
        "score_1": ven1_str, "score_2": ven2_str,
        "weight":  0.20,
    })

    # ── 3. Groom's Venus in Bride's D-9 Moon sign? ───────────────
    # (Cross-chart: desires alignment)
    moon2_d9 = _d9(pd2, "Moon")
    moon1_d9 = _d9(pd1, "Moon")
    cross_ven1 = (ven1_d9 == moon2_d9)   # groom Venus meets bride Moon in D9
    cross_ven2 = (ven2_d9 == moon1_d9)   # bride Venus meets groom Moon in D9
    cross_score = (100 if cross_ven1 else 50) + (100 if cross_ven2 else 50)
    cross_score /= 2
    score += cross_score * 0.15
    factors.append({
        "factor": "Cross-Venus-Moon in D-9",
        "desc":   f"Groom Venus ({SS_SHORT_P2[ven1_d9]}) in Bride Moon sign ({SS_SHORT_P2[moon2_d9]}): {'✅' if cross_ven1 else '—'}  |  Bride Venus ({SS_SHORT_P2[ven2_d9]}) in Groom Moon sign ({SS_SHORT_P2[moon1_d9]}): {'✅' if cross_ven2 else '—'}",
        "score":  cross_score, "weight": 0.15,
    })

    # ── 4. Mutual planet placement in D-9 ────────────────────────
    # Do any key planets (Sun/Moon/Venus/Jupiter) of one chart fall in
    # 1st, 5th, 7th, 9th, 11th from D-9 lagna of other?
    KEY_P = ["Sun","Moon","Venus","Jupiter","Mars"]
    GOOD_H_D9 = {1,5,7,9,11}
    mut_score = 0; mut_count = 0
    for p in KEY_P:
        s_in_d9 = _d9(pd1, p)
        h_from_lag2 = (s_in_d9 - lag2_d9) % 12 + 1
        if h_from_lag2 in GOOD_H_D9: mut_score += 1
        mut_count += 1
    for p in KEY_P:
        s_in_d9 = _d9(pd2, p)
        h_from_lag1 = (s_in_d9 - lag1_d9) % 12 + 1
        if h_from_lag1 in GOOD_H_D9: mut_score += 1
        mut_count += 1
    mutual_pct = (mut_score / mut_count * 100) if mut_count else 50
    score += mutual_pct * 0.15
    factors.append({
        "factor": "Mutual D-9 Planet Placement",
        "desc":   f"{mut_score}/{mut_count} key planets in favorable houses (1,5,7,9,11) across charts",
        "score":  round(mutual_pct,1), "weight": 0.15,
    })

    # ── 5. D-9 Lagna compatibility ────────────────────────────────
    # Are D-9 lagnas compatible (same element, trine, 7th)?
    lag_rel = (lag2_d9 - lag1_d9) % 12 + 1
    if lag_rel in {1,5,9}:   lag_compat = 100; lag_desc = "Trine — excellent"
    elif lag_rel in {7}:      lag_compat = 85;  lag_desc = "7th — complementary"
    elif lag_rel in {3,11}:   lag_compat = 70;  lag_desc = "3-11 axis — supportive"
    elif lag_rel in {2,12}:   lag_compat = 30;  lag_desc = "2-12 — challenging"
    elif lag_rel in {6,8}:    lag_compat = 20;  lag_desc = "6-8 axis — difficult"
    else:                      lag_compat = 55;  lag_desc = "Neutral"
    score += lag_compat * 0.15
    factors.append({
        "factor": "D-9 Lagna Compatibility",
        "groom":  f"D-9 Lagna: {SS_FULL_P2[lag1_d9]}",
        "bride":  f"D-9 Lagna: {SS_FULL_P2[lag2_d9]}",
        "axis":   f"{lag_rel}-{13-lag_rel if lag_rel!=7 else 7}",
        "desc":   lag_desc,
        "score":  lag_compat, "weight": 0.15,
    })

    # ── 6. 7th house in D-9 strength: benefics/malefics ──────────
    BENEF = {"Jupiter","Venus","Mercury","Moon"}
    MALEF = {"Saturn","Mars","Sun","Rahu","Ketu"}
    def seventh_d9_occupants(pdata, d9_lagna):
        h7_sign = (d9_lagna + 6) % 12
        occ = []
        for p in list(BENEF|MALEF):
            if p in pdata:
                if _d9(pdata, p) == h7_sign:
                    occ.append(p)
        return h7_sign, occ
    h7s1, occ1 = seventh_d9_occupants(pd1, lag1_d9)
    h7s2, occ2 = seventh_d9_occupants(pd2, lag2_d9)
    b1 = sum(1 for p in occ1 if p in BENEF); m1 = sum(1 for p in occ1 if p in MALEF)
    b2 = sum(1 for p in occ2 if p in BENEF); m2 = sum(1 for p in occ2 if p in MALEF)
    h7_score = (50 + b1*15 - m1*15 + b2*15 - m2*15)
    h7_score = max(0, min(100, h7_score))
    score += h7_score * 0.15
    factors.append({
        "factor":       "7th House D-9 Occupants",
        "groom_7th":    f"{SS_FULL_P2[h7s1]}: {occ1 if occ1 else 'empty'} (B={b1},M={m1})",
        "bride_7th":     f"{SS_FULL_P2[h7s2]}: {occ2 if occ2 else 'empty'} (B={b2},M={m2})",
        "score":        h7_score, "weight": 0.15,
    })

    final_score = round(min(100, score), 1)
    grade = ("Excellent" if final_score >= 75 else "Good" if final_score >= 55 else
             "Average" if final_score >= 40 else "Weak")

    return {
        "navamsa_score":    final_score,
        "grade":            grade,
        "groom_d9_lagna":   SS_FULL_P2[lag1_d9],
        "bride_d9_lagna":    SS_FULL_P2[lag2_d9],
        "groom_venus_d9":   f"{SS_FULL_P2[ven1_d9]} ({ven1_dig})",
        "bride_venus_d9":    f"{SS_FULL_P2[ven2_d9]} ({ven2_dig})",
        "factors":          factors,
        "interpretation":   (
            "Strong D-9 compatibility — inner harmony and spiritual bond present." if final_score >= 70
            else "Moderate D-9 compatibility — relationship works with effort." if final_score >= 50
            else "D-9 shows some inner incompatibilities — need counselling."
        ),
    }


# ─── VENUS COMPATIBILITY ENGINE ──────────────────────────────────────────────

def analyze_venus_compatibility(pd1: dict, pd2: dict,
                                 name1: str = "P1", name2: str = "P2") -> dict:
    """
    Venus compatibility analysis for marriage.
    Analyzes:
    - Venus sign/house in D-1 and D-9
    - Cross-chart Venus aspects and conjunctions
    - Venus dignity and strength
    - Venus-Moon relationship between charts
    - Physical attraction indicators
    """
    from nakshtralogy_v2 import divisional_sign, aspects_on_planet, calculate_shadbala

    factors = []
    score   = 0

    lagna1 = pd1.get("Lagna",{}).get("rashi_idx",0)
    lagna2 = pd2.get("Lagna",{}).get("rashi_idx",0)

    # ── Venus signs (D-1) ─────────────────────────────────────────
    ven1    = pd1.get("Venus",{}).get("rashi_idx",0)
    ven2    = pd2.get("Venus",{}).get("rashi_idx",0)
    ven1_h  = (ven1 - lagna1) % 12 + 1
    ven2_h  = (ven2 - lagna2) % 12 + 1
    ven1_dig= pd1.get("Venus",{}).get("dignity","Normal")
    ven2_dig= pd2.get("Venus",{}).get("dignity","Normal")

    DIG_SCORE = {"Exalted":100,"Swakshetra 🏠":85,"Moolatrikona":80,"Normal":55,"Neech ↓":15}
    vs1 = DIG_SCORE.get(ven1_dig, 55)
    vs2 = DIG_SCORE.get(ven2_dig, 55)

    # ── Venus in 7th / 5th / 1st (D-1) — favorable for love ─────
    GOOD_VH = {1,5,7}; BAD_VH = {6,8,12}
    v1_bonus = 20 if ven1_h in GOOD_VH else (-15 if ven1_h in BAD_VH else 0)
    v2_bonus = 20 if ven2_h in GOOD_VH else (-15 if ven2_h in BAD_VH else 0)
    vs1 = max(0, min(100, vs1 + v1_bonus))
    vs2 = max(0, min(100, vs2 + v2_bonus))
    score += (vs1 + vs2) / 2 * 0.25
    factors.append({
        "factor":  "Venus Strength (D-1)",
        "groom":   f"Venus in {SS_FULL_P2[ven1]} (H{ven1_h}) {ven1_dig} → {vs1}",
        "bride":   f"Venus in {SS_FULL_P2[ven2]} (H{ven2_h}) {ven2_dig} → {vs2}",
        "weight":  0.25,
    })

    # ── Cross-chart: Groom Venus sign = Bride Moon sign ──────────
    moon1 = pd1.get("Moon",{}).get("rashi_idx",0)
    moon2 = pd2.get("Moon",{}).get("rashi_idx",0)
    v1_in_m2 = (ven1 == moon2)   # groom Venus in bride Moon sign
    v2_in_m1 = (ven2 == moon1)   # bride Venus in groom Moon sign
    cross_s  = (80 if v1_in_m2 else 45) + (80 if v2_in_m1 else 45)
    cross_s /= 2
    score += cross_s * 0.20
    factors.append({
        "factor": "Cross Venus-Moon (D-1)",
        "desc":   f"Groom Venus ({SS_SHORT_P2[ven1]}) = Bride Moon sign ({SS_SHORT_P2[moon2]}): {'✅ YES' if v1_in_m2 else 'No'}  |  Bride Venus ({SS_SHORT_P2[ven2]}) = Groom Moon ({SS_SHORT_P2[moon1]}): {'✅ YES' if v2_in_m1 else 'No'}",
        "score":  cross_s, "weight": 0.20,
    })

    # ── Venus in same element or trine signs ──────────────────────
    ELEM = [{0,4,8},{1,5,9},{2,6,10},{3,7,11}]  # fire,earth,air,water
    same_elem = any(ven1 in e and ven2 in e for e in ELEM)
    trine_v   = (ven2 - ven1) % 12 in {0,4,8}   # same or 5th/9th
    opp_v     = (ven2 - ven1) % 12 == 6           # 7th = opposition
    elem_s    = 80 if same_elem else (70 if trine_v else (65 if opp_v else 45))
    score += elem_s * 0.15
    factors.append({
        "factor": "Venus Elemental Harmony",
        "groom":  SS_FULL_P2[ven1],
        "bride":   SS_FULL_P2[ven2],
        "same_element": same_elem,
        "trine": trine_v,
        "score": elem_s, "weight": 0.15,
    })

    # ── Venus in D-9 (navamsa) ────────────────────────────────────
    ven1_d9 = divisional_sign(pd1.get("Venus",{}).get("lon",0), 9)[0]
    ven2_d9 = divisional_sign(pd2.get("Venus",{}).get("lon",0), 9)[0]
    _OWN_V  = {1,6}; _EXL_V = {11}; _DEB_V = {5}
    def ven_d9_score(s):
        if s in _EXL_V: return 100
        if s in _OWN_V: return 85
        if s in _DEB_V: return 10
        return 55
    vd9s1 = ven_d9_score(ven1_d9); vd9s2 = ven_d9_score(ven2_d9)
    score += (vd9s1 + vd9s2) / 2 * 0.20
    factors.append({
        "factor": "Venus in D-9 (Navamsa)",
        "groom":  f"Venus in D-9: {SS_FULL_P2[ven1_d9]} ({vd9s1})",
        "bride":   f"Venus in D-9: {SS_FULL_P2[ven2_d9]} ({vd9s2})",
        "weight": 0.20,
    })

    # ── Venus Shadbala strength ───────────────────────────────────
    try:
        sb1 = calculate_shadbala(pd1).get("Venus",{}).get("pct_of_min",50)
        sb2 = calculate_shadbala(pd2).get("Venus",{}).get("pct_of_min",50)
        sb_norm1 = min(100, sb1 / 1.5)
        sb_norm2 = min(100, sb2 / 1.5)
        score += (sb_norm1 + sb_norm2) / 2 * 0.20
        factors.append({
            "factor": "Venus Shadbala",
            "groom":  f"{sb1:.0f}% of min → {sb_norm1:.0f} norm",
            "bride":   f"{sb2:.0f}% of min → {sb_norm2:.0f} norm",
            "weight": 0.20,
        })
    except Exception:
        score += 50 * 0.20

    final = round(min(100, score), 1)
    grade = ("Excellent" if final >= 75 else "Good" if final >= 55 else
             "Average" if final >= 40 else "Weak")
    return {
        "venus_score":         final,
        "grade":               grade,
        "groom_venus":         f"{SS_FULL_P2[ven1]} H{ven1_h} {ven1_dig}",
        "bride_venus":          f"{SS_FULL_P2[ven2]} H{ven2_h} {ven2_dig}",
        "groom_venus_d9":      SS_FULL_P2[ven1_d9],
        "bride_venus_d9":       SS_FULL_P2[ven2_d9],
        "cross_venus_moon":    {"groom_venus_in_bride_moon": v1_in_m2, "bride_venus_in_groom_moon": v2_in_m1},
        "factors":             factors,
        "interpretation":      (
            "Strong Venus compatibility — deep attraction and romantic harmony." if final >= 70
            else "Good Venus compatibility — mutual attraction present." if final >= 55
            else "Moderate Venus alignment — physical attraction may need cultivation." if final >= 40
            else "Venus compatibility is weak — relationship may lack romantic spark."
        ),
    }


# ─── DASHA SYNC ANALYSIS ─────────────────────────────────────────────────────

def analyze_dasha_sync(pd1: dict, bj1: float,
                        pd2: dict, bj2: float,
                        name1: str = "P1", name2: str = "P2") -> dict:
    """
    Dasha Synchronization Analysis.
    Analyzes whether both persons are in complementary Vimshottari Dasha periods
    that support love/marriage.
    
    Key rules (from PDF section 20329+):
    - Both in Venus/Jupiter/Moon dasha = very favorable for marriage
    - 7th lord dasha running = marriage significant
    - Dasha periods overlapping in favorable houses from each other = sync
    - D-9 Narayana dasha alignment
    """
    from nakshtralogy_v2 import vimshottari_dasha, get_current_dasha_lords, jd_to_date
    from datetime import date

    today_jd  = __import__("nakshtralogy_v2").to_julian_day(
        date.today().year, date.today().month, date.today().day, 0)

    # ── Get current Vimshottari dasha for both ────────────────────
    try:
        lords1 = get_current_dasha_lords(pd1, bj1)
        lords2 = get_current_dasha_lords(pd2, bj2)
        vim1   = lords1.get("vim", {})
        vim2   = lords2.get("vim", {})
    except Exception:
        return {"error": "Could not compute dasha lords", "sync_score": 40}

    md1, ad1 = vim1.get("md","Sun"), vim1.get("ad","Sun")
    md2, ad2 = vim2.get("md","Sun"), vim2.get("ad","Sun")

    factors = []
    score   = 0

    # ── 1. Both in marriage-favorable Mahadasha ───────────────────
    # Venus/Jupiter/Moon MD are best for marriage
    # (from PDF: Venus dasa and Jupiter dasa bring marriage)
    MARRIAGE_MD = {"Venus":100,"Jupiter":90,"Moon":80,"Mercury":70,"Mars":60,"Sun":50,"Saturn":40,"Rahu":35,"Ketu":30}
    md1_s = MARRIAGE_MD.get(md1, 50)
    md2_s = MARRIAGE_MD.get(md2, 50)
    score += (md1_s + md2_s) / 2 * 0.25
    factors.append({
        "factor":  "Mahadasha Favorability",
        "person1": f"{name1}: {md1} MD ({md1_s}/100)",
        "person2": f"{name2}: {md2} MD ({md2_s}/100)",
        "weight":  0.25,
    })

    # ── 2. Antardasha lord favorable ─────────────────────────────
    MARRIAGE_AD = {"Venus":100,"Moon":90,"Jupiter":85,"Mercury":70,"Mars":60,"Sun":55,"Saturn":45,"Rahu":40,"Ketu":35}
    ad1_s = MARRIAGE_AD.get(ad1, 50)
    ad2_s = MARRIAGE_AD.get(ad2, 50)
    score += (ad1_s + ad2_s) / 2 * 0.20
    factors.append({
        "factor":  "Antardasha Favorability",
        "person1": f"{name1}: {ad1} AD ({ad1_s}/100)",
        "person2": f"{name2}: {ad2} AD ({ad2_s}/100)",
        "weight":  0.20,
    })

    # ── 3. MD lord as 7th lord in each chart ─────────────────────
    lagna1 = pd1.get("Lagna",{}).get("rashi_idx",0)
    lagna2 = pd2.get("Lagna",{}).get("rashi_idx",0)
    h7_lord1 = SIGN_LORD.get((lagna1 + 6) % 12, "Venus")
    h7_lord2 = SIGN_LORD.get((lagna2 + 6) % 12, "Venus")
    md_is_7th_lord1 = (md1 == h7_lord1 or ad1 == h7_lord1)
    md_is_7th_lord2 = (md2 == h7_lord2 or ad2 == h7_lord2)
    lord7_s = (70 if md_is_7th_lord1 else 40) + (70 if md_is_7th_lord2 else 40)
    lord7_s /= 2
    score += lord7_s * 0.20
    factors.append({
        "factor":  "7th Lord in Current Dasha",
        "person1": f"{name1}: 7th lord={h7_lord1} | Running MD={md1}/AD={ad1} → {'✅' if md_is_7th_lord1 else '—'}",
        "person2": f"{name2}: 7th lord={h7_lord2} | Running MD={md2}/AD={ad2} → {'✅' if md_is_7th_lord2 else '—'}",
        "score":   lord7_s, "weight": 0.20,
    })

    # ── 4. Dasha lord alignment (one person's MD = other's 7th lord) ─
    cross1 = (md1 == h7_lord2) or (ad1 == h7_lord2)
    cross2 = (md2 == h7_lord1) or (ad2 == h7_lord1)
    cross_s = (80 if cross1 else 40) + (80 if cross2 else 40)
    cross_s /= 2
    score += cross_s * 0.15
    factors.append({
        "factor": "Cross-Dasha 7th Lord Alignment",
        "desc":   f"{name1} dasha lord ({md1}) = {name2}'s 7th lord ({h7_lord2}): {'✅' if cross1 else '—'}  |  {name2} dasha ({md2}) = {name1}'s 7th lord ({h7_lord1}): {'✅' if cross2 else '—'}",
        "score":  cross_s, "weight": 0.15,
    })

    # ── 5. Are they in the same broad phase? ──────────────────────
    # If both are in benefic MD = aligned; one benefic + one malefic = mixed
    BENEF_MD = {"Venus","Jupiter","Moon","Mercury"}
    both_benef = md1 in BENEF_MD and md2 in BENEF_MD
    one_benef  = (md1 in BENEF_MD) != (md2 in BENEF_MD)
    phase_s    = 90 if both_benef else (60 if one_benef else 40)
    score += phase_s * 0.20
    factors.append({
        "factor": "Phase Alignment",
        "desc":   f"Both in {'benefic' if both_benef else 'mixed' if one_benef else 'non-benefic'} MD — phase_score={phase_s}",
        "score":  phase_s, "weight": 0.20,
    })

    final = round(min(100, score), 1)
    grade = ("Excellent" if final >= 75 else "Good" if final >= 55 else
             "Average" if final >= 40 else "Weak")

    # ── Best upcoming overlapping period ─────────────────────────
    upcoming_hint = []
    if md1 == "Venus" or md2 == "Venus":
        upcoming_hint.append("Venus Mahadasha active — ideal marriage window")
    if md1 == "Jupiter" or md2 == "Jupiter":
        upcoming_hint.append("Jupiter Mahadasha active — strong marriage timing")
    if md_is_7th_lord1:
        upcoming_hint.append(f"{name1} in 7th lord ({h7_lord1}) dasha — marriage period")
    if md_is_7th_lord2:
        upcoming_hint.append(f"{name2} in 7th lord ({h7_lord2}) dasha — marriage period")

    return {
        "sync_score":       final,
        "grade":            grade,
        "name1_dasha":      {"md": md1, "ad": ad1, "7th_lord": h7_lord1},
        "name2_dasha":      {"md": md2, "ad": ad2, "7th_lord": h7_lord2},
        "both_in_benefic":  both_benef,
        "factors":          factors,
        "timing_hints":     upcoming_hint,
        "interpretation":   (
            "Both in highly favorable dasha periods — excellent timing for marriage!" if final >= 75
            else "Good dasha synchronization — marriage timing is favorable." if final >= 55
            else "Mixed dasha periods — timing is workable but not ideal." if final >= 40
            else "Dasha periods not aligned for marriage — consider waiting for better timing."
        ),
    }


# ─── PHASE 2: ENHANCED MATCH FUNCTION ────────────────────────────────────────

def match_phase2(pdata1: dict, birth_jd1: float,
                  pdata2: dict, birth_jd2: float,
                  name1: str = "P1", name2: str = "P2",
                  gender1: str = "M", gender2: str = "F") -> dict:
    """
    Phase 2 enhanced Kundli Milan:
    - Navamsa compatibility
    - Full Mangal cancellation rules
    - Venus compatibility engine
    - Dasha sync analysis
    Returns combined Phase 2 analysis dict.
    """
    if gender1 == "M":
        gn, bn = name1, name2
        gp, bp = pdata1, pdata2
        gbj, bbj = birth_jd1, birth_jd2
    else:
        gn, bn = name2, name1
        gp, bp = pdata2, pdata1
        gbj, bbj = birth_jd2, birth_jd1

    navamsa   = analyze_navamsa_compatibility(gp, bp, gn, bn)
    mangal_g  = check_mangal_cancellations(gp, gn)
    mangal_b  = check_mangal_cancellations(bp, bn)
    papa      = check_mangal_papasamya(gp, bp, gn, bn)
    venus     = analyze_venus_compatibility(gp, bp, gn, bn)
    dasha     = analyze_dasha_sync(gp, gbj, bp, bbj, gn, bn)

    # Combined Phase 2 score
    p2_score = round(
        navamsa["navamsa_score"] * 0.30 +
        venus["venus_score"]     * 0.30 +
        dasha["sync_score"]      * 0.25 +
        (100 - max(mangal_g["score"], mangal_b["score"])) * 0.15,
        1
    )
    p2_grade = ("Excellent" if p2_score >= 75 else "Good" if p2_score >= 55 else
                "Average" if p2_score >= 40 else "Needs Work")

    return {
        "phase2_score":     p2_score,
        "phase2_grade":     p2_grade,
        "navamsa":          navamsa,
        "mangal_groom":     mangal_g,
        "mangal_bride":     mangal_b,
        "papasamya":        papa,
        "venus":            venus,
        "dasha_sync":       dasha,
        "summary": {
            "navamsa_score":  navamsa["navamsa_score"],
            "venus_score":    venus["venus_score"],
            "dasha_score":    dasha["sync_score"],
            "mangal_groom":   mangal_g["severity"],
            "mangal_bride":   mangal_b["severity"],
            "mangal_cancel":  papa["final_cancel"],
        }
    }


# ══════════════════════════════════════════════════════════════════
# PHASE 3: TRANSIT ANALYSIS + 7TH HOUSE STRENGTH +
#          UPAPADA LAGNA + DASHA MARRIAGE TIMELINE
# Source: "Vedic Astrology: An Integrated Approach" PDF
# ══════════════════════════════════════════════════════════════════

SS_P3 = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi']
SS_FULL_P3 = ['Aries','Taurus','Gemini','Cancer','Leo','Virgo',
              'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces']
SIGN_LORD_P3 = {0:"Mars",1:"Venus",2:"Mercury",3:"Moon",4:"Sun",5:"Mercury",
                6:"Venus",7:"Mars",8:"Jupiter",9:"Saturn",10:"Saturn",11:"Jupiter"}


# ─── UPAPADA LAGNA (UL) ENGINE ────────────────────────────────────────────────

def compute_upapada_lagna(pdata: dict) -> dict:
    """
    Compute Upapada Lagna (UL) — Arudha Pada of 12th house.
    Formula from BPHS / PDF lines 4228-4247:

    1. 12th house sign = (lagna + 11) % 12
    2. Lord of 12th house sign → find which sign it occupies
    3. Count signs from 12th sign to lord's sign (zodiacal)
    4. Count same number from lord's sign → candidate UL sign
    5. Exception: if result = 12th sign itself OR 7th from 12th → add 10 more signs
    """
    lagna   = pdata.get("Lagna", {}).get("rashi_idx", 0)
    h12     = (lagna + 11) % 12        # Sign containing 12th house
    lord    = SIGN_LORD_P3[h12]        # Lord of 12th sign

    # For Sc/Aq with dual lords, use the more accessible one
    if h12 == 7:   lord = "Mars"       # Sc: Mars (stronger classical choice)
    if h12 == 10:  lord = "Saturn"     # Aq: Saturn

    lord_sign = pdata.get(lord, {}).get("rashi_idx", 0)

    # Step 3: count from h12 to lord_sign (zodiacal, 1-indexed)
    count = (lord_sign - h12) % 12 + 1

    # Step 4: count same from lord_sign
    result = (lord_sign + count - 1) % 12

    # Step 5: exception rule
    if result == h12 or result == (h12 + 6) % 12:
        result = (result + 9) % 12   # add 10 more signs (10-1 = +9 in 0-indexed)

    ul_sign = result

    # Planets in UL and their significations
    PLANET_IN_UL = {
        "Sun":     "charming, authoritative spouse from respectable family",
        "Moon":    "fair, imaginative spouse; may have mood swings",
        "Mars":    "bold, energetic spouse (good) or quarrelsome (bad)",
        "Mercury": "intelligent, communicative spouse (good) or indecisive (bad)",
        "Jupiter": "wise, noble, dharmic spouse; long and stable marriage",
        "Venus":   "beautiful, artistic, romantic spouse; pleasurable marriage",
        "Saturn":  "older or hardworking spouse; delays in marriage",
        "Rahu":    "unconventional, foreign or exotic spouse; dramatic marriage",
        "Ketu":    "spiritual, detached spouse (good) or short-tempered (bad)",
    }

    planets_in_ul  = []
    planets_in_ul8 = []   # 8th from UL = longevity of marriage
    planets_in_ul2 = []   # 2nd from UL = potential end of marriage
    planets_in_ul7 = []   # 7th from UL = potential end

    ul8 = (ul_sign + 7) % 12
    ul2 = (ul_sign + 1) % 12
    ul7 = (ul_sign + 6) % 12

    MALEF = {"Saturn","Mars","Sun","Rahu","Ketu"}
    BENEF = {"Jupiter","Venus","Mercury","Moon"}

    for p in list(MALEF | BENEF):
        ps = pdata.get(p, {}).get("rashi_idx", -1)
        if ps == ul_sign:  planets_in_ul.append(p)
        if ps == ul8:      planets_in_ul8.append(p)
        if ps == ul2:      planets_in_ul2.append(p)
        if ps == ul7:      planets_in_ul7.append(p)

    # Longevity of marriage
    mal_in_ul8 = sum(1 for p in planets_in_ul8 if p in MALEF)
    ben_in_ul8 = sum(1 for p in planets_in_ul8 if p in BENEF)
    mal_in_end = sum(1 for p in planets_in_ul2 + planets_in_ul7 if p in MALEF)

    if ben_in_ul8 > 0 and mal_in_ul8 == 0:
        longevity = "Long, stable marriage (benefics in 8th from UL)"
    elif mal_in_ul8 >= 2:
        longevity = "Marriage may face serious troubles (malefics in 8th from UL)"
    elif mal_in_end >= 1:
        longevity = "2nd/7th from UL has malefics — some marital friction possible"
    else:
        longevity = "Moderate marriage longevity"

    # Jupiter in 8th from UL = noble but difficult marriage (from PDF line 4441)
    jup_in_ul8 = "Jupiter" in planets_in_ul8
    if jup_in_ul8:
        longevity += "; Jupiter in 8th from UL → noble spouse but rough marital path"

    # Spouse description from UL sign + planets in UL
    ul_lord = SIGN_LORD_P3[ul_sign]
    spouse_desc = []
    for p in planets_in_ul:
        spouse_desc.append(f"{p}: {PLANET_IN_UL.get(p, 'special influence')}")

    return {
        "ul_sign":          ul_sign,
        "ul_sign_name":     SS_FULL_P3[ul_sign],
        "ul_lord":          ul_lord,
        "h12_sign":         h12,
        "h12_lord":         lord,
        "lord_sign":        lord_sign,
        "count_used":       count,
        "planets_in_ul":    planets_in_ul,
        "planets_8th_ul":   planets_in_ul8,
        "planets_2nd_ul":   planets_in_ul2,
        "planets_7th_ul":   planets_in_ul7,
        "marriage_longevity": longevity,
        "spouse_description": spouse_desc if spouse_desc else [f"UL in {SS_FULL_P3[ul_sign]} — general spouse traits of {ul_lord}"],
        "ul2_sign":         ul2,
        "ul7_sign":         ul7,
        "ul8_sign":         ul8,
    }


def compare_upapada(pd1: dict, pd2: dict, n1: str = "P1", n2: str = "P2") -> dict:
    """
    Compare Upapada Lagnas of both charts for mutual compatibility.
    Key rules:
    - UL of one person in trine (1/5/9) from UL of other = excellent
    - UL of one person in 7th from UL of other = complementary
    - UL lords in friendship = good
    - Is one person's UL same as other's natal Moon? = strong attraction
    """
    ul1 = compute_upapada_lagna(pd1)
    ul2 = compute_upapada_lagna(pd2)

    sign1, sign2 = ul1["ul_sign"], ul2["ul_sign"]
    lord1, lord2 = ul1["ul_lord"], ul2["ul_lord"]

    # Position of UL2 from UL1
    count = (sign2 - sign1) % 12 + 1
    TRINE     = {1,5,9}
    GOOD_H    = {1,3,5,7,9,11}

    trine_match = count in TRINE
    good_match  = count in GOOD_H
    bad_axis    = count in {6,8,2,12}

    # UL lord friendship
    def lord_rel(l1, l2):
        F = {"Sun":{"Moon","Mars","Jupiter"},"Moon":{"Sun","Mercury"},"Mars":{"Sun","Moon","Jupiter"},
             "Mercury":{"Sun","Venus"},"Jupiter":{"Sun","Moon","Mars"},"Venus":{"Mercury","Saturn"},
             "Saturn":{"Mercury","Venus"}}
        E = {"Sun":{"Venus","Saturn"},"Mars":{"Mercury"},"Mercury":{"Moon"},
             "Jupiter":{"Mercury","Venus"},"Venus":{"Sun","Moon"},"Saturn":{"Sun","Moon","Mars"}}
        if l1==l2: return "same"
        if l2 in F.get(l1,set()) and l1 in F.get(l2,set()): return "mutual_friend"
        if l2 in F.get(l1,set()) or l1 in F.get(l2,set()): return "friend"
        if l2 in E.get(l1,set()) or l1 in E.get(l2,set()): return "enemy"
        return "neutral"

    rel     = lord_rel(lord1, lord2)
    lord_s  = {"same":100,"mutual_friend":90,"friend":75,"neutral":55,"enemy":25}
    lord_sc = lord_s.get(rel, 55)

    # Compatibility score
    pos_score = 100 if trine_match else (80 if count==7 else (60 if good_match else 25))
    score     = round((pos_score * 0.6 + lord_sc * 0.4), 1)
    grade     = "Excellent" if score>=75 else "Good" if score>=55 else "Average" if score>=40 else "Weak"

    moon1 = pd1.get("Moon",{}).get("rashi_idx",0)
    moon2 = pd2.get("Moon",{}).get("rashi_idx",0)
    ul1_in_moon2 = sign1 == moon2
    ul2_in_moon1 = sign2 == moon1

    return {
        "person1_ul":       ul1,
        "person2_ul":       ul2,
        "ul_compatibility": {"axis": count, "trine": trine_match,
                              "good_position": good_match, "bad_axis": bad_axis},
        "lord_relationship": rel,
        "lord_score":        lord_sc,
        "position_score":    pos_score,
        "ul_score":          score,
        "grade":             grade,
        "ul1_in_moon2":     ul1_in_moon2,
        "ul2_in_moon1":     ul2_in_moon1,
        "special_notes": (
            [f"{n1}'s UL in {n2}'s Moon sign — deep karmic bond" ] if ul1_in_moon2 else []
        ) + (
            [f"{n2}'s UL in {n1}'s Moon sign — strong emotional attraction"] if ul2_in_moon1 else []
        ),
        "interpretation": (
            "Upapada Lagnas in trine — karmic alignment for marriage." if trine_match else
            "UL in 7th from each other — complementary marriage energy." if count==7 else
            "Good UL axis — marriage is supported." if good_match else
            "UL axis is challenging — marital path may have friction."
        ),
    }


# ─── 7TH HOUSE DETAILED STRENGTH ─────────────────────────────────────────────

def analyze_seventh_house(pdata: dict, name: str = "Person") -> dict:
    """
    Comprehensive 7th house strength analysis for marriage readiness.

    Factors analyzed:
    - 7th house sign and its lord (sign, house, dignity, aspects)
    - Planets occupying 7th house (benefic/malefic count)
    - Karaka: Venus (for male) / Jupiter (for female)
    - Aspects on 7th house
    - SAV score of 7th
    - Ashtakavarga support
    - D-9 7th house
    """
    from nakshtralogy_v2 import (calculate_shadbala, calculate_ashtakavarga,
                                   aspects_on_house, aspects_on_planet, divisional_sign)

    lagna    = pdata.get("Lagna",{}).get("rashi_idx",0)
    h7_sign  = (lagna + 6) % 12
    h7_lord  = SIGN_LORD_P3[h7_sign]

    BENEF = {"Jupiter","Venus","Mercury","Moon"}
    MALEF = {"Saturn","Mars","Sun","Rahu","Ketu"}
    PLANETS = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]
    DIG_SCORE = {"Exalted":100,"Swakshetra 🏠":85,"Moolatrikona":80,"Normal":55,"Neech ↓":10}

    score  = 0
    factors= []

    # ── 1. 7th Lord Analysis (30%) ────────────────────────────────
    lord_sign = pdata.get(h7_lord,{}).get("rashi_idx",0)
    lord_house= (lord_sign - lagna) % 12 + 1
    lord_dig  = pdata.get(h7_lord,{}).get("dignity","Normal")
    lord_vakri= pdata.get(h7_lord,{}).get("vakri",False)
    lord_comb = pdata.get(h7_lord,{}).get("combust",False)
    lord_ds   = DIG_SCORE.get(lord_dig,55)

    GOOD_H_LORD = {1,2,4,5,7,9,10,11}
    BAD_H_LORD  = {6,8,12}
    h_bonus = 15 if lord_house in GOOD_H_LORD else (-20 if lord_house in BAD_H_LORD else 0)
    vakri_pen = -10 if lord_vakri else 0
    comb_pen  = -15 if lord_comb  else 0
    lord_score= max(0, min(100, lord_ds + h_bonus + vakri_pen + comb_pen))
    score    += lord_score * 0.30
    factors.append({
        "factor":  "7th Lord",
        "lord":    h7_lord,
        "in_sign": SS_FULL_P3[lord_sign],
        "in_house":lord_house,
        "dignity": lord_dig,
        "vakri":   lord_vakri,
        "combust": lord_comb,
        "score":   lord_score,
        "weight":  0.30,
    })

    # ── 2. Planets in 7th House (20%) ─────────────────────────────
    occ = [p for p in PLANETS if (pdata.get(p,{}).get("rashi_idx",0)-lagna)%12+1==7]
    if occ:
        ben_c = sum(1 for p in occ if p in BENEF)
        mal_c = sum(1 for p in occ if p in MALEF)
        occ_s = max(0, min(100, 50 + ben_c*20 - mal_c*20))
    else:
        occ_s = 55  # empty = neutral
    score += occ_s * 0.20
    factors.append({
        "factor":    "7th House Occupants",
        "planets":   occ if occ else ["Empty"],
        "benefic":   [p for p in occ if p in BENEF],
        "malefic":   [p for p in occ if p in MALEF],
        "score":     occ_s,
        "weight":    0.20,
    })

    # ── 3. Aspects on 7th House (15%) ─────────────────────────────
    asp7 = aspects_on_house(pdata, 7)
    ben_asp = sum(v for p,v in asp7.items() if p in BENEF)
    mal_asp = sum(v for p,v in asp7.items() if p in MALEF)
    asp_s   = max(0, min(100, 50 + ben_asp*15 - mal_asp*15))
    score  += asp_s * 0.15
    factors.append({
        "factor":      "Aspects on 7th House",
        "benefic_asp": {p:v for p,v in asp7.items() if p in BENEF},
        "malefic_asp": {p:v for p,v in asp7.items() if p in MALEF},
        "score":       asp_s,
        "weight":      0.15,
    })

    # ── 4. Venus/Jupiter Karaka (20%) ─────────────────────────────
    # Venus = karaka of marriage for both; Jupiter = DK in female charts
    ven_sig = pdata.get("Venus",{}).get("rashi_idx",0)
    ven_h   = (ven_sig - lagna) % 12 + 1
    ven_dig = pdata.get("Venus",{}).get("dignity","Normal")
    ven_s   = DIG_SCORE.get(ven_dig,55)
    # Venus in 7th or aspecting 7th is best
    if ven_h == 7:               ven_s = min(100, ven_s + 20)
    elif ven_h in {5,9,11,1}:    ven_s = min(100, ven_s + 10)
    elif ven_h in {6,8,12}:      ven_s = max(0, ven_s - 20)
    score += ven_s * 0.20
    factors.append({
        "factor":   "Venus (Karaka of Marriage)",
        "in_sign":  SS_FULL_P3[ven_sig],
        "in_house": ven_h,
        "dignity":  ven_dig,
        "score":    ven_s,
        "weight":   0.20,
    })

    # ── 5. SAV Score of 7th (15%) ─────────────────────────────────
    try:
        av   = calculate_ashtakavarga(pdata)
        sav7 = av["sav"][h7_sign]
        sav_s= max(0, min(100, (sav7 / 56) * 100))  # SAV max=56
    except Exception:
        sav7, sav_s = 28, 50
    score += sav_s * 0.15
    factors.append({
        "factor": "SAV of 7th House",
        "sav":    sav7,
        "score":  round(sav_s,1),
        "weight": 0.15,
        "note":   "SAV>35 excellent, 25-35 good, <20 weak",
    })

    # ── D-9 7th house strength ─────────────────────────────────────
    lag_d9      = divisional_sign(pdata.get("Lagna",{}).get("lon",0), 9)
    if isinstance(lag_d9, tuple): lag_d9 = lag_d9[0]
    h7_sign_d9  = (lag_d9 + 6) % 12
    h7_lord_d9  = SIGN_LORD_P3[h7_sign_d9]
    lord_d9_sign= divisional_sign(pdata.get(h7_lord_d9,{}).get("lon",0), 9)
    if isinstance(lord_d9_sign, tuple): lord_d9_sign = lord_d9_sign[0]
    occ_d9      = []
    for p in PLANETS:
        ps = divisional_sign(pdata.get(p,{}).get("lon",0), 9)
        if isinstance(ps, tuple): ps = ps[0]
        if ps == h7_sign_d9: occ_d9.append(p)
    ben_d9 = sum(1 for p in occ_d9 if p in BENEF)
    mal_d9 = sum(1 for p in occ_d9 if p in MALEF)

    final = round(score, 1)
    grade = "Excellent" if final>=75 else "Good" if final>=55 else "Average" if final>=40 else "Weak"

    return {
        "h7_sign":        SS_FULL_P3[h7_sign],
        "h7_lord":        h7_lord,
        "total_score":    final,
        "grade":          grade,
        "factors":        factors,
        "d9_7th": {
            "sign":       SS_FULL_P3[h7_sign_d9],
            "lord":       h7_lord_d9,
            "lord_in":    SS_FULL_P3[lord_d9_sign],
            "occupants":  occ_d9,
            "benefic":    ben_d9,
            "malefic":    mal_d9,
        },
        "interpretation": (
            "Strong 7th house — very favorable for marriage." if final>=75 else
            "Good 7th house — marriage is well-supported." if final>=55 else
            "Average 7th house — marriage possible with effort." if final>=40 else
            "Weak 7th house — delays or difficulties in marriage likely."
        ),
    }


# ─── GOCHAR (TRANSIT) MARRIAGE TIMING ────────────────────────────────────────

def analyze_gochar_marriage(pdata: dict, target_year: int = None) -> dict:
    """
    Transit (Gochar) analysis for marriage timing.
    From PDF lines 14382-14436, rules:
    - Jupiter transiting 7th house from lagna → marriage favorable
    - Jupiter transiting natal 7th lord's sign → marriage window
    - Jupiter aspecting 7th house from its transit position (5th,7th,9th aspect)
    - Venus transiting 7th house or UL sign
    - Jupiter transiting UL sign → marriage possible
    - 7th lord transiting own natal sign → activation
    """
    from nakshtralogy_v2 import get_all_positions, to_julian_day
    from datetime import date

    lagna   = pdata.get("Lagna",{}).get("rashi_idx",0)
    h7_sign = (lagna + 6) % 12
    h7_lord = SIGN_LORD_P3[h7_sign]
    h7_lord_natal = pdata.get(h7_lord,{}).get("rashi_idx",0)
    venus_natal   = pdata.get("Venus",{}).get("rashi_idx",0)
    moon_natal    = pdata.get("Moon",{}).get("rashi_idx",0)

    ul = compute_upapada_lagna(pdata)
    ul_sign = ul["ul_sign"]

    start_year = target_year or date.today().year
    windows    = []

    # Scan the next 12 years (Jupiter takes ~12 years to complete a cycle)
    for yr in range(start_year, start_year + 12):
        for month in [1, 4, 7, 10]:   # quarterly samples
            try:
                jd     = to_julian_day(yr, month, 15, 6.0)
                gpos   = get_all_positions(jd)
                jup_s  = int(gpos.get("Jupiter",{}).get("lon",0) / 30)
                ven_s  = int(gpos.get("Venus",{}).get("lon",0) / 30)
                sat_s  = int(gpos.get("Saturn",{}).get("lon",0) / 30)
                mars_s = int(gpos.get("Mars",{}).get("lon",0) / 30)
                moon_s = int(gpos.get("Moon",{}).get("lon",0) / 30)
            except Exception:
                continue

            score_yr = 0
            triggers = []

            # Jupiter in 7th from lagna
            jup_h = (jup_s - lagna) % 12 + 1
            if jup_h == 7:
                score_yr += 30; triggers.append("♃ Jupiter transiting 7th house")

            # Jupiter in 7th lord's natal sign
            if jup_s == h7_lord_natal:
                score_yr += 25; triggers.append(f"♃ Jupiter over natal 7th lord ({h7_lord})")

            # Jupiter aspecting 7th house (Jupiter aspects 5th,7th,9th from itself)
            jup_asp = {(jup_s+4)%12, (jup_s+6)%12, (jup_s+8)%12}
            if h7_sign in jup_asp:
                score_yr += 20; triggers.append(f"♃ Jupiter aspecting 7th house ({SS_P3[h7_sign]})")

            # Jupiter over UL
            if jup_s == ul_sign:
                score_yr += 20; triggers.append(f"♃ Jupiter over UL ({SS_FULL_P3[ul_sign]})")

            # Jupiter over Venus natal
            if jup_s == venus_natal:
                score_yr += 15; triggers.append("♃ Jupiter over natal Venus")

            # Venus in 7th from lagna
            ven_h = (ven_s - lagna) % 12 + 1
            if ven_h == 7:
                score_yr += 15; triggers.append("♀ Venus transiting 7th house")

            # Venus over UL
            if ven_s == ul_sign:
                score_yr += 12; triggers.append(f"♀ Venus over UL ({SS_FULL_P3[ul_sign]})")

            # 7th lord transiting own natal sign (activation)
            if SIGN_LORD_P3.get(h7_lord_natal, "") == h7_lord:
                # 7th lord in its own sign
                transit_7l = int(gpos.get(h7_lord,{}).get("lon",0) / 30) if h7_lord in gpos else -1
                if transit_7l == h7_lord_natal:
                    score_yr += 15; triggers.append(f"{h7_lord} transiting own sign")

            # Saturn in bad position from Moon (Sade Sati check — reduces marriage chance)
            sat_h_moon = (sat_s - moon_natal) % 12 + 1
            if sat_h_moon in {12,1,2}:
                score_yr -= 15; triggers.append(f"♄ Sade Sati active — reduces window")

            if score_yr >= 25 and triggers:
                windows.append({
                    "year":    yr,
                    "quarter": f"Q{(month-1)//3+1}",
                    "date":    f"{yr}-{month:02d}",
                    "score":   score_yr,
                    "triggers":triggers,
                    "jup_in":  SS_FULL_P3[jup_s],
                    "ven_in":  SS_FULL_P3[ven_s],
                })

    # Deduplicate by year, keep best quarter
    seen_years = {}
    for w in sorted(windows, key=lambda x: -x["score"]):
        yr = w["year"]
        if yr not in seen_years or w["score"] > seen_years[yr]["score"]:
            seen_years[yr] = w

    ranked = sorted(seen_years.values(), key=lambda x: -x["score"])

    return {
        "h7_sign":       SS_FULL_P3[h7_sign],
        "h7_lord":       h7_lord,
        "ul_sign":       SS_FULL_P3[ul_sign],
        "venus_natal":   SS_FULL_P3[venus_natal],
        "scan_years":    f"{start_year}–{start_year+11}",
        "windows":       ranked[:8],
        "best_window":   ranked[0] if ranked else None,
        "interpretation": (
            f"Best marriage transit window: {ranked[0]['date']} (score {ranked[0]['score']}) — {', '.join(ranked[0]['triggers'][:2])}"
            if ranked else "No strong transit windows found in scan period."
        ),
    }


# ─── DASHA MARRIAGE TIMELINE ─────────────────────────────────────────────────

def predict_marriage_dasha_timeline(pdata: dict, birth_jd: float,
                                     scan_years: int = 25) -> dict:
    """
    Scan all future Vimshottari Mahadasha + Antardasha periods and score each
    for marriage probability.

    Scoring rules from PDF:
    1. MD/AD lord = 7th lord → +30 (very strong)
    2. MD/AD lord = Venus → +25 (natural karaka)
    3. MD/AD lord = Jupiter → +20 (wisdom/expansion)
    4. MD/AD lord in 7th house → +20
    5. MD/AD lord aspects 7th house → +15
    6. MD/AD period of UL lord → +20 (from PDF: "dasa of UL lord can give marriage")
    7. MD/AD period of rasi containing UL → +15 (Narayana dasa logic)
    8. 2nd lord in MD/AD → +10 (family expansion)
    9. Bad houses (6/8/12) lord in MD/AD → -15
    10. Malefic in 7th lord role → -5
    """
    from nakshtralogy_v2 import vimshottari_dasha, jd_to_date, to_julian_day
    from datetime import datetime, date

    today = date.today()
    today_jd = to_julian_day(today.year, today.month, today.day, 0)

    lagna    = pdata.get("Lagna",{}).get("rashi_idx",0)
    h7_sign  = (lagna + 6) % 12
    h7_lord  = SIGN_LORD_P3[h7_sign]
    h2_lord  = SIGN_LORD_P3[(lagna + 1) % 12]
    h6_lord  = SIGN_LORD_P3[(lagna + 5) % 12]
    h8_lord  = SIGN_LORD_P3[(lagna + 7) % 12]
    h12_lord = SIGN_LORD_P3[(lagna + 11) % 12]

    ul       = compute_upapada_lagna(pdata)
    ul_sign  = ul["ul_sign"]
    ul_lord  = ul["ul_lord"]

    MALEF    = {"Saturn","Mars","Rahu","Ketu","Sun"}
    BENEF    = {"Jupiter","Venus","Mercury","Moon"}

    # Planets in 7th house
    planets_in_7 = [p for p in ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]
                    if (pdata.get(p,{}).get("rashi_idx",0) - lagna)%12+1 == 7]

    # Planets aspecting 7th
    ASP_7 = set()
    for p in ["Jupiter","Saturn","Mars"]:
        ps = pdata.get(p,{}).get("rashi_idx",0)
        jup_asp = {(ps+4)%12,(ps+6)%12,(ps+8)%12}
        sat_asp = {(ps+2)%12,(ps+6)%12,(ps+9)%12}
        mar_asp = {(ps+3)%12,(ps+6)%12,(ps+7)%12}
        asp_map = {"Jupiter":jup_asp,"Saturn":sat_asp,"Mars":mar_asp}
        if h7_sign in asp_map[p]: ASP_7.add(p)
    # All planets aspect 7th (full aspect)
    for p in ["Sun","Moon","Mercury","Venus","Rahu","Ketu"]:
        ps = pdata.get(p,{}).get("rashi_idx",0)
        if (h7_sign - ps) % 12 == 6: ASP_7.add(p)

    def score_period(planet: str) -> tuple:
        """Score a dasha lord for marriage potential. Returns (score, reasons)."""
        s = 0; r = []
        if planet == h7_lord:
            s += 30; r.append(f"7th lord ({planet}) dasha")
        if planet == "Venus":
            s += 25; r.append("Venus dasha (marriage karaka)")
        if planet == "Jupiter":
            s += 20; r.append("Jupiter dasha (wisdom & expansion)")
        if planet == "Moon":
            s += 15; r.append("Moon dasha (emotions & relationships)")
        if planet in planets_in_7:
            s += 20; r.append(f"{planet} in 7th house")
        if planet in ASP_7:
            s += 15; r.append(f"{planet} aspects 7th house")
        if planet == ul_lord:
            s += 20; r.append(f"UL lord ({planet}) dasha")
        if planet == h2_lord:
            s += 10; r.append("2nd lord (family) dasha")
        if planet in {h6_lord, h8_lord, h12_lord} and planet not in {h7_lord, ul_lord}:
            s -= 15; r.append(f"6/8/12 lord — challenging for marriage")
        if planet in MALEF and planet == h7_lord:
            s -= 5;  r.append("7th lord is malefic — delays possible")
        return s, r

    # Scan future dashas
    try:
        moon_lon = pdata["Moon"]["lon"]
        dashas, _, _ = vimshottari_dasha(moon_lon, birth_jd)
    except Exception:
        return {"error": "Could not compute dashas", "windows": []}

    cutoff_jd = today_jd + scan_years * 365.25
    windows   = []

    for md in dashas:
        if md["end_jd"] < today_jd: continue
        if md["start_jd"] > cutoff_jd: break

        md_score, md_reasons = score_period(md["planet"])

        for ad in md.get("sub", []):
            if ad["end_jd"] < today_jd: continue
            if ad["start_jd"] > cutoff_jd: break

            ad_score, ad_reasons = score_period(ad["planet"])
            total = md_score + ad_score
            if total <= 20: continue

            all_reasons = md_reasons + [f"AD: {r}" for r in ad_reasons]
            grade = ("Excellent" if total>=65 else "Very Good" if total>=50 else
                     "Good" if total>=35 else "Average" if total>=25 else "Weak")

            start_str = jd_to_date(max(ad["start_jd"], today_jd))
            end_str   = jd_to_date(ad["end_jd"])

            windows.append({
                "md":        md["planet"],
                "ad":        ad["planet"],
                "start":     start_str,
                "end":       end_str,
                "score":     total,
                "grade":     grade,
                "reasons":   all_reasons[:4],
                "duration":  f"{(ad['end_jd']-max(ad['start_jd'],today_jd))/30.44:.1f} months",
            })

    windows.sort(key=lambda x: -x["score"])

    # Best window overall
    best = windows[0] if windows else None

    # Chronological order for near-term view
    chron = sorted(windows[:15], key=lambda x: x["start"])

    return {
        "scan_period":     f"{today.year}–{today.year+scan_years}",
        "h7_lord":         h7_lord,
        "ul_lord":         ul_lord,
        "planets_in_7":    planets_in_7,
        "planets_asp_7":   list(ASP_7),
        "best_window":     best,
        "top_windows":     windows[:6],
        "chronological":   chron[:10],
        "total_found":     len(windows),
        "interpretation": (
            f"Best marriage dasha window: {best['md']}-{best['ad']} ({best['start']} to {best['end']}) Score={best['score']} [{best['grade']}]"
            if best else "No strong marriage dasha found in scan period."
        ),
    }


# ─── PHASE 3 MASTER FUNCTION ──────────────────────────────────────────────────

def match_phase3(pdata1: dict, birth_jd1: float,
                  pdata2: dict, birth_jd2: float,
                  name1: str = "P1", name2: str = "P2",
                  gender1: str = "M", gender2: str = "F") -> dict:
    """
    Phase 3 complete analysis:
    - Upapada Lagna of both persons + comparison
    - 7th house detailed strength for both
    - Gochar (transit) marriage timing windows
    - Dasha marriage timeline for both
    Combined Phase 3 score and overall interpretation.
    """
    if gender1 == "M":
        gn, bn, gp, bp, gbj, bbj = name1, name2, pdata1, pdata2, birth_jd1, birth_jd2
    else:
        gn, bn, gp, bp, gbj, bbj = name2, name1, pdata2, pdata1, birth_jd2, birth_jd1

    ul_analysis   = compare_upapada(gp, bp, gn, bn)
    h7_groom      = analyze_seventh_house(gp, gn)
    h7_bride      = analyze_seventh_house(bp, bn)
    gochar        = analyze_gochar_marriage(gp)      # use groom chart as reference
    dasha_groom   = predict_marriage_dasha_timeline(gp, gbj)
    dasha_bride   = predict_marriage_dasha_timeline(bp, bbj)

    # Combined Phase 3 score
    h7_avg  = (h7_groom["total_score"] + h7_bride["total_score"]) / 2
    p3_score= round(
        ul_analysis["ul_score"]    * 0.25 +
        h7_avg                     * 0.30 +
        (min(100, gochar["windows"][0]["score"] * 2) if gochar["windows"] else 40) * 0.20 +
        min(100, (dasha_groom["best_window"]["score"] if dasha_groom.get("best_window") else 40) * 0.8) * 0.15 +
        min(100, (dasha_bride["best_window"]["score"] if dasha_bride.get("best_window") else 40) * 0.8) * 0.10,
        1
    )
    p3_grade = ("Excellent" if p3_score>=75 else "Good" if p3_score>=55 else
                "Average" if p3_score>=40 else "Challenging")

    # Find common/overlapping marriage windows
    overlap = []
    if dasha_groom.get("top_windows") and dasha_bride.get("top_windows"):
        from datetime import datetime
        for gw in dasha_groom["top_windows"][:4]:
            for bw in dasha_bride["top_windows"][:4]:
                try:
                    gs = datetime.strptime(gw["start"], "%d/%m/%Y")
                    ge = datetime.strptime(gw["end"], "%d/%m/%Y")
                    bs = datetime.strptime(bw["start"], "%d/%m/%Y")
                    be = datetime.strptime(bw["end"], "%d/%m/%Y")
                    overlap_start = max(gs, bs)
                    overlap_end   = min(ge, be)
                    if overlap_start < overlap_end:
                        overlap.append({
                            "start":    overlap_start.strftime("%d/%m/%Y"),
                            "end":      overlap_end.strftime("%d/%m/%Y"),
                            "groom_period": f"{gw['md']}-{gw['ad']}",
                            "bride_period": f"{bw['md']}-{bw['ad']}",
                            "combined_score": gw["score"] + bw["score"],
                        })
                except Exception:
                    pass
        overlap.sort(key=lambda x: -x["combined_score"])

    return {
        "phase3_score":    p3_score,
        "phase3_grade":    p3_grade,
        "upapada":         ul_analysis,
        "seventh_house": {
            "groom": h7_groom,
            "bride":  h7_bride,
        },
        "gochar_windows":  gochar,
        "dasha_timeline": {
            "groom": dasha_groom,
            "bride":  dasha_bride,
        },
        "overlapping_windows": overlap[:5],
        "summary": {
            "ul_score":        ul_analysis["ul_score"],
            "h7_groom":        h7_groom["total_score"],
            "h7_bride":        h7_bride["total_score"],
            "best_gochar":     gochar["best_window"]["date"] if gochar.get("best_window") else "Not found",
            "best_dasha_groom":dasha_groom["best_window"]["start"] if dasha_groom.get("best_window") else "Not found",
            "best_dasha_bride":dasha_bride["best_window"]["start"] if dasha_bride.get("best_window") else "Not found",
            "overlap_count":   len(overlap),
        },
        "recommendation": (
            f"Best combined marriage timing: {overlap[0]['start']}–{overlap[0]['end']} "
            f"({overlap[0]['groom_period']} × {overlap[0]['bride_period']})"
            if overlap else
            f"Check individual timelines — best gochar: {gochar.get('best_window',{}).get('date','TBD')}"
        ),
    }
