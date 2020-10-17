import 'package:living_city/data/models/location_model.dart';
import 'package:living_city/data/models/point_of_interest_model.dart';

class TripPlanModel {
  LocationModel origin;
  LocationModel destination;
  int departureDate;
  int visitTime;
  int effort;
  int budget;
  List<int> categories;
  List<PointOfInterestModel> pois;

  clear() {
    this.origin = null;
    this.destination = null;
    this.departureDate = null;
    this.visitTime = null;
    this.effort = null;
    this.budget = null;
    this.categories = null;
    this.pois = null;
  }

  void clearRestrictions() {
    this.effort = null;
    this.budget = null;
    this.visitTime = null;
  }

  void clearInterests() {
    this.categories = null;
    this.pois = null;
  }

  Map<String, dynamic> toMap() {
    return {
      'origin': origin.toMapCoords(),
      'destination': destination.toMapCoords(),
      'departureDate': departureDate,
      'visitationTime': visitTime,
      'budget': budget,
      'effortLevel': effort,
      'selectedPoints': pois.map((e) => e.pointID).toList(growable: false),
      'selectedCategories': categories,
      'checkWeather': true,
    };
  }

  // Map<String, dynamic> _timeToMap() {
  //   return {'startTime': startTime, 'endTime': endTime};
  // }
}
