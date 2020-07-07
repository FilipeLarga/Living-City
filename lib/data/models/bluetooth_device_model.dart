import 'package:latlong/latlong.dart';

class BluetoothDeviceModel {
  int id;

  final LatLng coordinates;
  final int timestamp;

  BluetoothDeviceModel(this.coordinates, this.timestamp);

  factory BluetoothDeviceModel.fromJson(Map<String, dynamic> json) {
    return BluetoothDeviceModel(
        LatLng(
            json['coordinates']['latitude'], json['coordinates']['longitude']),
        json['timestamp']);
  }

  Map<String, dynamic> toMap() {
    return {
      'coordinates': coordinates.toMap(),
      'timestamp': timestamp,
    };
  }
}
