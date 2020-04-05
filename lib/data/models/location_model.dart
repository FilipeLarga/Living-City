import 'package:latlong/latlong.dart';

class LocationModel {
  String address;
  LatLng coordinates;
  bool get hasCoordinates {
    return coordinates != null;
  }

  LocationModel(this.address, this.coordinates);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'address': address,
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
    };
    return map;
  }

  LocationModel.fromMap(Map<String, dynamic> map) {
    address = map['address'];
    final latitude = map['latitude'];
    final longitude = map['longitude'];
    coordinates = LatLng(latitude, longitude);
  }
}
