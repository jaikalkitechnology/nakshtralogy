import 'dart:async';
import 'package:flutter/material.dart';
import '../l10n/gen/app_localizations.dart';
import '../screens/communication/live_viewer_screen.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'astro_avatar.dart';

/// "Live Now" row on the home screen, like YouTube's live avatars: every
/// astrologer streaming right now, as a photo with a red ring and a LIVE tag
/// over their name. Tapping one opens that stream (swipe for the others).
/// Renders nothing while no one is live, and re-checks every 30 seconds.
class LiveNowRow extends StatefulWidget {
  const LiveNowRow({super.key});
  @override
  State<LiveNowRow> createState() => _LiveNowRowState();
}

class _LiveNowRowState extends State<LiveNowRow> {
  final _api = ApiService();
  List<dynamic> _streams = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _load());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    List<dynamic> s;
    try {
      s = await _api.getActiveLiveStreams();
    } catch (_) {
      return; // keep what we had; the next tick retries
    }
    if (mounted) setState(() => _streams = s);
  }

  Future<void> _open(String streamId) async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => LiveReelsScreen(initialStreamId: streamId)));
    _load(); // the stream may have ended while the user watched
  }

  @override
  Widget build(BuildContext context) {
    if (_streams.isEmpty) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    final scale = MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, 1.4);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: AppColors.error, shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.error.withOpacity(0.6), blurRadius: 6)],
              ),
            ),
            const SizedBox(width: 8),
            Flexible(child: Text(l.liveNow, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontFamily: 'Manrope', color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w700))),
          ]),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 112 * scale,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _streams.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, i) {
              final s = _streams[i] as Map;
              final name = (s['host_name'] ?? l.astrologer).toString();
              final photo = (s['host_profile_image'] ?? s['host_avatar'])?.toString();
              return GestureDetector(
                onTap: () => _open(s['id'].toString()),
                child: SizedBox(
                  width: 76,
                  child: Column(children: [
                    _LiveAvatar(name: name, photo: photo, label: l.live.toUpperCase()),
                    const SizedBox(height: 8),
                    Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.ivory, fontSize: 11, fontWeight: FontWeight.w600)),
                  ]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}

/// Photo inside a red gradient ring with a red LIVE tag on its bottom edge.
class _LiveAvatar extends StatelessWidget {
  const _LiveAvatar({required this.name, required this.photo, required this.label});
  final String name;
  final String? photo;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72, height: 78,
      child: Stack(clipBehavior: Clip.none, alignment: Alignment.topCenter, children: [
        Container(
          width: 70, height: 70,
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFFF2D55), Color(0xFFFF6A00)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.background),
            child: AstroAvatar(imageUrl: photo, name: name, size: 60, ring: false),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 72),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFF0033),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.background, width: 1.5),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label, maxLines: 1,
                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
            ),
          ),
        ),
      ]),
    );
  }
}
