part of 'points_of_interest_bloc.dart';

@immutable
abstract class PointsOfInterestEvent {
  const PointsOfInterestEvent();
}

class PointsOfInterestFetch extends PointsOfInterestEvent {
  const PointsOfInterestFetch();
}
