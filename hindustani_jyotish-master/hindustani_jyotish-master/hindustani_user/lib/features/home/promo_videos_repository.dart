import 'package:hj_core/hj_core.dart';

import 'promo_video.dart';

/// Wraps `GET /promo-videos` — active feature-video items for the Home
/// carousel. Public, read-only marketing content.
class PromoVideosRepository {
  PromoVideosRepository(this._api);
  final ApiClient _api;

  Future<List<PromoVideo>> list() async {
    final res = await _api.get('/promo-videos');
    return (res as List)
        .map((e) => PromoVideo.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
