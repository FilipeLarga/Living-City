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
  final int date;
  const BSNavigationPlanningPoints({
    this.origin,
    this.destination,
    this.date,
  });
}

class BSNavigationSelectingLocation extends BSNavigationState {
  final bool isOrigin;

  const BSNavigationSelectingLocation(this.isOrigin);
}

class BSNavigationPlanningRestrictions extends BSNavigationState {
  final int minVisitTime;
  final int visitTime;
  final int departureDate;
  final int effort;
  final int budget;
  final int minBudget;
  const BSNavigationPlanningRestrictions(
      {@required this.minVisitTime,
      @required this.visitTime,
      @required this.departureDate,
      this.minBudget,
      this.effort,
      this.budget});
}

class BSNavigationPlanningInterests extends BSNavigationState {
  final List<int> categories;
  final List<PointOfInterestModel> pois;
  final int departureHour;
  final LatLng origin;

  const BSNavigationPlanningInterests(
      {this.categories,
      this.pois,
      @required this.departureHour,
      @required this.origin});
}

class BSNavigationConfirmingTrip extends BSNavigationState {
  final TripPlanModel tripPlanModel;
  const BSNavigationConfirmingTrip(this.tripPlanModel);
}

class BSNavigationActiveTrip extends BSNavigationState {
  final ProgressionTripModel trip;
  const BSNavigationActiveTrip(this.trip);
}
