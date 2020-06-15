import 'package:latlong/latlong.dart';
import 'package:living_city/data/models/point_of_interest_model.dart';

class TripModel {
  int id; // For database purposes

  final List<TimedPointOfInterestModel> pois;
  final List<LatLng> line;
  final double startTime;
  final double endTime;
  final int sustainability;
  final int price;
  final int distance;
  final int calories;

  TripModel(this.pois, this.line, this.startTime, this.endTime,
      this.sustainability, this.price, this.distance, this.calories);

  factory TripModel.fromJson(Map<String, dynamic> json) {
    var poiList = json['pois'] as List;
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

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'sustainability': sustainability,
      'distance': distance,
      'calories': calories,
      'time': _timeToMap(),
      'line': line.map((coords) => coords.toMap()).toList(growable: false),
      'pois': pois.map((timedPOI) => timedPOI.toMap()).toList(growable: false),
    };
  }

  Map<String, dynamic> _timeToMap() {
    return {'startTime': startTime, 'endTime': endTime};
  }

  @override
  String toString() {
    return 'Calories: $calories; Distance: $distance; POIs: ${pois?.length}; Sustainabiliy: $sustainability';
  }
}
