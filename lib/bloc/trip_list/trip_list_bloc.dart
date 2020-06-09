import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:living_city/data/models/trip_model.dart';
import 'package:living_city/data/repositories/trip_repository.dart';
import 'package:meta/meta.dart';

part 'trip_list_event.dart';
part 'trip_list_state.dart';

class TripListBloc extends Bloc<TripListEvent, TripListState> {
  final TripRepository _tripRepository;

  TripListBloc(this._tripRepository);

  @override
  TripListState get initialState => TripListUninitialized();

  @override
  Stream<TripListState> mapEventToState(
    TripListEvent event,
  ) async* {
    yield* _mapLoadToState(event);
  }

  Stream<TripListState> _mapLoadToState(LoadTripList event) async* {
    yield TripListLoading();
    List<TripModel> tripList = await _tripRepository.getTripHistory();

    if (tripList == null || tripList.isEmpty) {
      yield TripListEmpty();
    } else {
      int sumCalories = 0, sumDistance = 0, sumPOIsVisited = 0;
      for (TripModel trip in tripList) {
        sumCalories += trip.calories;
        sumDistance += trip.distance;
        sumPOIsVisited += trip.pointsOfInterest?.length ?? 0;
      }
      yield TripListLoaded(sumCalories, sumPOIsVisited, sumDistance, tripList);
    }
  }
}
