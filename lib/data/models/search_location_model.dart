import 'package:latlong/latlong.dart';

class SearchLocationModel {
  String title;
  LatLng coordinates;
  bool get hasCoordinates {
    return coordinates != null;
  }

  set setCoordinates(LatLng coords) {
    this.coordinates = coords;
  }

  set setTitle(String title) {
    this.title = title;
  }

  SearchLocationModel({this.title, this.coordinates});
}
