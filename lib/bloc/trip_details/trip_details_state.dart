part of 'trip_details_bloc.dart';

@immutable
abstract class TripDetailsState {
  final TripModel trip;

  TripDetailsState(this.trip);
}

class TripDetailsInitial extends TripDetailsState {
  TripDetailsInitial(TripModel trip) : super(trip);
}
