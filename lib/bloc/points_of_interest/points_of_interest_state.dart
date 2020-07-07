part of 'points_of_interest_bloc.dart';

@immutable
abstract class PointsOfInterestState {
  const PointsOfInterestState();
}

class PointsOfInterestInitial extends PointsOfInterestState {
  const PointsOfInterestInitial();
}

class PointsOfInterestLoading extends PointsOfInterestState {
  const PointsOfInterestLoading();
}

class PointsOfInterestLoaded extends PointsOfInterestState {
  final List<PointOfInterestModel> pois;
  const PointsOfInterestLoaded(this.pois);
}

class PointsOfInterestEmpty extends PointsOfInterestState {
  const PointsOfInterestEmpty();
}
