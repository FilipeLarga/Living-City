import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:living_city/data/models/trip_model.dart';
import 'package:living_city/data/repositories/trip_repository.dart';
import 'package:meta/meta.dart';
import '../../core/example_data.dart' as coords;
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

    // // Testing purposes only
    // // Test case: Add 5 planned trips. Start one of them

    // // Clean Planned and Current stores
    // await _tripRepository.testCleanPlannedAndCurrentStores();
    await _tripRepository.testCleanEverything();
    // print('Apaguei o planned e current');
    // // Create Trip
    var trip = coords.trip;

    // //Add this trip to planned list
    await _tripRepository.addPlannedTrip(trip);
    await _tripRepository.addPlannedTrip(trip);
    await _tripRepository.addPlannedTrip(trip);
    // // await _tripRepository.addPlannedTrip(trip);
    // // await _tripRepository.addPlannedTrip(trip);

    var tripsTest = await _tripRepository.getPlannedTrips();
    await _tripRepository.startTrip(tripsTest[0]);

    // await _tripRepository.testAddCompleted(ProgressionTripModel.initial(trip));
    // await _tripRepository.testAddCompleted(ProgressionTripModel.initial(trip));
    // await _tripRepository.testAddCompleted(ProgressionTripModel.initial(trip));

    // //Get Planned trips
    // List<TripModel> trips = await _tripRepository.getPlannedTrips();
    // print('Isto devia ser 5 e é ${trips.length}');

    // //Start a trip
    // await _tripRepository.startTrip(trips[0]);

    // //Check if it's 4 trips now
    // List<TripModel> trips2 = await _tripRepository.getPlannedTrips();
    // print('Isto devia ser 4 e é ${trips2.length}');

    ProgressionTripModel currentTrip = await _tripRepository.getCurrentTrip();
    List<TripModel> plannedList = await _tripRepository.getPlannedTrips();
    List<ProgressionTripModel> completedList =
        await _tripRepository.getCompletedTrips();

    int sumCalories = 0,
        sumDistance = 0,
        sumPOIsVisited = 0,
        sumSustainability = 0;

    for (ProgressionTripModel trip in completedList) {
      sumCalories += trip.originalTrip.calories;
      sumDistance += trip.originalTrip.distance;
      sumPOIsVisited += trip.originalTrip.pois?.length ?? 0;
      sumSustainability += trip.originalTrip.sustainability;
    }

    yield TripListLoaded(
        sumCalories,
        sumPOIsVisited,
        sumDistance,
        sumSustainability.toDouble() / completedList.length,
        plannedList,
        completedList,
        currentTrip);
  }
}
