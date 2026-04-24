"""
Character Analysis Module
=========================
Usage:
    from app.character import character_engine
    result = character_engine.analyze(pdata, birth_jd, name)
"""

from all_engine.character_analysis_engine.character_analysis import (
    CharacterEngine,
)

character_engine = CharacterEngine()

__all__ = ["character_engine", "CharacterEngine"]
