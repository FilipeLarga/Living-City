import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../data/models/point_of_interest_model.dart';
import '../../data/repositories/points_of_interest_repository.dart';

part 'points_of_interest_event.dart';
part 'points_of_interest_state.dart';

class PointsOfInterestBloc
    extends Bloc<PointsOfInterestEvent, PointsOfInterestState> {
  final PointsOfInterestRepository _pointsOfInterestRepository;

  PointsOfInterestBloc(this._pointsOfInterestRepository)
      : super(const PointsOfInterestInitial());

  @override
  Stream<PointsOfInterestState> mapEventToState(
    PointsOfInterestEvent event,
  ) async* {
    if (event is PointsOfInterestFetch)
      yield* _handleFetch();
    else if (event is PointsOfInterestQuickFetch) yield* _handleQuickFetch();
  }

  Stream<PointsOfInterestState> _handleFetch() async* {
    yield PointsOfInterestLoading();
    final pois = await _pointsOfInterestRepository.getPointsOfInterest();
    if (pois == null || pois.isEmpty)
      yield PointsOfInterestEmpty();
    else
      yield PointsOfInterestLoaded(pois);
  }

  Stream<PointsOfInterestState> _handleQuickFetch() async* {
    yield PointsOfInterestLoading();
    final pois = await _pointsOfInterestRepository.getLocalPointsOfInterest();
    if (pois == null || pois.isEmpty)
      yield PointsOfInterestEmpty();
    else
      yield PointsOfInterestLoaded(pois);
  }
}
