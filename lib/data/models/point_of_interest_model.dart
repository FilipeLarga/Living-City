import 'package:latlong/latlong.dart';

class PointOfInterestModel {
  final int pointID;
  final int categoryID;
  final int price;
  final int sustainability;
  final LatLng coordinates;

  PointOfInterestModel(this.pointID, this.categoryID, this.price,
      this.sustainability, this.coordinates);

  factory PointOfInterestModel.fromJson(Map<String, dynamic> json) {
    return PointOfInterestModel(
        json['pointID'],
        json['categoryID'],
        json['normalPrice'],
        json['sustainability'],
        LatLng(
            json['coordinate']['latitude'], json['coordinate']['longitude']));
  }
}

class TimedPointOfInterestModel {
  final PointOfInterestModel poi;
  final int timestamp;

  TimedPointOfInterestModel(this.poi, this.timestamp);

  factory TimedPointOfInterestModel.fromJson(Map<String, dynamic> json) {
    return TimedPointOfInterestModel(
        PointOfInterestModel.fromJson(json['POI']), json['timestamp']);
  }
}
