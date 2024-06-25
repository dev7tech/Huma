// ignore_for_file: annotate_overrides

part of 'userlocation_bloc.dart';

abstract class UserLocationEvents extends Equatable {
  const UserLocationEvents();

  @override
  List<Object> get props => [];
}

class UserLocationRequest extends UserLocationEvents {
  final double latitude;
  final double longitude;

  const UserLocationRequest({required this.latitude, required this.longitude});

  List<Object> get props => [latitude, longitude];
}

abstract class UserlocationEvent extends Equatable {
  const UserlocationEvent();

  @override
  List<Object> get props => [];
}
