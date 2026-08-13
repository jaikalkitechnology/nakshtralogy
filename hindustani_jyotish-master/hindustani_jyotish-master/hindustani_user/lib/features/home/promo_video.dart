/// A single item from `GET /promo-videos` (feature-video carousel on Home).
class PromoVideo {
  const PromoVideo({
    required this.id,
    required this.title,
    required this.videoUrl,
    this.thumbnailUrl,
  });

  final String id;
  final String title;
  final String videoUrl;
  final String? thumbnailUrl;

  factory PromoVideo.fromJson(Map<String, dynamic> j) => PromoVideo(
        id: j['id'] as String,
        title: j['title'] as String? ?? '',
        videoUrl: j['video_url'] as String,
        thumbnailUrl: j['thumbnail_url'] as String?,
      );
}
