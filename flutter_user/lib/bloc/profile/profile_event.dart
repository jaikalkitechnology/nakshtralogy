import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {}

class ProfileUpdateRequested extends ProfileEvent {
  final Map<String, dynamic> fields;
  const ProfileUpdateRequested(this.fields);
  @override
  List<Object?> get props => [fields];
}

class ProfileOrdersLoadRequested extends ProfileEvent {}
