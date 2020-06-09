import 'package:latlong/latlong.dart';
import 'package:living_city/data/models/point_of_interest_model.dart';

class TripModel {
  final List<TimedPointOfInterestModel> pointsOfInterest;
  final List<LatLng> line;
  final double startTime;
  final double endTime;
  final int sustainability;
  final int price;
  final int distance;
  final int calories;

  TripModel(this.pointsOfInterest, this.line, this.startTime, this.endTime,
      this.sustainability, this.price, this.distance, this.calories);

  factory TripModel.fromJson(Map<String, dynamic> json) {
    var poiList = json['POIs'] as List;
    var line = json['line'] as List;
    return TripModel(
        poiList.map((e) => TimedPointOfInterestModel.fromJson(e)).toList(),
        line.map((e) => LatLng(e['latitude'], e['longitude'])).toList(),
        json['time']['startTime'],
        json['time']['endTime'],
        json['sustainability'],
        json['price'],
        json['distance'],
        json['calories']);
  }

  @override
  String toString() {
    return 'Calories: $calories; Distance: $distance; POIs: ${pointsOfInterest?.length}';
  }
}
