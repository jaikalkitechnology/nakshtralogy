// Regression pin for the astrologer consultation chat's reconnect.
//
// The screen used to render a "Reconnecting…" banner whenever the chat
// WebSocket closed — and then do NOTHING. There was no timer, no retry: the
// socket stayed dead for the rest of the session while the banner claimed a
// reconnect was in progress. The astrologer's OWN messages still sent (those
// go over REST), so it looked like "chat works but is permanently stuck on
// Reconnecting…", which is exactly how it was reported from the field.
//
// Driven through an injected socket rather than a real one: a real socket
// needs real I/O, and under `runAsync` (the only way to get that in a widget
// test) google_fonts tries to fetch fonts and blows the test up. A fake
// socket keeps this deterministic and fast.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hindustani_astro/core/di.dart';
import 'package:hindustani_astro/features/portal/portal_repository.dart';
import 'package:hindustani_astro/l10n/app_localizations.dart';
import 'package:hindustani_astro/features/requests/ui/attend_chat_screen.dart';
import 'package:hj_core/hj_core.dart';

class _FakeWakelock implements WakelockService {
  @override
  Future<void> acquire() async {}
  @override
  Future<void> release() async {}
}

/// Counts REST history pulls. The reconnect path re-syncs messages missed
/// while the socket was down, so a genuine retry shows up here as a call
/// beyond the initial preload.
class _CountingPortalRepository implements PortalRepository {
  int messagesCalls = 0;

  @override
  Future<List<Map<String, dynamic>>> messages(String consultationId) async {
    messagesCalls++;
    return const [];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}

/// A ChatSocket whose lifecycle the test drives directly.
class _FakeChatSocket extends ChatSocket {
  _FakeChatSocket()
      : super(const AppConfig(apiBaseUrl: 'http://127.0.0.1:9/v1'), TokenStore());

  static int connectCount = 0;
  final _ctrl = StreamController<Map<String, dynamic>>.broadcast();

  @override
  Stream<Map<String, dynamic>> get stream => _ctrl.stream;

  @override
  void connect(String consultationId) => connectCount++;

  @override
  void send(String body) {}

  @override
  void disconnect() {}

  @override
  void dispose() {
    _ctrl.close();
  }

  void emitClosed() => _ctrl.add({'kind': 'closed', 'detail': 'test drop'});
  void emitStatus(String status) =>
      _ctrl.add({'kind': 'status', 'status': status});
}

void main() {
  late _CountingPortalRepository repo;
  late _FakeChatSocket socket;

  setUp(() async {
    await getIt.reset();
    _FakeChatSocket.connectCount = 0;
    repo = _CountingPortalRepository();
    getIt.registerSingleton<WakelockService>(_FakeWakelock());
    getIt.registerSingleton<PortalRepository>(repo);
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    socket = _FakeChatSocket();
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: AttendChatScreen(
        consultationId: 'c-1',
        userName: 'Seeker',
        socketFactory: () => socket,
      ),
    ));
    await tester.pump();
  }

  testWidgets('a dropped socket is actually RETRIED, not just announced',
      (tester) async {
    await pumpScreen(tester);
    expect(repo.messagesCalls, 1, reason: 'initial REST preload');
    expect(_FakeChatSocket.connectCount, 1);

    socket.emitClosed();
    // Two pumps: the stream delivers on a microtask that lands during the
    // first frame, so the setState it triggers is only painted by the next.
    await tester.pump();
    await tester.pump();
    // The banner appears immediately…
    expect(find.text('Reconnecting…'), findsOneWidget);

    // …and, crucially, an actual retry follows once the backoff elapses.
    await tester.pump(const Duration(seconds: 3));
    expect(
      _FakeChatSocket.connectCount,
      greaterThan(1),
      reason: 'the socket must be reconnected, not just labelled reconnecting',
    );
    expect(repo.messagesCalls, greaterThan(1),
        reason: 'messages missed while down must be re-synced over REST');

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 20));
  });

  testWidgets('the banner clears once frames flow again', (tester) async {
    await pumpScreen(tester);
    socket.emitClosed();
    await tester.pump();
    await tester.pump();
    expect(find.text('Reconnecting…'), findsOneWidget);

    socket.emitStatus('in_progress');
    await tester.pump();
    await tester.pump();
    expect(find.text('Reconnecting…'), findsNothing,
        reason: 'a live frame means the link is healthy again');

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 20));
  });

  testWidgets('a completed consultation stops retrying', (tester) async {
    await pumpScreen(tester);
    socket.emitStatus('completed');
    await tester.pump();
    final before = _FakeChatSocket.connectCount;

    socket.emitClosed();
    await tester.pump(const Duration(seconds: 20));
    expect(_FakeChatSocket.connectCount, before,
        reason: 'no point reconnecting to a finished consultation');

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 20));
  });
}
