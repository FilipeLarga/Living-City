import 'package:latlong/latlong.dart';

import '../../core/latlng_json_helper.dart';

class PointOfInterestModel {
  int id; //database

  final int pointID;
  final int categoryID;
  final String name;
  final int visitTime;
  final int openingHour;
  final int closureHour;
  final double price;
  final int sustainability;
  final LatLng coordinates;

  PointOfInterestModel(
      this.pointID,
      this.categoryID,
      this.name,
      this.visitTime,
      this.price,
      this.sustainability,
      this.openingHour,
      this.closureHour,
      this.coordinates);

  factory PointOfInterestModel.fromJson(Map<String, dynamic> json) {
    return PointOfInterestModel(
        json['pointID'],
        json['categoryID'],
        json['name'],
        json['visitTime'],
        json['normalPrice'],
        json['sustainability'],
        json['openingHour'],
        json['closureHour'],
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
      'openingHour': openingHour,
      'closureHour': closureHour,
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
