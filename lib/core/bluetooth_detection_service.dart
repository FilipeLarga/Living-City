import 'package:flutter/services.dart';
import 'package:living_city/core/exceptions.dart';
import 'package:living_city/data/models/bluetooth_device_model.dart';
import 'package:living_city/data/repositories/bluetooth_device_repository.dart';
import 'package:living_city/data/repositories/location_repository.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:latlong/latlong.dart';

class BluetoothDetectionService {
  final BluetoothDevicesRepository _bluetoothDevicesRepository;
  final LocationRepository _locationRepository;

  static const scanInterval = Duration(seconds: 40);
  static const scanTimeout = Duration(seconds: 10);

  Timer _timer;

  get _bluetooth => Platform.isAndroid
      ? FlutterBluetoothSerial.instance
      : FlutterBlue.instance;

  BluetoothDetectionService(
      this._bluetoothDevicesRepository, this._locationRepository);

  start() async {
    final duration =
        await _bluetoothDevicesRepository.getDurationSinceLastEntry();
    if (duration == null)
      _workAndSetupTimer();
    else {
      final delay = duration.inSeconds >= scanInterval.inSeconds
          ? const Duration(minutes: 0)
          : Duration(seconds: scanInterval.inSeconds - duration.inSeconds);
      Timer(delay, () {
        _workAndSetupTimer();
      });
    }
  }

  _workAndSetupTimer() async {
    try {
      int count;
      if (Platform.isAndroid)
        count = await _scanDevicesAndroid();
      else
        count = await _scanDevicesIOS();
      if (count > 0) _storeResults(count);
    } on BluetoothOffException {
      print('Exception: Bluetooth is off');
    } on LocationException catch (e) {
      print('Location Exception: $e');
    } on PlatformException catch (e) {
      print('Platform Exception: $e');
    } catch (e) {
      print('Erro: $e');
    } finally {
      print('Agendar outro');
      _timer = Timer(scanInterval, () => _workAndSetupTimer());
    }
  }

  Future<int> _scanDevicesAndroid() async {
    if (!await _bluetooth.isEnabled) throw BluetoothOffException();

    final locationStatus = await _locationRepository.getLocationStatus();
    if (!locationStatus.enabled) throw LocationEnabledException();
    if (!locationStatus.permission) throw LocationPermissionException();
    try {
      int count = 0;
      try {
        await for (BluetoothDiscoveryResult _ in _bluetooth.startDiscovery()) {
          count++;
        }
      } catch (e) {
        print('Erro na stream: ' + e);
      }
      return count;
    } catch (e) {
      if (e.code == 'no_permissions') throw LocationPermissionException();
      throw e;
    }
  }

  Future<int> _scanDevicesIOS() async {
    if (!await _bluetooth.isOn) throw BluetoothOffException();
    final locationStatus = await _locationRepository.getLocationStatus();
    if (!locationStatus.enabled) throw LocationEnabledException();
    if (!locationStatus.permission) throw LocationPermissionException();

    try {
      try {
        List<ScanResult> results =
            await _bluetooth.startScan(timeout: scanTimeout);
        return results.length;
      } catch (e) {
        print('Erro na stream: ' + e);
      }
      return 0;
    } catch (e) {
      if (e.code == 'no_permissions') throw LocationPermissionException();
      throw e;
    }
  }

  _storeResults(int count) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    LatLng coordinates =
        (await _locationRepository.getCurrentLocation()).coordinates;
    List<BluetoothDeviceModel> devices = List.generate(
        count, (_) => BluetoothDeviceModel(coordinates, timestamp),
        growable: false);
    _bluetoothDevicesRepository.storeDevices(devices);
  }

  restart() {
    _timer?.cancel();
    if (_bluetooth is FlutterBlue) {
      _bluetooth.stopScan();
    } else
      _bluetooth.cancelDiscovery();
    start();
  }
}
