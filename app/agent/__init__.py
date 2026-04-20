"""
Nakshtralogy AI Agent Module
=============================
12 domain-specialist AI chatbots powered by:
  - Vedic astrology probability engine (from Agent/nakshtra_agent.py)
  - Groq/Llama LLM for natural language explanations
"""
from .engine import NakshtraAgent, detect_intent, DOMAINS, compute_domain_probability
from .llm_service import generate_llm_response

__all__ = ["NakshtraAgent", "detect_intent", "DOMAINS",
           "compute_domain_probability", "generate_llm_response"]
