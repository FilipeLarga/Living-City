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

class ShowPreLoadedLocation extends LocationEvent {
  final LocationModel location;

  ShowPreLoadedLocation({@required this.location});
}

class ClearLocation extends LocationEvent {
  const ClearLocation();
}
