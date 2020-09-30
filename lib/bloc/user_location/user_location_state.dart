part of 'user_location_bloc.dart';

@immutable
abstract class UserLocationState {}

class UserLocationInitial extends UserLocationState {}

class UserLocationLoaded extends UserLocationState {
  final LatLng location;

  UserLocationLoaded(this.location);
}
