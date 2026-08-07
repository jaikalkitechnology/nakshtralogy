import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

/// Auto-sliding promotional banner carousel shown on the home screen.
/// Banners are admin-managed; tapping one opens its link (if set). The widget
/// renders nothing when there are no active banners.
class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});
  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final _api = ApiService();
  final _pc = PageController();
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

  Future<void> _load() async {
    final b = await _api.getBanners();
    if (!mounted) return;
    setState(() => _banners = b);
    _timer?.cancel();
    if (_banners.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (!mounted || !_pc.hasClients) return;
        final next = (_index + 1) % _banners.length;
        _pc.animateToPage(next, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      });
    }
  }

  Future<void> _open(String? link) async {
    if (link == null || link.isEmpty) return;
    try {
      await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_banners.isEmpty) return const SizedBox.shrink();
    return Column(children: [
      AspectRatio(
        aspectRatio: 16 / 7,
        child: PageView.builder(
          controller: _pc,
          itemCount: _banners.length,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (_, i) {
            final b = _banners[i] as Map;
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
                  loadingBuilder: (ctx, child, p) => p == null ? child : const Center(child: CircularProgressIndicator(color: AppColors.gold, strokeWidth: 2)),
                ),
              ),
            );
          },
        ),
      ),
      if (_banners.length > 1) ...[
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_banners.length, (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: i == _index ? 18 : 6, height: 6,
          decoration: BoxDecoration(
            color: i == _index ? AppColors.gold : AppColors.smoke.withOpacity(0.4),
            borderRadius: BorderRadius.circular(3),
          ),
        ))),
      ],
    ]);
  }
}
