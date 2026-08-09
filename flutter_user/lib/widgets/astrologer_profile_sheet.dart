import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme.dart';
import 'astro_avatar.dart';
import '../l10n/gen/app_localizations.dart';
import '../bloc/astrologer/astrologer_bloc.dart';
import '../bloc/astrologer/astrologer_event.dart';
import '../bloc/astrologer/astrologer_state.dart';
import '../services/api_service.dart';
import '../utils/coupon_labels.dart';
import '../utils/money.dart';
import '../screens/communication/chat_screen.dart';
import '../screens/communication/call_screen.dart';

/// Coupon code the user applied for the NEXT consultation (chat/call/video)
/// on this profile. Threaded into initiateChat/initiateCall so an admin/
/// astrologer code (e.g. a 100%-off) is honoured at billing. Reset each time
/// the sheet opens. File-scoped because only one profile sheet is open at once.
final ValueNotifier<String?> consultCouponCode = ValueNotifier<String?>(null);

/// Bottom sheet that shows full astrologer profile with rate card and reviews.
/// Dispatches AstrologerDetailRequested when opened and clears on close.
Future<void> showAstrologerProfileSheet(BuildContext context, String astrologerId) {
  consultCouponCode.value = null;
  context.read<AstrologerBloc>().add(AstrologerDetailRequested(astrologerId));
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _AstrologerProfileSheet(),
  ).whenComplete(() {
    if (context.mounted) {
      context.read<AstrologerBloc>().add(AstrologerDetailCleared());
    }
  });
}

class _AstrologerProfileSheet extends StatelessWidget {
  const _AstrologerProfileSheet();

  Future<void> _startCall(BuildContext context, Map<String, dynamic> astrologer, String callType) async {
    final l = AppLocalizations.of(context)!;
    Navigator.pop(context);
    final scaffold = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);

    scaffold.showSnackBar(SnackBar(content: Text(l.startingCall), duration: const Duration(seconds: 2)));

    try {
      final result = await ApiService().initiateCall(astrologer['id'] as String, callType, couponCode: consultCouponCode.value);
      if (result['statusCode'] == 200 || result['statusCode'] == 201) {
        nav.push(MaterialPageRoute(builder: (_) => CallScreen(
          callId: result['id'] as String? ?? '',
          channelName: result['channel_name'] as String? ?? '',
          agoraToken: result['agora_token'] as String? ?? '',
          agoraAppId: result['agora_app_id'] as String? ?? '',
          callType: callType,
          astrologerName: astrologer['display_name'] ?? l.astrologer,
          ratePerMin: (result['rate_per_min'] as num?)?.toDouble() ?? 0,
          eligibleMinutes: result['eligible_minutes'] as int? ?? 0,
          maxCallSeconds: result['max_call_seconds'] as int? ?? 0,
        )));
      } else {
        scaffold.showSnackBar(SnackBar(content: Text(result['detail'] ?? l.astroFailedStartCall), backgroundColor: AppColors.error));
      }
    } catch (e) {
      scaffold.showSnackBar(SnackBar(content: Text(l.astroErrorDetail(e.toString())), backgroundColor: AppColors.error));
    }
  }

  Future<void> _startChat(BuildContext context, Map<String, dynamic> astrologer) async {
    final l = AppLocalizations.of(context)!;
    Navigator.pop(context); // close the sheet
    final scaffold = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);

    scaffold.showSnackBar(SnackBar(content: Text(l.initiatingChat), duration: const Duration(seconds: 2)));

    try {
      final result = await ApiService().initiateChat(astrologer['id'] as String, couponCode: consultCouponCode.value);
      if (result['statusCode'] == 200 || result['statusCode'] == 201) {
        final sessionId = result['id'] as String? ?? '';
        final ratePerMin = (result['rate_per_min'] as num?)?.toDouble() ?? 0;
        final ratePerSession = (result['rate_per_session'] as num?)?.toDouble() ?? 0;
        final billingMode = result['billing_mode'] ?? 'per_session';
        final msgLimit = result['session_message_limit'] ?? 45;

        nav.push(MaterialPageRoute(builder: (_) => ChatScreen(
          sessionId: sessionId,
          astrologerName: astrologer['display_name'] ?? l.astrologer,
          ratePerMin: ratePerMin,
          ratePerSession: ratePerSession,
          billingMode: billingMode,
          sessionMessageLimit: msgLimit,
        )));
      } else {
        scaffold.showSnackBar(SnackBar(
          content: Text(result['detail'] ?? l.astroFailedStartChat),
          backgroundColor: AppColors.error,
        ));
      }
    } catch (e) {
      scaffold.showSnackBar(SnackBar(content: Text(l.astroErrorDetail(e.toString())), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollCtrl) => BlocBuilder<AstrologerBloc, AstrologerState>(
        builder: (context, state) {
          final l = AppLocalizations.of(context)!;
          if (state.detailLoading || state.detail == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(48),
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }
          final a = state.detail!;
          final reviews = state.detailReviews;
          final rating = (a['rating'] as num?)?.toDouble() ?? 0.0;
          final isOnline = a['is_online'] == true && a['is_busy'] != true;
          final saved = state.savedIds.contains(a['id']);

          return Column(
            children: [
              // Grab handle
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Header
                    Row(
                      children: [
                        Stack(
                          children: [
                            AstroAvatar(
                              imageUrl: ((a['profile_image_url'] ?? '').toString().isNotEmpty)
                                  ? a['profile_image_url']?.toString()
                                  : a['user_avatar']?.toString(),
                              name: (a['display_name'] ?? '').toString(),
                              size: 80,
                            ),
                            if (isOnline)
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.background, width: 2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a['display_name'] ?? '—',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                (a['specializations'] as List?)?.join(', ') ?? l.astrologer,
                                style: const TextStyle(color: AppColors.primary, fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  ...List.generate(5, (i) => Icon(
                                    Icons.star,
                                    size: 14,
                                    color: i < rating.round()
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  )),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${rating.toStringAsFixed(1)} (${a['total_reviews'] ?? 0})',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            saved ? Icons.favorite : Icons.favorite_border,
                            color: saved ? AppColors.error : AppColors.textSecondary,
                          ),
                          onPressed: () {
                            context.read<AstrologerBloc>().add(AstrologerToggleSave(a['id'] as String));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Stats grid
                    Row(
                      children: [
                        _statBox(l.astroExperience, '${a['experience_years'] ?? 0} ${l.yrs}'),
                        const SizedBox(width: 8),
                        _statBox(l.astroSessions, '${a['total_consultations'] ?? 0}'),
                        const SizedBox(width: 8),
                        _statBox(l.astroMinutes, '${a['total_minutes'] ?? 0}'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // First-time / astrologer coupon offer
                    AstrologerCouponBanner(astrologerId: a['id'] as String),

                    // Bio
                    if (a['bio'] != null && (a['bio'] as String).isNotEmpty) ...[
                      Text(l.astroAbout, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          a['bio'] as String,
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Languages
                    if (((a['languages'] as List?) ?? []).isNotEmpty) ...[
                      Text(l.astroLanguages, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: (a['languages'] as List).map((lang) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(lang.toString(),
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 11)),
                        )).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Rate card
                    Text(l.astroRateCard, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _rateBox(Icons.chat_bubble_outline, l.chat,
                            (a['rate_chat_display'] as num?)?.toDouble() ?? (a['rate_per_min_chat'] as num?)?.toDouble() ?? 0,
                            (a['session_currency'] as String?) ?? 'INR', l),
                        const SizedBox(width: 8),
                        _rateBox(Icons.call, l.astroVoice,
                            (a['rate_call_display'] as num?)?.toDouble() ?? (a['rate_per_min_call'] as num?)?.toDouble() ?? 0,
                            (a['session_currency'] as String?) ?? 'INR', l),
                        const SizedBox(width: 8),
                        _rateBox(Icons.videocam, l.video,
                            (a['rate_video_display'] as num?)?.toDouble() ?? (a['rate_per_min_video'] as num?)?.toDouble() ?? 0,
                            (a['session_currency'] as String?) ?? 'INR', l),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Reviews
                    Text(
                      l.astroReviews(reviews.length),
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                    ),
                    const SizedBox(height: 6),
                    if (reviews.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          l.astroNoReviews,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                        ),
                      )
                    else
                      ...reviews.map((r) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  r['user_name'] ?? l.astroAnonymous,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                ...List.generate(5, (i) => Icon(
                                  Icons.star,
                                  size: 11,
                                  color: i < (r['rating'] as num? ?? 0).round()
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                )),
                              ],
                            ),
                            if (r['comment'] != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                r['comment'] as String,
                                style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, height: 1.4),
                              ),
                            ],
                            const SizedBox(height: 4),
                            Text(
                              (r['created_at'] as String?)?.substring(0, 10) ?? '',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 9),
                            ),
                          ],
                        ),
                      )),
                    const SizedBox(height: 20),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: isOnline ? () => _startChat(context, a) : null,
                            icon: const Icon(Icons.chat_bubble_outline, size: 16),
                            label: Text(l.chat),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: isOnline ? () => _startCall(context, a, 'voice') : null,
                            icon: const Icon(Icons.call, size: 16),
                            label: Text(l.call),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: isOnline ? () => _startCall(context, a, 'video') : null,
                            icon: const Icon(Icons.videocam, size: 16),
                            label: Text(l.video),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _statBox(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _rateBox(IconData icon, String label, double rate, String currency, AppLocalizations l) {
    // International sessions show USD (5× rule); India shows ₹. USD keeps 2
    // decimals for per-minute rates; ₹ stays whole.
    final isUsd = currency.toUpperCase() == 'USD';
    final rateText = isUsd
        ? Money.format(rate, currency: 'USD', decimals: 2)
        : Money.format(rate, currency: 'INR', decimals: 0);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
            const SizedBox(height: 2),
            Text(
              '$rateText${l.perMin}',
              style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}


/// Shows an astrologer's active discount offer on their profile (auto-applied
/// at billing) AND a "Have a coupon code?" field so the user can apply an
/// astrologer or admin code (e.g. a 100%-off) to the NEXT chat/call/video.
/// The applied code is stored in [consultCouponCode] and passed to
/// initiateChat/initiateCall. Localized title from the backend; UI labels via
/// CouponLabels.
class AstrologerCouponBanner extends StatefulWidget {
  final String astrologerId;
  const AstrologerCouponBanner({super.key, required this.astrologerId});

  @override
  State<AstrologerCouponBanner> createState() => _AstrologerCouponBannerState();
}

class _AstrologerCouponBannerState extends State<AstrologerCouponBanner> {
  Map<String, dynamic>? _coupon;
  bool _used = false;
  bool _loaded = false;

  final _codeCtrl = TextEditingController();
  // Expanded by default so the code input + Apply button are always visible on
  // the profile — users shouldn't have to discover a hidden "Have a coupon?"
  // link first.
  bool _expanded = true;
  bool _busy = false;
  String? _appliedCode;   // mirrors consultCouponCode
  String? _msg;           // localized status
  bool _ok = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    Map<String, dynamic>? r;
    try {
      r = await ApiService().getAstrologerCoupon(widget.astrologerId);
    } catch (_) {/* offer stays hidden; the manual code field still shows */}
    if (!mounted) return;
    setState(() {
      _coupon = (r?['coupon'] as Map?)?.cast<String, dynamic>();
      _used = r?['already_used'] == true;
      _loaded = true;
    });
  }

  String _discountLabel() {
    final c = _coupon!;
    final type = c['discount_type']?.toString();
    final val = (c['discount_value'] as num?)?.toDouble() ?? 0;
    if (type == 'full') return '100%';
    if (type == 'flat') return '₹${val.toStringAsFixed(0)}';
    return '${val.toStringAsFixed(0)}%';
  }

  Future<void> _apply() async {
    final code = _codeCtrl.text.trim();
    if (code.isEmpty) return;
    setState(() { _busy = true; _msg = null; });
    // Validate against the chat scope — a consultation coupon covers
    // chat/call/video, so the actual scope is applied at billing.
    final r = await ApiService().validateCoupon(
      code: code, scope: 'chat', astrologerId: widget.astrologerId, baseAmount: 0);
    if (!mounted) return;
    if (r['valid'] == true) {
      consultCouponCode.value = code;
      setState(() {
        _appliedCode = code; _ok = true; _busy = false;
        _msg = CouponLabels.of(context, 'applied');
      });
    } else {
      consultCouponCode.value = null;
      setState(() {
        _appliedCode = null; _ok = false; _busy = false;
        _msg = CouponLabels.of(context, 'reason_${r['reason'] ?? 'invalid'}');
      });
    }
  }

  void _remove() {
    consultCouponCode.value = null;
    setState(() { _appliedCode = null; _ok = false; _msg = null; _codeCtrl.clear(); });
  }

  @override
  Widget build(BuildContext context) {
    // The manual code field renders immediately (even before the offer loads or
    // if the offer lookup fails), so the coupon input + Apply button are always
    // available. The astrologer's own offer banner appears once loaded.
    return Column(children: [
      if (_loaded && _coupon != null) _offerBanner(),
      _codeField(),
      const SizedBox(height: 16),
    ]);
  }

  void _applyAstroCode(String code) {
    _codeCtrl.text = code;
    consultCouponCode.value = code;
    setState(() { _appliedCode = code; _ok = true; _expanded = true; _msg = CouponLabels.of(context, 'applied'); });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${CouponLabels.of(context, 'applied')} · $code'),
      backgroundColor: AppColors.success, duration: const Duration(seconds: 2)));
  }

  Future<void> _copyCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Code $code copied'), duration: const Duration(seconds: 2)));
  }

  Widget _offerBanner() {
    final c = _coupon!;
    final title = (c['title'] ?? '').toString();
    final off = _discountLabel();
    final code = (c['code'] ?? '').toString();
    final audienceAll = c['first_time_only'] == false;
    final grey = _used;
    final color = grey ? AppColors.textSecondary : AppColors.gold;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: grey
            ? null
            : LinearGradient(colors: [AppColors.gold.withOpacity(0.16), AppColors.card.withOpacity(0.3)]),
        color: grey ? AppColors.card.withOpacity(0.4) : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(grey ? Icons.check_circle_outline : Icons.local_offer, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                grey ? CouponLabels.of(context, 'alreadyUsed')
                     : (title.isNotEmpty ? title : '$off ${audienceAll ? 'offer' : CouponLabels.of(context, 'firstTimeOffer')}'),
                style: TextStyle(color: grey ? AppColors.textSecondary : AppColors.textPrimary,
                    fontSize: 13, fontWeight: FontWeight.w700),
              ),
              if (!grey)
                Text('$off · chat / call / video${audienceAll ? '' : ' · ${CouponLabels.of(context, 'firstTimeOffer')}'}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            ]),
          ),
          if (!grey)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(8)),
              child: Text(off, style: const TextStyle(color: AppColors.midnight, fontSize: 13, fontWeight: FontWeight.w800)),
            ),
        ]),
        // Code row — copy + one-tap apply (when the offer carries a code).
        if (!grey && code.isNotEmpty) ...[
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gold.withOpacity(0.4), style: BorderStyle.solid),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(code, style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800, letterSpacing: 1)),
                  GestureDetector(
                    onTap: () => _copyCode(code),
                    child: const Icon(Icons.copy, size: 16, color: AppColors.textSecondary),
                  ),
                ]),
              ),
            ),
            const SizedBox(width: 8),
            _appliedCode == code
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.check_circle, color: AppColors.success, size: 22))
                : ElevatedButton(
                    onPressed: () => _applyAstroCode(code),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold, foregroundColor: AppColors.midnight,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
                    child: Text(CouponLabels.of(context, 'apply'), style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
          ]),
        ],
        if (!grey && code.isEmpty) ...[
          const SizedBox(height: 6),
          Text('Applied automatically — no code needed',
              style: TextStyle(color: AppColors.success.withOpacity(0.9), fontSize: 11)),
        ],
      ]),
    );
  }

  Widget _codeField() {
    if (!_expanded && _appliedCode == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => setState(() => _expanded = true),
          icon: const Icon(Icons.local_activity_outlined, size: 18, color: AppColors.gold),
          label: Text(CouponLabels.of(context, 'haveCoupon'),
              style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600, fontSize: 13)),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: (_ok ? AppColors.success : AppColors.border).withOpacity(0.5)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.local_activity_outlined, size: 16, color: AppColors.gold),
          const SizedBox(width: 6),
          Text(CouponLabels.of(context, 'haveCoupon'),
              style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600, fontSize: 12)),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _codeCtrl,
              enabled: _appliedCode == null && !_busy,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
              decoration: InputDecoration(
                isDense: true,
                hintText: CouponLabels.of(context, 'enterCode'),
                hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                border: InputBorder.none,
              ),
            ),
          ),
          _appliedCode == null
              ? TextButton(
                  onPressed: _busy ? null : _apply,
                  child: _busy
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold))
                      : Text(CouponLabels.of(context, 'apply'),
                          style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700)))
              : TextButton(
                  onPressed: _remove,
                  child: Text(CouponLabels.of(context, 'remove'),
                      style: const TextStyle(color: AppColors.textSecondary))),
        ]),
        if (_msg != null)
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 2),
            child: Text(_ok ? '${CouponLabels.of(context, 'applied')} · chat / call / video' : _msg!,
                style: TextStyle(color: _ok ? AppColors.success : AppColors.error, fontSize: 11)),
          ),
      ]),
    );
  }
}
