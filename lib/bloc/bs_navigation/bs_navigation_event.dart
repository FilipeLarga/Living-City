part of 'bs_navigation_bloc.dart';

@immutable
abstract class BSNavigationEvent {
  const BSNavigationEvent();
}

class BSNavigationLoadActiveTrip extends BSNavigationEvent {
  const BSNavigationLoadActiveTrip();
}

class BSNavigationLocationSelected extends BSNavigationEvent {
  final String address;
  final LatLng coordinates;
  final LocationModel locationModel;

  const BSNavigationLocationSelected({this.address, this.coordinates, this.locationModel});
}

class BSNavigationCanceled extends BSNavigationEvent {
  const BSNavigationCanceled();
}

class BSNavigationLocationAccepted extends BSNavigationEvent {
  final LocationModel location;
  final bool origin;
  const BSNavigationLocationAccepted(this.location, {this.origin});
}

class BSNavigationMapSelection extends BSNavigationEvent {
  final LatLng coordinates;
  const BSNavigationMapSelection(this.coordinates);
}

class BSNavigationPlanStarted extends BSNavigationEvent {
  const BSNavigationPlanStarted();
}

class BSNavigationPointSelected extends BSNavigationEvent {
  final bool origin;
  const BSNavigationPointSelected(this.origin);
}

class BSNavigationAdvanced extends BSNavigationEvent {
  const BSNavigationAdvanced();
}

class BSNavigationRestrictionAdded extends BSNavigationEvent {
  final int date;
  final int effort;
  final int budget;
  const BSNavigationRestrictionAdded({this.date, this.effort, this.budget});
}

class BSNavigationInterestAdded extends BSNavigationEvent {
  final List<int> categories;
  final List<PointOfInterestModel> pois;

  const BSNavigationInterestAdded({this.categories, this.pois});
}
