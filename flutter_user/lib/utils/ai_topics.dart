/// AI chat topic registry — mirrors the backend's topic/engine mapping
/// (app/agent/specialist_bridge.py DOMAIN_TO_SPECIALIST + EXTRA_CHAT_ENGINES).
///
/// A "topic" is what the user picks when starting a chat:
///  - the 12 probability domains (career, marriage, ...) — each also maps to
///    its own specialist engine for a richer, report-grade answer
///  - 3 engine-only topics with no domain counterpart: character, past_life,
///    daily_forecast
///  - "General" (no domain, no engine) — the existing unscoped "ask anything"
///    path, unaffected by any topic selection
///
/// Multi-chart engines (kundli_milan, relationship, child_probability,
/// love_compatibility, karma_linkage) are NOT chat topics — they need a
/// second chart and a different UX, out of scope for this chat feature.
library ai_topics;

class AiTopic {
  final String? domainKey; // one of the 12 probability domains, or null
  final String? engineKey; // specialist/engine key sent to the backend, or null
  final String label;
  final String emoji;

  const AiTopic({this.domainKey, this.engineKey, required this.label, required this.emoji});

  bool get isGeneral => domainKey == null && engineKey == null;

  /// The key the admin "AI Chat Agents" publish/pricing control
  /// (AiAgentSetting, surfaced via ApiService.getAiAgents()) is keyed by.
  String? get metaKey => domainKey ?? engineKey;
}

/// Mirrors specialist_bridge.DOMAIN_TO_SPECIALIST — the specialist engine key
/// each probability domain auto-grounds its chat answer in.
const Map<String, String> kDomainToSpecialist = {
  'career_job': 'career',
  'business_startup': 'business',
  'education_career': 'education',
  'money_wealth': 'wealth',
  'debt_recovery': 'debt_recovery',
  'love_relationship': 'love',
  'marriage_family': 'marriage',
  'health_wellness': 'health',
  'mental_stress': 'mental_stress',
  'property_assets': 'property',
  'legal_dispute': 'legal',
  'life_path_luck': 'life_path',
};

const AiTopic kGeneralTopic = AiTopic(label: 'General — Ask Anything', emoji: '🔮');

const List<AiTopic> kAiChatTopics = [
  kGeneralTopic,
  AiTopic(domainKey: 'career_job', engineKey: 'career', label: 'Career & Job', emoji: '💼'),
  AiTopic(domainKey: 'business_startup', engineKey: 'business', label: 'Business & Startup', emoji: '🚀'),
  AiTopic(domainKey: 'education_career', engineKey: 'education', label: 'Education', emoji: '🎓'),
  AiTopic(domainKey: 'money_wealth', engineKey: 'wealth', label: 'Money & Wealth', emoji: '💰'),
  AiTopic(domainKey: 'debt_recovery', engineKey: 'debt_recovery', label: 'Debt Recovery', emoji: '📉'),
  AiTopic(domainKey: 'love_relationship', engineKey: 'love', label: 'Love & Relationship', emoji: '❤️'),
  AiTopic(domainKey: 'marriage_family', engineKey: 'marriage', label: 'Marriage & Family', emoji: '💒'),
  AiTopic(domainKey: 'health_wellness', engineKey: 'health', label: 'Health & Wellness', emoji: '🏥'),
  AiTopic(domainKey: 'mental_stress', engineKey: 'mental_stress', label: 'Mental Stress', emoji: '🧠'),
  AiTopic(domainKey: 'property_assets', engineKey: 'property', label: 'Property & Assets', emoji: '🏠'),
  AiTopic(domainKey: 'legal_dispute', engineKey: 'legal', label: 'Legal & Dispute', emoji: '⚖️'),
  AiTopic(domainKey: 'life_path_luck', engineKey: 'life_path', label: 'Life Path & Luck', emoji: '🌟'),
  AiTopic(engineKey: 'character', label: 'Character Analysis', emoji: '🔍'),
  AiTopic(engineKey: 'past_life', label: 'Past Life & Karma', emoji: '🔮'),
  AiTopic(engineKey: 'daily_forecast', label: "Today's Forecast", emoji: '✨'),
];

/// Resolve a topic from a chat's stored `engine_key` (as returned by
/// GET /agent/chats/{id}) — used when resuming a chat.
AiTopic topicForEngineKey(String? engineKey) {
  if (engineKey == null || engineKey.isEmpty) return kGeneralTopic;
  return kAiChatTopics.firstWhere((t) => t.engineKey == engineKey, orElse: () => kGeneralTopic);
}

/// Resolve a topic from a legacy `domainKey` entry point (the 12-domain
/// grid on the home tab, or a report screen's "Ask AI" button).
AiTopic topicForDomainKey(String? domainKey) {
  if (domainKey == null || domainKey.isEmpty) return kGeneralTopic;
  return kAiChatTopics.firstWhere((t) => t.domainKey == domainKey, orElse: () => kGeneralTopic);
}
