// AgoraCallService.awaitJoined() contract: the native joinChannel call only
// acknowledges the REQUEST — an invalid token/App ID never makes it throw;
// the engine reports failure asynchronously via onError /
// onConnectionStateChanged. awaitJoined() is what turns those silent
// failures into real, catchable errors for both live screens (host start()
// and the viewer's connect() watchdog). These tests drive the same public
// notifiers the engine event handlers write to, so the full wait logic runs
// without a native engine.
import 'package:flutter_test/flutter_test.dart';
import 'package:hj_core/hj_core.dart';

void main() {
  test('completes once joined flips true', () async {
    final service = AgoraCallService();
    final wait = service.awaitJoined(timeout: const Duration(seconds: 5));
    await Future<void>.delayed(const Duration(milliseconds: 10));
    service.joined.value = true;
    await expectLater(wait, completes);
  });

  test('returns immediately when already joined', () async {
    final service = AgoraCallService();
    service.joined.value = true;
    await expectLater(
      service.awaitJoined(timeout: const Duration(milliseconds: 50)),
      completes,
    );
  });

  test('throws AgoraJoinException with the engine reason on media failure',
      () async {
    final service = AgoraCallService();
    final wait = service.awaitJoined(timeout: const Duration(seconds: 5));
    await Future<void>.delayed(const Duration(milliseconds: 10));
    service.mediaFailure.value =
        'The video service rejected the access token (Agora error 110)';
    await expectLater(
      wait,
      throwsA(isA<AgoraJoinException>().having(
        (e) => e.message,
        'message',
        contains('rejected the access token'),
      )),
    );
  });

  test('throws immediately when a failure is already recorded', () async {
    final service = AgoraCallService();
    service.mediaFailure.value = 'The configured video App ID is invalid.';
    await expectLater(
      service.awaitJoined(timeout: const Duration(seconds: 5)),
      throwsA(isA<AgoraJoinException>()),
    );
  });

  test('times out with a clear message when nothing ever happens', () async {
    final service = AgoraCallService();
    await expectLater(
      service.awaitJoined(timeout: const Duration(milliseconds: 50)),
      throwsA(isA<AgoraJoinException>().having(
        (e) => e.message,
        'message',
        contains('Timed out connecting to the video channel'),
      )),
    );
  });

  test('dispose() while a wait is pending does not crash the cleanup path',
      () async {
    final service = AgoraCallService();
    final wait = service.awaitJoined(timeout: const Duration(milliseconds: 80));
    await service.dispose();
    await expectLater(wait, throwsA(isA<AgoraJoinException>()));
  });
}
