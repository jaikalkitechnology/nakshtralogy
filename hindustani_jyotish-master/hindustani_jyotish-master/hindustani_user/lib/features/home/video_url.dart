/// URL classification for the in-app video player: decides whether a video
/// URL is a YouTube page (→ embedded YouTube player), a direct media file
/// (→ native `video_player`), or neither (→ external open as last resort).
///
/// Kept as plain top-level functions (rather than private statics on the
/// player screen) so the routing decision that keeps playback INSIDE the
/// app is unit-testable against every URL shape admins actually paste.
library;

/// File extensions ExoPlayer/AVPlayer can realistically decode as a
/// progressive-download or streaming source.
const videoFileExtensions = {
  'mp4', 'm4v', 'mov', 'webm', 'mkv', 'avi', '3gp', 'ts', 'flv', 'wmv',
  'ogv', 'm3u8', 'mpd',
};

bool isYoutubeHost(String host) {
  final h = host.toLowerCase();
  return h == 'youtu.be' ||
      h == 'youtube.com' ||
      h.endsWith('.youtube.com') ||
      h == 'youtube-nocookie.com' ||
      h.endsWith('.youtube-nocookie.com');
}

/// Extracts the 11-char video ID from any common YouTube URL shape
/// (watch?v=, youtu.be/, /embed/, /shorts/, /live/, /v/), or null if [uri]
/// isn't a YouTube URL / the ID can't be found (channel pages, playlists…).
String? extractYoutubeId(Uri uri) {
  if (!isYoutubeHost(uri.host)) return null;
  if (uri.host.toLowerCase() == 'youtu.be') {
    return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
  }
  final v = uri.queryParameters['v'];
  if (v != null && v.isNotEmpty) return v;
  final segments = uri.pathSegments;
  for (final prefix in const ['embed', 'shorts', 'live', 'v']) {
    final idx = segments.indexOf(prefix);
    if (idx != -1 && idx + 1 < segments.length) return segments[idx + 1];
  }
  return null;
}

/// True only for URLs that point at an actual media resource (not a
/// YouTube page, which is handled separately via the embedded player).
bool isDirectVideoUrl(Uri uri) {
  if (isYoutubeHost(uri.host)) return false;
  final path = uri.path.toLowerCase();
  final dot = path.lastIndexOf('.');
  if (dot == -1) return false;
  return videoFileExtensions.contains(path.substring(dot + 1));
}
