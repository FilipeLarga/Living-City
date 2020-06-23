import 'package:get_it/get_it.dart';
import 'package:living_city/core/bluetooth_detection_service.dart';
import 'package:living_city/data/database/ble_devices_database.dart';
import 'package:living_city/data/provider/geocoding_provider.dart';
import 'package:living_city/data/provider/search_history_provider.dart';
import 'package:living_city/data/provider/trip_provider.dart';
import 'package:living_city/data/repositories/bluetooth_device_repository.dart';
import 'package:living_city/data/provider/bluetooth_device_provider.dart';
import 'package:living_city/data/repositories/location_repository.dart';
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

  // Providers
  sl.registerLazySingleton(() => SearchHistoryProvider());
  sl.registerLazySingleton(() => GeolocatorProvider());
  sl.registerLazySingleton(() => TripProvider(sl()));
  sl.registerLazySingleton(() => BluetoothDeviceProvider(sl()));

  // Database
  sl.registerLazySingleton(() => TripDatabase());
  sl.registerLazySingleton(() => BLEDeviceDatabase());
}
