part of 'location_bloc.dart';

@immutable
abstract class LocationState {
  const LocationState();
}

class LocationInactive extends LocationState {
  const LocationInactive();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationError extends LocationState {
  final Error error;
  const LocationError(this.error);
}

class LocationLoaded extends LocationState {
  final LocationModel location;
  const LocationLoaded(this.location);
}
