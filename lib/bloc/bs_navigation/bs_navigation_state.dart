part of 'bs_navigation_bloc.dart';

@immutable
abstract class BSNavigationState {
  const BSNavigationState();
}

class BSNavigationExplore extends BSNavigationState {
  const BSNavigationExplore();
}

class BSNavigationShowingLocation extends BSNavigationState {
  final String address;
  final LatLng coordinates;
  final LocationModel locationModel;
  final bool origin;
  const BSNavigationShowingLocation(
      {this.address, this.coordinates, this.locationModel, this.origin});
}

class BSNavigationPlanningPoints extends BSNavigationState {
  final LocationModel origin;
  final LocationModel destination;
  const BSNavigationPlanningPoints({this.origin, this.destination});
}

class BSNavigationSelectingLocation extends BSNavigationState {
  final bool isOrigin;

  const BSNavigationSelectingLocation(this.isOrigin);
}

class BSNavigationPlanningRestrictions extends BSNavigationState {
  final int date;
  final int effort;
  final int budget;
  const BSNavigationPlanningRestrictions({this.date, this.effort, this.budget});
}

class BSNavigationPlanningInterests extends BSNavigationState {
  final List<int> categories;
  final List<PointOfInterestModel> pois;

  const BSNavigationPlanningInterests({this.categories, this.pois});
}

class BSNavigationActiveTrip extends BSNavigationState {
  final ProgressionTripModel trip;
  const BSNavigationActiveTrip(this.trip);
}
