part of 'trip_list_bloc.dart';

@immutable
abstract class TripListState {}

class TripListUninitialized extends TripListState {}

class TripListLoaded extends TripListState {
  final int sumCalories;
  final int sumPOIsVisited;
  final int sumTrips;
  final int sumDistance;
  final double avgSustainability;
  final List<TripModel> plannedTrips;
  final List<TripModel> completedTrips;
  final TripModel currentTrip;

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
