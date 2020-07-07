import 'package:living_city/data/database/point_of_interest_database.dart';
import 'package:sembast/sembast.dart';

import '../../models/point_of_interest_model.dart';

class PointsOfInterestLocalProvider {
  static const String COMPLETED_TRIP_STORE_NAME = 'poi';
  final _poiStore = intMapStoreFactory.store(COMPLETED_TRIP_STORE_NAME);

  final PointOfInterestDatabase _poiDatabase;

  Future<Database> get _db async => await _poiDatabase.database;

  PointsOfInterestLocalProvider(this._poiDatabase) {
    //_validateStores();
  }

  Future<List<PointOfInterestModel>> getPointsOfInterest() async {
    final recordSnapshots = await _poiStore.find(
      await _db,
    );

    // Making a List<Fruit> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final poi = PointOfInterestModel.fromJson(snapshot.value);
      // An ID is a key of a record from the database.
      poi.id = snapshot.key;
      return poi;
    }).toList();
  }

  Future<void> insertPointsOfInterest(List<PointOfInterestModel> pois) async {
    await _poiStore.addAll(await _db, pois.map((e) => e.toMap()).toList());
  }

  Future<void> removeAll() async {
    await _poiStore.delete(await _db);
  }
}
