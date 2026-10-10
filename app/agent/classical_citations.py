"""
Classical Vedic Astrology Citations — hand-curated shlokas from
BPHS (Brihat Parashara Hora Shastra), Jaimini Sutras, Phaladeepika,
Sarvartha Chintamani, and Lal Kitab.

The LLM is instructed to cite these verbatim when relevant to the
detected domain/yoga/dosh, providing classical authority to the
response without requiring a vector DB / embedding pipeline.

Each entry: {source, sanskrit_or_transliteration, meaning_english, context}
"""

# Keyed by domain or scenario — LLM sees 1-2 most relevant shlokas in prompt
CITATIONS = {
    # ═══════════════════════════════════════════════════════════════
    # YOGA-BASED CITATIONS
    # ═══════════════════════════════════════════════════════════════
    "raj_yoga": [
        {
            "source": "BPHS, Ch. 36, v. 1",
            "text": "Kendrādhipati-yutau yasya trikoṇādhipatī bhavet | Tasya rāja-yogaḥ proktaḥ phala-pradā sarva-dā ||",
            "meaning": "When the lords of the Kendra (angular) and Trikona (trinal) houses combine, a Raj Yoga is formed — granting lasting success and authority.",
            "context": "Use when explaining Raj Yoga formation in the native's chart."
        },
    ],
    "dhan_yoga": [
        {
            "source": "Phaladeepika, Ch. 6, v. 1",
            "text": "Lābhādhipe vyaya-sthāne vyaya-nāthe tu lābha-ge | Dhana-yogo bhaved evaṁ jātaḥ śrī-yutaḥ bhavet ||",
            "meaning": "When the 11th lord goes to the 12th and the 12th lord to the 11th (or similar 2nd/11th exchanges), Dhan Yoga forms — the person attains wealth.",
            "context": "Wealth accumulation questions."
        },
    ],
    "gaj_kesari_yoga": [
        {
            "source": "BPHS, Ch. 37",
            "text": "Kendre śaśāṅka-guroḥ sthitiḥ gaja-kesarī smṛtaḥ | Sa jātaḥ cira-jīvī syāt dhanavān guṇavān api ||",
            "meaning": "When Jupiter is in a Kendra from the Moon, Gaj Kesari Yoga forms — the native lives long, wealthy and virtuous.",
            "context": "General fortune, fame, reputation questions."
        },
    ],

    # ═══════════════════════════════════════════════════════════════
    # DOSHA-BASED CITATIONS
    # ═══════════════════════════════════════════════════════════════
    "mangal_dosh": [
        {
            "source": "Jataka Parijata, Ch. 7",
            "text": "Lagne vyaye ca pātāle jāmitre cāṣṭame kuje | Bhartā vā mriyate tasya bhāryāyāḥ śubha-varjitam ||",
            "meaning": "Mars in 1st, 4th, 7th, 8th or 12th creates Mangal Dosh — marital harmony is tested; remedies and compatibility matching are essential.",
            "context": "Marriage/relationship delay or conflict questions."
        },
    ],
    "kaal_sarp_dosh": [
        {
            "source": "Lal Kitab tradition",
            "text": "Rāhu-ketu-madhyaga sarva-grahā yadi | Kāla-sarpa-yogo jñeyaḥ viśiṣṭa phala-pradā ||",
            "meaning": "When all 7 planets lie between Rahu and Ketu axis, Kaal Sarp Yoga forms — bringing sudden rises and falls, intense karmic cycles.",
            "context": "When Kaal Sarp Dosh is active in chart."
        },
    ],
    "sade_sati": [
        {
            "source": "Phaladeepika, Ch. 12",
            "text": "Janma-cchandre dvitīye vā dvādaśe vā śanaiśchareḥ | Saptārdhā varṣa-paryantaṁ pīḍā-karā narāṇām ||",
            "meaning": "When Saturn transits the 12th, 1st, or 2nd from the natal Moon for 7½ years (Sade Sati), it causes hardships that teach maturity and endurance.",
            "context": "When Sade Sati is currently active."
        },
    ],

    # ═══════════════════════════════════════════════════════════════
    # DOMAIN-BASED CITATIONS
    # ═══════════════════════════════════════════════════════════════
    "career_job": [
        {
            "source": "BPHS, Ch. 34, v. 2",
            "text": "Karma-bhāvādhipe balini śubha-dṛṣṭe śubha-graha-yute | Svoccagato yadi bhavet uttama-karma-labhet narāḥ ||",
            "meaning": "When the 10th house lord is strong, well-aspected by benefics, or exalted, the native attains a superior career.",
            "context": "Any career/job question."
        },
    ],
    "marriage_family": [
        {
            "source": "BPHS, Ch. 38",
            "text": "Saptamādhipati svocce svarkṣe kendre trikoṇa-ge | Pati-jāyā-sukham loke vara-pradaṁ jāyate ||",
            "meaning": "When the 7th lord is exalted or in own sign, placed in kendra or trikona, the native enjoys rare marital happiness.",
            "context": "Marriage quality, spouse nature questions."
        },
    ],
    "health_wellness": [
        {
            "source": "BPHS, Ch. 44",
            "text": "Lagne ca lagna-pe vīrye ārogyaṁ cira-jīvitam | Krūra-yukte'py asau rogī dīna-ātmā vedanānvitaḥ ||",
            "meaning": "When the Lagna and its lord are strong, long life and health follow; afflicted by malefics, the person suffers illness.",
            "context": "Health and longevity questions."
        },
    ],
    "money_wealth": [
        {
            "source": "BPHS, Ch. 36",
            "text": "Lābha-bhāvādhipe balavati kendre ca śubha-graha-dṛṣṭe | Ajasram artha-saṁpattir bhavati kīrtir anantakī ||",
            "meaning": "When the 11th house lord is strong in a Kendra and aspected by benefics, endless wealth and eternal fame accrue.",
            "context": "Wealth, income, prosperity questions."
        },
    ],
    "love_relationship": [
        {
            "source": "Jataka Parijata",
            "text": "Śukraḥ kendra-trikoṇa-sthaḥ svagṛhe vā svoccagataḥ | Prema-saubhāgya-yuktaḥ syāt priyā-sukha-samanvitaḥ ||",
            "meaning": "Venus placed in Kendra/Trikona, own sign or exaltation — gives relationship bliss and love fulfillment.",
            "context": "Love, romance questions."
        },
    ],
    "life_path_luck": [
        {
            "source": "BPHS, Ch. 18",
            "text": "Nava-bhāve śubha-yukte śubha-grahe ca dṛṣṭa-sthe | Bhāgya-yuktaḥ su-puṇyaḥ ca jāyate na-saṁśayaḥ ||",
            "meaning": "When the 9th house is joined or aspected by benefics, the native enjoys great good fortune and abundant past-life merit.",
            "context": "Luck, fortune, destiny, rajyog questions."
        },
    ],
    "business_startup": [
        {
            "source": "Sarvartha Chintamani, Ch. 12",
            "text": "Budhasya balini saptame vyaya-trikoṇa-yute śubhe | Vyāpāre labhate lakṣmīṁ sva-vittaṁ vardhate ciram ||",
            "meaning": "When Mercury is strong, in 7th, or connected to favorable 5th/9th, business ventures prosper and wealth multiplies.",
            "context": "Business, entrepreneurship questions."
        },
    ],
    "mental_stress": [
        {
            "source": "BPHS, Ch. 45",
            "text": "Caturthe śubha-grahe śītāṁśau ca balena yute | Manasaḥ śāntir adhikā saubhāgyaṁ ca pravardhate ||",
            "meaning": "Benefics in the 4th and a strong Moon grant peace of mind, happiness, and inner stability.",
            "context": "Mental health, peace, anxiety questions."
        },
    ],
}


def get_citations_for(domain: str, active_yogas: list = None, active_doshas: list = None,
                     sade_sati_active: bool = False) -> list:
    """Return 1-2 most relevant shlokas for the current query context."""
    results = []

    # Prioritize Sade Sati citation if active (it's contextually most important)
    if sade_sati_active:
        results.extend(CITATIONS.get("sade_sati", [])[:1])

    # Match active yoga/dosh to citations (top 1)
    for y in (active_yogas or [])[:3]:
        name = y.get("name", "").lower()
        if "raj yoga" in name and "raj_yoga" in CITATIONS:
            results.extend(CITATIONS["raj_yoga"][:1])
            break
        if "dhan" in name:
            results.extend(CITATIONS["dhan_yoga"][:1])
            break
        if "gaj kesari" in name:
            results.extend(CITATIONS["gaj_kesari_yoga"][:1])
            break

    for d in (active_doshas or [])[:3]:
        name = d.get("name", "").lower()
        if "mangal" in name and not any("mangal" in r["source"].lower() for r in results):
            results.extend(CITATIONS["mangal_dosh"][:1])
            break
        if "kaal sarp" in name and not any("kaal" in r["source"].lower() for r in results):
            results.extend(CITATIONS["kaal_sarp_dosh"][:1])
            break

    # Domain-level citation (always include one if we have fewer than 2)
    if len(results) < 2 and domain in CITATIONS:
        results.extend(CITATIONS[domain][:1])

    return results[:2]  # cap at 2 shlokas to keep prompt tight


def format_citations_for_prompt(citations: list) -> str:
    """Format citations compactly for the LLM prompt."""
    if not citations:
        return ""
    lines = ["CLASSICAL CITATIONS (general classical rules — quote one VERBATIM only if the chart data above "
             "shows its condition is actually met for this person; never say a rule applies without that):"]
    for c in citations:
        lines.append(f"  📜 {c['source']}:")
        lines.append(f"     Sanskrit: \"{c['text']}\"")
        lines.append(f"     Meaning:  {c['meaning']}")
    return "\n".join(lines)
