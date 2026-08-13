// The Requests screen has to notice a new request on its own.
//
// It used to refresh in exactly three situations: the initial load, a manual
// pull-to-refresh/refresh-button tap, and a push notification arriving. So an
// astrologer sitting on an open Requests screen saw "No pending requests"
// while a seeker's request came in and quietly expired a couple of minutes
// later — no push on web at all, and on device a delayed or dropped
// notification produced the same silence. A Chromium end-to-end run through
// both apps reproduced it: the request never appeared until the page was
// reloaded by hand.
//
// These tests pin the background poll, and just as importantly pin that it
// stays *quiet*: a failing poll must not take over the screen with an error,
// and it must not fire while the app is backgrounded.
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hindustani_astro/core/di.dart';
import 'package:hindustani_astro/core/push/pending_request_action.dart';
import 'package:hindustani_astro/features/portal/portal_repository.dart';
import 'package:hindustani_astro/features/requests/ui/requests_screen.dart';
import 'package:hindustani_astro/l10n/app_localizations.dart';
import 'package:hj_core/hj_core.dart';

class _FakePortalRepository implements PortalRepository {
  List<Consultation> pending = const [];
  int calls = 0;
  Object? throwThis;

  @override
  Future<List<Consultation>> pendingRequests() async {
    calls++;
    if (throwThis != null) throw throwThis!;
    return pending;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}

Consultation _request(String id) => Consultation(
      id: id,
      userId: 'u-1',
      astrologerId: 'a-1',
      userName: 'Test Seeker',
      type: ConsultationType.chat,
      status: ConsultationStatus.requested,
      rate: '5.00',
    );

void main() {
  late _FakePortalRepository repo;

  setUp(() async {
    await getIt.reset();
    repo = _FakePortalRepository();
    getIt.registerSingleton<PortalRepository>(repo);
    getIt.registerSingleton<PendingRequestAction>(PendingRequestAction());
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.dark(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: RequestsScreen()),
    ));
    await tester.pump();
    await tester.pump();
  }

  testWidgets('a request that arrives while the screen is open shows up without '
      'any manual refresh', (tester) async {
    await pumpScreen(tester);
    expect(find.text('Test Seeker'), findsNothing);

    // The seeker asks while the astrologer is just sitting on this screen.
    repo.pending = [_request('c-1')];

    await tester.pump(const Duration(seconds: 9));
    await tester.pump();

    expect(find.text('Test Seeker'), findsOneWidget,
        reason: 'the poll should have surfaced the new request on its own');

    // Let the periodic timer stop before the test ends.
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a failing poll never replaces the list with an error screen',
      (tester) async {
    repo.pending = [_request('c-1')];
    await pumpScreen(tester);
    await tester.pump(const Duration(seconds: 9));
    await tester.pump();
    expect(find.text('Test Seeker'), findsOneWidget);

    // Network blip on a background poll.
    repo.throwThis = ApiException(0, 'offline');
    await tester.pump(const Duration(seconds: 9));
    await tester.pump();

    expect(find.text('Test Seeker'), findsOneWidget,
        reason: 'a silent background poll must not take over the screen');
    expect(find.text('offline'), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the poll stops while the app is backgrounded', (tester) async {
    await pumpScreen(tester);
    await tester.pump(const Duration(seconds: 9));
    await tester.pump();
    final whileVisible = repo.calls;
    expect(whileVisible, greaterThan(0));

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    await tester.pump(const Duration(seconds: 30));
    await tester.pump();

    expect(repo.calls, whileVisible,
        reason: 'no polling should happen while the app is in the background');

    // ...and coming back to the foreground refreshes immediately rather than
    // waiting out the rest of the interval.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump();
    expect(repo.calls, greaterThan(whileVisible));

    await tester.pumpWidget(const SizedBox());
  });
}
