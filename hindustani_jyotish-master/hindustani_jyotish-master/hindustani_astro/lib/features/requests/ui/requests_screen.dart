import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../core/push/pending_request_action.dart';
import '../../../l10n/app_localizations.dart';
import '../../portal/portal_repository.dart';
import 'attend_call_screen.dart';
import 'attend_chat_screen.dart';

typedef _RequestsCubit = DataCubit<List<Consultation>>;

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<_RequestsCubit>(
      create: (_) => DataCubit(getIt<PortalRepository>().pendingRequests)..load(),
      child: const _RequestsView(),
    );
  }
}

class _RequestsView extends StatefulWidget {
  const _RequestsView();

  @override
  State<_RequestsView> createState() => _RequestsViewState();
}

class _RequestsViewState extends State<_RequestsView> with WidgetsBindingObserver {
  late final PendingRequestAction _pendingAction;

  /// A seeker's request expires server-side after a couple of minutes, and
  /// until now the only things that could surface one on an already-open
  /// Requests screen were a push notification or the astrologer manually
  /// pulling to refresh. On web there is no push at all, and on device a
  /// delayed/dropped notification meant the astrologer sat looking at "No
  /// pending requests" while the request quietly expired. So poll as well.
  Timer? _poll;
  static const _pollInterval = Duration(seconds: 8);

  /// Set while accept/decline is in flight (and while we're pushed into a
  /// call/chat screen) so a poll can't refresh the list out from under it.
  bool _busy = false;

  // Guards against retrying forever: a pending consultation that's genuinely
  // not in the list (already expired/handled elsewhere) should only trigger
  // one extra reload attempt (in case it simply hadn't arrived yet in an
  // already-loaded/stale list) before being dropped silently.
  String? _refreshAttemptedFor;

  @override
  void initState() {
    super.initState();
    _pendingAction = getIt<PendingRequestAction>();
    // Covers a Requests screen that was already built (and kept alive by
    // StatefulShellRoute.indexedStack) before this action arrived — a plain
    // BlocConsumer listener alone only fires on a *new* cubit state, which
    // won't happen just from this tab becoming relevant again.
    _pendingAction.addListener(_handlePendingAction);
    // Also covers an action that was already pending before this screen's
    // very first build (e.g. cold start straight into /requests).
    WidgetsBinding.instance.addPostFrameCallback((_) => _handlePendingAction());
    WidgetsBinding.instance.addObserver(this);
    _poll = Timer.periodic(_pollInterval, (_) => _pollOnce());
  }

  @override
  void dispose() {
    _poll?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _pendingAction.removeListener(_handlePendingAction);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Coming back from the background is exactly when the list is most likely
    // to be stale, and waiting up to a full poll interval to find out there's
    // someone waiting is the difference between taking the consult and it
    // expiring.
    if (state == AppLifecycleState.resumed) _pollOnce();
  }

  /// A deliberately quiet refresh: it asks the server directly and only pushes
  /// a new list into the cubit when the set of pending requests actually
  /// changed. Going through `cubit.refresh()` unconditionally would replace
  /// the screen with an error state on any transient network blip, and would
  /// rebuild the list every few seconds for no reason.
  Future<void> _pollOnce() async {
    if (!mounted || _busy) return;
    // Null means no lifecycle event has been delivered yet (cold start on some
    // platforms) — that's a running app, not a backgrounded one.
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    if (lifecycle != null && lifecycle != AppLifecycleState.resumed) return;
    try {
      final latest = await getIt<PortalRepository>().pendingRequests();
      if (!mounted || _busy) return;
      final current = context.read<_RequestsCubit>().state.dataOrNull;
      final changed = current == null ||
          current.length != latest.length ||
          !current.map((c) => c.id).toSet().containsAll(latest.map((c) => c.id));
      if (changed) context.read<_RequestsCubit>().emitLoaded(latest);
    } catch (_) {
      // Silent by design — a failed background poll must never take over the
      // screen. The next tick tries again, and pull-to-refresh still reports
      // errors normally.
    }
  }

  void _handlePendingAction() {
    if (!mounted) return;
    final pending = _pendingAction.peek();
    if (pending == null) return;

    final cubit = context.read<_RequestsCubit>();
    final items = cubit.state.dataOrNull;
    if (items == null) return; // still loading — this fires again once it emits.

    Consultation? match;
    for (final c in items) {
      if (c.id == pending.consultationId) {
        match = c;
        break;
      }
    }

    if (match == null) {
      // The request that triggered this action may simply not be in an
      // already-loaded (stale) list yet — reload once before giving up.
      if (_refreshAttemptedFor != pending.consultationId) {
        _refreshAttemptedFor = pending.consultationId;
        unawaited(cubit.refresh());
        return;
      }
      _pendingAction.consume();
      return;
    }

    _pendingAction.consume();
    _refreshAttemptedFor = null;
    if (pending.accept) {
      _accept(context, match);
    } else {
      _decline(context, match);
    }
  }

  Future<void> _accept(BuildContext context, Consultation c) async {
    final repo = getIt<PortalRepository>();
    final cubit = context.read<_RequestsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    _busy = true;
    try {
      final res = await repo.accept(c.id);
      if (c.type == ConsultationType.chat) {
        await navigator.push(MaterialPageRoute(
            builder: (_) =>
                AttendChatScreen(consultationId: c.id, userName: c.userName)));
      } else {
        // Guard the Agora payload: a missing/mis-typed field must produce a
        // clear message rather than an opaque cast crash.
        final agoraRaw = res['agora'];
        if (agoraRaw is! Map<String, dynamic>) {
          messenger.showSnackBar(const SnackBar(
              content: Text(
                  'Call could not start: the server did not return Agora call details.')));
          await cubit.refresh();
          return;
        }
        final grant = AgoraGrant.fromJson(agoraRaw);
        await navigator.push(MaterialPageRoute(
            builder: (_) => AttendCallScreen(
                  grant: grant,
                  video: c.type == ConsultationType.video,
                  consultationId: c.id,
                  userName: c.userName,
                )));
      }
      await cubit.refresh();
    } on ApiException catch (e) {
      // Backend/API error — surface the real detail (e.g. 409 not-in-requested).
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e, st) {
      // Any other failure (parse/null/socket/500) — surface the REAL message
      // instead of a generic "something went wrong", and log the stack.
      debugPrint('[accept] failed for ${c.id}: $e\n$st');
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      _busy = false;
    }
  }

  Future<void> _decline(BuildContext context, Consultation c) async {
    final cubit = context.read<_RequestsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    _busy = true;
    try {
      await getIt<PortalRepository>().decline(c.id);
      await cubit.refresh();
    } on ApiException catch (e) {
      // Backend/API error — surface the real detail (e.g. request already expired).
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e, st) {
      // Any other failure (parse/null/socket/500) — surface the REAL message
      // instead of a generic "something went wrong", and log the stack.
      debugPrint('[decline] failed for ${c.id}: $e\n$st');
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      _busy = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<_RequestsCubit, DataState<List<Consultation>>>(
        // Re-check on every new state (e.g. once the initial load — or a
        // reload triggered by _handlePendingAction itself — lands).
        listener: (context, state) => _handlePendingAction(),
        builder: (context, state) {
          final items = state.dataOrNull;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(AppLocalizations.of(context).reqTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.display(size: 22)),
                    ),
                    if (items != null && items.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.saffron,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text('${items.length}',
                            style: AppTextStyles.mono(size: 12, color: AppColors.indigoVoid)),
                      ),
                    ],
                    const Spacer(),
                    IconButton(
                      onPressed: () => context.read<_RequestsCubit>().refresh(),
                      icon: Icon(Icons.refresh, color: AppColors.ivoryDim),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => context.read<_RequestsCubit>().refresh(),
                  color: AppColors.saffron,
                  child: _body(context, state, items),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _body(BuildContext context, DataState<List<Consultation>> state, List<Consultation>? items) {
    if (items == null) {
      final err = state.errorMessage;
      if (err != null) return _scrollMessage(err, AppColors.danger);
      return const Center(child: CircularProgressIndicator(color: AppColors.saffron));
    }
    if (items.isEmpty) {
      return _emptyState(AppLocalizations.of(context).reqEmpty);
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        for (final c in items)
          _RequestCard(
            c: c,
            onAccept: () => _accept(context, c),
            onDecline: () => _decline(context, c),
          ),
      ],
    );
  }

  Widget _scrollMessage(String text, Color color) => ListView(
        children: [
          const SizedBox(height: 120),
          Center(
            child: Text(text, textAlign: TextAlign.center, style: AppTextStyles.body(color: color)),
          ),
        ],
      );

  /// Refined empty state — icon medallion + message instead of a bare Text.
  Widget _emptyState(String text) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        children: [
          const SizedBox(height: 110),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface2,
                border: Border.all(color: AppColors.borderSoft),
              ),
              child: Icon(Icons.inbox_outlined, size: 40, color: AppColors.ivoryFaint),
            ),
          ),
          const SizedBox(height: 18),
          Text(text,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(size: 14, color: AppColors.ivoryDim)),
        ],
      );
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.c, required this.onAccept, required this.onDecline});
  final Consultation c;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  IconData get _icon => switch (c.type) {
        ConsultationType.chat => Icons.chat_bubble_outline,
        ConsultationType.call => Icons.call,
        ConsultationType.video => Icons.videocam_outlined,
      };

  /// Per-type accent — existing brand constants only: chat = info blue,
  /// call = success green, video = premium copper.
  Color get _accent => switch (c.type) {
        ConsultationType.chat => AppColors.info,
        ConsultationType.call => AppColors.success,
        ConsultationType.video => AppColors.copperLight,
      };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [_accent.withValues(alpha: 0.08), AppColors.surface1],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accent.withValues(alpha: 0.30)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_icon, size: 20, color: _accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (c.userName != null && c.userName!.trim().isNotEmpty)
                          ? c.userName!
                          : 'Seeker',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body(size: 15, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(l.reqRequestLabel(c.type.name.toUpperCase()),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.mono(size: 11, color: _accent)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text('₹${c.rate}',
                    style: AppTextStyles.mono(
                        size: 13, weight: FontWeight.w700, color: AppColors.success)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDecline,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.danger),
                    foregroundColor: AppColors.danger,
                  ),
                  child: Text(l.reqDecline),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(
      // Explicit full width: the shared theme no longer forces an
      // (invalid) infinite minimum width on every ElevatedButton.
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),onPressed: onAccept, child: Text(l.reqAccept))),
            ],
          ),
        ],
      ),
    );
  }
}
