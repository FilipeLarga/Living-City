part of 'trip_list_bloc.dart';

@immutable
abstract class TripListState {
  const TripListState();
}

class TripListUninitialized extends TripListState {
  const TripListUninitialized();
}

class TripListLoaded extends TripListState {
  final int sumCalories;
  final int sumPOIsVisited;
  final int sumTrips;
  final int sumDistance;
  final double avgSustainability;
  final List<TripModel> plannedTrips;
  final List<ProgressionTripModel> completedTrips;
  final ProgressionTripModel currentTrip;

  TripListLoaded(
      this.sumCalories,
      this.sumPOIsVisited,
      this.sumDistance,
      this.avgSustainability,
      this.plannedTrips,
      this.completedTrips,
      this.currentTrip)
      : sumTrips = completedTrips.length;
}

class TripListLoading extends TripListState {}
