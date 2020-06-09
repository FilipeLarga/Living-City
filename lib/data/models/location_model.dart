import 'package:latlong/latlong.dart';

class LocationModel {
  String name;
  String locality;
  LatLng coordinates;
  bool get hasCoordinates {
    return coordinates != null;
  }

  LocationModel(this.name, this.locality, this.coordinates);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'locality': locality,
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
    };
    return map;
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(map['name'], map['locality'],
        LatLng(map['latitude'], map['longitude']));
  }
}
