import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../widgets/desktop_center.dart';
import '../../utils/astro_labels.dart';
import '../../l10n/gen/app_localizations.dart';

/// What clients said after a completed chat/voice/video session with this
/// astrologer — rating, review text, who left it, and when. Read-only;
/// reviews are written by users (via POST /comm/review) after a completed
/// session, never by the astrologer themselves.
class MyReviewsScreen extends StatefulWidget {
  final String astrologerProfileId;
  final double initialRating;
  final int initialTotalReviews;

  const MyReviewsScreen({
    super.key,
    required this.astrologerProfileId,
    this.initialRating = 0,
    this.initialTotalReviews = 0,
  });

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  final _api = ApiService();
  static const _pageSize = 20;

  List<dynamic> _items = [];
  double _rating = 0;
  int _total = 0;
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // widget.initial* can't be read in a field initializer (`widget` isn't
    // attached to the State yet at that point) — set them here instead.
    _rating = widget.initialRating;
    _total = widget.initialTotalReviews;
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    final res = await _api.getMyReviews(widget.astrologerProfileId, skip: 0, limit: _pageSize);
    if (!mounted) return;
    if (res['statusCode'] == 200) {
      setState(() {
        _items = (res['reviews'] as List?) ?? const [];
        _total = (res['total'] as num?)?.toInt() ?? _items.length;
        _rating = (res['rating'] as num?)?.toDouble() ?? _rating;
        _loading = false;
      });
    } else {
      setState(() { _loading = false; _error = 'Could not load your reviews.'; });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || _items.length >= _total) return;
    setState(() => _loadingMore = true);
    final res = await _api.getMyReviews(widget.astrologerProfileId, skip: _items.length, limit: _pageSize);
    if (!mounted) return;
    if (res['statusCode'] == 200) {
      setState(() {
        _items = [..._items, ...((res['reviews'] as List?) ?? const [])];
        _total = (res['total'] as num?)?.toInt() ?? _total;
        _loadingMore = false;
      });
    } else {
      setState(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasMore = _items.length < _total;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(AstroLabels.of(context, 'myReviews'), style: const TextStyle(color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: DesktopCenter(
        maxWidth: 900,
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
            : _error != null
                ? Center(child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(_error!, style: const TextStyle(color: AppColors.textSecondary)),
                  ))
                : RefreshIndicator(
                    color: AppColors.gold,
                    onRefresh: _load,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _SummaryCard(rating: _rating, total: _total),
                        const SizedBox(height: 16),
                        if (_items.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 60),
                            child: Column(children: [
                              const Icon(Icons.rate_review_outlined, color: AppColors.textSecondary, size: 48),
                              const SizedBox(height: 12),
                              Text(AstroLabels.of(context, 'noReviewsYet'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: AppColors.textSecondary)),
                            ]),
                          )
                        else ...[
                          ...List.generate(_items.length, (i) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _ReviewCard(review: _items[i] as Map<String, dynamic>),
                              )),
                          if (hasMore)
                            Center(
                              child: TextButton(
                                onPressed: _loadingMore ? null : _loadMore,
                                child: _loadingMore
                                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold))
                                    : Text(AstroLabels.of(context, 'reviewSeeMore'),
                                        style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700)),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double rating;
  final int total;
  const _SummaryCard({required this.rating, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        Text(rating.toStringAsFixed(1),
            style: const TextStyle(color: AppColors.gold, fontSize: 32, fontWeight: FontWeight.w800)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: List.generate(5, (i) => Icon(
                  i < rating.round() ? Icons.star : Icons.star_border,
                  color: AppColors.gold,
                  size: 18,
                ))),
            const SizedBox(height: 4),
            Text('$total ${AppLocalizations.of(context)!.reviews}',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ]),
        ),
      ]),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final rating = (review['rating'] as num?)?.toDouble() ?? 0;
    final comment = review['comment'] as String?;
    final name = (review['user_name'] as String?)?.trim();
    final avatar = (review['user_avatar'] as String?) ?? '';
    final createdAt = (review['created_at'] as String?)?.substring(0, 10) ?? '';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.gold.withOpacity(0.15),
          backgroundImage: avatar.isNotEmpty
              ? NetworkImage(
                  ApiService.resolveMediaUrl(avatar),
                  headers: ApiService().mediaHeadersFor(avatar),
                )
              : null,
          child: avatar.isEmpty
              ? Text((name?.isNotEmpty ?? false) ? name![0].toUpperCase() : '?',
                  style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700))
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(
                  (name?.isNotEmpty ?? false) ? name! : AstroLabels.of(context, 'anonymousUser'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              ...List.generate(5, (i) => Icon(
                    Icons.star,
                    size: 13,
                    color: i < rating.round() ? AppColors.gold : AppColors.textSecondary.withOpacity(0.4),
                  )),
            ]),
            if (comment != null && comment.trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(comment, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12.5, height: 1.4)),
            ],
            const SizedBox(height: 6),
            Text(createdAt, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
          ]),
        ),
      ]),
    );
  }
}
