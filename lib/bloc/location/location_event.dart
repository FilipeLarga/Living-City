part of 'location_bloc.dart';

@immutable
abstract class LocationEvent {
  const LocationEvent();
}

class LoadLocation extends LocationEvent {
  final String address;
  final LatLng coordinates;

  LoadLocation({this.address, this.coordinates});
}

class ResetLocation extends LocationEvent {
  const ResetLocation();
}
