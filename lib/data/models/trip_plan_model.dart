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
}
