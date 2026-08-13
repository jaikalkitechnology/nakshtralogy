import 'package:hj_core/hj_core.dart';

class DiscoveryRepository {
  DiscoveryRepository(this._api);
  final ApiClient _api;

  Future<List<Astrologer>> list({
    bool? online,
    String? language,
    String? skill,
    String? search,
    String sort = 'top_rated',
    int page = 1,
    int pageSize = 20,
  }) async {
    final query = <String, dynamic>{
      'sort': sort,
      'page': page,
      'page_size': pageSize,
    };
    if (online != null) query['online'] = online;
    if (language != null && language.isNotEmpty) query['language'] = language;
    if (skill != null && skill.isNotEmpty) query['skill'] = skill;
    // `search` may be ignored by older backends; harmless if unrecognised.
    final trimmed = search?.trim() ?? '';
    if (trimmed.isNotEmpty) query['search'] = trimmed;
    final res = await _api.get('/astrologers', query: query);
    return (res as List)
        .map((e) => Astrologer.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Astrologer> get(String id) async {
    final res = await _api.get('/astrologers/$id');
    return Astrologer.fromJson(res as Map<String, dynamic>);
  }

  /// Rated consultations for this astrologer, newest first — each row
  /// carries `user_name`, `rating`, `review` and `created_at`.
  Future<List<Map<String, dynamic>>> reviews(
    String id, {
    int page = 1,
    int pageSize = 50,
  }) async {
    final res = await _api.get(
      '/astrologers/$id/reviews',
      query: {'page': page, 'page_size': pageSize},
    );
    return (res as List).cast<Map<String, dynamic>>();
  }

  Future<bool> toggleFollow(String id) async {
    final res = await _api.post('/astrologers/$id/follow');
    return res['following'] as bool;
  }

  /// Whether the caller may rate this astrologer (requires at least one
  /// completed consultation) plus any rating they have already given.
  Future<({bool canRate, int? rating})> myRating(String id) async {
    final res = await _api.get('/astrologers/$id/my-rating');
    return (
      canRate: (res['can_rate'] as bool?) ?? false,
      rating: (res['rating'] as num?)?.toInt(),
    );
  }

  /// Submit a 1-5 star rating. Returns `{rating, avg_rating, review_count}`;
  /// the backend rejects with 403 when the seeker has never consulted this
  /// astrologer.
  Future<Map<String, dynamic>> rate(String id, int rating) async {
    final res = await _api.post('/astrologers/$id/rate', body: {'rating': rating});
    return (res as Map).cast<String, dynamic>();
  }
}
