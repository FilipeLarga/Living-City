import 'package:get_it/get_it.dart';
import 'package:living_city/data/provider/geocoding_provider.dart';
import 'package:living_city/data/provider/search_history_provider.dart';
import 'package:living_city/data/provider/trip_provider.dart';
import 'package:living_city/data/repositories/location_repository.dart';
import 'package:living_city/data/repositories/trip_repository.dart';
import 'package:living_city/data/database/trip_database.dart';

final sl = GetIt.instance;

void init() {
  // Repositories
  sl.registerLazySingleton(() => LocationRepository(sl(), sl()));
  sl.registerLazySingleton(() => TripRepository(sl()));

  // Providers
  sl.registerLazySingleton(() => SearchHistoryProvider());
  sl.registerLazySingleton(() => GeolocatorProvider());
  sl.registerLazySingleton(() => TripProvider(sl()));

  // Database
  sl.registerLazySingleton(() => TripDatabase());
}
