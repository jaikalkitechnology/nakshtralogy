import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../core/di.dart';
import 'consultation_repository.dart';

/// In-flight guard so a double-tap on a discovery card's Chat/Call/Video
/// button can't fire two consultation requests (each of which would create a
/// separate session and, for calls, could bill twice). Reset in a `finally`
/// so a failed/slow request always frees it. Only one consult can be starting
/// at a time app-wide, which is exactly the intent — you can't begin two
/// sessions at once. The profile screen has its own `_requesting` guard on a
/// separate path, so the two never contend.
bool _consultStarting = false;

/// Requests a consultation of [type] with [astrologerId] and, on success,
/// routes into the existing consultation screen. Shows a SnackBar on failure.
///
/// Shared by the astrologer cards (quick Chat/Call/Video actions) and the
/// profile screen so the request → route flow lives in exactly one place.
Future<void> startConsultation(
  BuildContext context,
  String astrologerId,
  ConsultationType type,
) async {
  if (_consultStarting) return;
  _consultStarting = true;
  final messenger = ScaffoldMessenger.of(context);
  final router = GoRouter.of(context);
  try {
    final c = await getIt<ConsultationRepository>().request(astrologerId, type);
    router.push('/consultation/${c.id}', extra: type);
  } on ApiException catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(e.message)));
  } finally {
    _consultStarting = false;
  }
}
