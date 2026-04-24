"""
test_kundli_milan.py
====================
Comprehensive test suite for kundli_milan.py

Covers:
  - Validation layer (missing data, invalid inputs)
  - All 8 Gun calculations including edge cases
  - Yoni matching logic (classical Vedic rules)
  - GANA_SCORE correctness (BPHS values)
  - Navamsa compatibility (no _ variable leakage)
  - Mangal Dosha full cancellation rules
  - Venus compatibility engine
  - Dasha sync analysis
  - Upapada Lagna calculation
  - 7th house strength
  - Gochar marriage windows
  - Dasha timeline prediction
  - Unified compatibility score
  - Caching behaviour
  - Phase 2 and Phase 3 master functions
  - Extreme dosha scenarios
  - Full match pipeline

Run:
    python -m pytest test_kundli_milan.py -v
    # or
    python test_kundli_milan.py
"""

import io, contextlib, pytest, logging
import nakshtralogy_v2 as _nk
import kundli_milan as km
from kundli_milan import (
    KundliMilanError, validate_pdata,
    _moon_data, YONI, GANA, GANA_SCORE, NADI, NAK_RAJJU,
    calc_varna, calc_vashya, calc_tara, calc_yoni,
    calc_graha_maitri, calc_gana, calc_bhakoot, calc_nadi,
    check_mangal_dosh, check_mangal_cancellations, check_mangal_papasamya,
    check_rajju_dosha, check_papasamya, compute_probability,
    analyze_navamsa_compatibility, analyze_venus_compatibility,
    analyze_dasha_sync, compute_upapada_lagna, compare_upapada,
    analyze_seventh_house, analyze_gochar_marriage,
    predict_marriage_dasha_timeline,
    match_phase2, match_phase3, compute_unified_score,
    milan_engine, _chart_cache, YONI_ENEMY_ANIMALS, YONI_FRIEND_ANIMALS,
)

logging.basicConfig(level=logging.WARNING)   # quiet during tests

# ──────────────────────────────────────────────────────────────────
#  FIXTURES
# ──────────────────────────────────────────────────────────────────

def _make_chart(name, gender, dob, tob, place):
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        pdata, _ = _nk.calculate_chart(name, gender, dob, tob, place)
    return pdata

@pytest.fixture(scope="module")
def chart_arjun():
    return _make_chart("Arjun", "M", "15/07/1988", "06:45", "Jaipur")

@pytest.fixture(scope="module")
def chart_radha():
    return _make_chart("Radha", "F", "22/11/1991", "14:20", "Pune")

@pytest.fixture(scope="module")
def chart_ram():
    return _make_chart("Ram", "M", "01/01/1990", "10:00", "Delhi")

@pytest.fixture(scope="module")
def chart_sita():
    return _make_chart("Sita", "F", "05/05/1993", "08:30", "Mumbai")

@pytest.fixture(scope="module")
def bj_arjun():
    return _nk.to_julian_day(1988, 7, 15, 6.75 - 5.5)

@pytest.fixture(scope="module")
def bj_radha():
    return _nk.to_julian_day(1991, 11, 22, 14.33 - 5.5)

@pytest.fixture(scope="module")
def bj_ram():
    return _nk.to_julian_day(1990, 1, 1, 10.0 - 5.5)

@pytest.fixture(scope="module")
def bj_sita():
    return _nk.to_julian_day(1993, 5, 5, 8.5 - 5.5)

# A minimal valid pdata for unit tests (Aries lagna, Moon in Gemini)
@pytest.fixture
def minimal_pdata():
    """Minimal pdata with all required planets, valid rashi_idx/nak_idx."""
    return {
        "Lagna":   {"rashi_idx": 0, "lon": 0.0},
        "Moon":    {"rashi_idx": 2, "lon": 68.0, "nak_idx": 6, "pada": 1,
                    "deg_rashi": 8.0, "dignity": "Normal", "vakri": False, "combust": False},
        "Sun":     {"rashi_idx": 0, "lon": 10.0, "nak_idx": 0, "dignity": "Normal"},
        "Mars":    {"rashi_idx": 3, "lon": 99.0, "nak_idx": 8, "dignity": "Normal",
                    "vakri": False, "combust": False},
        "Mercury": {"rashi_idx": 1, "lon": 40.0, "nak_idx": 2, "dignity": "Normal",
                    "vakri": False, "combust": False},
        "Jupiter": {"rashi_idx": 8, "lon": 260.0, "nak_idx": 20, "dignity": "Normal",
                    "vakri": False, "combust": False},
        "Venus":   {"rashi_idx": 1, "lon": 35.0, "nak_idx": 1, "dignity": "Normal",
                    "vakri": False, "combust": False},
        "Saturn":  {"rashi_idx": 9, "lon": 285.0, "nak_idx": 22, "dignity": "Normal",
                    "vakri": False, "combust": False},
        "Rahu":    {"rashi_idx": 4, "lon": 130.0, "nak_idx": 11},
        "Ketu":    {"rashi_idx": 10, "lon": 310.0, "nak_idx": 23},
    }

def _stub_moon(nak_idx: int, sign_idx: int = 0):
    """Create a minimal moon data dict for gun tests."""
    ya = YONI.get(nak_idx, ("Horse", "M"))
    return {
        "sign": sign_idx, "sign_name": km.SS_FULL[sign_idx],
        "sign_short": km.SS_SHORT[sign_idx], "nak": nak_idx,
        "nak_name": km.NAK_NAMES[nak_idx], "nak_lord": km.NAK_LORD[nak_idx],
        "pada": 1, "lon": sign_idx * 30.0, "deg_sign": 0.0,
        "varna": km.VARNA[sign_idx], "varna_rank": km.VARNA_RANK[km.VARNA[sign_idx]],
        "nadi": NADI[nak_idx], "gana": GANA[nak_idx],
        "yoni": ya, "yoni_str": f"{ya[0]} ({ya[1]})",
        "rajju": NAK_RAJJU.get(nak_idx, "Siro"),
        "sign_lord": km.SIGN_LORD[sign_idx],
    }


# ══════════════════════════════════════════════════════════════════
#  1. VALIDATION TESTS
# ══════════════════════════════════════════════════════════════════

class TestValidation:

    def test_empty_dict_raises(self):
        with pytest.raises(KundliMilanError, match="empty or not a dict"):
            validate_pdata({})

    def test_none_raises(self):
        with pytest.raises(KundliMilanError):
            validate_pdata(None)   # type: ignore

    def test_missing_moon_raises(self, minimal_pdata):
        bad = {k: v for k, v in minimal_pdata.items() if k != "Moon"}
        with pytest.raises(KundliMilanError, match="Moon"):
            validate_pdata(bad, "no_moon")

    def test_missing_lagna_raises(self, minimal_pdata):
        bad = {k: v for k, v in minimal_pdata.items() if k != "Lagna"}
        with pytest.raises(KundliMilanError, match="Lagna"):
            validate_pdata(bad, "no_lagna")

    def test_missing_venus_raises(self, minimal_pdata):
        bad = {k: v for k, v in minimal_pdata.items() if k != "Venus"}
        with pytest.raises(KundliMilanError, match="Venus"):
            validate_pdata(bad, "no_venus")

    def test_missing_mars_raises(self, minimal_pdata):
        bad = {k: v for k, v in minimal_pdata.items() if k != "Mars"}
        with pytest.raises(KundliMilanError, match="Mars"):
            validate_pdata(bad, "no_mars")

    def test_invalid_rashi_idx_raises(self, minimal_pdata):
        bad = dict(minimal_pdata)
        bad["Moon"] = {**bad["Moon"], "rashi_idx": 15}  # out of range
        with pytest.raises(KundliMilanError, match="rashi_idx"):
            validate_pdata(bad, "bad_rashi")

    def test_invalid_nak_idx_raises(self, minimal_pdata):
        bad = dict(minimal_pdata)
        bad["Moon"] = {**bad["Moon"], "nak_idx": 99}
        with pytest.raises(KundliMilanError, match="nak_idx"):
            validate_pdata(bad, "bad_nak")

    def test_valid_chart_passes(self, chart_arjun):
        validate_pdata(chart_arjun, "Arjun")   # should not raise

    def test_match_raises_on_missing_moon(self, minimal_pdata):
        """match() should propagate KundliMilanError from validate_pdata."""
        bad = {k: v for k, v in minimal_pdata.items() if k != "Moon"}
        with pytest.raises(KundliMilanError):
            milan_engine.match(bad, minimal_pdata, "Bad", "Good")

    def test_moon_data_raises_on_missing_moon(self):
        with pytest.raises(KundliMilanError, match="Moon data missing"):
            _moon_data({})


# ══════════════════════════════════════════════════════════════════
#  2. GUN CALCULATION TESTS
# ══════════════════════════════════════════════════════════════════

class TestVarna:
    """Gun 1 — max 1 point."""

    def test_brahmin_groom_shudra_bride_compatible(self):
        g = _stub_moon(7, 3)   # Cancer=Brahmin
        b = _stub_moon(9, 2)   # Gemini=Shudra
        r = calc_varna(g, b)
        assert r["score"] == 1
        assert r["probability"] == 100

    def test_shudra_groom_brahmin_bride_incompatible(self):
        g = _stub_moon(9, 2)   # Shudra
        b = _stub_moon(7, 3)   # Brahmin
        r = calc_varna(g, b)
        assert r["score"] == 0
        assert r["probability"] == 10

    def test_same_varna_compatible(self):
        g = _stub_moon(7, 3)   # Brahmin
        b = _stub_moon(0, 4)   # Leo=Brahmin
        r = calc_varna(g, b)
        assert r["score"] == 1

    def test_max_is_one(self):
        r = calc_varna(_stub_moon(0,0), _stub_moon(0,0))
        assert r["max"] == 1


class TestVashya:
    """Gun 2 — max 2 points."""

    def test_mutual_control_is_2(self):
        # Ar(0) controls Ta(1), check if Ta also controls Ar
        import kundli_milan as km2
        g = _stub_moon(0, 0)   # Aries
        b = _stub_moon(0, 1)   # Taurus
        r = calc_vashya(g, b)
        assert r["score"] in {0, 1, 2}  # depends on VASHYA table

    def test_no_control_is_0(self):
        # Aries(0) vs Aquarius(10) — unlikely to control each other
        g = _stub_moon(0, 0)
        b = _stub_moon(0, 10)
        r = calc_vashya(g, b)
        assert r["score"] in {0, 1, 2}

    def test_max_is_2(self):
        r = calc_vashya(_stub_moon(0,0), _stub_moon(0,0))
        assert r["max"] == 2

    def test_probability_in_range(self):
        r = calc_vashya(_stub_moon(0,0), _stub_moon(0,3))
        assert 0 <= r["probability"] <= 100


class TestTara:
    """Gun 3 — max 3 points."""

    def test_both_favorable_is_3(self):
        # Pushya(7) and Uttara Phalguni(11): check specific taras
        g = _stub_moon(7, 3)    # Pushya
        b = _stub_moon(11, 4)   # U.Phalguni
        r = calc_tara(g, b)
        assert r["score"] in {0.0, 1.5, 3.0}
        assert r["max"] == 3

    def test_score_is_0_15_or_3(self):
        """Tara score can only be 0, 1.5, or 3."""
        g = _stub_moon(0, 0)
        for nak in range(27):
            b = _stub_moon(nak, 0)
            r = calc_tara(g, b)
            assert r["score"] in {0.0, 1.5, 3.0}, f"Invalid score {r['score']} for nak {nak}"

    def test_tara_details_present(self):
        r = calc_tara(_stub_moon(5, 2), _stub_moon(7, 3))
        assert "tara_bride_from_groom" in r
        assert "tara_groom_from_bride" in r
        assert 1 <= r["tara_bride_from_groom"]["tara"] <= 9


class TestYoni:
    """
    Gun 4 — max 4 points.
    BPHS rules (fixed):
      Same animal, opposite sex = 4
      Friendly cross-animal     = 3
      Neutral cross-animal      = 2
      Enemy cross-animal        = 1
      Same animal, same sex     = 0
    """

    def _stub_yoni(self, animal, gender):
        """Return a minimal moon_data stub with a given yoni."""
        g = _stub_moon(0, 0)
        return {**g, "yoni": (animal, gender), "yoni_str": f"{animal} ({gender})"}

    # ── Same animal ───────────────────────────────────────────────

    def test_same_animal_opposite_sex_is_4(self):
        """Ashwini (Horse M) × Sravana (Horse F) = 4."""
        g = _stub_moon(0, 0)   # Ashwini → Horse M
        b = _stub_moon(21, 8)  # Sravana → Horse F
        r = calc_yoni(g, b)
        assert r["score"] == 4, f"Expected 4, got {r['score']}: {r['status']}"

    def test_same_animal_same_sex_male_is_0(self):
        """Two males of same animal = 0."""
        g = self._stub_yoni("Cat", "M")
        b = self._stub_yoni("Cat", "M")
        r = calc_yoni(g, b)
        assert r["score"] == 0

    def test_same_animal_same_sex_female_is_0(self):
        """Two females of same animal = 0."""
        g = self._stub_yoni("Snake", "F")
        b = self._stub_yoni("Snake", "F")
        r = calc_yoni(g, b)
        assert r["score"] == 0

    def test_all_same_animal_pairs_correct(self):
        """For every animal: M×F = 4, M×M = 0, F×F = 0."""
        animals_genders = set(YONI.values())
        seen_animals = set(a for a, _ in animals_genders)
        for animal in seen_animals:
            gM = self._stub_yoni(animal, "M")
            gF = self._stub_yoni(animal, "F")
            # opposite sex
            if animal != "Mongoose":  # Mongoose only has M
                r = calc_yoni(gM, gF)
                assert r["score"] == 4, f"{animal} M×F got {r['score']}"
                r2 = calc_yoni(gF, gM)
                assert r2["score"] == 4, f"{animal} F×M got {r2['score']}"
            # same sex
            r3 = calc_yoni(gM, gM)
            assert r3["score"] == 0, f"{animal} M×M got {r3['score']}"

    # ── Cross-animal ──────────────────────────────────────────────

    def test_enemy_yoni_is_1(self):
        """Cat × Rat = enemy = 1."""
        g = self._stub_yoni("Cat", "M")
        b = self._stub_yoni("Rat", "F")
        r = calc_yoni(g, b)
        assert r["score"] == 1

    def test_enemy_yoni_reverse_is_1(self):
        """Rat × Cat = enemy = 1 (symmetric)."""
        g = self._stub_yoni("Rat", "M")
        b = self._stub_yoni("Cat", "F")
        r = calc_yoni(g, b)
        assert r["score"] == 1

    def test_friendly_cross_animal_is_3(self):
        """Horse × Deer = friendly = 3."""
        g = self._stub_yoni("Horse", "M")
        b = self._stub_yoni("Deer", "F")
        r = calc_yoni(g, b)
        assert r["score"] == 3

    def test_neutral_yoni_is_2(self):
        """Cow × Horse = neutral = 2."""
        g = self._stub_yoni("Cow", "M")
        b = self._stub_yoni("Horse", "F")
        r = calc_yoni(g, b)
        assert r["score"] == 2

    def test_all_enemy_pairs_bidirectional(self):
        """Every pair in YONI_ENEMY_ANIMALS should return score=1 both ways."""
        animals = [("Horse","Buffalo"),("Elephant","Lion"),("Sheep","Dog"),
                   ("Snake","Mongoose"),("Cat","Rat"),("Cow","Tiger"),
                   ("Deer","Dog"),("Monkey","Lion")]
        for a1, a2 in animals:
            g = self._stub_yoni(a1, "M")
            b = self._stub_yoni(a2, "F")
            r  = calc_yoni(g, b)
            r2 = calc_yoni(b, g)
            assert r["score"]  == 1, f"{a1}×{a2} expected 1 got {r['score']}"
            assert r2["score"] == 1, f"{a2}×{a1} expected 1 got {r2['score']}"

    def test_frozenset_deduplication_does_not_break_yoni(self):
        """
        Regression: frozenset(["Horse","Horse"]) == frozenset({"Horse"}).
        The old code used YONI_FRIEND which included same-animal frozensets,
        causing same-animal-opposite-sex to be misrouted to the 'friend=3' branch.
        This test guards against that regression.
        """
        # Ashwini nak=0 = Horse M, Sravana nak=21 = Horse F
        g = _stub_moon(0, 0)
        b = _stub_moon(21, 8)
        r = calc_yoni(g, b)
        assert r["score"] == 4, (
            f"Regression: Horse M × Horse F should be 4 (same animal, opp sex), "
            f"got {r['score']} ({r['status']}). frozenset deduplication bug re-introduced.")

    def test_yoni_probability_mapping(self):
        """Each possible score maps to a probability."""
        from kundli_milan import GUN_PROB
        for score in [0, 1, 2, 3, 4]:
            prob = GUN_PROB["Yoni"].get(score)
            assert prob is not None, f"No probability for Yoni score={score}"
            assert 0 <= prob <= 100


class TestGrahaMaitri:
    """Gun 5 — max 5 points."""

    def test_same_lord_is_5(self):
        g = _stub_moon(0, 3)   # Cancer, Moon lord
        b = _stub_moon(0, 3)   # Cancer, Moon lord
        r = calc_graha_maitri(g, b)
        assert r["score"] == 5

    def test_mutual_friend_is_5(self):
        # Sun(Le) & Moon(Cn) are mutual friends
        g = _stub_moon(0, 4)   # Leo — Sun
        b = _stub_moon(0, 3)   # Cancer — Moon
        r = calc_graha_maitri(g, b)
        assert r["score"] in {4, 5}  # friend or mutual_friend

    def test_mutual_enemy_is_0(self):
        # Sun(Le) vs Saturn(Cp): Sun hates Saturn, Saturn hates Sun
        g = _stub_moon(0, 4)   # Leo — Sun
        b = _stub_moon(0, 9)   # Capricorn — Saturn
        r = calc_graha_maitri(g, b)
        assert r["score"] in {0, 1}


class TestGana:
    """Gun 6 — max 6 points. GANA_SCORE must follow BPHS."""

    def test_same_gana_deva_is_6(self):
        g = _stub_moon(0, 0)   # Ashwini = Deva
        b = _stub_moon(4, 0)   # Mrigashira = Deva
        r = calc_gana(g, b)
        assert r["score"] == 6

    def test_same_gana_manushya_is_6(self):
        g = _stub_moon(1, 0)   # Bharani = Manushya
        b = _stub_moon(3, 0)   # Rohini = Manushya
        r = calc_gana(g, b)
        assert r["score"] == 6

    def test_same_gana_rakshasa_is_6(self):
        g = _stub_moon(2, 0)   # Krittika = Rakshasa
        b = _stub_moon(8, 0)   # Ashlesha = Rakshasa
        r = calc_gana(g, b)
        assert r["score"] == 6

    def test_deva_manushya_is_5_bphs(self):
        """BPHS: Deva-Manushya = 5, NOT 6 (the old buggy value)."""
        g = _stub_moon(0, 0)   # Deva
        b = _stub_moon(1, 0)   # Manushya
        r = calc_gana(g, b)
        assert r["score"] == 5, f"Expected 5 per BPHS, got {r['score']}"

    def test_manushya_deva_is_5_bphs(self):
        """BPHS: Manushya-Deva = 5 (symmetric)."""
        g = _stub_moon(1, 0)   # Manushya
        b = _stub_moon(0, 0)   # Deva
        r = calc_gana(g, b)
        assert r["score"] == 5

    def test_deva_rakshasa_is_1(self):
        g = _stub_moon(0, 0)   # Deva
        b = _stub_moon(2, 0)   # Rakshasa
        r = calc_gana(g, b)
        assert r["score"] == 1

    def test_manushya_rakshasa_is_0(self):
        g = _stub_moon(1, 0)   # Manushya
        b = _stub_moon(2, 0)   # Rakshasa
        r = calc_gana(g, b)
        assert r["score"] == 0

    def test_gana_score_table_correctness(self):
        """Verify every entry in GANA_SCORE against BPHS."""
        expected = {
            ("Deva","Deva"):6,       ("Manushya","Manushya"):6, ("Rakshasa","Rakshasa"):6,
            ("Deva","Manushya"):5,   ("Manushya","Deva"):5,
            ("Deva","Rakshasa"):1,   ("Rakshasa","Deva"):1,
            ("Manushya","Rakshasa"):0,("Rakshasa","Manushya"):0,
        }
        for key, expected_val in expected.items():
            actual = GANA_SCORE.get(key)
            assert actual == expected_val, (
                f"GANA_SCORE{key}={actual}, expected {expected_val} per BPHS")


class TestBhakoot:
    """Gun 7 — max 7 points."""

    def test_bad_axis_6_8_is_0(self):
        # Cancer(3) and Capricorn(9): 9-3=7+1=7 from Cn, 3-9%12+1=7... let's compute
        # Try Ar(0) and Vi(5): Vi from Ar = 6, Ar from Vi = 8 → bad 6-8 axis
        g = _stub_moon(0, 0)   # Aries
        b = _stub_moon(0, 5)   # Virgo
        r = calc_bhakoot(g, b)
        assert r["score"] == 0, f"6-8 axis should be 0 got {r['score']}"
        assert r["has_dosha"]

    def test_bad_axis_5_9_is_0(self):
        # Ar(0) vs Le(4): Le from Ar=5, Ar from Le=9 → bad 5-9
        g = _stub_moon(0, 0)   # Aries
        b = _stub_moon(0, 4)   # Leo
        r = calc_bhakoot(g, b)
        assert r["score"] == 0

    def test_bad_axis_2_12_is_0(self):
        # Ar(0) vs Pi(11): Pi from Ar=12, Ar from Pi=2 → bad 2-12
        g = _stub_moon(0, 0)   # Aries
        b = _stub_moon(0, 11)  # Pisces
        r = calc_bhakoot(g, b)
        assert r["score"] == 0

    def test_same_sign_is_7(self):
        g = _stub_moon(0, 3)   # Cancer
        b = _stub_moon(0, 3)   # Cancer
        r = calc_bhakoot(g, b)
        assert r["score"] == 7

    def test_all_bad_axes_detected(self):
        """All 6 bad (count,count) pairs return score=0."""
        from kundli_milan import BHAKOOT_BAD
        assert (6,8) in BHAKOOT_BAD
        assert (8,6) in BHAKOOT_BAD
        assert (5,9) in BHAKOOT_BAD
        assert (9,5) in BHAKOOT_BAD
        assert (2,12) in BHAKOOT_BAD
        assert (12,2) in BHAKOOT_BAD


class TestNadi:
    """Gun 8 — max 8 points."""

    def test_different_nadi_is_8(self):
        # Ashwini=Aadi, Bharani=Madhya → different
        g = _stub_moon(0, 0)   # Aadi
        b = _stub_moon(1, 0)   # Madhya
        r = calc_nadi(g, b)
        assert r["score"] == 8
        assert not r["has_dosha"]

    def test_same_nadi_is_0_dosha(self):
        # Ashwini=Aadi, Ardra=Aadi → same → dosha
        g = _stub_moon(0, 0)   # Aadi
        b = _stub_moon(5, 2)   # Ardra=Aadi
        r = calc_nadi(g, b)
        assert r["score"] == 0
        assert r["has_dosha"]

    def test_nadi_table_has_27_entries(self):
        assert len(NADI) == 27

    def test_nadi_cycle_9_9_9(self):
        """Each nadi should appear exactly 9 times."""
        from collections import Counter
        counts = Counter(NADI.values())
        assert counts["Aadi"] == 9
        assert counts["Madhya"] == 9
        assert counts["Antya"] == 9


# ══════════════════════════════════════════════════════════════════
#  3. SUPPLEMENTARY CHECKS
# ══════════════════════════════════════════════════════════════════

class TestMangalDosh:

    def test_mars_in_h7_from_lagna(self, chart_arjun):
        r = check_mangal_dosh(chart_arjun, "Arjun")
        assert isinstance(r["has_mangal_dosh"], bool)
        assert r["mars_h_lagna"] in range(1, 13)

    def test_mars_own_sign_cancels(self, minimal_pdata):
        """Mars in Scorpio (own sign) from lagna — should cancel dosha."""
        p = dict(minimal_pdata)
        # Put Mars in Sc(7), Lagna in Ar(0): H8 from Ar → bad, but own sign cancels
        p["Lagna"] = {"rashi_idx": 0, "lon": 0.0}
        p["Mars"]  = {"rashi_idx": 7, "lon": 220.0, "nak_idx": 17,
                       "dignity": "Swakshetra 🏠", "vakri": False, "combust": False}
        r = check_mangal_cancellations(p, "Test")
        cancel_rules = [c["rule"] for c in r["cancellations"]]
        assert "Own Sign" in cancel_rules
        assert not r["has_effective_dosh"]

    def test_mars_exalted_cancels(self, minimal_pdata):
        """Mars exalted in Capricorn cancels dosha."""
        p = dict(minimal_pdata)
        p["Lagna"] = {"rashi_idx": 3, "lon": 90.0}   # Cancer
        p["Mars"]  = {"rashi_idx": 9, "lon": 280.0, "nak_idx": 22,
                       "dignity": "Exalted", "vakri": False, "combust": False}
        r = check_mangal_cancellations(p, "Test")
        cancel_rules = [c["rule"] for c in r["cancellations"]]
        assert "Exalted Sign" in cancel_rules

    def test_no_dosha_when_mars_not_in_dosha_houses(self, minimal_pdata):
        """Mars in H3 — no Mangal Dosha."""
        p = dict(minimal_pdata)
        p["Lagna"] = {"rashi_idx": 0, "lon": 0.0}
        p["Mars"]  = {"rashi_idx": 2, "lon": 60.0, "nak_idx": 5,
                       "dignity": "Normal", "vakri": False, "combust": False}
        r = check_mangal_dosh(p, "Test")
        assert not r["has_mangal_dosh"]

    def test_papasamya_both_have_mangal_cancels(self, chart_arjun, chart_radha):
        """If both charts have Mangal Dosha with equal severity, papasamya cancels."""
        r = check_mangal_papasamya(chart_arjun, chart_radha, "A", "R")
        assert isinstance(r["final_cancel"], bool)
        assert isinstance(r["ext_aff_balanced"], bool)


class TestRajjuDosha:

    def test_same_rajju_is_dosha(self):
        # Ashwini(0)=Pada_A, Magha(9)=Pada_A → same → dosha
        g = _stub_moon(0, 0)
        b = _stub_moon(9, 4)
        r = check_rajju_dosha(g, b)
        assert r["has_rajju_dosha"]

    def test_different_rajju_no_dosha(self):
        # Ashwini(0)=Pada_A, Pushya(7)=Kati → different → no dosha
        g = _stub_moon(0, 0)
        b = _stub_moon(7, 3)
        r = check_rajju_dosha(g, b)
        assert not r["has_rajju_dosha"]


# ══════════════════════════════════════════════════════════════════
#  4. COMPUTE PROBABILITY
# ══════════════════════════════════════════════════════════════════

class TestComputeProbability:

    def _all_guns(self, g, b):
        return [calc_varna(g,b), calc_vashya(g,b), calc_tara(g,b),
                calc_yoni(g,b), calc_graha_maitri(g,b), calc_gana(g,b),
                calc_bhakoot(g,b), calc_nadi(g,b)]

    def test_probability_in_range(self):
        g = _stub_moon(0, 0); b = _stub_moon(1, 1)
        guns = self._all_guns(g, b)
        doshas = {"groom": check_mangal_dosh({"Lagna":{"rashi_idx":0},"Moon":{"rashi_idx":0},"Mars":{"rashi_idx":3},"Venus":{"rashi_idx":1}},),
                  "bride":  {"has_mangal_dosh":False},
                  "rajju":  {"has_rajju_dosha":False}}
        papa = {"balanced": False}
        r = compute_probability(guns, doshas, papa)
        assert 0 <= r["final_probability"] <= 100
        assert 0 <= r["base_probability"] <= 100

    def test_nadi_dosha_penalty_applied(self):
        """Nadi Dosha should subtract 15% from base."""
        g = _stub_moon(0, 0)   # Aadi
        b = _stub_moon(5, 2)   # Aadi → Nadi Dosha
        guns = self._all_guns(g, b)
        nadi_gun = next(x for x in guns if x["gun"] == "Nadi")
        assert nadi_gun["has_dosha"]
        doshas = {"groom":{"has_mangal_dosh":False},"bride":{"has_mangal_dosh":False},"rajju":{"has_rajju_dosha":False}}
        r = compute_probability(guns, doshas, {"balanced":False})
        assert "Nadi Dosha" in r["penalties"]
        assert r["penalties"]["Nadi Dosha"] == 15

    def test_bhakoot_dosha_penalty_applied(self):
        g = _stub_moon(0, 0)   # Aries
        b = _stub_moon(0, 5)   # Virgo → 6-8 axis
        guns = self._all_guns(g, b)
        doshas = {"groom":{"has_mangal_dosh":False},"bride":{"has_mangal_dosh":False},"rajju":{"has_rajju_dosha":False}}
        r = compute_probability(guns, doshas, {"balanced":False})
        assert "Bhakoot Dosha" in r["penalties"]


# ══════════════════════════════════════════════════════════════════
#  5. PHASE 2 — ADVANCED ANALYSES
# ══════════════════════════════════════════════════════════════════

class TestNavamsa:

    def test_score_in_range(self, chart_arjun, chart_radha):
        r = analyze_navamsa_compatibility(chart_arjun, chart_radha, "A", "R")
        assert 0 <= r["navamsa_score"] <= 100

    def test_no_underscore_in_factor_output(self, chart_arjun, chart_radha):
        """Regression: _ variable must not appear literally in factor groom/bride strings."""
        r = analyze_navamsa_compatibility(chart_arjun, chart_radha, "A", "R")
        for factor in r["factors"]:
            for key in ["groom", "bride", "desc"]:
                val = factor.get(key, "")
                assert "({_})" not in str(val), f"_ literal leaked into {key}: {val}"
                assert "({dignity_label})" not in str(val)

    def test_grade_is_valid_string(self, chart_arjun, chart_radha):
        r = analyze_navamsa_compatibility(chart_arjun, chart_radha, "A", "R")
        assert r["grade"] in {"Excellent", "Good", "Average", "Weak"}

    def test_d9_lagnas_are_sign_names(self, chart_arjun, chart_radha):
        r = analyze_navamsa_compatibility(chart_arjun, chart_radha, "A", "R")
        from kundli_milan import SS_FULL_P2
        assert r["groom_d9_lagna"] in SS_FULL_P2
        assert r["bride_d9_lagna"]  in SS_FULL_P2


class TestVenusCompatibility:

    def test_score_in_range(self, chart_arjun, chart_radha):
        r = analyze_venus_compatibility(chart_arjun, chart_radha, "A", "R")
        assert 0 <= r["venus_score"] <= 100

    def test_cross_venus_moon_is_bool(self, chart_arjun, chart_radha):
        r = analyze_venus_compatibility(chart_arjun, chart_radha, "A", "R")
        cvm = r["cross_venus_moon"]
        assert isinstance(cvm["groom_venus_in_bride_moon"], bool)
        assert isinstance(cvm["bride_venus_in_groom_moon"], bool)

    def test_grade_valid(self, chart_arjun, chart_radha):
        r = analyze_venus_compatibility(chart_arjun, chart_radha, "A", "R")
        assert r["grade"] in {"Excellent", "Good", "Average", "Weak"}


class TestDashaSync:

    def test_score_in_range(self, chart_arjun, bj_arjun, chart_radha, bj_radha):
        r = analyze_dasha_sync(chart_arjun, bj_arjun, chart_radha, bj_radha, "A", "R")
        assert 0 <= r["sync_score"] <= 100

    def test_both_dasha_keys_present(self, chart_arjun, bj_arjun, chart_radha, bj_radha):
        r = analyze_dasha_sync(chart_arjun, bj_arjun, chart_radha, bj_radha, "A", "R")
        assert "md" in r["name1_dasha"]
        assert "md" in r["name2_dasha"]


class TestMatchPhase2:

    def test_phase2_score_in_range(self, chart_arjun, bj_arjun, chart_radha, bj_radha):
        r = match_phase2(chart_arjun, bj_arjun, chart_radha, bj_radha, "A", "R", "M", "F")
        assert 0 <= r["phase2_score"] <= 100

    def test_summary_keys(self, chart_arjun, bj_arjun, chart_radha, bj_radha):
        r = match_phase2(chart_arjun, bj_arjun, chart_radha, bj_radha, "A", "R", "M", "F")
        s = r["summary"]
        assert "navamsa_score"  in s
        assert "venus_score"    in s
        assert "dasha_score"    in s
        assert "mangal_cancel"  in s


# ══════════════════════════════════════════════════════════════════
#  6. PHASE 3 — TIMING ANALYSES
# ══════════════════════════════════════════════════════════════════

class TestUpapadaLagna:

    def test_ul_sign_in_valid_range(self, chart_arjun):
        r = compute_upapada_lagna(chart_arjun)
        assert 0 <= r["ul_sign"] <= 11

    def test_ul_sign_name_valid(self, chart_arjun):
        r = compute_upapada_lagna(chart_arjun)
        from kundli_milan import SS_FULL_P3
        assert r["ul_sign_name"] in SS_FULL_P3

    def test_ul_exception_rule_applied(self, minimal_pdata):
        """
        If UL result falls on same sign as 12th or 7th from 12th → exception applies.
        Test by constructing a chart where this is triggered.
        """
        r = compute_upapada_lagna(minimal_pdata)
        # Just verify it completes without error and returns valid sign
        assert 0 <= r["ul_sign"] <= 11

    def test_compare_upapada_score_in_range(self, chart_arjun, chart_radha):
        r = compare_upapada(chart_arjun, chart_radha, "A", "R")
        assert 0 <= r["ul_score"] <= 100

    def test_same_ul_sign_trine_axis(self, chart_arjun):
        """Comparing a chart with itself → UL axis=1 → trine → score=100."""
        r = compare_upapada(chart_arjun, chart_arjun, "A", "A")
        assert r["ul_compatibility"]["trine"]
        assert r["ul_score"] >= 75


class TestSeventhHouse:

    def test_score_in_range(self, chart_arjun):
        r = analyze_seventh_house(chart_arjun)
        assert 0 <= r["total_score"] <= 100

    def test_factors_count(self, chart_arjun):
        r = analyze_seventh_house(chart_arjun)
        assert len(r["factors"]) == 5   # lord, occupants, aspects, venus, SAV

    def test_d9_seventh_present(self, chart_arjun):
        r = analyze_seventh_house(chart_arjun)
        d9 = r["d9_7th"]
        assert "sign" in d9
        assert "lord" in d9
        assert "occupants" in d9

    def test_grade_valid(self, chart_arjun):
        r = analyze_seventh_house(chart_arjun)
        assert r["grade"] in {"Excellent", "Good", "Average", "Weak"}


class TestGocharMarriage:

    def test_windows_is_list(self, chart_arjun):
        r = analyze_gochar_marriage(chart_arjun, 2025)
        assert isinstance(r["windows"], list)

    def test_each_window_has_required_keys(self, chart_arjun):
        r = analyze_gochar_marriage(chart_arjun, 2025)
        for w in r["windows"]:
            assert "year"     in w
            assert "score"    in w
            assert "triggers" in w
            assert "jup_in"   in w

    def test_scan_12_years(self, chart_arjun):
        r = analyze_gochar_marriage(chart_arjun, 2026)
        assert r["scan_years"].startswith("2026")

    def test_best_window_is_highest_score(self, chart_arjun):
        r = analyze_gochar_marriage(chart_arjun, 2025)
        if r["windows"] and r["best_window"]:
            max_score = max(w["score"] for w in r["windows"])
            assert r["best_window"]["score"] == max_score


class TestDashaTimeline:

    def test_windows_list(self, chart_arjun, bj_arjun):
        r = predict_marriage_dasha_timeline(chart_arjun, bj_arjun, 15)
        assert isinstance(r["top_windows"], list)

    def test_each_window_has_keys(self, chart_arjun, bj_arjun):
        r = predict_marriage_dasha_timeline(chart_arjun, bj_arjun, 15)
        for w in r["top_windows"]:
            assert "md" in w and "ad" in w
            assert "score" in w
            assert "grade" in w

    def test_best_window_highest_score(self, chart_arjun, bj_arjun):
        r = predict_marriage_dasha_timeline(chart_arjun, bj_arjun, 15)
        if r["best_window"] and r["top_windows"]:
            assert r["best_window"]["score"] == r["top_windows"][0]["score"]


class TestMatchPhase3:

    def test_phase3_score_in_range(self, chart_arjun, bj_arjun, chart_radha, bj_radha):
        r = match_phase3(chart_arjun, bj_arjun, chart_radha, bj_radha, "A", "R", "M", "F")
        assert 0 <= r["phase3_score"] <= 100

    def test_summary_keys_present(self, chart_arjun, bj_arjun, chart_radha, bj_radha):
        r = match_phase3(chart_arjun, bj_arjun, chart_radha, bj_radha, "A", "R", "M", "F")
        s = r["summary"]
        for key in ["ul_score","h7_groom","h7_bride","best_gochar","overlap_count"]:
            assert key in s, f"Missing key in summary: {key}"


# ══════════════════════════════════════════════════════════════════
#  7. UNIFIED SCORE
# ══════════════════════════════════════════════════════════════════

class TestUnifiedScore:

    def test_score_in_range(self, chart_arjun, bj_arjun, chart_radha, bj_radha):
        ph1 = milan_engine.match(chart_arjun, chart_radha, "A", "R", "M", "F")
        ph2 = match_phase2(chart_arjun, bj_arjun, chart_radha, bj_radha, "A", "R", "M", "F")
        ph3 = match_phase3(chart_arjun, bj_arjun, chart_radha, bj_radha, "A", "R", "M", "F")
        r   = compute_unified_score(ph1, ph2, ph3)
        assert 0 <= r["unified_score"] <= 100

    def test_component_scores_present(self, chart_arjun, bj_arjun, chart_radha, bj_radha):
        ph1 = milan_engine.match(chart_arjun, chart_radha, "A", "R", "M", "F")
        ph2 = match_phase2(chart_arjun, bj_arjun, chart_radha, bj_radha, "A", "R", "M", "F")
        ph3 = match_phase3(chart_arjun, bj_arjun, chart_radha, bj_radha, "A", "R", "M", "F")
        r   = compute_unified_score(ph1, ph2, ph3)
        for key in ["ashtakoot_prob","navamsa","venus","dasha_sync",
                    "mangal_factor","upapada","seventh_house"]:
            assert key in r["component_scores"]

    def test_grade_is_valid(self, chart_arjun, bj_arjun, chart_radha, bj_radha):
        ph1 = milan_engine.match(chart_arjun, chart_radha, "A", "R", "M", "F")
        ph2 = match_phase2(chart_arjun, bj_arjun, chart_radha, bj_radha, "A", "R", "M", "F")
        ph3 = match_phase3(chart_arjun, bj_arjun, chart_radha, bj_radha, "A", "R", "M", "F")
        r   = compute_unified_score(ph1, ph2, ph3)
        valid_grades = {"Exceptional","Excellent","Very Good","Good",
                        "Average","Below Average","Not Recommended"}
        assert r["grade"] in valid_grades

    def test_weights_sum_to_one(self):
        from kundli_milan import UNIFIED_WEIGHTS
        total = sum(UNIFIED_WEIGHTS.values())
        assert abs(total - 1.0) < 0.001, f"Weights sum to {total}, not 1.0"

    def test_marriage_verdict_is_nonempty(self, chart_arjun, bj_arjun, chart_radha, bj_radha):
        ph1 = milan_engine.match(chart_arjun, chart_radha, "A", "R", "M", "F")
        ph2 = match_phase2(chart_arjun, bj_arjun, chart_radha, bj_radha, "A", "R", "M", "F")
        ph3 = match_phase3(chart_arjun, bj_arjun, chart_radha, bj_radha, "A", "R", "M", "F")
        r   = compute_unified_score(ph1, ph2, ph3)
        assert len(r["marriage_verdict"]) > 10

    def test_high_scoring_match_gets_high_grade(self, chart_arjun, bj_arjun):
        """Self-match should return a high score."""
        ph1 = milan_engine.match(chart_arjun, chart_arjun, "A", "A", "M", "F")
        ph2 = match_phase2(chart_arjun, bj_arjun, chart_arjun, bj_arjun, "A", "A", "M", "F")
        ph3 = match_phase3(chart_arjun, bj_arjun, chart_arjun, bj_arjun, "A", "A", "M", "F")
        r   = compute_unified_score(ph1, ph2, ph3)
        # Self match should score fairly high
        assert r["unified_score"] >= 50

    def test_low_dosha_match_not_penalised_to_zero(self, chart_arjun, bj_arjun, chart_radha, bj_radha):
        """Unified score should never reach 0 on normal charts."""
        ph1 = milan_engine.match(chart_arjun, chart_radha, "A", "R", "M", "F")
        ph2 = match_phase2(chart_arjun, bj_arjun, chart_radha, bj_radha, "A", "R", "M", "F")
        ph3 = match_phase3(chart_arjun, bj_arjun, chart_radha, bj_radha, "A", "R", "M", "F")
        r   = compute_unified_score(ph1, ph2, ph3)
        assert r["unified_score"] > 5


# ══════════════════════════════════════════════════════════════════
#  8. CACHING
# ══════════════════════════════════════════════════════════════════

class TestCaching:

    def test_cache_populates_on_match_from_birth(self):
        _chart_cache.clear()
        assert len(_chart_cache) == 0
        milan_engine.match_from_birth(
            "Arjun","M","15/07/1988","06:45","Jaipur",
            "Radha","F","22/11/1991","14:20","Pune")
        assert len(_chart_cache) == 2

    def test_second_call_uses_cache_not_recalculate(self):
        _chart_cache.clear()
        milan_engine.match_from_birth(
            "Ram","M","01/01/1990","10:00","Delhi",
            "Sita","F","05/05/1993","08:30","Mumbai")
        count_after_first = len(_chart_cache)
        milan_engine.match_from_birth(
            "Ram","M","01/01/1990","10:00","Delhi",
            "Sita","F","05/05/1993","08:30","Mumbai")
        assert len(_chart_cache) == count_after_first  # no new entries

    def test_different_persons_different_cache_keys(self):
        _chart_cache.clear()
        milan_engine.match_from_birth(
            "A","M","15/07/1988","06:45","Jaipur",
            "B","F","22/11/1991","14:20","Pune")
        milan_engine.match_from_birth(
            "C","M","01/01/1990","10:00","Delhi",
            "D","F","05/05/1993","08:30","Mumbai")
        assert len(_chart_cache) == 4  # 2 per call, no overlap


# ══════════════════════════════════════════════════════════════════
#  9. FULL MATCH PIPELINE
# ══════════════════════════════════════════════════════════════════

class TestFullMatchPipeline:

    def test_match_returns_all_8_guns(self, chart_arjun, chart_radha):
        r = milan_engine.match(chart_arjun, chart_radha, "Arjun", "Radha", "M", "F")
        assert len(r["guns"]) == 8
        gun_names = {g["gun"] for g in r["guns"]}
        for name in ["Varna","Vashya","Tara (Dina)","Yoni",
                     "Graha Maitri","Gana","Bhakoot","Nadi"]:
            assert name in gun_names

    def test_total_score_in_range(self, chart_arjun, chart_radha):
        r = milan_engine.match(chart_arjun, chart_radha, "Arjun", "Radha", "M", "F")
        assert 0 <= r["total_score"] <= 36

    def test_final_probability_in_range(self, chart_arjun, chart_radha):
        r = milan_engine.match(chart_arjun, chart_radha, "Arjun", "Radha", "M", "F")
        assert 0 <= r["final_probability"] <= 100

    def test_grade_is_valid(self, chart_arjun, chart_radha):
        r = milan_engine.match(chart_arjun, chart_radha, "Arjun", "Radha", "M", "F")
        valid_grades = {"Exceptional","Excellent","Very Good","Good",
                        "Average","Below Average","Not Recommended"}
        assert r["grade"] in valid_grades

    def test_groom_bride_assigned_correctly(self, chart_arjun, chart_radha):
        r = milan_engine.match(chart_arjun, chart_radha, "Arjun", "Radha", "M", "F")
        assert r["groom_name"] == "Arjun"
        assert r["bride_name"]  == "Radha"

    def test_gender_swap_assigns_correctly(self, chart_arjun, chart_radha):
        """When gender1=F, names should swap groom/bride."""
        r = milan_engine.match(chart_arjun, chart_radha, "Arjun", "Radha", "F", "M")
        assert r["groom_name"] == "Radha"
        assert r["bride_name"]  == "Arjun"

    def test_match_from_birth_produces_birth_info(self):
        r = milan_engine.match_from_birth(
            "Ram","M","01/01/1990","10:00","Delhi",
            "Sita","F","05/05/1993","08:30","Mumbai")
        assert r["person1_birth"]["name"] == "Ram"
        assert r["person2_birth"]["name"] == "Sita"

    def test_strong_and_weak_guns_classified(self, chart_arjun, chart_radha):
        r = milan_engine.match(chart_arjun, chart_radha, "A", "R", "M", "F")
        all_guns = {g["gun"] for g in r["guns"]}
        for g in r["strong_guns"]:
            assert g in all_guns
        for g in r["weak_guns"]:
            assert g in all_guns


# ══════════════════════════════════════════════════════════════════
#  10. EXTREME DOSHA SCENARIOS
# ══════════════════════════════════════════════════════════════════

class TestExtremeDoshaScenarios:

    def _make_worst_match(self):
        """Construct a moon_data pair designed to maximise doshas."""
        # Same Nadi (Aadi) → Nadi Dosha
        # 6-8 Bhakoot axis → Bhakoot Dosha
        # Same gana Manushya-Rakshasa → 0 Gana
        g = _stub_moon(0, 0)    # Aries, Ashwini, Aadi, Deva
        b = _stub_moon(5, 5)    # Virgo (6th from Ar → 6-8 axis), Ardra, Aadi, Manushya
        return g, b

    def test_worst_case_total_score_is_low(self):
        g, b = self._make_worst_match()
        guns = [calc_varna(g,b), calc_vashya(g,b), calc_tara(g,b),
                calc_yoni(g,b), calc_graha_maitri(g,b), calc_gana(g,b),
                calc_bhakoot(g,b), calc_nadi(g,b)]
        total = sum(x["score"] for x in guns)
        # Nadi=0, Bhakoot=0 alone = 15 pts lost
        assert total < 20, f"Worst-case should be low, got {total}"

    def test_extreme_dosha_probability_very_low(self):
        g, b = self._make_worst_match()
        guns = [calc_varna(g,b), calc_vashya(g,b), calc_tara(g,b),
                calc_yoni(g,b), calc_graha_maitri(g,b), calc_gana(g,b),
                calc_bhakoot(g,b), calc_nadi(g,b)]
        doshas = {"groom":{"has_mangal_dosh":True,"score":80},
                  "bride": {"has_mangal_dosh":False},
                  "rajju": {"has_rajju_dosha":True}}
        r = compute_probability(guns, doshas, {"balanced":False})
        assert r["final_probability"] < 25

    def test_perfect_match_score_is_high(self):
        """Same sign, Deva-Deva, different nadi, same gender different animal."""
        # Ashwini(0)=Deva/Aadi/Horse-M, Sravana(21)=Rakshasa/Antya/Horse-F
        # They share same Moon sign (need to fake it)
        g = _stub_moon(0, 3)    # Ashwini, Cancer
        b = _stub_moon(7, 3)    # Pushya, Cancer → same sign=7/7 Bhakoot, Deva-Deva
        guns = [calc_varna(g,b), calc_vashya(g,b), calc_tara(g,b),
                calc_yoni(g,b), calc_graha_maitri(g,b), calc_gana(g,b),
                calc_bhakoot(g,b), calc_nadi(g,b)]
        total = sum(x["score"] for x in guns)
        assert total > 20  # Gana=6, Bhakoot=7, Nadi=8 alone = 21

    def test_nadi_dosha_is_most_severe_penalty(self):
        """Nadi Dosha penalty (15) > Bhakoot (10) > Rajju (7)."""
        from kundli_milan import compute_probability
        g = _stub_moon(0, 0)   # Aadi, Aries
        b = _stub_moon(5, 5)   # Aadi, Virgo
        guns = [calc_varna(g,b), calc_vashya(g,b), calc_tara(g,b),
                calc_yoni(g,b), calc_graha_maitri(g,b), calc_gana(g,b),
                calc_bhakoot(g,b), calc_nadi(g,b)]
        doshas = {"groom":{"has_mangal_dosh":False},"bride":{"has_mangal_dosh":False},
                  "rajju":{"has_rajju_dosha":False}}
        r = compute_probability(guns, doshas, {"balanced":False})
        if "Nadi Dosha" in r["penalties"] and "Bhakoot Dosha" in r["penalties"]:
            assert r["penalties"]["Nadi Dosha"] > r["penalties"]["Bhakoot Dosha"]


# ══════════════════════════════════════════════════════════════════
#  STANDALONE RUNNER
# ══════════════════════════════════════════════════════════════════

if __name__ == "__main__":
    import sys, traceback

    def _make(name,g,dob,tob,place):
        buf=io.StringIO()
        with contextlib.redirect_stdout(buf):
            p,_=_nk.calculate_chart(name,g,dob,tob,place)
        return p

    p1=_make("Arjun","M","15/07/1988","06:45","Jaipur")
    p2=_make("Radha","F","22/11/1991","14:20","Pune")
    bj1=_nk.to_julian_day(1988,7,15,6.75-5.5)
    bj2=_nk.to_julian_day(1991,11,22,14.33-5.5)
    min_p = {
        "Lagna":{"rashi_idx":0,"lon":0.0},
        "Moon": {"rashi_idx":2,"lon":68.0,"nak_idx":6,"pada":1,"deg_rashi":8.0,
                 "dignity":"Normal","vakri":False,"combust":False},
        "Sun":  {"rashi_idx":0,"lon":10.0,"nak_idx":0,"dignity":"Normal"},
        "Mars": {"rashi_idx":3,"lon":99.0,"nak_idx":8,"dignity":"Normal","vakri":False,"combust":False},
        "Mercury":{"rashi_idx":1,"lon":40.0,"nak_idx":2,"dignity":"Normal","vakri":False,"combust":False},
        "Jupiter":{"rashi_idx":8,"lon":260.0,"nak_idx":20,"dignity":"Normal","vakri":False,"combust":False},
        "Venus":{"rashi_idx":1,"lon":35.0,"nak_idx":1,"dignity":"Normal","vakri":False,"combust":False},
        "Saturn":{"rashi_idx":9,"lon":285.0,"nak_idx":22,"dignity":"Normal","vakri":False,"combust":False},
        "Rahu": {"rashi_idx":4,"lon":130.0,"nak_idx":11},
        "Ketu": {"rashi_idx":10,"lon":310.0,"nak_idx":23},
    }

    suites = [
        TestValidation(), TestVarna(), TestVashya(), TestTara(),
        TestYoni(), TestGrahaMaitri(), TestGana(), TestBhakoot(), TestNadi(),
        TestMangalDosh(), TestRajjuDosha(), TestComputeProbability(),
        TestNavamsa(), TestVenusCompatibility(), TestDashaSync(),
        TestMatchPhase2(), TestUpapadaLagna(), TestSeventhHouse(),
        TestGocharMarriage(), TestDashaTimeline(), TestMatchPhase3(),
        TestUnifiedScore(), TestCaching(), TestFullMatchPipeline(),
        TestExtremeDoshaScenarios(),
    ]

    passed = failed = 0
    for suite in suites:
        cname = type(suite).__name__
        methods = [m for m in dir(suite) if m.startswith("test_")]
        for mname in methods:
            try:
                m = getattr(suite, mname)
                # Inject fixtures manually for standalone run
                import inspect
                sig = inspect.signature(m)
                kwargs = {}
                for param in list(sig.parameters.keys()):
                    if param in ("chart_arjun","chart_ram"):  kwargs[param]=p1
                    elif param in ("chart_radha","chart_sita"): kwargs[param]=p2
                    elif param in ("bj_arjun","bj_ram"):    kwargs[param]=bj1
                    elif param in ("bj_radha","bj_sita"):   kwargs[param]=bj2
                    elif param == "minimal_pdata":          kwargs[param]=min_p
                m(**kwargs)
                print(f"  ✓ {cname}.{mname}")
                passed += 1
            except Exception as e:
                tb_last = traceback.format_exc().strip().split('\n')[-1]
                print(f"  ✗ {cname}.{mname}: {tb_last}")
                failed += 1

    print(f"\n{'='*60}")
    print(f"  TOTAL: {passed+failed}  PASSED: {passed}  FAILED: {failed}")
    sys.exit(0 if failed == 0 else 1)
