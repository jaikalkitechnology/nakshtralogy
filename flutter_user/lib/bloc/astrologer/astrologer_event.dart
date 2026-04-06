import 'package:equatable/equatable.dart';

abstract class AstrologerEvent extends Equatable {
  const AstrologerEvent();
  @override
  List<Object?> get props => [];
}

class AstrologerLoadRequested extends AstrologerEvent {
  final int limit;
  final String? search;
  const AstrologerLoadRequested({this.limit = 20, this.search});
  @override
  List<Object?> get props => [limit, search];
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
