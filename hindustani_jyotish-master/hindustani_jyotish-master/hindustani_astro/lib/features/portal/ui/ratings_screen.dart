import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../shared/premium_ui.dart';
import '../../../shared/responsive.dart';
import '../portal_repository.dart';

/// All ratings & reviews this astrologer has received — reviewer name,
/// stars, review text and date/time, newest first (GET /astrologer/reviews).
/// Loads incrementally: 50 per page, appending the next page as the
/// astrologer scrolls toward the end while the last page came back full.
class RatingsScreen extends StatefulWidget {
  const RatingsScreen({super.key});

  @override
  State<RatingsScreen> createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  static const _pageSize = 50;

  /// The last page fetched; [_PremiumReviews] drives when the next one loads.
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final repo = getIt<PortalRepository>();
    return Scaffold(
      appBar: AppBar(title: const Text('My Ratings & Reviews')),
      body: SafeArea(
        child: CenteredMaxWidth(
          maxWidth: 640,
          child: _PremiumReviews(
            pageSize: _pageSize,
            loader: () {
              _page = 1;
              return repo.myReviews(page: 1, pageSize: _pageSize);
            },
            loadMore: () => repo.myReviews(page: ++_page, pageSize: _pageSize),
            emptyText:
                'No ratings yet. Reviews appear here after customers rate '
                'their consultations with you.',
          ),
        ),
      ),
    );
  }
}

/// Premium presentation of the paginated reviews feed. Pure presentation over
/// the same repository calls: a gold summary hero (average + star row) followed
/// by one [PremiumCard] per review, with infinite scroll driven by [loadMore].
class _PremiumReviews extends StatefulWidget {
  const _PremiumReviews({
    required this.loader,
    this.loadMore,
    this.pageSize,
    this.emptyText = 'No ratings yet.',
  });

  /// Loads the first page.
  final Future<List<ReviewItem>> Function() loader;

  /// Loads the NEXT page each time it is invoked (the caller keeps its own
  /// page counter). Null disables load-more entirely (single-shot list).
  final Future<List<ReviewItem>> Function()? loadMore;

  /// The page size [loader]/[loadMore] fetch with — used to detect the last
  /// page (a batch shorter than this ends pagination).
  final int? pageSize;

  final String emptyText;

  @override
  State<_PremiumReviews> createState() => _PremiumReviewsState();
}

class _PremiumReviewsState extends State<_PremiumReviews> {
  List<ReviewItem>? _items;
  Object? _error;
  bool _loadingMore = false;
  bool _hasMore = false;

  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _loadFirst();
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  bool _batchEndsPagination(List<ReviewItem> batch) =>
      batch.isEmpty ||
      (widget.pageSize != null && batch.length < widget.pageSize!);

  Future<void> _loadFirst() async {
    try {
      final items = await widget.loader();
      if (!mounted) return;
      setState(() {
        _items = items;
        _hasMore = widget.loadMore != null && !_batchEndsPagination(items);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
      _fetchMore();
    }
  }

  Future<void> _fetchMore() async {
    final loadMore = widget.loadMore;
    if (loadMore == null || _loadingMore || !_hasMore || _items == null) return;
    setState(() => _loadingMore = true);
    try {
      final batch = await loadMore();
      if (!mounted) return;
      setState(() {
        _items = [..._items!, ...batch];
        _loadingMore = false;
        _hasMore = !_batchEndsPagination(batch);
      });
    } catch (_) {
      // Silently stop paging; reopening the screen retries.
      if (!mounted) return;
      setState(() {
        _loadingMore = false;
        _hasMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            _error is Exception
                ? _friendly(_error!)
                : 'Something went wrong. Please try again.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body(color: AppColors.danger),
          ),
        ),
      );
    }

    final items = _items;
    if (items == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(color: AppColors.saffron),
        ),
      );
    }

    if (items.isEmpty) {
      return _EmptyState(text: widget.emptyText);
    }

    // Header (summary hero + label) + one card per review + trailing spinner.
    final headerCount = 1;
    final tailCount = _loadingMore ? 1 : 0;
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      itemCount: headerCount + items.length + tailCount,
      itemBuilder: (_, i) {
        if (i == 0) return _SummaryHeader(items: items);
        final idx = i - 1;
        if (idx >= items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.saffron),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ReviewCard(item: items[idx]),
        );
      },
    );
  }

  static String _friendly(Object e) {
    // ApiException.message is already clean; anything else gets a generic
    // line — never a raw exception string.
    try {
      final dynamic err = e;
      final msg = err.message;
      if (msg is String && msg.isNotEmpty) return msg;
    } catch (_) {}
    return 'Something went wrong. Please try again.';
  }
}

/// Gold rating summary averaged over the loaded reviews.
class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({required this.items});

  final List<ReviewItem> items;

  @override
  Widget build(BuildContext context) {
    final count = items.length;
    final avg = count == 0
        ? 0.0
        : items.fold<int>(0, (sum, r) => sum + r.rating) / count;
    final countLabel = count == 1 ? '1 review' : '$count reviews';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeroGradientCard(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    avg.toStringAsFixed(1),
                    style: AppTextStyles.display(
                      size: 52,
                      weight: FontWeight.w700,
                      color: AppColors.goldLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  _StarRow(value: avg, size: 18),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Your rating',
                      style: AppTextStyles.label(
                        size: 12,
                        weight: FontWeight.w700,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Averaged across $countLabel from your seekers.',
                      style: AppTextStyles.body(
                        size: 13,
                        color: AppColors.ivoryDim,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SectionLabel(
          'Reviews',
          trailing: StatusChip(
            countLabel,
            tone: ChipTone.warn,
            icon: Icons.star_rounded,
          ),
        ),
      ],
    );
  }
}

/// One review as a soft premium card.
class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.item});

  final ReviewItem item;

  String? _dateLabel() {
    final dt = item.createdAt?.toLocal();
    if (dt == null) return null;
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year} · '
        '${two(dt.hour)}:${two(dt.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final name = item.userName?.trim().isNotEmpty == true
        ? item.userName!.trim()
        : 'Seeker';
    final date = _dateLabel();
    final review = item.review?.trim();

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.gold.withValues(alpha: 0.22),
                      AppColors.gold.withValues(alpha: 0.06),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.28),
                  ),
                ),
                child: Text(
                  name[0].toUpperCase(),
                  style: AppTextStyles.heading(
                    size: 15,
                    weight: FontWeight.w700,
                    color: AppColors.gold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.body(
                        size: 15,
                        weight: FontWeight.w700,
                        color: AppColors.ivory,
                      ),
                    ),
                    const SizedBox(height: 3),
                    _StarRow(value: item.rating.toDouble(), size: 14),
                  ],
                ),
              ),
              if (date != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 8),
                  child: Text(
                    date,
                    style: AppTextStyles.mono(
                      size: 10.5,
                      color: AppColors.ivoryFaint,
                    ),
                  ),
                ),
            ],
          ),
          if (review != null && review.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              review,
              style: AppTextStyles.body(
                size: 13.5,
                color: AppColors.ivoryDim,
              ).copyWith(height: 1.45),
            ),
          ],
        ],
      ),
    );
  }
}

/// A 5-star row (gold) for a rating [value], filling full / half / empty stars.
class _StarRow extends StatelessWidget {
  const _StarRow({required this.value, this.size = 16});

  final double value;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var s = 1; s <= 5; s++)
          Padding(
            padding: EdgeInsets.only(right: s < 5 ? 2 : 0),
            child: Icon(
              value >= s
                  ? Icons.star_rounded
                  : value >= s - 0.5
                      ? Icons.star_half_rounded
                      : Icons.star_outline_rounded,
              size: size,
              color: AppColors.gold,
            ),
          ),
      ],
    );
  }
}

/// Friendly "no reviews yet" placeholder.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const IconTile(Icons.reviews_outlined, tone: TileTone.gold, size: 56),
            const SizedBox(height: 18),
            Text(
              'No reviews yet',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading(size: 17, color: AppColors.ivory),
            ),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(size: 13.5, color: AppColors.ivoryFaint),
            ),
          ],
        ),
      ),
    );
  }
}
