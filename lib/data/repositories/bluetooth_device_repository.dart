import 'package:living_city/data/models/bluetooth_device_model.dart';
import 'package:living_city/data/provider/bluetooth_device_provider.dart';

class BluetoothDevicesRepository {
  final BluetoothDeviceProvider _bleDeviceProvider;
  static const scanInterval = 5;

  BluetoothDevicesRepository(this._bleDeviceProvider);

  Future<Duration> getDurationSinceLastEntry() async {
    final device = await _bleDeviceProvider.getMostRecent();
    if (device == null) return null;
    print(DateTime.fromMillisecondsSinceEpoch(device.timestamp).toString());
    final duration = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(device.timestamp));
    return duration;
  }

  Future storeDevices(List<BluetoothDeviceModel> devices) async {
    _bleDeviceProvider.insertDevices(devices);
  }
}
