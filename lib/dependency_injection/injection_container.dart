import 'package:get_it/get_it.dart';
import 'package:living_city/core/bluetooth_detection_service.dart';
import 'package:living_city/data/database/ble_devices_database.dart';
import 'package:living_city/data/database/point_of_interest_database.dart';
import 'package:living_city/data/provider/location_provider.dart';
import 'package:living_city/data/provider/points_of_interest_providers.dart/points_of_interest_local_provider.dart';
import 'package:living_city/data/provider/points_of_interest_providers.dart/points_of_interest_remote_provider.dart';
import 'package:living_city/data/provider/search_history_provider.dart';
import 'package:living_city/data/provider/trip_provider.dart';
import 'package:living_city/data/repositories/bluetooth_device_repository.dart';
import 'package:living_city/data/provider/bluetooth_device_provider.dart';
import 'package:living_city/data/repositories/location_repository.dart';
import 'package:living_city/data/repositories/points_of_interest_repository.dart';
import 'package:living_city/data/repositories/trip_repository.dart';
import 'package:living_city/data/database/trip_database.dart';

final sl = GetIt.instance;

void init() {
  // Services
  sl.registerLazySingleton(() => BluetoothDetectionService(sl(), sl()));

  // Repositories
  sl.registerLazySingleton(() => LocationRepository(sl(), sl()));
  sl.registerLazySingleton(() => TripRepository(sl()));
  sl.registerLazySingleton(() => BluetoothDevicesRepository(sl()));
  sl.registerLazySingleton(() => PointsOfInterestRepository(sl(), sl()));

  // Providers
  sl.registerLazySingleton(() => SearchHistoryProvider());
  sl.registerLazySingleton(() => LocationProvider());
  sl.registerLazySingleton(() => TripProvider(sl()));
  sl.registerLazySingleton(() => BluetoothDeviceProvider(sl()));
  sl.registerLazySingleton(() => PointsOfInterestRemoteProvider());
  sl.registerLazySingleton(() => PointsOfInterestLocalProvider(sl()));

  // Database
  sl.registerLazySingleton(() => TripDatabase());
  sl.registerLazySingleton(() => BLEDeviceDatabase());
  sl.registerLazySingleton(() => PointOfInterestDatabase());
}

// Bloc (special case for blocs that depend on others)
// sl.registerLazySingleton(() =>

// mixin AutoResetLazySingleton<E, S> on Bloc<E, S> {
//   @override
//   Future<void> close() {
//     if (sl.isRegistered<Bloc<E, S>>(instance: this)) {
//       sl.resetLazySingleton<Bloc<E, S>>(instance: this);
//     }
//     return super.close();
//   }
// }
