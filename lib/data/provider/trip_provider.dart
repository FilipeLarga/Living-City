import 'package:living_city/data/models/trip_model.dart';
import 'package:living_city/data/database/trip_database.dart';
import 'package:sembast/sembast.dart';

class TripProvider {
  static const String COMPLETED_TRIP_STORE_NAME = 'completed_trips';
  static const String PLANNED_TRIP_STORE_NAME = 'planned_trips';
  static const String CURRENT_TRIP_STORE_NAME = 'current_trip';

  final _completedTripsStore =
      intMapStoreFactory.store(COMPLETED_TRIP_STORE_NAME);
  final _plannedTripsStore = intMapStoreFactory.store(PLANNED_TRIP_STORE_NAME);
  final _currentTripStore = intMapStoreFactory.store(CURRENT_TRIP_STORE_NAME);

  final TripDatabase _tripDatabase;

  Future<Database> get _db async => await _tripDatabase.database;

  TripProvider(this._tripDatabase) {
    //_validateStores();
  }

  Future insertCompleted(ProgressionTripModel trip) async {
    var key = await _completedTripsStore.add(await _db, trip.toMap());
  }

  Future insertPlanned(TripModel trip) async {
    await _plannedTripsStore.add(await _db, trip.toMap());
  }

  Future insertCurrent(ProgressionTripModel trip) async {
    //Maybe check for other trips here...
    await _currentTripStore.add(await _db, trip.toMap());
  }

  Future updateCompleted(ProgressionTripModel trip) async {
    final finder = Finder(filter: Filter.byKey(trip.id));
    await _completedTripsStore.update(
      await _db,
      trip.toMap(),
      finder: finder,
    );
  }

  Future updatePlanned(TripModel trip) async {
    final finder = Finder(filter: Filter.byKey(trip.id));
    await _plannedTripsStore.update(
      await _db,
      trip.toMap(),
      finder: finder,
    );
  }

  Future updateCurrent(ProgressionTripModel trip) async {
    final finder = Finder(filter: Filter.byKey(trip.id));
    await _currentTripStore.update(
      await _db,
      trip.toMap(),
      finder: finder,
    );
  }

  Future deleteCompleted(ProgressionTripModel trip) async {
    final finder = Finder(filter: Filter.byKey(trip.id));
    await _completedTripsStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future deletePlanned(TripModel trip) async {
    final finder = Finder(filter: Filter.byKey(trip.id));
    await _plannedTripsStore.delete(
      await _db,
      finder: finder,
    );
  }

  // Future<TripModel> deleteAndGetPlanned(TripModel trip) async {
  //   var result = await _plannedTripsStore.findFirst(await _db,
  //       finder: Finder(filter: Filter.byKey(trip.id)));
  //   if (result != null) {
  //     TripModel trip = TripModel.fromJson(result.value);
  //     trip.id = result.key;
  //     await _plannedTripsStore.delete(await _db,
  //         finder: Finder(filter: Filter.byKey(trip.id)));
  //     return trip;
  //   } else
  //     return null;
  // }

  Future<ProgressionTripModel> deleteAndGetCurrent() async {
    var result = await _currentTripStore.findFirst(await _db);
    if (result != null) {
      ProgressionTripModel trip = ProgressionTripModel.fromJson(result.value);
      trip.id = result.key;
      await _currentTripStore.delete(await _db,
          finder: Finder(filter: Filter.byKey(trip.id)));
      return trip;
    } else
      return null;
  }

  Future<List<ProgressionTripModel>> getAllCompletedSortedByDate() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('time.startTime'),
    ]);

    final recordSnapshots = await _completedTripsStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Fruit> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final trip = ProgressionTripModel.fromJson(snapshot.value);
      // An ID is a key of a record from the database.
      trip.id = snapshot.key;
      return trip;
    }).toList();
  }

  Future<List<TripModel>> getAllPlannedSortedByDate() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('time.startTime'),
    ]);

    final recordSnapshots = await _plannedTripsStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Fruit> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final trip = TripModel.fromJson(snapshot.value);
      // An ID is a key of a record from the database.
      trip.id = snapshot.key;
      return trip;
    }).toList();
  }

  Future<ProgressionTripModel> getCurrent() async {
    // Finder object can also sort data.
    final finder = Finder();

    final recordSnapshots = await _currentTripStore.find(
      await _db,
      finder: finder,
    );

    if (recordSnapshots.length > 1)
      print(
          'ERRO! Current Trip só deiva ser uma mas há: ${recordSnapshots.length}');

    if (recordSnapshots == null || recordSnapshots.isEmpty) return null;

    // Making a List<Fruit> out of List<RecordSnapshot>
    final trip = ProgressionTripModel.fromJson(recordSnapshots.first.value);
    trip.id = recordSnapshots.first.key;
    return trip;
  }

  //Future _validateStores() {}

  // Future<List<TripModel>> getTripHistory() async {
  //   return await Future.delayed(Duration(milliseconds: 3000), () {
  //     return [
  //       TripModel(null, null, null, null, 75, 100, 500, 500),
  //       TripModel(null, null, null, null, 75, 100, 500, 500)
  //     ];
  //   });
  // }

  // Test Purposes Only!!
  Future testDeleteAllPlanned() async {
    await _plannedTripsStore.delete(
      await _db,
    );
  }

  Future testDeleteAllCurrent() async {
    await _currentTripStore.delete(
      await _db,
    );
  }

  Future testDeleteAllCompleted() async {
    await _completedTripsStore.delete(
      await _db,
    );
  }
}
