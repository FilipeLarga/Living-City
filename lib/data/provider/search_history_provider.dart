import '../../data/models/location_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class SearchHistoryProvider {
  Database _db;

  Future<void> _init() async {
    _db = await openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), 'search_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE searches(id INTEGER PRIMARY KEY AUTOINCREMENT, address TEXT, latitude REAL, longitude REAL)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> insertSearch(LocationModel location) async {
    // Init the database if it's not already.
    if (_db == null) {
      await _init();
    }

    // Count the number of entries. If it's under 10 keep adding them if not replace the oldest.
    int count = Sqflite.firstIntValue(
        await _db.rawQuery('SELECT COUNT(*) FROM searches'));

    if (count < 10) {
      await _db.insert(
        'searches',
        location.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      //Delete the first (oldest) entry and insert the new one
      await _db.rawDelete(
          'Delete from searches where id IN (Select id from searches limit 1)');
      await _db.insert(
        'searches',
        location.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<LocationModel>> getSearches() async {
    // Init the database if it's not already.
    if (_db == null) {
      await _init();
    }

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await _db.query('searches');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return LocationModel.fromMap(maps[i]);
    }).reversed.toList();
  }
}
