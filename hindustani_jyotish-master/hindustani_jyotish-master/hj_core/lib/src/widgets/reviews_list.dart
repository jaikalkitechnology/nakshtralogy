// Shared ratings/reviews list — used by the user app's "View All Ratings &
// Reviews" sheet on an astrologer profile and the astrologer app's own
// Ratings screen. Rows carry the reviewer's name, star rating, date/time
// and the review text (rating-only rows render without text).

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// One review row as returned by GET /astrologers/{id}/reviews and
/// GET /astrologer/reviews.
class ReviewItem {
  const ReviewItem({
    required this.rating,
    this.userName,
    this.review,
    this.createdAt,
  });

  factory ReviewItem.fromJson(Map<String, dynamic> j) => ReviewItem(
        rating: (j['rating'] as num?)?.toInt() ?? 0,
        userName: j['user_name'] as String?,
        review: j['review'] as String?,
        createdAt: j['created_at'] is String
            ? DateTime.tryParse(j['created_at'] as String)
            : null,
      );

  final int rating;
  final String? userName;
  final String? review;
  final DateTime? createdAt;
}

/// Scrollable list of reviews fed by [loader] (the repository's paginated
/// reviews call for page 1). Handles loading, error (message already
/// user-friendly via ApiClient) and empty states itself.
///
/// Pass [loadMore] (plus the matching [pageSize]) to enable infinite scroll:
/// when the user nears the end of the list the next page is fetched and
/// appended. A batch shorter than [pageSize] (or empty) marks the end.
class ReviewsList extends StatefulWidget {
  const ReviewsList({
    super.key,
    required this.loader,
    this.loadMore,
    this.pageSize,
    this.emptyText = 'No ratings yet.',
    this.controller,
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 24),
  });

  /// Loads the first page.
  final Future<List<ReviewItem>> Function() loader;

  /// Loads the NEXT page each time it is invoked (the caller keeps its own
  /// page counter). Null disables load-more entirely (single-shot list).
  final Future<List<ReviewItem>> Function()? loadMore;

  /// The page size [loader]/[loadMore] fetch with — used to detect the last
  /// page (a batch shorter than this ends pagination). When null, pagination
  /// only stops on an empty batch.
  final int? pageSize;

  final String emptyText;
  final ScrollController? controller;
  final EdgeInsets padding;

  @override
  State<ReviewsList> createState() => _ReviewsListState();
}

class _ReviewsListState extends State<ReviewsList> {
  List<ReviewItem>? _items;
  Object? _error;
  bool _loadingMore = false;
  bool _hasMore = false;

  ScrollController? _ownController;
  ScrollController get _scroll =>
      widget.controller ?? (_ownController ??= ScrollController());

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _loadFirst();
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _ownController?.dispose();
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
      // Silently stop paging; pull-to-refresh / reopening retries.
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
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(widget.emptyText,
              style: AppTextStyles.body(color: AppColors.ivoryFaint)),
        ),
      );
    }
    return ListView.builder(
      controller: _scroll,
      padding: widget.padding,
      itemCount: items.length + (_loadingMore ? 1 : 0),
      itemBuilder: (_, i) {
        if (i >= items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.saffron),
            ),
          );
        }
        return _ReviewRow(item: items[i]);
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

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.item});
  final ReviewItem item;

  String? _dateLabel() {
    final dt = item.createdAt?.toLocal();
    if (dt == null) return null;
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year} · ${two(dt.hour)}:${two(dt.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final name = item.userName?.trim().isNotEmpty == true
        ? item.userName!.trim()
        : 'Customer';
    final date = _dateLabel();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.surface2,
                child: Text(name[0].toUpperCase(),
                    style: AppTextStyles.body(
                        size: 14, weight: FontWeight.w700, color: AppColors.gold)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: AppTextStyles.body(
                            size: 14, weight: FontWeight.w700)),
                    if (date != null)
                      Text(date,
                          style: AppTextStyles.mono(
                              size: 11, color: AppColors.ivoryFaint)),
                  ],
                ),
              ),
              Row(
                children: [
                  for (var s = 1; s <= 5; s++)
                    Icon(
                      s <= item.rating ? Icons.star : Icons.star_border,
                      size: 16,
                      color: AppColors.gold,
                    ),
                ],
              ),
            ],
          ),
          if (item.review?.trim().isNotEmpty == true) ...[
            const SizedBox(height: 10),
            Text(item.review!.trim(),
                style:
                    AppTextStyles.body(size: 13, color: AppColors.ivoryDim)),
          ],
        ],
      ),
    );
  }
}
