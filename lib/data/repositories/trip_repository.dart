import 'package:living_city/data/models/trip_model.dart';
import 'package:living_city/data/provider/trip_provider.dart';

class TripRepository {
  final TripProvider _tripProvider;

  const TripRepository(this._tripProvider);

  Future<List<ProgressionTripModel>> getCompletedTrips() async {
    var list = await _tripProvider.getAllCompletedSortedByDate();
    return list;
  }

  Future<List<TripModel>> getPlannedTrips() async {
    var list = await _tripProvider.getAllPlannedSortedByDate();
    return list;
  }

  Future<ProgressionTripModel> getCurrentTrip() async {
    var trip = await _tripProvider.getCurrent();
    return trip;
  }

  Future startTrip(TripModel trip) async {
    final progressionTrip = ProgressionTripModel.initial(trip);
    await Future.wait([
      _tripProvider.deletePlanned(trip),
      _tripProvider.insertCurrent(progressionTrip),
    ]);
    //This also works
    // await _tripProvider.deletePlanned(trip);
    // await _tripProvider.insertCurrent(trip);
  }

  Future completeTrip() async {
    ProgressionTripModel trip = await _tripProvider.deleteAndGetCurrent();
    trip.id = null;
    _tripProvider.insertCompleted(trip);
  }

  Future addPlannedTrip(TripModel trip) async {
    await _tripProvider.insertPlanned(trip);
  }

  // Only for testing - Do not use
  // Future testInsertCompleted(TripModel trip) async {
  //   await _tripProvider.insertCompleted(trip);
  // }

  Future testCleanPlannedAndCurrentStores() async {
    await Future.wait([
      _tripProvider.testDeleteAllPlanned(),
      _tripProvider.deleteAndGetCurrent(),
      // _tripProvider.testDeleteAllCurrent(),
    ]);
  }

  Future testCleanEverything() async {
    await Future.wait([
      _tripProvider.testDeleteAllPlanned(),
      _tripProvider.testDeleteAllCurrent(),
      _tripProvider.testDeleteAllCompleted(),
    ]);
  }

  Future testAddCompleted(ProgressionTripModel trip) async {
    await _tripProvider.insertCompleted(trip);
  }
}
