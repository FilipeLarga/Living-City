import 'package:latlong/latlong.dart';

class PointOfInterestModel {
  final int pointID;
  final int categoryID;
  final int price;
  final int sustainability;
  final LatLng coordinates;

  const PointOfInterestModel(this.pointID, this.categoryID, this.price,
      this.sustainability, this.coordinates);

  factory PointOfInterestModel.fromJson(Map<String, dynamic> json) {
    return PointOfInterestModel(
        json['pointID'],
        json['categoryID'],
        json['normalPrice'],
        json['sustainability'],
        LatLng(
            json['coordinates']['latitude'], json['coordinates']['longitude']));
  }

  Map<String, dynamic> toMap() {
    return {
      'pointID': pointID,
      'categoryID': categoryID,
      'normalPrice': price,
      'sustainability': sustainability,
      'coordinates': coordinates.toMap(),
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
