// Lifecycle-awareness + back-button-guard regression tests for the
// astrologer's call/video screen.
//
// The screen previously had no `WidgetsBindingObserver` — nothing reacted to
// the app resuming from background — so it could sit on a live-looking call
// UI for a consultation the server auto-ended (the backend sweeps a
// consultation whose user-side heartbeat goes silent for 150s) while this
// app was backgrounded. It also had no back-button guard, so a stray
// Android back press could silently drop a live call.
//
// Driven through an injected, un-initialised `AgoraCallService` (real class,
// `.init()` never called — its notifiers are plain `ValueNotifier`s and
// every method that would touch the native engine null-safely no-ops, the
// same established pattern `go_live_controls_test.dart` uses) so the in-call
// UI can be exercised without a real Agora native engine.
//
// All timers here run in the fake-async zone flutter_test wraps every
// `testWidgets` body in, so `tester.pump(duration)` — not real wall-clock
// time — is what advances the elapsed-call ticker / the post-"ended"
// auto-pop timer. `pumpAndSettle` is deliberately avoided while the elapsed
// ticker (a `Timer.periodic`) is running: it schedules a new frame every
// second for as long as the widget is mounted, which can starve
// `pumpAndSettle`'s own settle detection.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hindustani_astro/core/di.dart';
import 'package:hindustani_astro/features/portal/portal_repository.dart';
import 'package:hindustani_astro/l10n/app_localizations.dart';
import 'package:hindustani_astro/features/requests/ui/attend_call_screen.dart';
import 'package:hj_core/hj_core.dart';

class _FakeWakelock implements WakelockService {
  @override
  Future<void> acquire() async {}
  @override
  Future<void> release() async {}
}

/// Stubs exactly `activeConsultation` — the only repository call this screen
/// makes. Everything else throws loudly if ever hit.
class _FakePortalRepository implements PortalRepository {
  _FakePortalRepository({this.active});

  /// The consultation to report as still-active, or null to simulate
  /// "already ended server-side" (dropped out of the active list).
  Consultation? active;
  int activeConsultationCalls = 0;

  @override
  Future<Consultation?> activeConsultation(String id) async {
    activeConsultationCalls++;
    return active;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}

Consultation _consultation({String payout = '0.00'}) => Consultation(
      id: 'c-1',
      userId: 'u-1',
      astrologerId: 'a-1',
      type: ConsultationType.video,
      status: ConsultationStatus.inProgress,
      astrologerPayout: payout,
    );

const _grant = AgoraGrant(appId: 'app-id', channel: 'ch-1', uid: 1, token: 'tok');

void main() {
  late _FakePortalRepository repo;

  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<WakelockService>(_FakeWakelock());
    repo = _FakePortalRepository(active: _consultation());
    getIt.registerSingleton<PortalRepository>(repo);
  });

  /// Pumps a two-route stack — a "Requests" placeholder + the call screen
  /// pushed on top — mirroring how `RequestsScreen._accept` really opens
  /// this screen, so pop-back-to-Requests assertions are meaningful.
  Future<AgoraCallService> pumpScreen(
    WidgetTester tester, {
    bool video = true,
    String? userName = 'Meera',
  }) async {
    final agora = AgoraCallService();
    addTearDown(agora.dispose);
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: Center(child: Text('Requests Screen'))),
    ));
    final context = tester.element(find.text('Requests Screen'));
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AttendCallScreen(
        grant: _grant,
        video: video,
        consultationId: 'c-1',
        userName: userName,
        agoraOverride: agora,
      ),
    ));
    await tester.pump();
    await tester.pumpAndSettle(); // let the push transition settle (no timers running yet)
    return agora;
  }

  testWidgets('shows the seeker name, connecting state, then live + elapsed timer once joined',
      (tester) async {
    final agora = await pumpScreen(tester);
    expect(find.text('Meera'), findsOneWidget);
    // Not joined yet.
    expect(find.text('Connecting…'), findsOneWidget);
    expect(find.text('Connecting'), findsOneWidget, reason: 'header pill');

    agora.joined.value = true;
    await tester.pump();
    expect(find.text('Waiting for the seeker…'), findsOneWidget);

    agora.remoteUid.value = 42;
    await tester.pump();
    expect(find.textContaining('Live ·'), findsOneWidget,
        reason: 'header shows a live elapsed timer once the seeker joins');

    await tester.pump(const Duration(seconds: 3));
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink()); // dispose — cancels the elapsed ticker
    await tester.pump();
  });

  testWidgets('mute, speaker, flip-camera and camera-on/off controls all work without crashing',
      (tester) async {
    final agora = await pumpScreen(tester, video: true);
    agora.joined.value = true;
    agora.remoteUid.value = 7;
    await tester.pump();

    // Mute.
    expect(find.byIcon(Icons.mic), findsOneWidget);
    expect(agora.muted.value, isFalse);
    await tester.tap(find.byIcon(Icons.mic));
    await tester.pump();
    expect(agora.muted.value, isTrue);
    expect(find.byIcon(Icons.mic_off), findsOneWidget);

    // Speaker toggle (video calls default to speaker-on).
    expect(find.byIcon(Icons.volume_up), findsOneWidget);
    await tester.tap(find.byIcon(Icons.volume_up));
    await tester.pump();
    expect(find.byIcon(Icons.hearing), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Flip camera — no-ops safely against the un-initialised engine.
    await tester.tap(find.byIcon(Icons.cameraswitch));
    await tester.pump();
    expect(tester.takeException(), isNull);

    // Camera on/off.
    expect(find.byIcon(Icons.videocam), findsOneWidget);
    await tester.tap(find.byIcon(Icons.videocam));
    await tester.pump();
    expect(agora.videoEnabled.value, isFalse);
    expect(find.byIcon(Icons.videocam_off), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('an audio call has no camera/flip controls', (tester) async {
    await pumpScreen(tester, video: false);
    expect(find.byIcon(Icons.cameraswitch), findsNothing);
    expect(find.byIcon(Icons.videocam), findsNothing);
    expect(find.byIcon(Icons.mic), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('earnings-so-far is surfaced once known, from the portal repository',
      (tester) async {
    repo.active = _consultation(payout: '128.50');
    await pumpScreen(tester);
    await tester.pump();
    expect(find.textContaining('Earnings so far: ₹128.50'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('the Android back button during a live call is intercepted with a confirm dialog',
      (tester) async {
    final agora = await pumpScreen(tester);
    agora.joined.value = true;
    agora.remoteUid.value = 3;
    await tester.pump();

    final ctx = tester.element(find.byType(AttendCallScreen));
    // `maybePop()` itself yields once internally (its deprecated `willPop()`
    // check) before reaching the `PopScope`-aware `popDisposition` branch
    // that actually invokes `onPopInvokedWithResult` — await it directly
    // (matching real back-button dispatch) rather than just pumping once.
    await Navigator.of(ctx).maybePop();
    await tester.pump();

    expect(find.text('End this call?'), findsOneWidget,
        reason: 'a live call must not be dropped by a bare back press');
    // The screen itself is still there — nothing popped yet.
    expect(find.byType(AttendCallScreen), findsOneWidget);

    // Cancel — stays on the call.
    await tester.tap(find.text('Cancel'));
    await tester.pump();
    expect(find.byType(AttendCallScreen), findsOneWidget);
    expect(find.text('End this call?'), findsNothing);

    // Confirm — actually ends and pops back to Requests. By this point the
    // elapsed ticker is already cancelled (inside `_end()`, before the pop),
    // so it's safe to let the pop transition fully settle here.
    await Navigator.of(ctx).maybePop();
    await tester.pump();
    await tester.tap(find.text('End'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byType(AttendCallScreen), findsNothing);
    expect(find.text('Requests Screen'), findsOneWidget);
  });

  testWidgets('resuming the app re-syncs status; a session the server already ended '
      'shows "This session has ended" and returns to Requests', (tester) async {
    final agora = await pumpScreen(tester);
    agora.joined.value = true;
    agora.remoteUid.value = 9;
    await tester.pump();
    expect(find.byType(AttendCallScreen), findsOneWidget);

    // The server-side sweep auto-ended it while this app was backgrounded.
    repo.active = null;
    final before = repo.activeConsultationCalls;

    WidgetsBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    // Two pumps: the repository call resolves on a microtask that lands
    // during the first frame, so the setState it triggers is only painted
    // by the next (mirrors `attend_chat_reconnect_test.dart`).
    await tester.pump();
    await tester.pump();
    expect(repo.activeConsultationCalls, greaterThan(before),
        reason: 'resume must re-sync the consultation status from the server');

    expect(find.text('This session has ended'), findsOneWidget);
    // The dead call UI must be gone — not left showing "Live"/controls.
    expect(find.textContaining('Live ·'), findsNothing);

    // Auto-returns to Requests shortly after. The elapsed ticker is already
    // cancelled by this point (inside `_handleSessionEnded`), so it's safe
    // to let the pop transition fully settle.
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byType(AttendCallScreen), findsNothing);
    expect(find.text('Requests Screen'), findsOneWidget);
  });

  testWidgets('"Back to Requests" on the ended state pops immediately, without waiting',
      (tester) async {
    await pumpScreen(tester);
    repo.active = null;
    WidgetsBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump();
    expect(find.text('This session has ended'), findsOneWidget);

    await tester.tap(find.text('Back to Requests'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byType(AttendCallScreen), findsNothing);
    expect(find.text('Requests Screen'), findsOneWidget);
  });
}
