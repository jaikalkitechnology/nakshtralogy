import 'package:hj_core/hj_core.dart';

/// One admin-configured home-screen banner (`GET /banners`).
class HomeBanner {
  const HomeBanner({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.linkUrl,
  });

  factory HomeBanner.fromJson(Map<String, dynamic> j) => HomeBanner(
        id: '${j['id']}',
        title: (j['title'] as String?) ?? '',
        imageUrl: (j['image_url'] as String?) ?? '',
        linkUrl: j['link_url'] as String?,
      );

  final String id;
  final String title;
  final String imageUrl;

  /// Optional tap-through URL; empty/null banners are display-only.
  final String? linkUrl;
}

/// Wraps `GET /banners` — active home-screen banners (admin console →
/// Banners) in display order. Public, read-only marketing content, rendered
/// above the Live section on Home.
class BannersRepository {
  BannersRepository(this._api);
  final ApiClient _api;

  Future<List<HomeBanner>> list() async {
    final res = await _api.get('/banners');
    return [
      for (final e in res as List)
        if (e is Map<String, dynamic>) HomeBanner.fromJson(e),
    ];
  }
}
