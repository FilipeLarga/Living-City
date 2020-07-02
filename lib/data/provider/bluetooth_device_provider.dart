import 'package:living_city/data/database/ble_devices_database.dart';
import 'package:living_city/data/models/bluetooth_device_model.dart';
import 'package:sembast/sembast.dart';

class BluetoothDeviceProvider {
  static const String BLUETOOTH_DEVICES_STORE_NAME = 'bluetooth_devices';

  final _devicesStore = intMapStoreFactory.store(BLUETOOTH_DEVICES_STORE_NAME);

  final BLEDeviceDatabase _deviceDatabase;

  Future<Database> get _db async => await _deviceDatabase.database;

  BluetoothDeviceProvider(this._deviceDatabase);

  Future insertDevice(BluetoothDeviceModel device) async {
    await _devicesStore.add(await _db, device.toMap());
  }

  Future insertDevices(List<BluetoothDeviceModel> devices) async {
    await _devicesStore.addAll(
        await _db, devices.map((device) => device.toMap()).toList());
  }

  Future deleteAllDevices() async {
    await _devicesStore.delete(await _db);
  }

  Future<List<BluetoothDeviceModel>> getAllDevices() async {
    final recordSnapshots = await _devicesStore.find(
      await _db,
    );
    return recordSnapshots.map((snapshot) {
      final device = BluetoothDeviceModel.fromJson(snapshot.value);
      device.id = snapshot.key;
      return device;
    }).toList();
  }

  Future<BluetoothDeviceModel> getMostRecent() async {
    int count = await _devicesStore.count(await _db);
    final record = await _devicesStore.record(count).getSnapshot(await _db);
    if (record != null) {
      final device = BluetoothDeviceModel.fromJson(record.value);
      device.id = record.key;
      return device;
    } else
      return null;
  }
}
