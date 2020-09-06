import 'package:latlong/latlong.dart';
import 'package:living_city/core/latlng_json_helper.dart';

class PointOfInterestModel {
  int id; //database

  final int pointID;
  final int categoryID;
  final String name;
  final int visitTime;
  final double price;
  final int sustainability;
  final LatLng coordinates;

  PointOfInterestModel(this.pointID, this.categoryID, this.name, this.visitTime,
      this.price, this.sustainability, this.coordinates);

  factory PointOfInterestModel.fromJson(Map<String, dynamic> json) {
    return PointOfInterestModel(
        json['pointID'],
        json['categoryID'],
        json['name'],
        json['visitTime'],
        json['normalPrice'],
        json['sustainability'],
        LatLng(
            json['coordinates']['latitude'], json['coordinates']['longitude']));
  }

  Map<String, dynamic> toMap() {
    return {
      'pointID': pointID,
      'categoryID': categoryID,
      'name': name,
      'visitTime': visitTime,
      'normalPrice': price,
      'sustainability': sustainability,
      'coordinates': latLngToMap(coordinates),
    };
  }
}

class TimedPointOfInterestModel {
  final PointOfInterestModel poi;
  final int timestamp;

  const TimedPointOfInterestModel(this.poi, this.timestamp);

  factory TimedPointOfInterestModel.fromJson(Map<String, dynamic> json) {
    return TimedPointOfInterestModel(
        PointOfInterestModel.fromJson(json['poi']), json['timestamp']);
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'poi': poi.toMap(),
    };
  }
}
