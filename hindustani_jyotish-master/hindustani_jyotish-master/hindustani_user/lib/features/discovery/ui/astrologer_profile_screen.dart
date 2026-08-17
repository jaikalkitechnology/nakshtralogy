import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/premium_ui.dart';
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
            final l = AppLocalizations.of(context);
            // Presentation-only derivations of the same data keys.
            final avg = double.tryParse('${_avgRatingOverride ?? a.avgRating}') ?? 0;
            final reviews = _reviewCountOverride ?? a.reviewCount;
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
                    const SizedBox(height: 12),
                    HeroGradientCard(
                      child: Column(
                        children: [
                          GestureDetector(
                            // Tap the photo to inspect it full-screen with
                            // pinch-zoom (shared viewer).
                            onTap: a.photoUrl == null
                                ? null
                                : () => showFullscreenImage(context, a.photoUrl!),
                            child: Container(
                              width: 104,
                              height: 104,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.gold.withValues(alpha: 0.55), width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.gold.withValues(alpha: 0.25),
                                    blurRadius: 22,
                                    spreadRadius: -4,
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: a.photoUrl == null
                                  ? ColoredBox(
                                      color: AppColors.indigoMid,
                                      child: Icon(Icons.person,
                                          size: 52, color: AppColors.copperLight))
                                  : CachedNetworkImage(imageUrl: a.photoUrl!, fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(a.displayName ?? 'Astrologer',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.display(size: 24)),
                          const SizedBox(height: 10),
                          _statusChip(a.isOnline, a.isLive),
                          const SizedBox(height: 14),
                          _StarRating(rating: avg, reviewCount: reviews),
                        ],
                      ),
                    ),
                    if (a.bio != null && a.bio!.isNotEmpty) ...[
                      SectionLabel(l.astroAbout),
                      PremiumCard(
                        child: Text(a.bio!,
                            style: AppTextStyles.body(size: 14, color: AppColors.ivoryDim)),
                      ),
                    ],
                    SectionLabel(l.astroDetails),
                    PremiumCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const IconTile(Icons.workspace_premium_rounded,
                                  tone: TileTone.gold, size: 40),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(l.astroExperience,
                                    style:
                                        AppTextStyles.body(size: 15, weight: FontWeight.w600)),
                              ),
                              Text('${a.yearsExperience} yrs',
                                  style: AppTextStyles.body(
                                      size: 14,
                                      weight: FontWeight.w700,
                                      color: AppColors.gold)),
                            ],
                          ),
                          if (a.languages.isNotEmpty) ...[
                            const _DetailDivider(),
                            _ChipBlock(label: l.astroLanguages, items: a.languages),
                          ],
                          if (a.skills.isNotEmpty) ...[
                            const _DetailDivider(),
                            _ChipBlock(label: l.astroSpecialities, items: a.skills),
                          ],
                        ],
                      ),
                    ),
                    SectionLabel(l.astroRates),
                    PremiumCard(
                      child: Column(
                        children: [
                          _RateLine(
                              icon: Icons.chat_bubble_rounded,
                              tone: TileTone.saffron,
                              label: 'Chat',
                              price: '₹${a.rateChatPerMsg}/msg'),
                          const _DetailDivider(),
                          _RateLine(
                              icon: Icons.call_rounded,
                              tone: TileTone.gold,
                              label: 'Audio Call',
                              price: '₹${a.rateCallPerMin}/min'),
                          const _DetailDivider(),
                          _RateLine(
                              icon: Icons.videocam_rounded,
                              tone: TileTone.info,
                              label: 'Video Call',
                              price: '₹${a.rateVideoPerMin}/min'),
                        ],
                      ),
                    ),
                    if (a.superChatPresets.isNotEmpty) ...[
                      SectionLabel(l.astroSuperChat),
                      // One Super Chat price per astrologer (like the
                      // chat/call/video rates above). Backend storage is
                      // still a list — the FIRST element is THE price;
                      // legacy rows may carry extra defaults, ignored here.
                      _SuperChatPriceCard(amount: a.superChatPresets.first),
                    ],
                    SectionLabel(l.astroConsultNow),
                    PremiumPrimaryButton(
                      label: 'Chat Now',
                      icon: Icons.chat_bubble_rounded,
                      onPressed:
                          _requesting ? null : () => _consult(ConsultationType.chat),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ConsultOutlineButton(
                            icon: Icons.call_rounded,
                            label: 'Audio Call',
                            onPressed:
                                _requesting ? null : () => _consult(ConsultationType.call),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ConsultOutlineButton(
                            icon: Icons.videocam_rounded,
                            label: 'Video Call',
                            onPressed:
                                _requesting ? null : () => _consult(ConsultationType.video),
                          ),
                        ),
                      ],
                    ),
                    if (!a.isOnline)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text('This astrologer is currently offline.',
                            style: AppTextStyles.label(size: 12, color: AppColors.ivoryFaint)),
                      ),
                    SectionLabel(l.astroRateThis),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

/// The header online/live status pill, mapped onto the shared [StatusChip].
Widget _statusChip(bool online, bool live) {
  if (live) {
    return const StatusChip('LIVE', tone: ChipTone.warn, icon: Icons.sensors_rounded);
  }
  if (online) {
    return const StatusChip('Online', tone: ChipTone.success, icon: Icons.circle);
  }
  return const StatusChip('Offline', tone: ChipTone.muted, icon: Icons.circle_outlined);
}

/// A gold five-star row rendered from the average [rating] (full / half /
/// outline), with the numeric average and the review count beside it.
class _StarRating extends StatelessWidget {
  const _StarRating({required this.rating, required this.reviewCount});
  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: Icon(
              rating >= i
                  ? Icons.star_rounded
                  : rating >= i - 0.5
                      ? Icons.star_half_rounded
                      : Icons.star_outline_rounded,
              size: 22,
              color: AppColors.gold,
            ),
          ),
        const SizedBox(width: 8),
        Text(rating.toStringAsFixed(1),
            style: AppTextStyles.body(
                size: 14, weight: FontWeight.w700, color: AppColors.gold)),
        const SizedBox(width: 6),
        Text('($reviewCount)',
            style: AppTextStyles.label(size: 12, color: AppColors.ivoryDim)),
      ],
    );
  }
}

/// Hairline divider between grouped rows inside a [PremiumCard].
class _DetailDivider extends StatelessWidget {
  const _DetailDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 14),
      color: AppColors.borderSoft,
    );
  }
}

/// A labelled cluster of pill chips (languages / specialities).
class _ChipBlock extends StatelessWidget {
  const _ChipBlock({required this.label, required this.items});
  final String label;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: AppTextStyles.label(
                size: 11, weight: FontWeight.w700, color: AppColors.ivoryFaint)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [for (final it in items) StatusChip(it, tone: ChipTone.muted)],
        ),
      ],
    );
  }
}

/// A single rate row (icon tile + label + coloured price) in the Rates card.
class _RateLine extends StatelessWidget {
  const _RateLine({
    required this.icon,
    required this.tone,
    required this.label,
    required this.price,
  });
  final IconData icon;
  final TileTone tone;
  final String label;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconTile(icon, tone: tone, size: 40),
        const SizedBox(width: 14),
        Expanded(
          child: Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body(size: 15, weight: FontWeight.w600)),
        ),
        Text(price,
            style: AppTextStyles.body(
                size: 14, weight: FontWeight.w700, color: AppColors.success)),
      ],
    );
  }
}

/// A gold-bordered secondary consult action (Audio / Video).
class _ConsultOutlineButton extends StatelessWidget {
  const _ConsultOutlineButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surface1,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.40)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: AppColors.gold),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body(
                          size: 14, weight: FontWeight.w700, color: AppColors.gold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The astrologer's single Super Chat price, on the shared [PremiumCard]
/// surface (not tappable — Super Chats are sent from the live stream).
class _SuperChatPriceCard extends StatelessWidget {
  const _SuperChatPriceCard({required this.amount});
  final String amount;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Row(
        children: [
          const IconTile(Icons.bolt_rounded, tone: TileTone.gold, size: 40),
          const SizedBox(width: 14),
          Expanded(
            child: Text('Super Chat',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body(size: 15, weight: FontWeight.w600)),
          ),
          Text('₹$amount',
              style: AppTextStyles.body(
                  size: 14, weight: FontWeight.w700, color: AppColors.success)),
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
    return PremiumCard(
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
                      i <= rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 34,
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
