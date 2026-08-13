part of 'astro_session_cubit.dart';

enum SessionStatus { unknown, unauthenticated, authenticated }

class AstroSessionState extends Equatable {
  const AstroSessionState({this.status = SessionStatus.unknown, this.astrologer});

  final SessionStatus status;
  final Astrologer? astrologer;

  bool get isAuthenticated => status == SessionStatus.authenticated && astrologer != null;
  bool get isApproved => astrologer?.isApproved ?? false;

  AstroSessionState copyWith({SessionStatus? status, Astrologer? astrologer}) =>
      AstroSessionState(status: status ?? this.status, astrologer: astrologer ?? this.astrologer);

  @override
  List<Object?> get props => [status, astrologer];
}
