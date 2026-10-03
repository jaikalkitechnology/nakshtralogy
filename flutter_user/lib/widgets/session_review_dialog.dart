import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

/// A rating + review prompt shown after a paid session (chat / voice / video)
/// ends. The user picks 1–5 stars and optionally leaves a comment; on submit it
/// POSTs to `/comm/review`. Skippable — never blocks the user.
///
/// If the user already reviewed this session, their existing rating/comment
/// is fetched and pre-filled on open (GET /comm/review/for-session/...) so
/// re-opening the dialog edits in place rather than risking a second,
/// duplicate review — the backend already upserts by session either way,
/// this just means the user sees what they said before instead of a blank
/// form.
///
/// Usage:
///   await showSessionReviewDialog(
///     context,
///     sessionType: 'video', sessionId: id, astrologerName: name,
///   );
Future<void> showSessionReviewDialog(
  BuildContext context, {
  required String sessionType,      // chat | voice | video
  required String sessionId,
  String? astrologerName,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => _SessionReviewDialog(
      sessionType: sessionType,
      sessionId: sessionId,
      astrologerName: astrologerName,
    ),
  );
}

class _SessionReviewDialog extends StatefulWidget {
  final String sessionType;
  final String sessionId;
  final String? astrologerName;

  const _SessionReviewDialog({
    required this.sessionType,
    required this.sessionId,
    this.astrologerName,
  });

  @override
  State<_SessionReviewDialog> createState() => _SessionReviewDialogState();
}

class _SessionReviewDialogState extends State<_SessionReviewDialog> {
  int _rating = 0;
  final _commentCtrl = TextEditingController();
  bool _submitting = false;
  bool _loadingExisting = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final existing = await ApiService().fetchExistingSessionReview(widget.sessionType, widget.sessionId);
    if (!mounted) return;
    setState(() {
      if (existing != null) {
        _rating = (existing['rating'] as num?)?.toInt() ?? 0;
        _commentCtrl.text = (existing['comment'] as String?) ?? '';
        _isEditing = _rating > 0;
      }
      _loadingExisting = false;
    });
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0 || _submitting) return;
    setState(() => _submitting = true);
    Map<String, dynamic>? result;
    try {
      result = await ApiService().submitSessionReview(
        sessionType: widget.sessionType,
        sessionId: widget.sessionId,
        rating: _rating,
        comment: _commentCtrl.text.trim(),
      );
    } catch (_) {}
    if (!mounted) return;
    Navigator.pop(context);
    final ok = (result?['statusCode'] as int?) == 200;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok
          ? (_isEditing ? 'Your review has been updated!' : 'Thanks for your feedback!')
          : (result?['detail']?.toString() ?? 'Could not submit your review. Please try again.')),
      backgroundColor: ok ? AppColors.success : AppColors.error,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final who = (widget.astrologerName != null && widget.astrologerName!.isNotEmpty)
        ? widget.astrologerName!
        : 'the astrologer';
    return AlertDialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('⭐', style: TextStyle(fontSize: 34)),
        const SizedBox(height: 6),
        Text(_isEditing ? 'Update your rating' : 'Rate your session',
            style: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text('How was your consultation with $who?',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.normal)),
      ]),
      content: _loadingExisting
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: SizedBox(
                width: 28, height: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary),
              )),
            )
          : Column(mainAxisSize: MainAxisSize.min, children: [
              // FittedBox: the five 40px stars are ~200px wide and overflowed the
              // dialog on narrow screens / large display-scale. Scale the row down to
              // fit when needed instead of clipping.
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(5, (i) {
                  final idx = i + 1;
                  return IconButton(
                    onPressed: () => setState(() => _rating = idx),
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      idx <= _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: idx <= _rating ? AppColors.primary : AppColors.textSecondary,
                      size: 36,
                    ),
                  );
                })),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _commentCtrl,
                maxLines: 3,
                maxLength: 500,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Share your experience (optional)',
                  hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  counterStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                  filled: true,
                  fillColor: AppColors.background.withOpacity(0.4),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ]),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.pop(context),
          child: const Text('Skip', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: (_rating == 0 || _submitting || _loadingExisting) ? null : _submit,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: _submitting
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Text(_isEditing ? 'Update' : 'Submit'),
        ),
      ],
    );
  }
}
