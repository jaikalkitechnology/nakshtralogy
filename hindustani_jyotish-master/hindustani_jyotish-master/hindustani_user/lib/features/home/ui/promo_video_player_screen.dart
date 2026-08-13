import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../promo_video.dart';
import '../video_url.dart';

/// Full-screen playback for a single Home "Featured videos" item.
///
/// YouTube links (youtube.com / youtu.be / youtube-nocookie.com) play
/// embedded in-app via `youtube_player_iframe` — never redirected to the
/// YouTube app/browser. Direct media URLs (`.mp4` etc.) play via
/// `video_player`. Anything else (a link `video_player` can't decode and
/// isn't YouTube) falls back to opening externally, and a failed YouTube
/// embed (e.g. the owner disabled embedding) or a failed `video_player`
/// initialize is never a dead end: the error screen shows the real failure
/// detail plus Retry and "Open externally" actions.
class PromoVideoPlayerScreen extends StatefulWidget {
  const PromoVideoPlayerScreen({super.key, required this.video});

  final PromoVideo video;

  @override
  State<PromoVideoPlayerScreen> createState() => _PromoVideoPlayerScreenState();
}

class _PromoVideoPlayerScreenState extends State<PromoVideoPlayerScreen> {
  VideoPlayerController? _controller;
  YoutubePlayerController? _ytController;
  String? _errorDetail;
  bool _openingExternally = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final url = widget.video.videoUrl;
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      setState(() => _errorDetail = 'This video link is invalid.');
      return;
    }

    final ytId = extractYoutubeId(uri);
    if (ytId != null) {
      final controller = YoutubePlayerController.fromVideoId(
        videoId: ytId,
        autoPlay: true,
        params: const YoutubePlayerParams(showFullscreenButton: true),
      );
      _ytController = controller;
      controller.stream.listen((value) {
        if (!mounted) return;
        if (value.hasError) {
          debugPrint(
              '[PromoVideoPlayer] YouTube embed error for $url: ${value.error}');
          setState(() =>
              _errorDetail = 'This video cannot be embedded (${value.error.name}).');
        }
      });
      setState(() {});
      return;
    }

    if (!isDirectVideoUrl(uri)) {
      // Not something the native player can decode and not a YouTube link —
      // hand it to the system browser/app instead of letting initialize()
      // fail cryptically.
      debugPrint(
          '[PromoVideoPlayer] non-direct video URL, opening externally: $url');
      setState(() => _openingExternally = true);
      final launched = await _openExternally();
      if (!mounted) return;
      if (launched) {
        Navigator.of(context).maybePop();
      } else {
        setState(() {
          _openingExternally = false;
          _errorDetail =
              'This link is not a direct video file and could not be opened '
              'in another app.';
        });
      }
      return;
    }

    final controller = VideoPlayerController.networkUrl(uri);
    _controller = controller;
    try {
      await controller.initialize();
      if (!mounted) return;
      setState(() {});
      controller.play();
    } catch (e) {
      debugPrint('[PromoVideoPlayer] initialize failed for $url: $e');
      if (!mounted) return;
      setState(() => _errorDetail = '$e');
    }
  }

  Future<void> _retry() async {
    final oldVideo = _controller;
    final oldYt = _ytController;
    _controller = null;
    _ytController = null;
    setState(() => _errorDetail = null);
    await oldVideo?.dispose();
    await oldYt?.close();
    if (mounted) await _init();
  }

  /// Opens the raw video URL with the platform's default handler. Returns
  /// whether the launch succeeded; surfaces a SnackBar on failure when this
  /// was user-initiated (i.e. from the error screen's button).
  Future<bool> _openExternally({bool notifyOnFailure = false}) async {
    final uri = Uri.tryParse(widget.video.videoUrl);
    var ok = false;
    if (uri != null) {
      try {
        ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint(
            '[PromoVideoPlayer] external launch failed for $uri: $e');
      }
    }
    if (!ok && notifyOnFailure && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this video link.')),
      );
    }
    return ok;
  }

  @override
  void dispose() {
    _controller?.dispose();
    _ytController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final ytController = _ytController;
    final ready = controller != null && controller.value.isInitialized;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: _errorDetail != null
                  ? _ErrorPane(
                      detail: _errorDetail!,
                      onRetry: _retry,
                      onOpenExternally: () =>
                          _openExternally(notifyOnFailure: true),
                    )
                  : _openingExternally
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(
                                color: AppColors.saffron),
                            const SizedBox(height: 16),
                            Text(
                              'Opening video in another app…',
                              style:
                                  AppTextStyles.body(color: AppColors.ivory),
                            ),
                          ],
                        )
                      : ytController != null
                          ? YoutubePlayer(controller: ytController)
                          : ready
                              ? AspectRatio(
                                  aspectRatio:
                                      controller.value.aspectRatio == 0
                                          ? 16 / 9
                                          : controller.value.aspectRatio,
                                  child: GestureDetector(
                                    onTap: () => setState(() {
                                      controller.value.isPlaying
                                          ? controller.pause()
                                          : controller.play();
                                    }),
                                    child: VideoPlayer(controller),
                                  ),
                                )
                              : const CircularProgressIndicator(
                                  color: AppColors.saffron),
            ),
            if (ready)
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  colors: const VideoProgressColors(
                    playedColor: AppColors.saffron,
                    bufferedColor: Colors.white24,
                    backgroundColor: Colors.white12,
                  ),
                ),
              ),
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
            Positioned(
              top: 8,
              left: 56,
              right: 16,
              child: Text(
                widget.video.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body(size: 15, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Playback-failure state: headline, the REAL error detail (so a codec or
/// network problem is diagnosable from a screenshot), and two ways forward.
class _ErrorPane extends StatelessWidget {
  const _ErrorPane({
    required this.detail,
    required this.onRetry,
    required this.onOpenExternally,
  });

  final String detail;
  final VoidCallback onRetry;
  final VoidCallback onOpenExternally;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.saffron),
          const SizedBox(height: 16),
          Text(
            'Could not play this video.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body(size: 16, color: AppColors.ivory),
          ),
          const SizedBox(height: 8),
          Text(
            detail,
            textAlign: TextAlign.center,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body(size: 12, color: Colors.white60),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.saffron,
                  side: const BorderSide(color: AppColors.saffron),
                ),
              ),
              ElevatedButton.icon(
      // Explicit full width: the shared theme no longer forces an
      // (invalid) infinite minimum width on every ElevatedButton.
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                onPressed: onOpenExternally,
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open externally'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
