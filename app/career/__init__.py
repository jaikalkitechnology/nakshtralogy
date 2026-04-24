"""
Career Specialist Module
========================
Wraps all_engine/career_specialist_engine/career_specialist.py so it can
import nakshtralogy_v2 from app.kundli.engine.

Usage:
    from app.career import career_engine
    result = career_engine.analyze(pdata, birth_jd, name)
"""

import sys
from app.kundli import engine as _kundli_engine

# career_specialist.py does `import nakshtralogy_v2 as _nk`.
# Make that resolve to our already-loaded kundli engine module.
sys.modules.setdefault("nakshtralogy_v2", _kundli_engine)

from all_engine.career_specialist_engine.career_specialist import (
    CareerSpecialistEngine,
)

career_engine = CareerSpecialistEngine()

__all__ = ["career_engine", "CareerSpecialistEngine"]
