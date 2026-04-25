"""
Template Resolver — condition evaluator + placeholder filler
=============================================================
Checks answer_templates for a matched question, evaluates conditions
against chart/agent data, fills placeholders, returns ready text.

No eval/exec — uses operator module for safe condition evaluation.

Usage:
    from app.ai_config.template_resolver import resolve_template
    text = resolve_template(question_id, chart_context, agent_result, lang_code)
    # → filled template string, or None if no template matches
"""

import logging
import operator
import re
from typing import Optional, Dict, Any

logger = logging.getLogger("template_resolver")

_template_cache: Dict[str, list] = {}

_OPS = {
    "==": operator.eq,
    "!=": operator.ne,
    ">=": operator.ge,
    "<=": operator.le,
    ">":  operator.gt,
    "<":  operator.lt,
    "in": lambda val, container: val in container,
    "contains": lambda container, val: val in container,
}


def load_templates():
    """Load all active templates with translations into memory cache."""
    from app.core.database import SessionLocal
    from app.models.model import AiAnswerTemplate, AiTemplateTranslation
    db = SessionLocal()
    try:
        templates = db.query(AiAnswerTemplate).filter(
            AiAnswerTemplate.is_active == True
        ).order_by(AiAnswerTemplate.priority.desc()).all()

        _template_cache.clear()
        for t in templates:
            translations = db.query(AiTemplateTranslation).filter(
                AiTemplateTranslation.template_id == t.id
            ).all()
            trans_map = {}
            for tr in translations:
                trans_map[tr.lang_code] = {
                    "body": tr.body,
                    "placeholders": tr.placeholders or [],
                }

            key = t.question_id or t.domain_key or "_global"
            entry = {
                "id": t.id,
                "question_id": t.question_id,
                "domain_key": t.domain_key,
                "condition_key": t.condition_key,
                "condition_op": t.condition_op,
                "condition_val": t.condition_val,
                "priority": t.priority,
                "use_llm_fill": t.use_llm_fill,
                "translations": trans_map,
            }
            _template_cache.setdefault(key, []).append(entry)

        total = sum(len(v) for v in _template_cache.values())
        logger.info("Loaded %d answer templates", total)
    except Exception as e:
        logger.warning("Template cache load failed: %s", e)
    finally:
        db.close()


def _eval_condition(template: dict, data: dict) -> bool:
    """Evaluate a single template condition against data dict. No eval/exec."""
    cond_key = template.get("condition_key")
    cond_op = template.get("condition_op")
    cond_val = template.get("condition_val")

    if not cond_key or not cond_op:
        return True

    actual = _deep_get(data, cond_key)
    if actual is None:
        return False

    op_fn = _OPS.get(cond_op)
    if not op_fn:
        logger.warning("Unknown operator: %s", cond_op)
        return False

    try:
        if isinstance(cond_val, (int, float)) and isinstance(actual, str):
            actual = float(actual)
        elif isinstance(cond_val, str) and isinstance(actual, (int, float)):
            cond_val = float(cond_val)
        return op_fn(actual, cond_val)
    except (TypeError, ValueError):
        return False


def _deep_get(data: dict, dotted_key: str):
    """Get nested value from dict using dotted key: 'breakdown.house_score'."""
    parts = dotted_key.split(".")
    current = data
    for part in parts:
        if isinstance(current, dict):
            current = current.get(part)
        else:
            return None
    return current


def _fill_placeholders(body: str, data: dict) -> str:
    """Replace {key} placeholders in template body with values from data."""
    def _replace(match):
        key = match.group(1)
        val = _deep_get(data, key)
        if val is None:
            return match.group(0)
        if isinstance(val, float):
            return f"{val:.1f}"
        if isinstance(val, list):
            return ", ".join(str(v) for v in val[:5])
        return str(val)

    return re.sub(r'\{(\w+(?:\.\w+)*)\}', _replace, body)


def resolve_template(
    question_id: Optional[str],
    domain_key: str,
    chart_context: dict,
    agent_result: dict,
    lang_code: str = "english",
) -> Optional[str]:
    """Find and fill the best matching template.
    Returns filled text or None if no template matches.

    Search order: question_id templates → domain templates → global templates.
    Within each group: highest priority first, conditions evaluated.
    Language fallback: requested → hindi → english.
    """
    merged_data = {**chart_context, **agent_result}

    search_keys = []
    if question_id:
        search_keys.append(question_id)
    search_keys.append(domain_key)
    search_keys.append("_global")

    for key in search_keys:
        templates = _template_cache.get(key, [])
        for t in templates:
            if not _eval_condition(t, merged_data):
                continue

            if t.get("use_llm_fill"):
                return None

            trans = (t["translations"].get(lang_code)
                     or t["translations"].get("hindi")
                     or t["translations"].get("english"))
            if not trans:
                continue

            filled = _fill_placeholders(trans["body"], merged_data)
            logger.info("Template hit: id=%s, question=%s, domain=%s",
                        t["id"], question_id, domain_key)
            return filled

    return None
