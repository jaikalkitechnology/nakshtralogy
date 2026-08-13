// Post-live SUMMARY verification: after the astrologer ends a broadcast the
// screen must actually render the "That's a wrap!" summary — not silently
// fail layout and leave nothing but the CosmicBackground gradient painted
// (which on devices reads as a plain "blue screen" after ending a live
// session; that exact regression is what this test pins).
//
// Root cause of the blue screen: the summary Column lives inside an
// IntrinsicHeight (the short-viewport scroll guard), and it contained a
// shrink-wrapped GridView. RenderShrinkWrappingViewport does not support
// returning intrinsic dimensions, so every layout pass threw — the summary
// subtree never painted while the cosmic gradient behind it did.
//
// Pumps with the REAL app theme, same discipline as go_live_controls_test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hindustani_astro/core/di.dart';
import 'package:hindustani_astro/features/live/broadcast_cubit.dart';
import 'package:hindustani_astro/features/live/ui/go_live_screen.dart';
import 'package:hindustani_astro/features/portal/portal_repository.dart';
import 'package:hindustani_astro/l10n/app_localizations.dart';
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

  Future<void> pumpSummary(WidgetTester tester, BroadcastState state) async {
    final cubit = _TestBroadcastCubit();
    // No addTearDown(cubit.close): GoLiveScreen's own dispose() closes the
    // injected cubit (see go_live_controls_test.dart).
    cubit.force(state);
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: GoLiveScreen(cubitOverride: cubit),
    ));
    await tester.pump();
  }

  testWidgets('ended phase renders the summary (no blue screen) under the REAL theme',
      (tester) async {
    await pumpSummary(
      tester,
      BroadcastState(
        phase: BroadcastPhase.ended,
        broadcastId: 'b-1',
        startedAt: DateTime(2026, 1, 1, 10),
        peakViewers: 7,
        summary: const {
          'peak_viewers': 7,
          'started_at': '2026-01-01T10:00:00Z',
          'ended_at': '2026-01-01T10:42:00Z',
        },
      ),
    );

    expect(tester.takeException(), isNull,
        reason: 'the summary must lay out cleanly — a layout exception here '
            'paints only the cosmic background: the on-device "blue screen"');
    expect(find.text("That’s a wrap!"), findsOneWidget);
    expect(find.text('Peak viewers'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('Duration'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Done'), findsOneWidget);
  });

  testWidgets('summary also renders with an EMPTY server summary map',
      (tester) async {
    // _onEndedByServer lands here with summary: {} — the degenerate payload
    // must render too, not just the happy /end response.
    await pumpSummary(
      tester,
      const BroadcastState(phase: BroadcastPhase.ended, summary: {}),
    );
    expect(tester.takeException(), isNull);
    expect(find.text("That’s a wrap!"), findsOneWidget);
  });

  testWidgets('summary renders on a SHORT viewport without exceptions',
      (tester) async {
    // The IntrinsicHeight/scroll guard exists for short screens — make sure
    // the fix holds there too (this is where the GridView used to sit).
    tester.view.physicalSize = const Size(720, 640);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);
    await pumpSummary(
      tester,
      const BroadcastState(phase: BroadcastPhase.ended, summary: {}),
    );
    expect(tester.takeException(), isNull);
    expect(find.text("That’s a wrap!"), findsOneWidget);
  });
}
