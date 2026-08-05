import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../l10n/gen/app_localizations.dart';

/// Premium, self-contained profile-photo picker with instant local preview.
///
/// Tapping the avatar opens a polished bottom sheet (Camera / Gallery / Remove).
/// The picked image previews immediately from the local file while it uploads;
/// on success [onUploaded] is invoked with the returned media path so the caller
/// can persist it to the profile. Uploaded avatars are served from an
/// auth-protected endpoint, so display uses [ApiService.mediaHeaders].
class AvatarPicker extends StatefulWidget {
  final double size;
  final String? imageUrl;
  final String fallbackInitial;
  final bool enabled;
  final Future<void> Function(String mediaUrl) onUploaded;
  final Future<void> Function()? onRemoved;

  const AvatarPicker({
    super.key,
    required this.size,
    required this.imageUrl,
    required this.fallbackInitial,
    required this.onUploaded,
    this.onRemoved,
    this.enabled = true,
  });

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  // Local preview bytes (web-safe: XFile.readAsBytes works on every platform,
  // avoiding a dart:io File which breaks the web build).
  Uint8List? _localBytes;
  bool _busy = false;

  bool get _hasImage => _localBytes != null || (widget.imageUrl != null && widget.imageUrl!.isNotEmpty);

  Future<void> _pick(ImageSource source) async {
    if (Navigator.canPop(context)) Navigator.pop(context);
    try {
      final x = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (x == null) return;
      final bytes = await x.readAsBytes();
      setState(() {
        _localBytes = bytes;
        _busy = true;
      });
      final resp = await ApiService().uploadChatFile(bytes, x.name);
      final url = resp['media_url'];
      final ok = (resp['statusCode'] == 200 || resp['statusCode'] == 201) && url is String && url.isNotEmpty;
      if (ok) {
        await widget.onUploaded(url as String);
        _snack(AppLocalizations.of(context)?.photoUpdated ?? 'Photo updated', AppColors.success);
      } else {
        setState(() => _localBytes = null);
        _snack(AppLocalizations.of(context)?.photoUploadFailed ?? 'Couldn\'t upload photo. Please try again.', AppColors.error);
      }
    } catch (_) {
      if (mounted) setState(() => _localBytes = null);
      _snack(AppLocalizations.of(context)?.photoUploadFailed ?? 'Couldn\'t upload photo. Please try again.', AppColors.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _remove() async {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() => _localBytes = null);
    if (widget.onRemoved != null) await widget.onRemoved!();
  }

  void _snack(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  void _openSheet() {
    final l = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.smoke.withOpacity(0.4), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 18),
          Text(l?.updatePhoto ?? 'Update Photo', style: const TextStyle(color: AppColors.ivory, fontSize: 17, fontWeight: FontWeight.w700, fontFamily: 'Manrope')),
          const SizedBox(height: 18),
          Row(children: [
            Expanded(child: _SheetTile(icon: Icons.photo_camera_rounded, label: l?.takePhoto ?? 'Camera', color: AppColors.gold, onTap: () => _pick(ImageSource.camera))),
            const SizedBox(width: 12),
            Expanded(child: _SheetTile(icon: Icons.photo_library_rounded, label: l?.chooseFromGallery ?? 'Gallery', color: AppColors.aurora, onTap: () => _pick(ImageSource.gallery))),
          ]),
          if (_hasImage) ...[
            const SizedBox(height: 12),
            _SheetTile(icon: Icons.delete_outline_rounded, label: l?.removePhoto ?? 'Remove Photo', color: AppColors.error, wide: true, onTap: _remove),
          ],
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l?.cancel ?? 'Cancel', style: const TextStyle(color: AppColors.smoke)),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    final l = AppLocalizations.of(context);
    return Semantics(
      button: widget.enabled,
      label: l?.updatePhoto ?? 'Update Photo',
      child: GestureDetector(
        onTap: widget.enabled && !_busy ? _openSheet : null,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: s,
                height: s,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [AppColors.gold, AppColors.saffron], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.25), blurRadius: 22, spreadRadius: 1)],
                ),
                padding: const EdgeInsets.all(3),
                child: ClipOval(child: _imageLayer(s - 6)),
              ),
              if (_busy)
                Container(
                  width: s, height: s,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.45)),
                  child: const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.gold))),
                ),
              if (widget.enabled)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: s * 0.32,
                    height: s * 0.32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(colors: [AppColors.gold, AppColors.saffron]),
                      border: Border.all(color: AppColors.background, width: 2.5),
                    ),
                    child: Icon(Icons.photo_camera_rounded, size: s * 0.16, color: AppColors.midnight),
                  ),
                ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget _imageLayer(double d) {
    if (_localBytes != null) {
      return Image.memory(_localBytes!, width: d, height: d, fit: BoxFit.cover);
    }
    final url = widget.imageUrl;
    if (url != null && url.isNotEmpty) {
      return Image.network(
        ApiService.resolveMediaUrl(url),
        width: d, height: d, fit: BoxFit.cover,
        headers: ApiService().mediaHeaders,
        loadingBuilder: (ctx, child, progress) => progress == null ? child : _fallback(d),
        errorBuilder: (_, __, ___) => _fallback(d),
      );
    }
    return _fallback(d);
  }

  Widget _fallback(double d) {
    return Container(
      width: d, height: d,
      color: AppColors.nebula,
      alignment: Alignment.center,
      child: Text(
        widget.fallbackInitial,
        style: TextStyle(color: AppColors.midnight, fontSize: d * 0.4, fontWeight: FontWeight.w800, fontFamily: 'Manrope'),
      ),
    );
  }
}

class _SheetTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool wide;
  const _SheetTile({required this.icon, required this.label, required this.color, required this.onTap, this.wide = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: wide ? 14 : 18, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.30)),
        ),
        child: wide
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(label, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
              ])
            : Column(children: [
                Icon(icon, color: color, size: 26),
                const SizedBox(height: 8),
                Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
              ]),
      ),
    );
  }
}
