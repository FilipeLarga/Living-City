part of 'user_location_bloc.dart';

@immutable
abstract class UserLocationEvent {}

class NewLocation extends UserLocationEvent {
  final LatLng location;

  NewLocation(this.location);
}
