import 'package:flutter/material.dart';
import 'package:living_city/core/bluetooth_detection_service.dart';

class LifeCycleObserver extends WidgetsBindingObserver {
  final BluetoothDetectionService _bluetoothDetectionService;

  LifeCycleObserver(this._bluetoothDetectionService);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _bluetoothDetectionService.restart();
        break;
      default:
        break;
    }
  }
}
