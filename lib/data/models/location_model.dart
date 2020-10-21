import 'package:latlong/latlong.dart';

class LocationModel {
  String name;
  String locality;
  LatLng coordinates;
  bool get hasCoordinates {
    return coordinates != null;
  }

  LocationModel(this.coordinates, {this.name, this.locality});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'locality': locality,
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
    };
    return map;
  }

  Map<String, dynamic> toMapCoords() {
    var map = <String, dynamic>{
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
    };
    return map;
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      LatLng(map['latitude'], map['longitude']),
      name: map['name'],
      locality: map['locality'],
    );
  }
}
