// Lifecycle-awareness tests for the consultation call/video screen:
//  - back button / close button are guarded during an active call
//    (must not silently drop a live, billing session);
//  - on resume, a heartbeat that's actually due (>=60s of REAL wall-clock
//    time) fires immediately and the server's `elapsed_seconds`/
//    `amount_charged` overwrite the local ticker, instead of trusting it;
//  - on resume, discovering the session already ended server-side (the
//    backend's abandoned-session sweep, or the astrologer) shows a clear
//    message and routes the user to history instead of leaving them on a
//    dead call screen.
//
// Driven through `agoraFactory` (a fake AgoraCallService subclass, matching
// the astrologer app's `go_live_controls_test.dart` pattern) and a fake
// `ConsultationRepository`, with the wall clock injected via `package:clock`
// so "60+ seconds passed while backgrounded" doesn't require the test to
// actually wait 60 real seconds.
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import 'package:hindustani_user/core/di.dart';
import 'package:hindustani_user/features/consultation/consultation_repository.dart';
import 'package:hindustani_user/features/consultation/ui/consultation_screen.dart';
import 'package:hindustani_user/l10n/app_localizations.dart';

class _FakeWakelock implements WakelockService {
  @override
  Future<void> acquire() async {}
  @override
  Future<void> release() async {}
}

/// A real [AgoraCallService] with `init`/`join` overridden to skip the
/// native engine entirely (unavailable under `flutter test`) — every other
/// method (`toggleMute`, `leave`, `dispose`, …) is already null-safe on a
/// `null` engine, so it's left as-is, and the public notifiers
/// (`joined`/`remoteUid`/`muted`/`videoEnabled`) stay live and test-drivable.
class _FakeAgoraCallService extends AgoraCallService {
  @override
  Future<void> init(String appId) async {}

  @override
  Future<void> join(AgoraGrant grant, {required bool video}) async {
    videoEnabled.value = video;
    joined.value = true;
  }
}

class _FakeConsultationRepository implements ConsultationRepository {
  final List<String> calls = [];
  int heartbeatCalls = 0;

  Map<String, dynamic> heartbeatResponse = const {
    'elapsed_seconds': 65,
    'amount_charged': '10.00',
    'wallet_balance': '90.00',
    'should_end': false,
  };

  /// Thrown by [heartbeat] when set — used to simulate a 409 (no longer
  /// in_progress).
  ApiException? heartbeatError;

  Consultation? findMineResult;

  Map<String, dynamic> endResponse = const {
    'duration_seconds': 65,
    'amount_charged': '10.00',
    'astrologer_payout': '8.00',
    'wallet_balance': '90.00',
  };

  /// The Agora grant `/start` hands back. Overridable so a test can simulate
  /// a server with no Agora credentials configured, which returns a
  /// placeholder grant the client can't actually join with.
  Map<String, dynamic> startAgora = const {
    'app_id': 'test-app-id',
    'channel': 'ch-1',
    'uid': 1001,
    'token': 'tok',
  };

  @override
  Future<Map<String, dynamic>> start(String id) async {
    calls.add('start');
    return {'agora': startAgora};
  }

  @override
  Future<Map<String, dynamic>> heartbeat(String id) async {
    calls.add('heartbeat');
    heartbeatCalls++;
    final err = heartbeatError;
    if (err != null) throw err;
    return heartbeatResponse;
  }

  @override
  Future<Map<String, dynamic>> end(String id) async {
    calls.add('end');
    return endResponse;
  }

  @override
  Future<Consultation?> findMine(String id) async {
    calls.add('findMine');
    return findMineResult;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}

/// Grants the mic/camera permission request `AgoraCallService.
/// requestPermissions` makes via the real `permission_handler` platform
/// channel — otherwise `_startCall` never gets past the permission check
/// under `flutter test` (no native implementation registered).
void _mockPermissionsGranted() {
  const channel = MethodChannel('flutter.baseflow.com/permissions/methods');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
    if (call.method == 'requestPermissions') {
      final perms = (call.arguments as List).cast<int>();
      return {for (final p in perms) p: 1}; // 1 == PermissionStatus.granted
    }
    if (call.method == 'checkPermissionStatus') return 1;
    return null;
  });
}

Future<void> _pumpCall(
  WidgetTester tester, {
  required _FakeConsultationRepository repo,
  required _FakeAgoraCallService agora,
  required GoRouter router,
}) async {
  await tester.pumpWidget(MaterialApp.router(
    theme: AppTheme.dark(),
    routerConfig: router,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  ));
  await tester.pumpAndSettle();
  // Push on top of `/home` (rather than starting there) so there's a route
  // underneath to pop back to — matching the real app, where the
  // consultation screen is always reached via a push.
  router.push('/consultation/c-1');
  await tester.pumpAndSettle();
}

/// `/home` → push `/consultation/c-1` (so there's a route underneath to pop
/// back to, matching the real app) → `/history` as the reroute target.
GoRouter _buildRouter({
  required _FakeConsultationRepository repo,
  required _FakeAgoraCallService agora,
  ConsultationType type = ConsultationType.call,
}) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(path: '/home', builder: (_, _) => const Scaffold(body: Text('HOME_SCREEN'))),
      GoRoute(
        path: '/consultation/:id',
        builder: (_, _) => ConsultationScreen(
          consultationId: 'c-1',
          type: type,
          agoraFactory: () => agora,
        ),
      ),
      GoRoute(path: '/history', builder: (_, _) => const Scaffold(body: Text('HISTORY_SCREEN'))),
    ],
  );
}

Future<void> _startCallAndJoin(WidgetTester tester, _FakeAgoraCallService agora) async {
  await tester.tap(find.text('Start'));
  await tester.pumpAndSettle();
  expect(agora.joined.value, isTrue, reason: 'the fake join() must have run');
  agora.remoteUid.value = 42; // the astrologer "joins" the channel
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<WakelockService>(_FakeWakelock());
    _mockPermissionsGranted();
  });

  testWidgets(
      'active call: back and the close (X) button are guarded by a confirm '
      "dialog — a live, billing session can't be silently dropped",
      (tester) async {
    final repo = _FakeConsultationRepository();
    final agora = _FakeAgoraCallService();
    getIt.registerSingleton<ConsultationRepository>(repo);
    final router = _buildRouter(repo: repo, agora: agora);
    await _pumpCall(tester, repo: repo, agora: agora, router: router);

    await _startCallAndJoin(tester, agora);
    expect(tester.takeException(), isNull);

    // System back (PopScope's canPop=false path) must NOT pop the screen —
    // it must surface the confirm dialog instead. `maybePop()`'s bool return
    // just means "a pop attempt was handled here", true even when the route
    // itself was vetoed (see NavigatorState.maybePop's `willPop` check) — the
    // real proof is the screen/dialog state below, not that return value.
    final context = tester.element(find.byType(ConsultationScreen));
    await Navigator.of(context).maybePop();
    await tester.pumpAndSettle();
    expect(find.byType(ConsultationScreen), findsOneWidget,
        reason: 'the live call screen must still be there — not popped');
    expect(find.text('End this call?'), findsOneWidget,
        reason: 'the back attempt must surface the confirm dialog');

    // Cancel — the call keeps running, nothing was ended.
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(repo.calls.contains('end'), isFalse);

    // The header's X button bypasses PopScope entirely (it's a plain
    // IconButton, not a Navigator pop) — it must route through the same
    // guard rather than popping directly.
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('End this call?'), findsOneWidget);

    // Confirm this time — the call actually ends.
    await tester.tap(find.text('End'));
    await tester.pumpAndSettle();
    expect(repo.calls.contains('end'), isTrue);
  });

  testWidgets(
      'resume after real background time immediately heartbeats and '
      'corrects elapsed/cost from the SERVER, not the local ticker',
      (tester) async {
    final repo = _FakeConsultationRepository()
      ..heartbeatResponse = const {
        'elapsed_seconds': 245, // 04:05 — deliberately far from any local tick count
        'amount_charged': '42.00',
        'wallet_balance': '58.00',
        'should_end': false,
      };
    final agora = _FakeAgoraCallService();
    getIt.registerSingleton<ConsultationRepository>(repo);
    final router = _buildRouter(repo: repo, agora: agora);

    var testNow = DateTime(2026, 1, 1, 12, 0, 0);
    final testClock = Clock(() => testNow);

    await withClock(testClock, () async {
      await _pumpCall(tester, repo: repo, agora: agora, router: router);
      await _startCallAndJoin(tester, agora);

      expect(repo.heartbeatCalls, 0,
          reason: 'no heartbeat should have fired before a minute passed');

      // Simulate the app going to the background for 90 real seconds — far
      // more than the 60s heartbeat cadence — then coming back.
      testNow = testNow.add(const Duration(seconds: 90));
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      expect(repo.heartbeatCalls, 1,
          reason: 'resume with >=60s of real time due must heartbeat immediately, '
              'not wait for the next natural tick');
      expect(find.textContaining('04:05'), findsWidgets,
          reason: 'elapsed must come from the heartbeat response (245s), not '
              'whatever the local ticker happened to count');
      expect(find.textContaining('42.00'), findsWidgets,
          reason: 'the live cost must reflect the server-truth amount_charged');
    });
  });

  testWidgets(
      'resume discovers the session already ended in the background: shows '
      'a clear message and routes to history instead of a dead call screen',
      (tester) async {
    final repo = _FakeConsultationRepository();
    final agora = _FakeAgoraCallService();
    getIt.registerSingleton<ConsultationRepository>(repo);
    final router = _buildRouter(repo: repo, agora: agora);

    await _pumpCall(tester, repo: repo, agora: agora, router: router);
    await _startCallAndJoin(tester, agora);

    // The backend's abandoned-session sweep already finalised this call
    // while the app was backgrounded — `findMine` now reports it completed.
    repo.findMineResult = const Consultation(
      id: 'c-1',
      userId: 'u-1',
      astrologerId: 'a-1',
      type: ConsultationType.call,
      status: ConsultationStatus.completed,
      durationSeconds: 180,
      amountCharged: '30.00',
    );

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    expect(
      find.text('This call ended while the app was in the background.'),
      findsOneWidget,
    );
    expect(repo.heartbeatCalls, 0,
        reason: 'the cheap findMine status check must catch this before ever '
            'attempting a (billing) heartbeat');

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(find.text('HISTORY_SCREEN'), findsOneWidget,
        reason: 'the user must be routed out, not left on the dead call screen');
    expect(find.byType(ConsultationScreen), findsNothing);
  });

  testWidgets(
      'a heartbeat 409 (session ended between heartbeats) is treated the '
      'same way as the findMine-detected case',
      (tester) async {
    final repo = _FakeConsultationRepository()
      ..heartbeatError = ApiException(409, 'Consultation not in progress');
    final agora = _FakeAgoraCallService();
    getIt.registerSingleton<ConsultationRepository>(repo);
    final router = _buildRouter(repo: repo, agora: agora);

    var testNow = DateTime(2026, 1, 1, 12, 0, 0);
    final testClock = Clock(() => testNow);

    await withClock(testClock, () async {
      await _pumpCall(tester, repo: repo, agora: agora, router: router);
      await _startCallAndJoin(tester, agora);

      testNow = testNow.add(const Duration(seconds: 90));
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      expect(
        find.text('This call ended while the app was in the background.'),
        findsOneWidget,
      );
    });
  });

  testWidgets(
      'a call that can never connect is closed out immediately so it cannot '
      'be billed', (tester) async {
    // Reproduces a real charge seen in a Chromium end-to-end run: with no
    // Agora credentials configured, `/start` still flipped the consultation
    // to in_progress and stamped started_at, then the client bailed out
    // because the grant was a placeholder — and left the session open. No
    // heartbeat ever lands on a call nobody joined, so the backend's
    // abandoned-session sweep later finalised it and billed
    // max(1, ceil(duration/60)) minutes. The seeker paid Rs10 for a call that
    // never connected.
    final repo = _FakeConsultationRepository()
      ..startAgora = const {
        'app_id': 'dev-app-id', // the server's "not configured" placeholder
        'channel': 'ch-1',
        'uid': 1001,
        'token': 'dev-token:ch-1:1001',
      };
    final agora = _FakeAgoraCallService();
    getIt.registerSingleton<ConsultationRepository>(repo);
    final router = _buildRouter(repo: repo, agora: agora);

    await _pumpCall(tester, repo: repo, agora: agora, router: router);
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(repo.calls, contains('end'),
        reason: 'the session must be ended immediately, not left in_progress '
            'for the sweep to bill');
    // Ended straight away means duration_seconds is 0, and a zero-length call
    // is not billed.
    expect(repo.calls.indexOf('end'), greaterThan(repo.calls.indexOf('start')));
    expect(agora.joined.value, isFalse,
        reason: 'nothing should have joined an unusable channel');

    // ...and the seeker is told why, rather than staring at "Connecting".
    expect(
      find.textContaining("audio/video isn't available"),
      findsOneWidget,
    );
  });
}
