import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
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

  /// The last page fetched; [ReviewsList] drives when the next one loads.
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final repo = getIt<PortalRepository>();
    return Scaffold(
      appBar: AppBar(title: const Text('My Ratings & Reviews')),
      body: SafeArea(
        child: CenteredMaxWidth(
          maxWidth: 640,
          child: ReviewsList(
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
