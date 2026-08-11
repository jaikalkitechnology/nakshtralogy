import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive.dart';
import '../../widgets/avatar_picker.dart';
import '../../bloc/astro_profile/astro_profile_bloc.dart';
import '../../bloc/astro_profile/astro_profile_event.dart';
import '../../bloc/astro_profile/astro_profile_state.dart';

/// Full-screen astrologer profile editor.
///
/// Replaces the old tall AlertDialog with a scrollable page organised into
/// Profile → Professional → Pricing → Message Settings sections, a live
/// preview, chip selectors for languages/specializations, unsaved-change
/// tracking and inline validation.
///
/// IMPORTANT: this is a presentation-only redesign. It dispatches the exact
/// same [AstroProfileUpdateRequested] event with the same backend field names
/// (`name`, `phone`, `display_name`, `bio`, `experience_years`, `languages`,
/// `specializations`, `qualification`, `rate_per_min_*`, `rate_per_session_*`,
/// `session_message_limit`, `session_validity_hours`, `rate_per_msg_chat`,
/// `super_chat_rate`) and the same "only send non-empty fields" semantics as
/// the previous dialog — no API/contract/validation-logic changes.
class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> me;
  const EditProfileScreen({super.key, required this.me});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const int _bioMax = 500;

  late final Map<String, dynamic> _profile;

  // ── Controllers (text fields) ──
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _display;
  late final TextEditingController _bio;
  late final TextEditingController _exp;
  late final TextEditingController _qual;
  late final TextEditingController _chatMin;
  late final TextEditingController _callMin;
  late final TextEditingController _videoMin;
  late final TextEditingController _chatSess;
  late final TextEditingController _callSess;
  late final TextEditingController _videoSess;
  late final TextEditingController _msgLimit;
  late final TextEditingController _validity;
  late final TextEditingController _perMsg;
  late final TextEditingController _superChat;

  // ── Chip lists ──
  late List<String> _languages;
  late List<String> _specializations;

  // ── State ──
  bool _dirty = false;
  bool _submitting = false; // true only between a Save press and its result
  int _pricingTab = 0; // 0 = per-minute, 1 = per-session, 2 = per-message
  final _formKey = GlobalKey<FormState>();
  final _scrollCtrl = ScrollController();

  // Section expansion state (kept for the session).
  bool _profileOpen = true;
  bool _proOpen = true;
  bool _pricingOpen = true;
  bool _msgOpen = false;

  // Snapshot of the initial serialized state, for dirty comparison.
  late final String _initialSig;

  static const _langSuggestions = [
    'Hindi', 'English', 'Marathi', 'Gujarati', 'Tamil', 'Telugu',
    'Kannada', 'Bengali', 'Punjabi', 'Malayalam', 'Odia', 'Sanskrit',
  ];
  static const _specSuggestions = [
    'Vedic Astrology', 'Numerology', 'Tarot', 'Marriage', 'Career',
    'Kundli', 'Vastu', 'Palmistry', 'Nadi', 'Lal Kitab', 'KP System',
  ];

  @override
  void initState() {
    super.initState();
    final me = widget.me;
    _profile = (me['profile'] ?? me['astrologer_profile'] ?? <String, dynamic>{})
        as Map<String, dynamic>;

    String s(dynamic v) => v == null ? '' : '$v';

    _name = _c(s(me['name']));
    _phone = _c(s(me['phone']));
    _display = _c(s(_profile['display_name']));
    _bio = _c(s(_profile['bio']));
    _exp = _c(s(_profile['experience_years']));
    _qual = _c(s(_profile['qualification']));
    _chatMin = _c(s(_profile['rate_per_min_chat']));
    _callMin = _c(s(_profile['rate_per_min_call']));
    _videoMin = _c(s(_profile['rate_per_min_video']));
    _chatSess = _c(s(_profile['rate_per_session_chat']));
    _callSess = _c(s(_profile['rate_per_session_call']));
    _videoSess = _c(s(_profile['rate_per_session_video']));
    _msgLimit = _c(s(_profile['session_message_limit'] ?? 45));
    _validity = _c(s(_profile['session_validity_hours'] ?? 24));
    _perMsg = _c(s(_profile['rate_per_msg_chat']));
    _superChat = _c(s(_profile['super_chat_rate'] ?? 50));

    _languages = ((_profile['languages'] as List?) ?? const [])
        .map((e) => e.toString()).toList();
    _specializations = ((_profile['specializations'] as List?) ?? const [])
        .map((e) => e.toString()).toList();

    _initialSig = _signature();
  }

  TextEditingController _c(String text) {
    final ctrl = TextEditingController(text: text);
    ctrl.addListener(_recomputeDirty);
    return ctrl;
  }

  String _signature() =>
      [_name, _phone, _display, _bio, _exp, _qual, _chatMin, _callMin,
       _videoMin, _chatSess, _callSess, _videoSess, _msgLimit, _validity,
       _perMsg, _superChat].map((c) => c.text).join('') +
      '${_languages.join(',')}${_specializations.join(',')}';

  void _recomputeDirty() {
    final d = _signature() != _initialSig;
    if (d != _dirty) setState(() => _dirty = d);
  }

  @override
  void dispose() {
    for (final c in [_name, _phone, _display, _bio, _exp, _qual, _chatMin,
        _callMin, _videoMin, _chatSess, _callSess, _videoSess, _msgLimit,
        _validity, _perMsg, _superChat]) {
      c.dispose();
    }
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Save ──
  void _save() {
    // Validate only the numeric fields inline (mirrors the tryParse the save
    // used before — invalid numbers were silently dropped). Blocking here is a
    // UX improvement, not a new business rule.
    if (!(_formKey.currentState?.validate() ?? true)) {
      // Jump to the first error by expanding all sections.
      setState(() { _profileOpen = _proOpen = _pricingOpen = _msgOpen = true; });
      return;
    }
    _submitting = true;

    final userFields = <String, dynamic>{};
    if (_name.text.trim().isNotEmpty) userFields['name'] = _name.text.trim();
    if (_phone.text.trim().isNotEmpty) userFields['phone'] = _phone.text.trim();

    final pf = <String, dynamic>{};
    void put(String key, String raw) {
      if (raw.trim().isNotEmpty) pf[key] = raw.trim();
    }
    void putInt(String key, String raw) {
      if (raw.trim().isNotEmpty) pf[key] = int.tryParse(raw.trim());
    }
    void putNum(String key, String raw) {
      if (raw.trim().isNotEmpty) pf[key] = double.tryParse(raw.trim());
    }

    put('display_name', _display.text);
    put('bio', _bio.text);
    putInt('experience_years', _exp.text);
    if (_languages.isNotEmpty) pf['languages'] = _languages;
    if (_specializations.isNotEmpty) pf['specializations'] = _specializations;
    put('qualification', _qual.text);
    putNum('rate_per_min_chat', _chatMin.text);
    putNum('rate_per_min_call', _callMin.text);
    putNum('rate_per_min_video', _videoMin.text);
    putNum('rate_per_session_chat', _chatSess.text);
    putNum('rate_per_session_call', _callSess.text);
    putNum('rate_per_session_video', _videoSess.text);
    putInt('session_message_limit', _msgLimit.text);
    putInt('session_validity_hours', _validity.text);
    putNum('rate_per_msg_chat', _perMsg.text);
    putNum('super_chat_rate', _superChat.text);

    context.read<AstroProfileBloc>()
        .add(AstroProfileUpdateRequested(userFields: userFields, profileFields: pf));
  }

  Future<bool> _confirmDiscard() async {
    if (!_dirty) return true;
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Discard changes?',
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        content: const Text('You have unsaved changes. If you leave now, your edits will be lost.',
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep editing', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Discard', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    return res ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return BlocListener<AstroProfileBloc, AstroProfileState>(
      listenWhen: (prev, curr) =>
          prev.saving != curr.saving ||
          prev.successMessage != curr.successMessage ||
          prev.error != curr.error,
      listener: (context, state) {
        // React only to the result of OUR Save press (not to avatar uploads,
        // which also flow through this bloc).
        if (_submitting && !state.saving) {
          if (state.error != null) {
            // Keep the screen open with all entered values so nothing is lost.
            _submitting = false;
          } else {
            // Success: parent ProfileTab shows the snackbar; close directly
            // (pop() bypasses the PopScope discard guard — changes are saved).
            _submitting = false;
            _dirty = false;
            Navigator.of(context).pop();
          }
        }
      },
      child: PopScope(
        canPop: !_dirty,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;
          if (await _confirmDiscard() && mounted) Navigator.of(context).pop();
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.midnight,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () async {
                if (await _confirmDiscard() && mounted) Navigator.of(context).pop();
              },
            ),
            title: Text(l?.editProfile ?? 'Edit Profile',
                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
            actions: [
              BlocBuilder<AstroProfileBloc, AstroProfileState>(
                builder: (context, state) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextButton(
                    onPressed: (_dirty && !state.saving) ? _save : null,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.gold,
                      disabledForegroundColor: AppColors.smoke.withOpacity(0.6),
                    ),
                    child: state.saving
                        ? const SizedBox(width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold))
                        : Text(l?.save ?? 'Save',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  ),
                ),
              ),
            ],
          ),
          // Sticky save bar lives in the body (not bottomNavigationBar) so it
          // always sits directly above the keyboard when a field is focused.
          body: SafeArea(
            top: false,
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: Responsive.isDesktop(context) ? 980 : 640),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    Expanded(
                      child: ListView(
                        controller: _scrollCtrl,
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        children: Responsive.isDesktop(context)
                            // Desktop: two columns — form fields on the left,
                            // preview + pricing + message settings on the right.
                            ? [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(children: [
                                        _profileSection(),
                                        const SizedBox(height: 16),
                                        _professionalSection(),
                                      ]),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(children: [
                                        _preview(),
                                        if (_dirty) ...[
                                          const SizedBox(height: 12),
                                          _unsavedBadge(),
                                        ],
                                        const SizedBox(height: 16),
                                        _pricingSection(),
                                        const SizedBox(height: 16),
                                        _messageSettingsSection(),
                                      ]),
                                    ),
                                  ],
                                ),
                              ]
                            : [
                                _preview(),
                                if (_dirty) ...[
                                  const SizedBox(height: 12),
                                  _unsavedBadge(),
                                ],
                                const SizedBox(height: 20),
                                _profileSection(),
                                const SizedBox(height: 16),
                                _professionalSection(),
                                const SizedBox(height: 16),
                                _pricingSection(),
                                const SizedBox(height: 16),
                                _messageSettingsSection(),
                              ],
                      ),
                    ),
                    _saveBar(l),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Profile preview ──
  Widget _preview() {
    final display = _display.text.trim().isNotEmpty
        ? _display.text.trim()
        : (_name.text.trim().isNotEmpty ? _name.text.trim() : 'Astrologer');
    final rating = (_profile['rating'] as num?)?.toDouble() ?? 0.0;
    final reviews = (_profile['total_reviews'] as num?)?.toInt() ?? 0;
    final uploaded = (_profile['profile_image_url'] ?? '').toString();
    final google = (widget.me['avatar_url'] ?? '').toString();
    final img = uploaded.isNotEmpty ? uploaded : google;
    final expYears = int.tryParse(_exp.text.trim());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.nebula, AppColors.twilight.withOpacity(0.55)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gold.withOpacity(0.25)),
      ),
      child: Row(children: [
        AvatarPicker(
          size: 68,
          imageUrl: img.isNotEmpty ? img : null,
          fallbackInitial: display.isNotEmpty ? display[0].toUpperCase() : 'A',
          onUploaded: (url) async => context.read<AstroProfileBloc>()
              .add(AstroProfileUpdateRequested(userFields: const {}, profileFields: {'profile_image_url': url})),
          onRemoved: () async => context.read<AstroProfileBloc>()
              .add(AstroProfileUpdateRequested(userFields: const {}, profileFields: {'profile_image_url': ''})),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(display,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.star, color: AppColors.gold, size: 15),
              const SizedBox(width: 3),
              Text(rating > 0 ? '${rating.toStringAsFixed(1)} ($reviews)' : 'New',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
              if (expYears != null && expYears > 0) ...[
                const Text('   •   ', style: TextStyle(color: AppColors.smoke, fontSize: 12)),
                Text('$expYears yrs',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
              ],
            ]),
            if (_specializations.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(_specializations.take(3).join(' • '),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
            if (_languages.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(_languages.join(' • '),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5)),
            ],
          ]),
        ),
      ]),
    );
  }

  Widget _unsavedBadge() {
    return Row(children: [
      Container(width: 8, height: 8,
        decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle)),
      const SizedBox(width: 8),
      const Text('Unsaved changes',
          style: TextStyle(color: AppColors.gold, fontSize: 12.5, fontWeight: FontWeight.w600)),
    ]);
  }

  // ── Sections ──
  Widget _profileSection() {
    return _SectionCard(
      icon: Icons.person_outline,
      title: 'Profile Information',
      expanded: _profileOpen,
      onToggle: () => setState(() => _profileOpen = !_profileOpen),
      children: [
        _LabeledField(label: 'Full Name', controller: _name, icon: Icons.person_outline,
            hint: 'Your full name', textCapitalization: TextCapitalization.words),
        _LabeledField(label: 'Phone', controller: _phone, icon: Icons.phone_outlined,
            hint: '9999990000', keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]'))]),
        _LabeledField(label: 'Display Name', controller: _display, icon: Icons.badge_outlined,
            hint: 'Shown to users', textCapitalization: TextCapitalization.words),
        _LabeledField(
          label: 'Bio', controller: _bio, icon: Icons.description_outlined,
          hint: 'Tell users about your astrology experience…',
          maxLines: 4, maxLength: _bioMax, showCounter: true,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _professionalSection() {
    return _SectionCard(
      icon: Icons.school_outlined,
      title: 'Professional Information',
      expanded: _proOpen,
      onToggle: () => setState(() => _proOpen = !_proOpen),
      children: [
        _LabeledField(
          label: 'Experience', controller: _exp, icon: Icons.work_history_outlined,
          hint: '10', suffixText: 'years', keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (v) {
            final t = v?.trim() ?? '';
            if (t.isEmpty) return null;
            final n = int.tryParse(t);
            if (n == null || n < 0 || n > 100) return 'Enter a valid number of years.';
            return null;
          },
        ),
        _ChipSelector(
          label: 'Languages',
          values: _languages,
          suggestions: _langSuggestions,
          addHint: 'Add a language',
          onChanged: (v) => setState(() { _languages = v; _recomputeDirty(); }),
        ),
        const SizedBox(height: 14),
        _ChipSelector(
          label: 'Specializations',
          values: _specializations,
          suggestions: _specSuggestions,
          addHint: 'Add a specialization',
          onChanged: (v) => setState(() { _specializations = v; _recomputeDirty(); }),
        ),
        const SizedBox(height: 14),
        _LabeledField(label: 'Qualification', controller: _qual, icon: Icons.school_outlined,
            hint: 'e.g. B.Sc, Jyotish Acharya', textCapitalization: TextCapitalization.words),
      ],
    );
  }

  Widget _pricingSection() {
    return _SectionCard(
      icon: Icons.payments_outlined,
      title: 'Consultation Pricing',
      subtitle: 'Set how users are charged for your consultations.',
      expanded: _pricingOpen,
      onToggle: () => setState(() => _pricingOpen = !_pricingOpen),
      children: [
        _Segmented(
          options: const ['Per Minute', 'Per Session', 'Per Message'],
          selected: _pricingTab,
          onChanged: (i) => setState(() => _pricingTab = i),
        ),
        const SizedBox(height: 16),
        if (_pricingTab == 0) ...[
          _RateRow(icon: Icons.chat_bubble_outline, label: 'Chat', controller: _chatMin, unit: '/ min'),
          _RateRow(icon: Icons.call_outlined, label: 'Call', controller: _callMin, unit: '/ min'),
          _RateRow(icon: Icons.videocam_outlined, label: 'Video', controller: _videoMin, unit: '/ min'),
        ] else if (_pricingTab == 1) ...[
          // Session pricing applies to CHAT only. Audio & video calls are always
          // billed per minute, so no per-session fields are shown for them.
          _RateRow(icon: Icons.chat_bubble_outline, label: 'Chat', controller: _chatSess, unit: '/ session'),
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('Audio and video calls are billed per minute (set under "Per Minute"). Session pricing applies to chat only.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ),
        ] else ...[
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text('After a chat session\'s included messages are used up, each further message is charged this rate (the chat stays open).',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ),
          _RateRow(icon: Icons.mail_outline, label: 'Per Message', controller: _perMsg, unit: '/ msg'),
          _RateRow(icon: Icons.bolt_outlined, label: 'Super Chat', controller: _superChat, unit: 'min'),
        ],
      ],
    );
  }

  Widget _messageSettingsSection() {
    return _SectionCard(
      icon: Icons.forum_outlined,
      title: 'Message Settings',
      subtitle: 'Controls paid-message allowance and validity per session.',
      expanded: _msgOpen,
      onToggle: () => setState(() => _msgOpen = !_msgOpen),
      children: [
        _LabeledField(
          label: 'Messages per session', controller: _msgLimit, icon: Icons.message_outlined,
          hint: '45', suffixText: 'msgs', keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (v) => _positiveIntOrNull(v, 'Enter a valid number of messages.'),
        ),
        _LabeledField(
          label: 'Session validity', controller: _validity, icon: Icons.timer_outlined,
          hint: '24', suffixText: 'hours', keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (v) => _positiveIntOrNull(v, 'Enter a valid number of hours.'),
        ),
      ],
    );
  }

  String? _positiveIntOrNull(String? v, String msg) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return null;
    final n = int.tryParse(t);
    if (n == null || n <= 0) return msg;
    return null;
  }

  // ── Sticky save bar ──
  Widget _saveBar(AppLocalizations? l) {
    return BlocBuilder<AstroProfileBloc, AstroProfileState>(
      builder: (context, state) {
        return SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            decoration: BoxDecoration(
              color: AppColors.midnight,
              border: Border(top: BorderSide(color: AppColors.gold.withOpacity(0.18))),
            ),
            child: Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: state.saving ? null : () async {
                    if (await _confirmDiscard() && mounted) Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: BorderSide(color: AppColors.border),
                    minimumSize: const Size(0, 48),
                  ),
                  child: Text(l?.cancel ?? 'Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: (_dirty && !state.saving) ? _save : null,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
                  child: state.saving
                      ? const SizedBox(width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.midnight))
                      : const Text('Save Changes'),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}

// ════════════════════════ Reusable components ════════════════════════

/// Collapsible titled card used for each form section.
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool expanded;
  final VoidCallback onToggle;
  final List<Widget> children;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.children,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: [
        // Header
        Semantics(
          button: true,
          header: true,
          expanded: expanded,
          label: title,
          child: InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
              child: Row(children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.gold, size: 19),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(title,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 15.5, fontWeight: FontWeight.w700)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ]),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                ),
              ]),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
          ),
          crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 180),
          sizeCurve: Curves.easeOut,
        ),
      ]),
    );
  }
}

/// Text field with an always-visible label above it (not just a floating one).
class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? hint;
  final String? suffixText;
  final int maxLines;
  final int? maxLength;
  final bool showCounter;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;

  const _LabeledField({
    required this.label,
    required this.controller,
    required this.icon,
    this.hint,
    this.suffixText,
    this.maxLines = 1,
    this.maxLength,
    this.showCounter = false,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          maxLength: showCounter ? maxLength : null,
          textCapitalization: textCapitalization,
          validator: validator,
          autovalidateMode: validator != null ? AutovalidateMode.onUserInteraction : null,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14.5),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.smoke.withOpacity(0.7), fontSize: 14),
            prefixIcon: Icon(icon, size: 19, color: AppColors.smoke),
            suffixText: suffixText,
            suffixStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
            counterText: showCounter ? null : '',
            filled: true,
            fillColor: AppColors.midnight.withOpacity(0.5),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: maxLines > 1 ? 12 : 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.gold, width: 1.6),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1.6),
            ),
          ),
        ),
      ]),
    );
  }
}

/// Chip-based multi-select that keeps the backend's List<String> format.
class _ChipSelector extends StatelessWidget {
  final String label;
  final List<String> values;
  final List<String> suggestions;
  final String addHint;
  final ValueChanged<List<String>> onChanged;

  const _ChipSelector({
    required this.label,
    required this.values,
    required this.suggestions,
    required this.addHint,
    required this.onChanged,
  });

  Future<void> _add(BuildContext context) async {
    final ctrl = TextEditingController();
    final unused = suggestions.where((s) =>
        !values.any((v) => v.toLowerCase() == s.toLowerCase())).toList();
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 40, height: 4,
            decoration: BoxDecoration(color: AppColors.smoke, borderRadius: BorderRadius.circular(2)),
            margin: const EdgeInsets.only(bottom: 16)),
          Text(addHint, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          TextField(
            controller: ctrl,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(color: AppColors.textPrimary),
            onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
            decoration: InputDecoration(
              hintText: addHint,
              hintStyle: const TextStyle(color: AppColors.smoke),
              filled: true, fillColor: AppColors.midnight.withOpacity(0.5),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.gold, width: 1.6)),
            ),
          ),
          if (unused.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('Suggestions', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final s in unused)
                ActionChip(
                  label: Text(s, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12.5)),
                  backgroundColor: AppColors.midnight.withOpacity(0.6),
                  side: BorderSide(color: AppColors.border),
                  onPressed: () => Navigator.pop(ctx, s),
                ),
            ]),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              style: ElevatedButton.styleFrom(minimumSize: const Size(0, 46)),
              child: const Text('Add'),
            ),
          ),
        ]),
      ),
    );
    if (result != null && result.isNotEmpty) {
      final exists = values.any((v) => v.toLowerCase() == result.toLowerCase());
      if (!exists) onChanged([...values, result]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 6),
        child: Text(label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5, fontWeight: FontWeight.w600)),
      ),
      Wrap(spacing: 8, runSpacing: 8, children: [
        for (final v in values)
          Container(
            padding: const EdgeInsets.only(left: 12, right: 6, top: 6, bottom: 6),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.14),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.gold.withOpacity(0.4)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(v, style: const TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(width: 4),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(values.where((e) => e != v).toList()),
                child: Semantics(
                  button: true,
                  label: 'Remove $v',
                  child: const Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(Icons.close, size: 15, color: AppColors.gold),
                  ),
                ),
              ),
            ]),
          ),
        // Add button
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _add(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.gold.withOpacity(0.5)),
            ),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.add, size: 15, color: AppColors.gold),
              SizedBox(width: 4),
              Text('Add', style: TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w600)),
            ]),
          ),
        ),
      ]),
    ]);
  }
}

/// Segmented control for the pricing tabs.
class _Segmented extends StatelessWidget {
  final List<String> options;
  final int selected;
  final ValueChanged<int> onChanged;

  const _Segmented({required this.options, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.midnight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        for (int i = 0; i < options.length; i++)
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected == i ? AppColors.gold : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    options[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected == i ? AppColors.midnight : AppColors.textSecondary,
                      fontSize: 12.5,
                      fontWeight: selected == i ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}

/// A single pricing row: icon + label on the left, ₹ input + unit on the right.
class _RateRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final String unit;

  const _RateRow({
    required this.icon,
    required this.label,
    required this.controller,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.midnight.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(children: [
          Icon(icon, size: 19, color: AppColors.gold),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          const Text('₹', style: TextStyle(color: AppColors.textSecondary, fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(width: 4),
          SizedBox(
            width: 72,
            child: TextFormField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
              validator: (v) {
                final t = v?.trim() ?? '';
                if (t.isEmpty) return null;
                final n = double.tryParse(t);
                if (n == null || n < 0) return '';
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                isDense: true,
                hintText: '0',
                hintStyle: TextStyle(color: AppColors.smoke.withOpacity(0.6)),
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                filled: true,
                fillColor: AppColors.background.withOpacity(0.5),
                errorStyle: const TextStyle(height: 0, fontSize: 0),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(color: AppColors.gold, width: 1.5)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(color: AppColors.error)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(color: AppColors.error, width: 1.5)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 58,
            child: Text(unit,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ),
        ]),
      ),
    );
  }
}
