import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:living_city/core/Exceptions.dart';
import '../models/location_model.dart';

class GeolocatorProvider {
  final Geolocator _geolocator = Geolocator();

  Future<double> getDistance(LatLng first, LatLng second) async {
    final double distance = await _geolocator.distanceBetween(
        first.latitude, first.longitude, second.latitude, second.longitude);
    return distance;
  }

  Future<LocationModel> getPlacemarkFromAdress(String address) async {
    try {
      List<Placemark> placemarks =
          await _geolocator.placemarkFromAddress(address);
      for (Placemark place in placemarks) {
        // print(
        //     'Place: (${place.subThoroughfare}, ${place.subLocality}, ${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.subAdministrativeArea}, ${place.thoroughfare}, ${place.position.latitude}, ${place.position.longitude} )');
      }
      return LocationModel(
        LatLng(
            placemarks[0].position.latitude, placemarks[0].position.longitude),
        name: placemarks[0].name,
        locality: placemarks[0].locality,
      );
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

  Future<LatLng> getCurrentPosition() async {
    Position p = await _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return LatLng(p.latitude, p.longitude);
  }
}
