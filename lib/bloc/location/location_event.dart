part of 'location_bloc.dart';

@immutable
abstract class LocationEvent {
  const LocationEvent();
}

class LoadLocation extends LocationEvent {
  String address;
  LatLng coordinates;

  LoadLocation.address(this.address);
  LoadLocation.coordinates(this.coordinates);
}

class ResetLocation extends LocationEvent {
  const ResetLocation();
}
