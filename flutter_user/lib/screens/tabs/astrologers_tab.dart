import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../utils/money.dart';
import '../../theme/app_theme.dart';
import '../../widgets/astro_avatar.dart';
import '../../bloc/astrologer/astrologer_bloc.dart';
import '../../bloc/astrologer/astrologer_event.dart';
import '../../bloc/astrologer/astrologer_state.dart';
import '../../widgets/astrologer_profile_sheet.dart';
import '../../services/api_service.dart';
import '../communication/chat_screen.dart';
import '../communication/call_screen.dart';

class AstrologersTab extends StatefulWidget {
  const AstrologersTab({super.key});

  @override
  State<AstrologersTab> createState() => _AstrologersTabState();
}

class _AstrologersTabState extends State<AstrologersTab> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  String _selectedCategory = 'All';
  bool _onlineOnly = false;
  String? _selectedLanguage;

  static const _categories = ['All', 'Vedic', 'Tarot', 'Numerology', 'Kundli'];
  static const _languages = ['Hindi', 'English', 'Marathi', 'Gujarati', 'Tamil', 'Telugu', 'Kannada', 'Bengali', 'Punjabi', 'Malayalam'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFiltered();
      context.read<AstrologerBloc>().add(AstrologerSavedLoadRequested());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _loadFiltered() {
    context.read<AstrologerBloc>().add(AstrologerLoadRequested(
      limit: 50,
      search: _searchCtrl.text.isEmpty ? null : _searchCtrl.text,
      specialization: _selectedCategory == 'All' ? null : _selectedCategory,
      language: _selectedLanguage,
      onlineOnly: _onlineOnly,
    ));
  }

  void _onSearchChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _loadFiltered());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _searchField(),
        const SizedBox(height: 4),
        _categoryChipsRow(),
        const SizedBox(height: 8),
        _attributeChipsRow(),
        const SizedBox(height: 8),
        _resultHeader(),
        const SizedBox(height: 4),
        Expanded(
          child: BlocBuilder<AstrologerBloc, AstrologerState>(
            builder: (context, state) {
              if (state.loading && state.list.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColors.gold));
              }
              if (state.list.isEmpty) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)?.noAstrologersFound ?? 'No astrologers found',
                    style: const TextStyle(color: AppColors.smoke, fontSize: 12),
                  ),
                );
              }
              return RefreshIndicator(
                color: AppColors.gold,
                onRefresh: () async => _loadFiltered(),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                  itemCount: state.list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _AstroCard(
                    astro: state.list[i],
                    saved: state.savedIds.contains(state.list[i]['id']),
                    index: i,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------- SEARCH FIELD ----------
  Widget _searchField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.gold.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 14, color: AppColors.smoke),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              onChanged: _onSearchChanged,
              style: const TextStyle(
                color: AppColors.ivory,
                fontSize: 12,
                fontFamily: 'Manrope',
              ),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)?.searchByNameSpeciality ?? 'Search by name, speciality...',
                hintStyle: TextStyle(
                  color: AppColors.smoke,
                  fontSize: 12,
                  fontFamily: 'Manrope',
                ),
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- CATEGORY CHIPS (Row 1) ----------
  Widget _categoryChipsRow() {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final c = _categories[i];
          final active = _selectedCategory == c;
          return _chip(
            label: c,
            active: active,
            onTap: () { setState(() => _selectedCategory = c); _loadFiltered(); },
          );
        },
      ),
    );
  }

  Widget _attributeChipsRow() {
    return SizedBox(
      height: 30,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _chip(label: '● Online', active: _onlineOnly, onTap: () { setState(() => _onlineOnly = !_onlineOnly); _loadFiltered(); }),
          const SizedBox(width: 8),
          ..._languages.map((lang) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _chip(label: lang, active: _selectedLanguage == lang, onTap: () {
              setState(() => _selectedLanguage = _selectedLanguage == lang ? null : lang);
              _loadFiltered();
            }),
          )),
        ],
      ),
    );
  }

  Widget _chip({required String label, required bool active, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(colors: [AppColors.gold, AppColors.saffron])
              : null,
          color: active ? null : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? Colors.transparent : AppColors.gold.withOpacity(0.2),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Manrope',
            color: active ? AppColors.midnight : AppColors.ivory,
            fontSize: 10,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  // ---------- RESULT HEADER ----------
  Widget _resultHeader() {
    return BlocBuilder<AstrologerBloc, AstrologerState>(
      builder: (context, state) {
        final count = state.list.length;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                '$count ${AppLocalizations.of(context)?.astrologers ?? 'astrologers'} \u00b7 ${AppLocalizations.of(context)?.sortedByRating ?? 'Sorted by rating'}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: AppColors.smoke,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------- ASTROLOGER CARD ----------
class _AstroCard extends StatelessWidget {
  final dynamic astro;
  final bool saved;
  final int index;
  const _AstroCard({required this.astro, required this.saved, required this.index});

  Future<void> _startChat(BuildContext context, Map<String, dynamic> a) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)?.initiatingChat ?? 'Initiating chat...'), duration: const Duration(seconds: 2)),
    );
    try {
      final result = await ApiService().initiateChat(a['id'] as String);
      if (!context.mounted) return;
      if (result['statusCode'] == 200 || result['statusCode'] == 201) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ChatScreen(
            sessionId: result['id'] as String? ?? '',
            astrologerName: a['display_name'] ?? 'Astrologer',
            ratePerMin: (result['rate_per_min'] as num?)?.toDouble() ?? 0,
            ratePerSession: (result['rate_per_session'] as num?)?.toDouble() ?? 0,
            billingMode: result['billing_mode'] ?? 'per_session',
            sessionMessageLimit: result['session_message_limit'] ?? 45,
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['detail'] ?? 'Failed'), backgroundColor: AppColors.error),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _startCall(BuildContext context, Map<String, dynamic> a, String callType) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${AppLocalizations.of(context)?.startingCall ?? 'Starting call...'}'), duration: const Duration(seconds: 2)),
    );
    try {
      final result = await ApiService().initiateCall(a['id'] as String, callType);
      if (!context.mounted) return;
      if (result['statusCode'] == 200 || result['statusCode'] == 201) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CallScreen(
            callId: result['id'] as String? ?? '',
            channelName: result['channel_name'] as String? ?? '',
            agoraToken: result['agora_token'] as String? ?? '',
            agoraAppId: result['agora_app_id'] as String? ?? '',
            callType: callType,
            astrologerName: a['display_name'] ?? 'Astrologer',
            ratePerMin: (result['rate_per_min'] as num?)?.toDouble() ?? 0,
            eligibleMinutes: result['eligible_minutes'] ?? 0,
            maxCallSeconds: result['max_call_seconds'] ?? 0,
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['detail'] ?? 'Failed'), backgroundColor: AppColors.error),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final a = (astro is Map) ? Map<String, dynamic>.from(astro as Map) : <String, dynamic>{};
    final rating = (a['rating'] as num?)?.toDouble() ?? 0.0;
    final reviews = (a['total_reviews'] as num?)?.toInt() ?? 0;
    final years = (a['experience_years'] as num?)?.toInt() ?? 0;
    final isOnline = a['is_online'] == true && a['is_busy'] != true;
    final isBusy = a['is_busy'] == true;
    final name = (a['display_name'] ?? '\u2014').toString();

    final specs = (a['specializations'] as List?)?.cast<dynamic>() ?? const [];
    final specTail = specs.isNotEmpty ? specs.take(2).join(' \u00b7 ') : 'Astrologer';
    final specLine = years > 0 ? '$specTail \u00b7 $years ${l?.yrs ?? 'yrs'}' : specTail;

    // Region-aware chat rate label: USD for international (5× rule), ₹ for India.
    final _rateCur = (a['session_currency'] as String?) ?? 'INR';
    final _rateVal = (a['rate_chat_display'] as num?)?.toDouble() ??
        (a['rate_per_min_chat'] as num?)?.toDouble() ?? 0;
    final chatRateLabel = _rateCur.toUpperCase() == 'USD'
        ? Money.format(_rateVal, currency: 'USD', decimals: 2)
        : Money.format(_rateVal, currency: 'INR', decimals: 0);

    // Reviews label e.g. 2.1k
    String reviewLabel(int n) {
      if (n >= 1000) {
        final v = n / 1000.0;
        return '${v.toStringAsFixed(v >= 10 ? 0 : 1)}k';
      }
      return n.toString();
    }

    return GestureDetector(
      onTap: () => showAstrologerProfileSheet(context, a['id'] as String),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.nebula.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gold.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            // Avatar with online dot
            Stack(
              children: [
                AstroAvatar(
                  imageUrl: ((a['profile_image_url'] ?? '').toString().isNotEmpty)
                      ? a['profile_image_url']?.toString()
                      : a['user_avatar']?.toString(),
                  name: (a['display_name'] ?? '').toString(),
                  size: 48,
                ),
                if (isOnline)
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.midnight, width: 2),
                      ),
                    ),
                  ),
                if (isBusy)
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFACC15),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.midnight, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      color: AppColors.ivory,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    specLine,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      color: AppColors.smoke,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\u2605 ${rating.toStringAsFixed(1)} (${reviewLabel(reviews)})',
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          color: AppColors.gold,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$chatRateLabel/min',
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          color: AppColors.smoke,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  // Discount badge — the astrologer's active offer.
                  if ((a['offer'] as Map?)?['label'] != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.gold.withOpacity(0.4)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.local_offer, size: 10, color: AppColors.gold),
                        const SizedBox(width: 3),
                        Text(
                          (a['offer'] as Map)['label'].toString(),
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            color: AppColors.gold,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ],
              ),
            ),
            // CTAs
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: isOnline ? () => _startChat(context, a) : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: isOnline
                          ? const LinearGradient(colors: [AppColors.gold, AppColors.saffron])
                          : null,
                      color: isOnline ? null : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: isOnline
                          ? null
                          : Border.all(color: AppColors.gold.withOpacity(0.2)),
                    ),
                    child: Text(
                      (l?.chat ?? 'CHAT').toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: isOnline ? AppColors.midnight : AppColors.smoke,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: isOnline ? () => _startCall(context, a, 'voice') : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: isOnline
                          ? const LinearGradient(colors: [AppColors.gold, AppColors.saffron])
                          : null,
                      color: isOnline ? null : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: isOnline
                          ? null
                          : Border.all(color: AppColors.gold.withOpacity(0.2)),
                    ),
                    child: Text(
                      (l?.call ?? 'CALL').toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: isOnline ? AppColors.midnight : AppColors.smoke,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            // Save / favorite
            IconButton(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              icon: Icon(
                saved ? Icons.favorite : Icons.favorite_border,
                color: saved ? AppColors.cosmicPink : AppColors.smoke,
                size: 18,
              ),
              onPressed: () {
                context.read<AstrologerBloc>().add(AstrologerToggleSave(a['id'] as String));
              },
            ),
          ],
        ),
      ),
    );
  }
}
