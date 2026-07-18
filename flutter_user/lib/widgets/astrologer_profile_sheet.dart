import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme.dart';
import '../l10n/gen/app_localizations.dart';
import '../bloc/astrologer/astrologer_bloc.dart';
import '../bloc/astrologer/astrologer_event.dart';
import '../bloc/astrologer/astrologer_state.dart';
import '../services/api_service.dart';
import '../screens/communication/chat_screen.dart';
import '../screens/communication/call_screen.dart';

/// Bottom sheet that shows full astrologer profile with rate card and reviews.
/// Dispatches AstrologerDetailRequested when opened and clears on close.
Future<void> showAstrologerProfileSheet(BuildContext context, String astrologerId) {
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
      final result = await ApiService().initiateCall(astrologer['id'] as String, callType);
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
      final result = await ApiService().initiateChat(astrologer['id'] as String);
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
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: AppColors.card,
                              backgroundImage: a['profile_image_url'] != null
                                  ? NetworkImage(a['profile_image_url'] as String)
                                  : null,
                              child: a['profile_image_url'] == null
                                  ? const Text('🔮', style: TextStyle(fontSize: 32))
                                  : null,
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
                        _rateBox(Icons.chat_bubble_outline, l.chat, (a['rate_per_min_chat'] as num?)?.toDouble() ?? 0, l),
                        const SizedBox(width: 8),
                        _rateBox(Icons.call, l.astroVoice, (a['rate_per_min_call'] as num?)?.toDouble() ?? 0, l),
                        const SizedBox(width: 8),
                        _rateBox(Icons.videocam, l.video, (a['rate_per_min_video'] as num?)?.toDouble() ?? 0, l),
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

  Widget _rateBox(IconData icon, String label, double rate, AppLocalizations l) {
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
              '₹${rate.toInt()}${l.perMin}',
              style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
