import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/consultation.dart' show AgoraGrant;

/// Thrown by [AgoraCallService.join]/[joinLive] when the grant is a server-side
/// placeholder (see [AgoraGrant.isPlaceholder]) instead of proceeding to native
/// Agora calls that would otherwise fail with a cryptic engine error (e.g.
/// AgoraRtcException -7 NOT_INITIALIZED) because the App ID/token are bogus.
class AgoraNotConfiguredException implements Exception {
  const AgoraNotConfiguredException([
    this.message =
        "Audio/video isn't available — the server hasn't provided a valid Agora credential yet.",
  ]);

  final String message;

  @override
  String toString() => message;
}

/// Thrown by [AgoraCallService.awaitJoined] when the channel join does not
/// actually complete — either the engine reported a fatal error (invalid App
/// ID, rejected/expired token, …) or nothing happened within the timeout.
///
/// This matters because the native `joinChannel` call itself returns as soon
/// as the REQUEST is acknowledged: an invalid token or App ID does NOT make
/// it throw — the failure arrives asynchronously via engine events. Without
/// awaiting the actual join, a host can sit on the "live" screen seeing their
/// own (purely local) camera preview while never being connected to the
/// channel at all — and every viewer sees "Connecting…" forever with zero
/// signal of what went wrong anywhere.
class AgoraJoinException implements Exception {
  const AgoraJoinException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Why the remote party left the channel, surfaced via [AgoraCallService.peerLeft].
///
/// Agora only tells you the remote peer went offline through a single event;
/// the *reason* it carries is what lets a caller distinguish a deliberate
/// hang-up ([quit] — end the call immediately and attribute it) from a
/// transient network drop ([dropped] — hold a bounded "Reconnecting…" grace
/// window and only end if they don't return). Without this, every peer
/// departure looks identical and a brief blip is indistinguishable from a
/// real hang-up.
enum PeerLeaveReason { quit, dropped }

/// Wraps the Agora RTC engine for 1:1 consultation calls and live streaming.
///
/// Usage: `await init(appId)` once, then `join(grant, video: …)`. The UI renders
/// [localView]/[remoteView] and listens to [remoteUid]/[joined]. Call [leave]
/// then [dispose] when done.
class AgoraCallService {
  RtcEngine? _engine;
  String _channel = '';

  // Memoized video widgets/controllers — see the doc comments on [localView]
  // and [remoteView] for why these are cached instead of built fresh on
  // every call.
  Widget? _localViewWidget;
  VideoViewController? _localController;
  Widget? _remoteViewWidget;
  VideoViewController? _remoteController;
  int? _remoteViewUid;

  /// `agora_rtc_engine` renders `AgoraVideoView` one of two ways on mobile:
  /// by default (`useFlutterTexture: false`) it embeds a native Android/iOS
  /// `PlatformView` into the Flutter tree via the platform-view channel
  /// (Hybrid Composition); with this set true it instead uses Flutter's own
  /// `Texture` widget — a normal Flutter `RenderObject` with no native view
  /// or platform-view channel involved at all.
  ///
  /// This matters specifically for the live broadcast screens: a
  /// `PlatformView` sits in a single-Activity Flutter app's ONE Android
  /// window, so opening the keyboard ANYWHERE in the app — including in a
  /// totally separate modal bottom sheet route stacked on top, as the
  /// compose fields on both live screens now are — still triggers the
  /// Activity's `android:windowSoftInputMode="adjustResize"` resize of that
  /// same window, which forces the platform view to redo native layout
  /// mid-frame. That is what a `PlatformView`-backed camera preview can
  /// still race a pointer/focus event into "Cannot hit test a render box
  /// with no size" (and, on some devices, into the IME never actually
  /// opening) even with every other precaution already taken — moving the
  /// TextField into its own sheet, memoizing the controller, hardening
  /// conditional widget swaps to `Visibility`. A `Texture` widget is not a
  /// platform view, isn't part of that native window-resize path, and
  /// participates in Flutter's own layout/hit-test system like any other
  /// widget — this removes the failure mode at its root instead of working
  /// around another one of its symptoms.
  static const bool _useFlutterTexture = true;

  /// The remote party's uid once they join (null before/after).
  final ValueNotifier<int?> remoteUid = ValueNotifier<int?>(null);

  /// The reason the remote party most recently left, or null while they are
  /// present (or have never joined). Set on `onUserOffline`, cleared back to
  /// null on `onUserJoined` so a rejoin within a caller's grace window reads
  /// as "peer is back". Screens listen to this to tell a clean hang-up
  /// ([PeerLeaveReason.quit]) apart from a network blip ([PeerLeaveReason.dropped]).
  final ValueNotifier<PeerLeaveReason?> peerLeft =
      ValueNotifier<PeerLeaveReason?>(null);

  /// Whether we've joined the channel.
  final ValueNotifier<bool> joined = ValueNotifier<bool>(false);

  final ValueNotifier<bool> muted = ValueNotifier<bool>(false);
  final ValueNotifier<bool> videoEnabled = ValueNotifier<bool>(true);

  /// Human-readable description of a fatal media failure reported by the
  /// engine (invalid App ID, rejected/expired token, connection banned…), or
  /// null while everything is healthy. Cleared automatically when a join
  /// succeeds. The engine reports these ONLY through async events — the
  /// join call itself returns "successfully" even with a bogus token — so
  /// without surfacing this, every credential problem is invisible: the host
  /// sees their own local preview, viewers see "Connecting…" forever, and
  /// nothing anywhere says why.
  final ValueNotifier<String?> mediaFailure = ValueNotifier<String?>(null);

  RtcEngine? get engine => _engine;
  bool get isInitialised => _engine != null;

  /// Ask for mic (+ camera for video) permission. Returns true if granted.
  static Future<bool> requestPermissions({required bool video}) async {
    final perms = <Permission>[Permission.microphone];
    if (video) perms.add(Permission.camera);
    final statuses = await perms.request();
    return statuses.values.every((s) => s.isGranted);
  }

  Future<void> init(String appId) async {
    if (_engine != null) return;
    final engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
    engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        debugPrint('[AgoraCallService] joined channel=${connection.channelId} '
            'localUid=${connection.localUid}');
        joined.value = true;
        mediaFailure.value = null;
      },
      onUserJoined: (RtcConnection connection, int uid, int elapsed) {
        debugPrint('[AgoraCallService] onUserJoined uid=$uid '
            'channel=${connection.channelId}');
        remoteUid.value = uid;
        // The peer is present again — clear any pending "left" reason so a
        // caller's reconnect grace can see they came back.
        peerLeft.value = null;
      },
      // Fallback path to surface the remote party: if `onUserJoined` was
      // somehow missed (a timing edge on the audience side of a live channel),
      // the first decoded remote video frame still tells us who to render, so
      // the viewer isn't stranded on "Waiting for the astrologer's video…"
      // while frames are actually arriving. All-int params (no version-specific
      // enums) so it stays build-safe across agora_rtc_engine minors.
      onFirstRemoteVideoFrame:
          (RtcConnection connection, int uid, int width, int height, int elapsed) {
        debugPrint('[AgoraCallService] first remote video frame uid=$uid '
            '${width}x$height channel=${connection.channelId}');
        if (remoteUid.value == null) remoteUid.value = uid;
      },
      onUserOffline: (RtcConnection connection, int uid, UserOfflineReasonType reason) {
        debugPrint('[AgoraCallService] onUserOffline uid=$uid reason=$reason');
        if (remoteUid.value == uid) {
          remoteUid.value = null;
          // Preserve WHY they left so the screen can end immediately on a
          // deliberate hang-up but hold a grace window on a network drop.
          peerLeft.value = reason == UserOfflineReasonType.userOfflineQuit
              ? PeerLeaveReason.quit
              : PeerLeaveReason.dropped;
        }
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        joined.value = false;
        remoteUid.value = null;
      },
      // The two channels the engine actually reports credential/connection
      // problems on. joinChannel() itself does NOT throw for a bad token/App
      // ID — without these, every such failure was completely silent.
      onError: (ErrorCodeType err, String msg) {
        debugPrint('[AgoraCallService] onError: $err $msg');
        final described = _describeError(err);
        if (described != null) mediaFailure.value = described;
      },
      onConnectionStateChanged: (
        RtcConnection connection,
        ConnectionStateType state,
        ConnectionChangedReasonType reason,
      ) {
        debugPrint('[AgoraCallService] connection state: $state ($reason)');
        if (state == ConnectionStateType.connectionStateFailed) {
          mediaFailure.value = _describeDisconnectReason(reason);
        }
      },
    ));
    _engine = engine;
  }

  /// Maps the fatal join/credential error codes to a human-readable line;
  /// returns null for codes that aren't join-fatal (transient warnings must
  /// not flag the stream as failed).
  static String? _describeError(ErrorCodeType err) => switch (err) {
        ErrorCodeType.errInvalidAppId =>
          'The configured video App ID is invalid (Agora error 101).',
        ErrorCodeType.errInvalidChannelName =>
          'Invalid video channel name (Agora error 102).',
        ErrorCodeType.errTokenExpired =>
          'The video access token has expired (Agora error 109).',
        ErrorCodeType.errInvalidToken =>
          'The video service rejected the access token (Agora error 110) — '
              'the Agora App ID/Certificate configured on the server does not '
              'match the Agora project.',
        ErrorCodeType.errJoinChannelRejected =>
          'The video service rejected the join request (Agora error 17).',
        _ => null,
      };

  static String _describeDisconnectReason(ConnectionChangedReasonType reason) =>
      switch (reason) {
        ConnectionChangedReasonType.connectionChangedInvalidToken ||
        ConnectionChangedReasonType.connectionChangedTokenExpired =>
          'The video service rejected the access token — the Agora App ID/'
              'Certificate configured on the server does not match the Agora '
              'project.',
        ConnectionChangedReasonType.connectionChangedInvalidAppId =>
          'The configured video App ID is invalid.',
        ConnectionChangedReasonType.connectionChangedRejectedByServer =>
          'The video service rejected the connection.',
        ConnectionChangedReasonType.connectionChangedBannedByServer =>
          'This device was banned from the video channel.',
        _ => 'Could not connect to the video service ($reason).',
      };

  /// Completes once the channel join actually succeeds ([joined] flips
  /// true). Throws [AgoraJoinException] if the engine reports a fatal
  /// failure first, or if neither happens within [timeout].
  ///
  /// Call this right after [join]/[joinLive]: those only await the native
  /// REQUEST — real success/failure arrives asynchronously (see
  /// [AgoraJoinException]'s doc for the on-device symptoms of skipping
  /// this).
  Future<void> awaitJoined({Duration timeout = const Duration(seconds: 15)}) async {
    if (joined.value) return;
    final failure = mediaFailure.value;
    if (failure != null) throw AgoraJoinException(failure);

    final completer = Completer<void>();
    void check() {
      if (completer.isCompleted) return;
      if (joined.value) {
        completer.complete();
      } else if (mediaFailure.value != null) {
        completer.completeError(AgoraJoinException(mediaFailure.value!));
      }
    }

    joined.addListener(check);
    mediaFailure.addListener(check);
    try {
      await completer.future.timeout(
        timeout,
        onTimeout: () => throw AgoraJoinException(
          mediaFailure.value ??
              'Timed out connecting to the video channel. Check your internet '
                  'connection and try again.',
        ),
      );
    } finally {
      // The service can be disposed while this wait is pending (the user
      // backs out of the screen mid-connect) — the notifiers are disposed
      // with it, and removeListener on a disposed ChangeNotifier asserts.
      if (!_disposed) {
        joined.removeListener(check);
        mediaFailure.removeListener(check);
      }
    }
  }

  /// Join the channel described by [grant]. Enables video for video calls.
  ///
  /// Throws [AgoraNotConfiguredException] — before touching the native engine
  /// at all — if [grant] is a placeholder, so a misconfigured server never
  /// crashes the native SDK with a cryptic error code.
  Future<void> join(AgoraGrant grant, {required bool video}) async {
    if (grant.isPlaceholder) throw const AgoraNotConfiguredException();
    final engine = _engine;
    if (engine == null) throw StateError('AgoraCallService not initialised');
    _channel = grant.channel;
    videoEnabled.value = video;

    await engine.enableAudio();
    if (video) {
      await engine.enableVideo();
      await engine.startPreview();
    } else {
      await engine.disableVideo();
    }

    await engine.joinChannel(
      token: grant.token,
      channelId: grant.channel,
      uid: grant.uid,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );
  }

  /// Join a live-streaming channel. The host joins as broadcaster (publishes
  /// audio+video); viewers join as audience (subscribe only).
  ///
  /// Throws [AgoraNotConfiguredException] if [grant] is a placeholder — see
  /// [join] for why this guard exists.
  Future<void> joinLive(AgoraGrant grant, {required bool asHost}) async {
    if (grant.isPlaceholder) throw const AgoraNotConfiguredException();
    final engine = _engine;
    if (engine == null) throw StateError('AgoraCallService not initialised');
    _channel = grant.channel;
    videoEnabled.value = asHost;

    await engine.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    await engine.setClientRole(
      role: asHost ? ClientRoleType.clientRoleBroadcaster : ClientRoleType.clientRoleAudience,
    );
    // enableVideo()/enableAudio() initialise the engine's media pipeline —
    // including the DECODE side needed to render an incoming remote stream —
    // not just local capture/publish. This used to run only `if (asHost)`,
    // which meant a viewer (asHost: false) never initialised the video
    // pipeline at all: `onUserJoined` still fired (that's just channel
    // presence) and `remoteView()` still built an `AgoraVideoView`, but with
    // no video module enabled there were no decoded frames for it to
    // display, so viewers saw a permanently black/empty remote view even
    // though the astrologer's own preview and the join itself both
    // succeeded. `startPreview()` (local camera capture) is still
    // host-only — a viewer must never turn on its own camera.
    await engine.enableAudio();
    await engine.enableVideo();
    if (asHost) {
      await engine.startPreview();
    }

    await engine.joinChannel(
      token: grant.token,
      channelId: grant.channel,
      uid: grant.uid,
      options: ChannelMediaOptions(
        clientRoleType:
            asHost ? ClientRoleType.clientRoleBroadcaster : ClientRoleType.clientRoleAudience,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        publishMicrophoneTrack: asHost,
        publishCameraTrack: asHost,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
    );
  }

  Future<void> toggleMute() async {
    muted.value = !muted.value;
    await _engine?.muteLocalAudioStream(muted.value);
  }

  Future<void> toggleVideo() async {
    videoEnabled.value = !videoEnabled.value;
    await _engine?.muteLocalVideoStream(!videoEnabled.value);
  }

  Future<void> switchCamera() async => _engine?.switchCamera();

  Future<void> leave() async {
    await _engine?.leaveChannel();
    joined.value = false;
    remoteUid.value = null;
  }

  /// The local camera preview widget.
  ///
  /// Memoized: constructing a fresh `VideoViewController` allocates a new
  /// underlying native platform view every time — calling this inline in a
  /// screen's `build()` (as every caller does, since the widget it returns
  /// has to be a normal part of the widget tree) meant a brand new camera
  /// preview was being torn down and recreated on EVERY rebuild, including
  /// ones with nothing to do with the video at all (an incoming chat
  /// message, a viewer-count tick — very frequent during an active
  /// broadcast). Repeatedly destroying/recreating a platform view mid-
  /// broadcast is exactly the kind of churn that produces a transient
  /// "Cannot hit test a render box with no size" — the new view hasn't
  /// finished laying out yet when a pointer event's hit-test pass happens
  /// to run — and it also leaked the old, discarded `VideoViewController`
  /// every time, since nothing ever called `.dispose()` on it. Now built
  /// once per engine and reused across every rebuild.
  Widget localView() {
    final engine = _engine;
    if (engine == null) return const SizedBox.shrink();
    if (_localController == null) {
      _localController = VideoViewController(
        rtcEngine: engine,
        canvas: const VideoCanvas(uid: 0),
        useFlutterTexture: _useFlutterTexture,
      );
      _localViewWidget = AgoraVideoView(controller: _localController!);
    }
    return _localViewWidget!;
  }

  /// The remote party's video widget (empty until they join). Memoized the
  /// same way and for the same reason as [localView] — rebuilt only when
  /// the remote `uid` actually changes (they left and a different party
  /// joined), not on every unrelated rebuild.
  Widget remoteView() {
    final engine = _engine;
    final uid = remoteUid.value;
    if (engine == null || uid == null) return const SizedBox.shrink();
    if (_remoteController == null || _remoteViewUid != uid) {
      _remoteController = VideoViewController.remote(
        rtcEngine: engine,
        canvas: VideoCanvas(uid: uid),
        connection: RtcConnection(channelId: _channel),
        useFlutterTexture: _useFlutterTexture,
      );
      _remoteViewWidget = AgoraVideoView(controller: _remoteController!);
      _remoteViewUid = uid;
    }
    return _remoteViewWidget!;
  }

  bool _disposed = false;

  Future<void> dispose() async {
    // Idempotent: teardown can be reached from more than one owner (e.g. a
    // cubit's close() and a screen's dispose()) — a second call must be a
    // no-op, not a "ValueNotifier used after being disposed" crash.
    if (_disposed) return;
    _disposed = true;
    remoteUid.dispose();
    peerLeft.dispose();
    joined.dispose();
    muted.dispose();
    videoEnabled.dispose();
    mediaFailure.dispose();
    // Explicitly dispose the cached video controllers rather than just
    // dropping the references — AgoraVideoView's own widget lifecycle
    // handles this when a NEW controller replaces an old one in the same
    // widget position (see didUpdateWidget in agora_rtc_engine's internal
    // implementation), but nothing else does that on the service's own
    // teardown path once the widget tree is gone entirely.
    await _localController?.dispose();
    await _remoteController?.dispose();
    _localController = null;
    _localViewWidget = null;
    _remoteController = null;
    _remoteViewWidget = null;
    _remoteViewUid = null;
    await _engine?.leaveChannel();
    await _engine?.release();
    _engine = null;
  }
}
