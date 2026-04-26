"""
AI Config Cache — loads languages, domains, engines from DB at startup.
Falls back to hardcoded defaults if DB is empty.

Usage:
    from app.ai_config import ai_cache
    ai_cache.get_language("hindi")        → {"code":"hindi","llm_instruction":"..."}
    ai_cache.get_domain("career_job")     → full domain config dict
    ai_cache.get_all_languages()          → [...]
    ai_cache.build_system_prompt(...)     → string (replaces hardcoded DOMAIN_SPECIALISTS)
"""

import logging
from typing import Dict, List, Optional

logger = logging.getLogger("ai_config")


class AiConfigCache:
    def __init__(self):
        self._languages: Dict[str, dict] = {}
        self._domains: Dict[str, dict] = {}
        self._engines: Dict[str, dict] = {}
        self._loaded = False

    def load_from_db(self):
        from app.core.database import SessionLocal
        from app.models.model import AiLanguage, AiDomainConfig, AiEngine
        db = SessionLocal()
        try:
            langs = db.query(AiLanguage).filter(AiLanguage.is_active == True).order_by(AiLanguage.sort_order).all()
            for l in langs:
                self._languages[l.code] = {
                    "code": l.code,
                    "label": l.label,
                    "native_label": l.native_label,
                    "script": l.script,
                    "llm_instruction": l.llm_instruction,
                    "script_range_start": l.script_range_start,
                    "script_range_end": l.script_range_end,
                    "detection_keywords": l.detection_keywords or [],
                    "sort_order": l.sort_order,
                }

            domains = db.query(AiDomainConfig).filter(AiDomainConfig.is_active == True).order_by(AiDomainConfig.sort_order).all()
            for d in domains:
                self._domains[d.key] = {
                    "key": d.key,
                    "label": d.label,
                    "emoji": d.emoji,
                    "icon_name": d.icon_name,
                    "specialist": {
                        "role": d.specialist_role or "",
                        "focus": d.specialist_focus or "",
                        "key_planets": d.specialist_key_planets or "",
                        "key_yogas": d.specialist_key_yogas or "",
                        "key_doshas": d.specialist_key_doshas or "",
                        "style": d.specialist_style or "",
                    },
                    "houses": d.houses or [],
                    "house_weights": d.house_weights or {},
                    "key_planets": d.key_planets or [],
                    "planet_weights": d.planet_weights or {},
                    "yogas": d.yogas or [],
                    "doshas": d.doshas or [],
                    "keywords": d.keywords_en or [],
                    "keywords_hi": d.keywords_hi or [],
                    "keywords_hinglish": d.keywords_hinglish or [],
                    "divisional_charts": d.divisional_charts or ["D9", "D1"],
                }

            engines = db.query(AiEngine).filter(AiEngine.is_active == True).order_by(AiEngine.sort_order).all()
            for e in engines:
                self._engines[e.code] = {
                    "code": e.code,
                    "label": e.label,
                    "emoji": e.emoji,
                    "icon_name": e.icon_name,
                    "description": e.description,
                }

            self._loaded = True
            logger.info("AI config loaded: %d languages, %d domains, %d engines",
                        len(self._languages), len(self._domains), len(self._engines))
        except Exception as e:
            logger.warning("AI config DB load failed (using fallback): %s", e)
        finally:
            db.close()

    def reload(self):
        self._languages.clear()
        self._domains.clear()
        self._engines.clear()
        self._loaded = False
        self.load_from_db()

    # ── Language accessors ──

    def get_language(self, code: str) -> Optional[dict]:
        return self._languages.get(code)

    def get_language_instruction(self, code: str) -> str:
        lang = self._languages.get(code)
        if lang and lang["llm_instruction"]:
            return lang["llm_instruction"]
        return "Respond in clear, warm English."

    def get_all_languages(self) -> List[dict]:
        return list(self._languages.values())

    def detect_language(self, text: str) -> str:
        for lang in self._languages.values():
            start = lang.get("script_range_start")
            end = lang.get("script_range_end")
            if start and end:
                if any(start <= ord(c) <= end for c in text):
                    return lang["code"]
        for lang in self._languages.values():
            kws = lang.get("detection_keywords") or []
            if kws and any(kw in text.lower() for kw in kws):
                return lang["code"]
        return "english"

    # ── Domain accessors ──

    def get_domain(self, key: str) -> Optional[dict]:
        return self._domains.get(key)

    def get_all_domains(self) -> List[dict]:
        return list(self._domains.values())

    def get_domain_specialist(self, key: str) -> dict:
        d = self._domains.get(key)
        if d:
            return d["specialist"]
        return {"role": "Vedic Astrology Specialist", "focus": "", "key_planets": "",
                "key_yogas": "", "key_doshas": "", "style": ""}

    def get_domain_divisionals(self, key: str) -> List[str]:
        d = self._domains.get(key)
        if d:
            return d.get("divisional_charts", ["D9", "D1"])
        return ["D9", "D1"]

    def get_domain_keywords(self, key: str) -> List[str]:
        d = self._domains.get(key)
        if d:
            return d.get("keywords", [])
        return []

    # ── Engine accessors ──

    def get_engine_meta(self, code: str) -> Optional[dict]:
        return self._engines.get(code)

    def get_all_engines(self) -> List[dict]:
        return list(self._engines.values())

    @property
    def is_loaded(self) -> bool:
        return self._loaded


ai_cache = AiConfigCache()
