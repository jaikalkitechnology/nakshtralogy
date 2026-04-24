"""
Career Specialist Module
========================
Exposes CareerSpecialistEngine from all_engine/career_specialist_engine/.

Usage:
    from app.career import career_engine
    result = career_engine.analyze(pdata, birth_jd, name)
"""

from all_engine.career_specialist_engine.career_specialist import (
    CareerSpecialistEngine,
)

career_engine = CareerSpecialistEngine()

__all__ = ["career_engine", "CareerSpecialistEngine"]
