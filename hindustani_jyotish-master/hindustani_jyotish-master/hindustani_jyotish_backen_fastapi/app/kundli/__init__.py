"""
Kundli (Vedic Birth Chart) Module
==================================
Based on nakshtralogy_v2 (265KB engine) with NakshtraEngine wrapper from
nakshatralogy_helper.

Contents:
  - engine.py: Core calculation engine (pyswisseph + VSOP87 fallback)
  - helper.py: NakshtraEngine class with all 14 analysis methods
    (chart, vimshottari, moola, gochar, dosh, yoga, shadbala,
     ashtakavarga, aspects, life-areas, bhava, dasha-activation,
     chakra-health, full-analysis)

Usage:
  from app.kundli import engine as astro_engine
  chart  = astro_engine.get_chart(name, gender, dob, tob, place)
  doshas = astro_engine.get_dosh_analysis(chart["_pdata"])
"""

from . import engine as _engine_module   # the V2 engine
from . import helper

# Re-export the singleton NakshtraEngine instance
engine = helper.engine
NakshtraEngine = helper.NakshtraEngine

__all__ = ["engine", "NakshtraEngine", "helper"]
