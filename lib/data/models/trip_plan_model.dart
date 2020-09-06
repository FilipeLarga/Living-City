import 'package:living_city/data/models/location_model.dart';
import 'package:living_city/data/models/point_of_interest_model.dart';

class TripPlanModel {
  LocationModel origin;
  LocationModel destination;
  int date;
  int effort;
  int budget;
  List<int> categories;
  List<PointOfInterestModel> pois;

  clear() {
    this.origin = null;
    this.destination = null;
    this.date = null;
    this.effort = null;
    this.budget = null;
    this.categories = null;
    this.pois = null;
  }

  void clearRestrictions() {
    this.date = null;
    this.effort = null;
    this.budget = null;
  }

  void clearInterests() {
    this.categories = null;
    this.pois = null;
  }
}
