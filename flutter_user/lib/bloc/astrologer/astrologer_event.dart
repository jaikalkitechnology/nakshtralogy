import 'package:equatable/equatable.dart';

abstract class AstrologerEvent extends Equatable {
  const AstrologerEvent();
  @override
  List<Object?> get props => [];
}

class AstrologerLoadRequested extends AstrologerEvent {
  final int limit;
  final String? search;
  final String? specialization;
  final String? language;
  final bool onlineOnly;
  const AstrologerLoadRequested({this.limit = 20, this.search, this.specialization, this.language, this.onlineOnly = false});
  @override
  List<Object?> get props => [limit, search, specialization, language, onlineOnly];
}

class AstrologerSavedLoadRequested extends AstrologerEvent {}

class AstrologerToggleSave extends AstrologerEvent {
  final String astrologerId;
  const AstrologerToggleSave(this.astrologerId);
  @override
  List<Object?> get props => [astrologerId];
}

class AstrologerDetailRequested extends AstrologerEvent {
  final String astrologerId;
  const AstrologerDetailRequested(this.astrologerId);
  @override
  List<Object?> get props => [astrologerId];
}

class AstrologerDetailCleared extends AstrologerEvent {}
