part of 'trip_list_bloc.dart';

@immutable
abstract class TripListState {}

class TripListUninitialized extends TripListState {}

class TripListLoaded extends TripListState {
  final int sumCalories;
  final int sumPOIsVisited;
  final int sumTrips;
  final int sumDistance;
  final List<TripModel> trips;

  TripListLoaded(
      this.sumCalories, this.sumPOIsVisited, this.sumDistance, this.trips)
      : sumTrips = trips.length;
}

class TripListLoading extends TripListState {}

class TripListEmpty extends TripListState {}
