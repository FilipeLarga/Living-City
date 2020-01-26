import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:living_city/core/Exceptions.dart';

class GeolocatorProvider {
  final Geolocator _geolocator = Geolocator();

  Future<double> getDistance(LatLng first, LatLng second) async {
    final double distance = await _geolocator.distanceBetween(
        first.latitude, first.longitude, second.latitude, second.longitude);
    return distance;
  }

  Future<List<Placemark>> getPlacemarkFromAdress(String address) async {
    try {
      List<Placemark> placemarks =
          await _geolocator.placemarkFromAddress(address);
      for (Placemark place in placemarks) {
        print(
            'Place: (${place.position.latitude}, ${place.position.longitude} )');
      }
      return placemarks;
    } catch (_) {
      throw NoConnectionException();
    }
  }

  Future<List<Placemark>> getPlacemarkFromCoordinates(LatLng coords) async {
    return await _geolocator.placemarkFromCoordinates(
        coords.latitude, coords.longitude);
  }

  Stream<Position> getPositionStream() async* {
    const LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 5);
    yield* Geolocator().getPositionStream(locationOptions);
  }

  Future<Position> getCurrentPosition() async {
    Position p = await _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return p;
  }
}
