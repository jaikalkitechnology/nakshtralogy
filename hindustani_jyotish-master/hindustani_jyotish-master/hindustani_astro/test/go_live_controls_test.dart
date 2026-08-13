// Live-phase CONTROLS verification: proves the broadcasting overlay renders
// every control the astrologer needs — the chat compose field (reply to
// viewers), the red "End Live" button, the mic mute/unmute toggle, and the
// flip-camera button — and that the mic/flip controls actually drive the
// Agora service. This is the app-side half of the live-streaming
// verification; the server half (two-way chat over real WebSockets +
// crash auto-end) is covered by backend tests and a live-server run.
//
// Unlike go_live_screen_layout_test.dart (skipped for a teardown leak),
// this file registers the getIt services BroadcastCubit touches on close()
// so teardown completes cleanly.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hindustani_astro/core/di.dart';
import 'package:hindustani_astro/features/live/broadcast_cubit.dart';
import 'package:hindustani_astro/features/live/ui/go_live_screen.dart';
import 'package:hindustani_astro/features/portal/portal_repository.dart';
import 'package:hj_core/hj_core.dart';

class _FakePortalRepository implements PortalRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}

class _FakeWakelock implements WakelockService {
  @override
  Future<void> acquire() async {}
  @override
  Future<void> release() async {}
}

class _TestBroadcastCubit extends BroadcastCubit {
  _TestBroadcastCubit() : super(_FakePortalRepository());
  void force(BroadcastState s) => emit(s);
}

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<WakelockService>(_FakeWakelock());
  });

  testWidgets(
      'live phase shows compose field, red End Live, mic toggle and flip camera — and they work',
      (tester) async {
    // A real (un-initialised) AgoraCallService: its muted/videoEnabled
    // notifiers are live, and toggleMute()/switchCamera() are null-safe on
    // the engine, so the buttons exercise the REAL control paths.
    final agora = AgoraCallService();
    final cubit = _TestBroadcastCubit();
    // No addTearDown(cubit.close): GoLiveScreen's own dispose() closes the
    // injected cubit — closing it twice was itself a bug this test caught
    // (double AgoraCallService.dispose), now also hardened in hj_core.
    cubit.force(BroadcastState(
      phase: BroadcastPhase.live,
      broadcastId: 'b-1',
      startedAt: DateTime(2026, 1, 1),
      viewers: 5,
      agora: agora,
    ));

    // Pump with the REAL app theme, not MaterialApp's default: the theme's
    // global ElevatedButton minimumSize was Size(∞, 52) for weeks, which
    // crashed performLayout for any button in a Row — the live top bar —
    // and blanked the whole live overlay on devices. This test originally
    // passed because it skipped the app theme; never let that happen again.
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.dark(),
      home: GoLiveScreen(cubitOverride: cubit),
    ));
    await tester.pump();
    expect(tester.takeException(), isNull,
        reason: 'live overlay must lay out cleanly under the REAL theme');

    // 1. Chat compose field — the astrologer's reply path.
    expect(find.byType(TextField), findsOneWidget,
        reason: 'the live overlay must show the chat compose field');
    expect(find.byIcon(Icons.send), findsOneWidget);

    // 2. Prominent red End Live button.
    final endBtn = find.widgetWithText(ElevatedButton, 'End Live');
    expect(endBtn, findsOneWidget, reason: 'End Live must be visible');
    final style = tester.widget<ElevatedButton>(endBtn).style!;
    expect(style.backgroundColor!.resolve({}), const Color(0xFFE53935),
        reason: 'End Live must be RED');

    // 3. Mic toggle present and actually mutes/unmutes.
    expect(find.byIcon(Icons.mic), findsOneWidget);
    expect(agora.muted.value, isFalse);
    await tester.tap(find.byIcon(Icons.mic));
    await tester.pump();
    expect(agora.muted.value, isTrue, reason: 'tapping mic must mute');
    expect(find.byIcon(Icons.mic_off), findsOneWidget);
    await tester.tap(find.byIcon(Icons.mic_off));
    await tester.pump();
    expect(agora.muted.value, isFalse, reason: 'tapping again must unmute');

    // 4. Flip camera present and tappable without error.
    final flip = find.byIcon(Icons.cameraswitch_outlined);
    expect(flip, findsOneWidget, reason: 'flip camera must be visible');
    await tester.tap(flip);
    await tester.pump();
    expect(tester.takeException(), isNull);

    // Typing a reply reaches the compose field.
    await tester.enterText(find.byType(TextField), 'Namaste viewers');
    await tester.pump();
    expect(find.text('Namaste viewers'), findsOneWidget);
  });
}
