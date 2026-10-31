import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

/// Auto-sliding promotional banner carousel shown on the home screen.
/// Banners are admin-managed; tapping one opens its link (if set). The widget
/// renders nothing when there are no active banners.
///
/// With 2+ banners it rotates every [_interval], always moving forward in an
/// endless loop (last → first slides on, not back across every banner). It
/// pauses while the user is touching it and restarts the countdown after.
class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});
  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  static const _interval = Duration(seconds: 4);
  // Endless loop: start far from page 0 so the user can swipe back too.
  static const _loopStart = 10000;

  final _api = ApiService();
  PageController _pc = PageController();
  List<dynamic> _banners = [];
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pc.dispose();
    super.dispose();
  }

  bool get _loops => _banners.length > 1;

  Future<void> _load() async {
    final b = await _api.getBanners();
    if (!mounted) return;
    setState(() {
      _banners = b;
      _index = 0;
      _pc.dispose();
      _pc = PageController(initialPage: _loops ? _loopStart - _loopStart % b.length : 0);
    });
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (!_loops) return;
    _timer = Timer.periodic(_interval, (_) {
      if (!mounted || !_pc.hasClients) return;
      _pc.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  void _pauseAutoPlay() => _timer?.cancel();

  Future<void> _open(String? link) async {
    if (link == null || link.isEmpty) return;
    try {
      await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_banners.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 7,
          child: Listener(
            // Hold still while the user touches / swipes; resume afterwards.
            onPointerDown: (_) => _pauseAutoPlay(),
            onPointerUp: (_) => _startAutoPlay(),
            onPointerCancel: (_) => _startAutoPlay(),
            child: PageView.builder(
              controller: _pc,
              itemCount: _loops ? null : _banners.length,
              onPageChanged: (i) => setState(() => _index = i % _banners.length),
              itemBuilder: (_, i) {
                final b = _banners[i % _banners.length] as Map;
                final url = ApiService.resolveMediaUrl((b['image_url'] ?? '').toString());
                return GestureDetector(
                  onTap: () => _open(b['link_url']?.toString()),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: AppColors.nebula),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      headers: _api.mediaHeadersFor((b['image_url'] ?? '').toString()),
                      errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image, color: AppColors.smoke)),
                      loadingBuilder: (ctx, child, p) =>
                          p == null ? child : const Center(child: CircularProgressIndicator(color: AppColors.gold, strokeWidth: 2)),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (_banners.length > 1) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _banners.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _index ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i == _index ? AppColors.gold : AppColors.smoke.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
