// Lifecycle-awareness regression tests for the astrologer's consultation
// chat screen.
//
// The screen previously had no `WidgetsBindingObserver` — nothing reacted to
// the app resuming from background, so a WebSocket silently frozen by the OS
// while backgrounded (some platforms never deliver a `closed` event for
// that) could sit dead for the rest of the session, and a consultation the
// backend's silent-heartbeat sweep auto-ended while this app was
// backgrounded could be left showing a live-looking chat thread forever.
//
// Driven through an injected, controllable `ChatSocket` (same pattern as
// `attend_chat_reconnect_test.dart` — a real socket needs real I/O, which the
// test binding fakes).
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hindustani_astro/core/di.dart';
import 'package:hindustani_astro/features/portal/portal_repository.dart';
import 'package:hindustani_astro/features/requests/ui/attend_chat_screen.dart';
import 'package:hj_core/hj_core.dart';

class _FakeWakelock implements WakelockService {
  @override
  Future<void> acquire() async {}
  @override
  Future<void> release() async {}
}

class _FakePortalRepository implements PortalRepository {
  _FakePortalRepository({this.active});

  /// The consultation to report as still-active, or null to simulate
  /// "already ended server-side" (dropped out of the active list).
  Consultation? active;
  int activeConsultationCalls = 0;
  int messagesCalls = 0;

  @override
  Future<Consultation?> activeConsultation(String id) async {
    activeConsultationCalls++;
    return active;
  }

  @override
  Future<List<Map<String, dynamic>>> messages(String consultationId) async {
    messagesCalls++;
    return const [];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}

Consultation _consultation() => const Consultation(
      id: 'c-1',
      userId: 'u-1',
      astrologerId: 'a-1',
      type: ConsultationType.chat,
      status: ConsultationStatus.inProgress,
    );

/// A ChatSocket whose lifecycle the test drives directly — mirrors
/// `attend_chat_reconnect_test.dart`'s fake.
class _FakeChatSocket extends ChatSocket {
  _FakeChatSocket() : super(const AppConfig(apiBaseUrl: 'http://127.0.0.1:9/v1'), TokenStore());

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

  void emitStatus(String status) => _ctrl.add({'kind': 'status', 'status': status});
}

void main() {
  late _FakePortalRepository repo;
  late _FakeChatSocket socket;

  setUp(() async {
    await getIt.reset();
    _FakeChatSocket.connectCount = 0;
    getIt.registerSingleton<WakelockService>(_FakeWakelock());
    repo = _FakePortalRepository(active: _consultation());
    getIt.registerSingleton<PortalRepository>(repo);
  });

  /// Pumps a two-route stack — a "Requests" placeholder + the chat screen
  /// pushed on top — so pop-back-to-Requests assertions are meaningful.
  Future<void> pumpScreen(WidgetTester tester) async {
    socket = _FakeChatSocket();
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.dark(),
      home: const Scaffold(body: Center(child: Text('Requests Screen'))),
    ));
    final context = tester.element(find.text('Requests Screen'));
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AttendChatScreen(
        consultationId: 'c-1',
        userName: 'Seeker',
        socketFactory: () => socket,
      ),
    ));
    await tester.pump();
    await tester.pumpAndSettle();
  }

  testWidgets('resuming forces a fresh socket connection and re-pulls history over REST',
      (tester) async {
    await pumpScreen(tester);
    expect(_FakeChatSocket.connectCount, 1, reason: 'initial connect');
    final messagesBefore = repo.messagesCalls;

    WidgetsBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump();

    expect(_FakeChatSocket.connectCount, greaterThan(1),
        reason: 'resume must force a fresh socket — the OS can silently freeze one while '
            'backgrounded without ever delivering a `closed` event');
    expect(repo.messagesCalls, greaterThan(messagesBefore),
        reason: 'resume must re-pull any messages missed while backgrounded');
  });

  testWidgets(
      'resuming re-syncs status; a consultation the server already ended shows '
      '"This session has ended" and returns to Requests', (tester) async {
    await pumpScreen(tester);
    expect(find.byType(AttendChatScreen), findsOneWidget);

    // The server-side sweep auto-ended it while this app was backgrounded.
    repo.active = null;
    final before = repo.activeConsultationCalls;

    WidgetsBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump();
    expect(repo.activeConsultationCalls, greaterThan(before),
        reason: 'resume must re-sync the consultation status from the server');

    expect(find.text('This session has ended'), findsOneWidget);
    expect(find.text('Chat with Seeker'), findsNothing,
        reason: 'the dead chat UI must be gone, not left showing a live-looking thread');

    await tester.tap(find.text('Back to Requests'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byType(AttendChatScreen), findsNothing);
    expect(find.text('Requests Screen'), findsOneWidget);
  });

  testWidgets(
      'a chat already known complete (via the live socket) shows the ended state on resume '
      'without re-hitting the network', (tester) async {
    await pumpScreen(tester);
    socket.emitStatus('completed');
    await tester.pump();
    final before = repo.activeConsultationCalls;
    final connectsBefore = _FakeChatSocket.connectCount;

    WidgetsBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump();

    expect(find.text('This session has ended'), findsOneWidget);
    expect(repo.activeConsultationCalls, before,
        reason: 'already known complete — no need to re-check the server');
    expect(_FakeChatSocket.connectCount, connectsBefore,
        reason: 'already known complete — no need to reconnect a dead thread');
  });

  testWidgets('resuming while still genuinely active does not show the ended state',
      (tester) async {
    await pumpScreen(tester);
    WidgetsBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump();
    expect(find.text('This session has ended'), findsNothing);
    expect(find.byType(AttendChatScreen), findsOneWidget);
  });
}
