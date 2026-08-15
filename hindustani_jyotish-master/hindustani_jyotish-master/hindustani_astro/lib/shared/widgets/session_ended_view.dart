import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

/// Shown on the astrologer's live call/video and chat screens when a
/// lifecycle re-sync (see `AttendCallScreen`/`AttendChatScreen`'s
/// `WidgetsBindingObserver`) finds that the consultation has already ended
/// server-side — e.g. the backend's silent-heartbeat sweep auto-ended it
/// while this app was backgrounded. Replaces the live call/chat UI entirely
/// instead of leaving a dead screen up, and the caller auto-returns to
/// Requests shortly after; [onBackNow] lets the astrologer skip the wait.
class SessionEndedView extends StatelessWidget {
  const SessionEndedView({super.key, required this.onBackNow, this.detail});

  final VoidCallback onBackNow;

  /// Optional explanation line — e.g. "The seeker ended this session." when
  /// the other party closed it. Falls back to the generic server-closed note.
  final String? detail;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface2,
                border: Border.all(color: AppColors.borderSoft),
              ),
              child: Icon(Icons.event_busy, size: 40, color: AppColors.ivoryFaint),
            ),
            const SizedBox(height: 18),
            Text('This session has ended', style: AppTextStyles.heading(size: 18)),
            const SizedBox(height: 8),
            Text(
              detail ?? 'The consultation was already closed on the server.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: onBackNow,
              child: const Text('Back to Requests'),
            ),
          ],
        ),
      ),
    );
  }
}
