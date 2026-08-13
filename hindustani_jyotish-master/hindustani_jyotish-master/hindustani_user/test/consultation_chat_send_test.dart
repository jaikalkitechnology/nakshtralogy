// Reliability tests for the user consultation CHAT screen (Phase 3):
//  - optimistic send: an outgoing message shows a "Sending…" bubble
//    immediately, reconciles to the server copy on success, and on failure
//    flips to "Not sent · Tap to retry" with a working retry;
//  - minimised → resync: backgrounding drops the socket (so the backend's
//    per-message push fires) and resuming reconnects + re-pulls history.
//
// Driven through the screen's `socketFactory` hook and a fake
// `ConsultationRepository` (a real socket needs real I/O the test binding
// fakes), matching the astrologer app's `attend_chat_*_test.dart` pattern.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

class _FakeConsultationRepository implements ConsultationRepository {
  int messagesCalls = 0;
  int sendCalls = 0;

  /// The test sets this to control each `sendMessage` outcome.
  Future<Map<String, dynamic>> Function(String body)? onSend;

  @override
  Future<List<Map<String, dynamic>>> messages(String id) async {
    messagesCalls++;
    return const [];
  }

  @override
  Future<Map<String, dynamic>> sendMessage(String id, String body) {
    sendCalls++;
    return onSend!(body);
  }

  @override
  Future<Consultation?> findMine(String id) async => null;

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
    if (!_ctrl.isClosed) _ctrl.close();
  }

  void emitStatus(String status) =>
      _ctrl.add({'kind': 'status', 'status': status});
}

void main() {
  late _FakeConsultationRepository repo;
  late _FakeChatSocket socket;

  setUp(() async {
    await getIt.reset();
    _FakeChatSocket.connectCount = 0;
    repo = _FakeConsultationRepository();
    getIt.registerSingleton<WakelockService>(_FakeWakelock());
    getIt.registerSingleton<ConsultationRepository>(repo);
  });

  Future<void> pumpChat(WidgetTester tester) async {
    socket = _FakeChatSocket();
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ConsultationScreen(
        consultationId: 'c-1',
        type: ConsultationType.chat,
        socketFactory: () => socket,
      ),
    ));
    await tester.pump();
    // Astrologer accepted → composer unlocks. The stream delivers on a
    // microtask that lands during the first frame, so the setState it triggers
    // is only painted by the next — hence two pumps.
    socket.emitStatus('in_progress');
    await tester.pump();
    await tester.pump();
  }

  testWidgets(
      'optimistic send shows "Sending…", then reconciles to the server copy',
      (tester) async {
    final completer = Completer<Map<String, dynamic>>();
    repo.onSend = (_) => completer.future;
    await pumpChat(tester);

    await tester.enterText(find.byType(TextField), 'Namaste');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    expect(find.text('Namaste'), findsOneWidget);
    expect(find.text('Sending…'), findsOneWidget,
        reason: 'the optimistic bubble is pending until the REST call returns');
    expect(repo.sendCalls, 1);

    completer.complete(const {
      'id': 's-1',
      'sender_role': 'user',
      'body': 'Namaste',
      'created_at': '2026-01-01T00:00:00Z',
    });
    await tester.pump();

    expect(find.text('Sending…'), findsNothing,
        reason: 'a 2xx reconciles the temp bubble to the server copy');
    expect(find.text('Not sent · Tap to retry'), findsNothing);
    expect(find.text('Namaste'), findsOneWidget,
        reason: 'still exactly one bubble — no duplicate');

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
      'a failed send flips to "Not sent · Tap to retry" and retry re-sends',
      (tester) async {
    var attempt = 0;
    repo.onSend = (body) async {
      attempt++;
      if (attempt == 1) throw ApiException(500, 'server boom');
      return {
        'id': 's-2',
        'sender_role': 'user',
        'body': body,
        'created_at': '2026-01-01T00:00:00Z',
      };
    };
    await pumpChat(tester);

    await tester.enterText(find.byType(TextField), 'Hello?');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump(); // pending bubble
    await tester.pump(); // error resolves

    expect(find.text('Not sent · Tap to retry'), findsOneWidget);
    expect(repo.sendCalls, 1);

    await tester.tap(find.text('Not sent · Tap to retry'));
    await tester.pump(); // new pending bubble
    await tester.pump(); // success resolves

    expect(repo.sendCalls, 2, reason: 'retry must re-send');
    expect(find.text('Not sent · Tap to retry'), findsNothing);
    expect(find.text('Sending…'), findsNothing);
    expect(find.text('Hello?'), findsOneWidget,
        reason: 'exactly one reconciled bubble after a successful retry');

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
      'minimising drops the socket; resuming reconnects and re-pulls history',
      (tester) async {
    repo.onSend = (_) async => const {};
    await pumpChat(tester);
    expect(_FakeChatSocket.connectCount, 1, reason: 'initial connect');
    final messagesBefore = repo.messagesCalls;

    // Minimised → the socket must be closed so the backend sees us offline and
    // delivers the next message via the Phase-2a per-message push. Drive the
    // full valid state chain (the composer's EditableText installs an
    // AppLifecycleListener that rejects illegal jumps like paused→resumed).
    for (final s in const [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(s);
      await tester.pump();
    }

    for (final s in const [
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(s);
      await tester.pump();
    }
    await tester.pump();

    expect(_FakeChatSocket.connectCount, greaterThan(1),
        reason: 'resume must reopen the socket');
    expect(repo.messagesCalls, greaterThan(messagesBefore),
        reason: 'resume must re-pull any messages missed while backgrounded');

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
