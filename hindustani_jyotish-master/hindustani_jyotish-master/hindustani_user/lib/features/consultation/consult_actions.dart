import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../core/di.dart';
import 'consultation_repository.dart';

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
  final messenger = ScaffoldMessenger.of(context);
  final router = GoRouter.of(context);
  try {
    final c = await getIt<ConsultationRepository>().request(astrologerId, type);
    router.push('/consultation/${c.id}', extra: type);
  } on ApiException catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(e.message)));
  }
}
