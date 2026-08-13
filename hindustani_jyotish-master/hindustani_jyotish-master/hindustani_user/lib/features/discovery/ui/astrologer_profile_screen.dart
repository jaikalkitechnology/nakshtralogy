import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../shared/responsive.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/fullscreen_image.dart';
import '../../consultation/consultation_repository.dart';
import '../discovery_repository.dart';

class AstrologerProfileScreen extends StatefulWidget {
  const AstrologerProfileScreen({super.key, required this.id});
  final String id;

  @override
  State<AstrologerProfileScreen> createState() => _AstrologerProfileScreenState();
}

class _AstrologerProfileScreenState extends State<AstrologerProfileScreen> {
  late Future<Astrologer> _future;
  bool _requesting = false;

  // Star-rating state (GET /my-rating + POST /rate).
  bool _canRate = false;
  int _myRating = 0;
  bool _submittingRating = false;
  // Fresher aggregates returned by POST /rate; shown until the next refresh.
  String? _avgRatingOverride;
  int? _reviewCountOverride;

  @override
  void initState() {
    super.initState();
    _future = getIt<DiscoveryRepository>().get(widget.id);
    _loadMyRating();
  }

  Future<void> _loadMyRating() async {
    try {
      final r = await getIt<DiscoveryRepository>().myRating(widget.id);
      if (mounted) {
        setState(() {
          _canRate = r.canRate;
          _myRating = r.rating ?? 0;
        });
      }
    } catch (_) {/* leave the stars disabled; refresh retries */}
  }

  Future<void> _refresh() async {
    final future = getIt<DiscoveryRepository>().get(widget.id);
    setState(() {
      _future = future;
      _avgRatingOverride = null;
      _reviewCountOverride = null;
    });
    _loadMyRating();
    try {
      await future;
    } catch (_) {/* FutureBuilder keeps showing the last loaded data */}
  }

  Future<void> _consult(ConsultationType type) async {
    setState(() => _requesting = true);
    try {
      final c = await getIt<ConsultationRepository>().request(widget.id, type);
      if (mounted) context.push('/consultation/${c.id}', extra: type);
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  Future<void> _rate(int stars) async {
    if (!_canRate) {
      // Preempt with the backend's own 403 message.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You have not consulted this astrologer yet. '
              'Please complete a consultation before rating.')));
      return;
    }
    if (_submittingRating) return;
    setState(() => _submittingRating = true);
    try {
      final res = await getIt<DiscoveryRepository>().rate(widget.id, stars);
      if (!mounted) return;
      setState(() {
        _myRating = (res['rating'] as num?)?.toInt() ?? stars;
        if (res['avg_rating'] != null) _avgRatingOverride = '${res['avg_rating']}';
        _reviewCountOverride = (res['review_count'] as num?)?.toInt() ?? _reviewCountOverride;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Thanks! Your rating has been saved.')));
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _submittingRating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CosmicBackground(
        child: FutureBuilder<Astrologer>(
          future: _future,
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator(color: AppColors.saffron));
            }
            final a = snap.data!;
            return SafeArea(
              top: false,
              child: RefreshIndicator(
                color: AppColors.saffron,
                onRefresh: _refresh,
                child: CenteredMaxWidth(
                  maxWidth: Responsive.readableMaxWidth,
                  child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  children: [
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            // Tap the photo to inspect it full-screen with
                            // pinch-zoom (shared viewer).
                            onTap: a.photoUrl == null
                                ? null
                                : () => showFullscreenImage(context, a.photoUrl!),
                            child: Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.borderMid, width: 2),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: a.photoUrl == null
                                  ? ColoredBox(
                                      color: AppColors.indigoMid,
                                      child: Icon(Icons.person, size: 48, color: AppColors.copperLight))
                                  : CachedNetworkImage(imageUrl: a.photoUrl!, fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(a.displayName ?? 'Astrologer', style: AppTextStyles.display(size: 24)),
                          const SizedBox(height: 6),
                          Text(a.skills.join(' · '),
                              style: AppTextStyles.label(color: AppColors.copperLight)),
                          const SizedBox(height: 8),
                          _StatusBadge(online: a.isOnline, live: a.isLive),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: _Stat(
                                    label: 'Rating',
                                    value: '⭐ ${_avgRatingOverride ?? a.avgRating}'),
                              ),
                              Flexible(
                                child: _Stat(
                                    label: 'Reviews',
                                    value: '${_reviewCountOverride ?? a.reviewCount}'),
                              ),
                              Flexible(
                                child: _Stat(
                                    label: 'Experience',
                                    value: '${a.yearsExperience} yrs'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (a.bio != null && a.bio!.isNotEmpty) ...[
                      Text('About', style: AppTextStyles.heading(size: 16)),
                      const SizedBox(height: 6),
                      Text(a.bio!, style: AppTextStyles.body(size: 14, color: AppColors.ivoryDim)),
                      const SizedBox(height: 20),
                    ],
                    Text('Languages', style: AppTextStyles.heading(size: 16)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final l in a.languages)
                          Chip(label: Text(l), backgroundColor: AppColors.surface2),
                      ],
                    ),
                    if (a.superChatPresets.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text('Super Chat', style: AppTextStyles.heading(size: 16)),
                      const SizedBox(height: 8),
                      // One Super Chat price per astrologer (like the
                      // chat/call/video rates below). Backend storage is
                      // still a list — the FIRST element is THE price;
                      // legacy rows may carry extra defaults, ignored here.
                      _SuperChatPriceCard(amount: a.superChatPresets.first),
                    ],
                    const SizedBox(height: 24),
                    Text('Consult Now', style: AppTextStyles.heading(size: 16)),
                    const SizedBox(height: 12),
                    _RateCard(
                      icon: Icons.chat_bubble_outline,
                      label: 'Chat',
                      price: '₹${a.rateChatPerMsg}/msg',
                      onTap: _requesting ? null : () => _consult(ConsultationType.chat),
                    ),
                    _RateCard(
                      icon: Icons.call,
                      label: 'Audio Call',
                      price: '₹${a.rateCallPerMin}/min',
                      onTap: _requesting ? null : () => _consult(ConsultationType.call),
                    ),
                    _RateCard(
                      icon: Icons.videocam_outlined,
                      label: 'Video Call',
                      price: '₹${a.rateVideoPerMin}/min',
                      onTap: _requesting ? null : () => _consult(ConsultationType.video),
                    ),
                    if (!a.isOnline)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text('This astrologer is currently offline.',
                            style: AppTextStyles.label(size: 12, color: AppColors.ivoryFaint)),
                      ),
                    const SizedBox(height: 24),
                    Text('Rate this astrologer', style: AppTextStyles.heading(size: 16)),
                    const SizedBox(height: 12),
                    _RatingCard(
                      canRate: _canRate,
                      submitting: _submittingRating,
                      rating: _myRating,
                      onRate: _rate,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => showAstrologerReviewsSheet(
                        context,
                        astrologerId: widget.id,
                        astrologerName: a.displayName ?? 'Astrologer',
                      ),
                      icon: const Icon(Icons.reviews_outlined),
                      label: Text(
                        'View All Ratings & Reviews (${_reviewCountOverride ?? a.reviewCount})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// All ratings & reviews for an astrologer, as a scrollable bottom sheet —
/// lets a seeker read the full feedback before starting a consultation.
/// Loads 50 reviews at a time and fetches the next page when scrolled to
/// the end (see [ReviewsList]'s loadMore support).
Future<void> showAstrologerReviewsSheet(
  BuildContext context, {
  required String astrologerId,
  required String astrologerName,
}) {
  const pageSize = 50;
  var page = 1;
  Future<List<ReviewItem>> fetch(int p) async => [
        for (final j in await getIt<DiscoveryRepository>()
            .reviews(astrologerId, page: p, pageSize: pageSize))
          ReviewItem.fromJson(j),
      ];
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.indigoDeep,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
            child: Row(
              children: [
                const Icon(Icons.reviews_outlined, color: AppColors.gold),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Ratings & Reviews — $astrologerName',
                      style: AppTextStyles.heading(size: 17)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReviewsList(
              controller: controller,
              pageSize: pageSize,
              loader: () {
                page = 1;
                return fetch(1);
              },
              loadMore: () => fetch(++page),
            ),
          ),
        ],
      ),
    ),
  );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.online, required this.live});
  final bool online;
  final bool live;

  @override
  Widget build(BuildContext context) {
    final color = live
        ? AppColors.live
        : online
            ? AppColors.success
            : AppColors.ivoryFaint;
    final label = live
        ? 'LIVE'
        : online
            ? 'Online'
            : 'Offline';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: AppTextStyles.label(size: 11, color: color)),
    );
  }
}

/// The astrologer's single Super Chat price, styled like the [_RateCard]s in
/// the "Consult Now" section (same surface/border/row layout, no chevron —
/// it isn't tappable; Super Chats are sent from the live stream).
class _SuperChatPriceCard extends StatelessWidget {
  const _SuperChatPriceCard({required this.amount});
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Row(
        children: [
          Icon(Icons.bolt, color: AppColors.gold),
          const SizedBox(width: 14),
          Expanded(
            child: Text('Super Chat',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body(size: 15, weight: FontWeight.w600)),
          ),
          Text('₹$amount', style: AppTextStyles.body(size: 14, color: AppColors.success)),
        ],
      ),
    );
  }
}

/// Five tappable stars. When the seeker hasn't completed a consultation the
/// stars render muted with an explanatory note; taps still reach [onRate] so
/// the screen can explain why rating is unavailable.
class _RatingCard extends StatelessWidget {
  const _RatingCard({
    required this.canRate,
    required this.submitting,
    required this.rating,
    required this.onRate,
  });
  final bool canRate;
  final bool submitting;
  final int rating;
  final ValueChanged<int> onRate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                InkWell(
                  onTap: submitting ? null : () => onRate(i),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Icon(
                      i <= rating ? Icons.star : Icons.star_border,
                      size: 32,
                      color: canRate ? AppColors.gold : AppColors.ivoryFaint,
                    ),
                  ),
                ),
            ],
          ),
          if (!canRate) ...[
            const SizedBox(height: 8),
            Text('Complete a consultation to rate.',
                style: AppTextStyles.label(size: 12, color: AppColors.ivoryFaint)),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body(size: 15, weight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.label(size: 11, color: AppColors.ivoryFaint)),
        ],
      ),
    );
  }
}

class _RateCard extends StatelessWidget {
  const _RateCard({required this.icon, required this.label, required this.price, this.onTap});
  final IconData icon;
  final String label;
  final String price;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.saffron),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(size: 15, weight: FontWeight.w600)),
            ),
            Text(price, style: AppTextStyles.body(size: 14, color: AppColors.success)),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: AppColors.ivoryFaint),
          ],
        ),
      ),
    );
  }
}
