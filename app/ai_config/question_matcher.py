"""
Question Matcher — matches user query against ai_questions bank
===============================================================
Uses keyword overlap scoring (MySQL-compatible, no pgvector needed).

Usage:
    from app.ai_config.question_matcher import match_question
    result = match_question("When will I get promoted?", "career_job")
    # → {"question_id": "...", "score": 0.85, "question": {...}} or None
"""

import logging
import re
from typing import Optional, Dict, Any

logger = logging.getLogger("question_matcher")

_question_cache: Dict[str, list] = {}


def load_questions():
    """Load all active questions with translations into memory cache."""
    from app.core.database import SessionLocal
    from app.models.model import AiQuestion, AiQuestionTranslation
    db = SessionLocal()
    try:
        questions = db.query(AiQuestion).filter(AiQuestion.is_active == True).all()
        _question_cache.clear()
        for q in questions:
            domain = q.domain_key
            translations = db.query(AiQuestionTranslation).filter(
                AiQuestionTranslation.question_id == q.id
            ).all()
            trans_map = {}
            all_keywords = set(q.keywords or [])
            for t in translations:
                trans_map[t.lang_code] = {
                    "text": t.text,
                    "short_label": t.short_label,
                }
                for kw in (t.keywords_lang or []):
                    all_keywords.add(kw.lower())

            entry = {
                "id": q.id,
                "domain_key": domain,
                "sub_domain": q.sub_domain,
                "question_type": q.question_type,
                "keywords": list(all_keywords),
                "match_threshold": q.match_threshold or 0.70,
                "translations": trans_map,
                "sort_order": q.sort_order,
            }
            _question_cache.setdefault(domain, []).append(entry)

        total = sum(len(v) for v in _question_cache.values())
        logger.info("Loaded %d questions across %d domains", total, len(_question_cache))
    except Exception as e:
        logger.warning("Question cache load failed: %s", e)
    finally:
        db.close()


def get_questions_for_domain(domain_key: str, lang_code: str = "english") -> list:
    """Get suggested questions for a domain (for Flutter chips)."""
    questions = _question_cache.get(domain_key, [])
    result = []
    for q in sorted(questions, key=lambda x: x["sort_order"]):
        trans = q["translations"].get(lang_code) or q["translations"].get("english") or {}
        text = trans.get("text") or trans.get("short_label") or ""
        if text:
            result.append({
                "id": q["id"],
                "text": text,
                "short_label": trans.get("short_label") or text[:50],
                "sub_domain": q["sub_domain"],
                "question_type": q["question_type"],
            })
    return result


def match_question(query: str, domain_key: str) -> Optional[Dict[str, Any]]:
    """Match a user query against the question bank for a domain.
    Returns best match with score, or None if below threshold."""
    questions = _question_cache.get(domain_key, [])
    if not questions:
        return None

    q_lower = query.lower()
    q_words = set(re.findall(r'\w+', q_lower))
    best_match = None
    best_score = 0.0

    for q in questions:
        keywords = q["keywords"]
        if not keywords:
            continue

        hit_count = 0
        hit_weight = 0.0
        for kw in keywords:
            kw_lower = kw.lower()
            if " " in kw_lower:
                kw_parts = set(kw_lower.split())
                if kw_parts.issubset(q_words):
                    hit_count += 1
                    hit_weight += 2.0
            else:
                if kw_lower in q_words:
                    hit_count += 1
                    hit_weight += 1.0

        if hit_count == 0:
            continue

        # Cap denominator at 5 so having many keyword variants doesn't
        # penalize the score. 2 keyword hits ≈ 40-60%, enough to match.
        max_weight = sum(2.0 if " " in kw else 1.0 for kw in keywords)
        score = min(1.0, hit_weight / min(max_weight, 5.0))

        if score > best_score:
            best_score = score
            best_match = q

    if best_match and best_score >= best_match["match_threshold"]:
        return {
            "question_id": best_match["id"],
            "score": round(best_score, 3),
            "domain_key": best_match["domain_key"],
            "sub_domain": best_match["sub_domain"],
            "question_type": best_match["question_type"],
            "translations": best_match["translations"],
        }

    return None
