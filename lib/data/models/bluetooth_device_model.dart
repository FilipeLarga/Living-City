import 'package:latlong/latlong.dart';
import 'package:living_city/core/latlng_json_helper.dart';

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
      'coordinates': latLngToMap(coordinates),
      'timestamp': timestamp,
    };
  }
}
