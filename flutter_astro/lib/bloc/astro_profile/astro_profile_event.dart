import 'package:equatable/equatable.dart';

abstract class AstroProfileEvent extends Equatable {
  const AstroProfileEvent();
  @override
  List<Object?> get props => [];
}

class AstroProfileLoadRequested extends AstroProfileEvent {}

class AstroProfileUpdateRequested extends AstroProfileEvent {
  /// Combines user-level fields (name, phone) + astrologer profile fields.
  /// The bloc decides which endpoint(s) to hit.
  final Map<String, dynamic> userFields;
  final Map<String, dynamic> profileFields;
  const AstroProfileUpdateRequested({this.userFields = const {}, this.profileFields = const {}});
  @override
  List<Object?> get props => [userFields, profileFields];
}
