// Proves the in-app video player's routing decision: every common YouTube
// URL shape must resolve to a video ID (→ embedded in-app player, NEVER a
// redirect to the YouTube app), direct media files go to the native
// player, and only genuinely unplayable links fall through to external.
import 'package:flutter_test/flutter_test.dart';
import 'package:hindustani_user/features/home/video_url.dart';

void main() {
  group('extractYoutubeId — every URL shape embeds in-app', () {
    const id = 'dQw4w9WgXcQ';
    final embeddable = <String>[
      'https://www.youtube.com/watch?v=$id',
      'https://youtube.com/watch?v=$id',
      'https://m.youtube.com/watch?v=$id&t=42s',
      'https://youtu.be/$id',
      'https://youtu.be/$id?si=SHARE_TOKEN',
      'https://www.youtube.com/embed/$id',
      'https://www.youtube.com/shorts/$id',
      'https://youtube.com/shorts/$id?feature=share',
      'https://www.youtube.com/live/$id',
      'https://www.youtube.com/v/$id',
      'https://www.youtube-nocookie.com/embed/$id',
    ];
    for (final url in embeddable) {
      test(url, () {
        expect(extractYoutubeId(Uri.parse(url)), id);
      });
    }

    test('non-YouTube URLs return null', () {
      expect(extractYoutubeId(Uri.parse('https://cdn.example.com/a.mp4')), isNull);
      expect(extractYoutubeId(Uri.parse('https://vimeo.com/12345')), isNull);
      // A lookalike host must not be treated as YouTube.
      expect(
          extractYoutubeId(Uri.parse('https://notyoutube.com/watch?v=x')), isNull);
      expect(extractYoutubeId(Uri.parse('https://youtu.be.evil.com/x')), isNull);
    });

    test('YouTube non-video pages (channel/playlist) return null', () {
      expect(
          extractYoutubeId(Uri.parse('https://www.youtube.com/@SomeChannel')),
          isNull);
      expect(
          extractYoutubeId(
              Uri.parse('https://www.youtube.com/playlist?list=PLx')),
          isNull);
    });
  });

  group('isDirectVideoUrl', () {
    test('media files are direct', () {
      for (final ext in ['mp4', 'm3u8', 'webm', 'mov']) {
        expect(isDirectVideoUrl(Uri.parse('https://cdn.example.com/v.$ext')),
            isTrue, reason: ext);
      }
      // Query strings after the extension are fine.
      expect(
          isDirectVideoUrl(
              Uri.parse('https://cdn.example.com/v.mp4?sig=abc&x=1')),
          isTrue);
    });

    test('YouTube pages and extension-less links are not direct', () {
      expect(
          isDirectVideoUrl(Uri.parse('https://www.youtube.com/watch?v=x')),
          isFalse);
      expect(isDirectVideoUrl(Uri.parse('https://example.com/watch')), isFalse);
      expect(isDirectVideoUrl(Uri.parse('https://example.com/page.html')),
          isFalse);
    });
  });
}
