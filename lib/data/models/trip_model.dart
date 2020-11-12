import 'package:latlong/latlong.dart';
import 'package:living_city/core/latlng_json_helper.dart';
import '../models/location_model.dart';
import 'package:living_city/data/models/point_of_interest_model.dart';

class TripModel {
  int id; // For database purposes

  final List<TimedPointOfInterestModel> pois;
  final List<LatLng> line;
  final int startTime;
  final int endTime;
  final LocationModel origin;
  final LocationModel destination;
  final int sustainability;
  final int price;
  final double distance;
  final int calories;
  final int durationTime;

  TripModel(
      this.pois,
      this.line,
      this.startTime,
      this.endTime,
      this.sustainability,
      this.price,
      this.distance,
      this.calories,
      this.origin,
      this.destination,
      this.durationTime);

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
      json['calories'],
      LocationModel(
        LatLng(json['origin']['latitude'], json['origin']['longitude']),
        name: json['origin']['name'],
        locality: json['origin']['locality'],
      ),
      LocationModel(
        LatLng(
            json['destination']['latitude'], json['destination']['longitude']),
        name: json['destination']['name'],
        locality: json['destination']['locality'],
      ),
      json['durationTime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'sustainability': sustainability,
      'distance': distance,
      'calories': calories,
      'time': _timeToMap(),
      'origin': origin.toMap(),
      'destination': destination.toMap(),
      'line': line.map((coords) => latLngToMap(coords)).toList(growable: false),
      'pois': pois.map((timedPOI) => timedPOI.toMap()).toList(growable: false),
      'durationTime': durationTime,
    };
  }

  Map<String, dynamic> _timeToMap() {
    return {'startTime': startTime, 'endTime': endTime};
  }

  // @override
  // String toString() {
  //   return 'Calories: $calories; Distance: $distance; POIs: ${pois?.length}; Sustainabiliy: $sustainability';
  // }
}

class ProgressionTripModel {
  int id; // For database purposes

  final TripModel originalTrip;
  final List<LatLng> progressLine;
  final List<TimedPointOfInterestModel> progressPOIs;

  ProgressionTripModel(this.originalTrip, this.progressLine, this.progressPOIs);
  ProgressionTripModel.initial(this.originalTrip)
      : this.progressLine = [],
        this.progressPOIs = [];

  factory ProgressionTripModel.fromJson(Map<String, dynamic> json) {
    var progressPoisList = json['progressPOIs'] as List;
    var line = json['progressLine'] as List;
    return ProgressionTripModel(
      TripModel.fromJson(json['originalTrip']),
      line.map((e) => LatLng(e['latitude'], e['longitude'])).toList(),
      progressPoisList
          .map((e) => TimedPointOfInterestModel.fromJson(e))
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'originalTrip': originalTrip.toMap(),
      'progressLine':
          progressLine.map((e) => latLngToMap(e)).toList(growable: false),
      'progressPOIs':
          progressPOIs.map((e) => e.toMap()).toList(growable: false),
    };
  }
}
