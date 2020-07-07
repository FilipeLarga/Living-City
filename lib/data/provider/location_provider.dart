import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:living_city/core/Exceptions.dart';
import 'package:living_city/data/repositories/location_repository.dart';
import '../models/location_model.dart';

class LocationProvider {
  final Geolocator _geolocator = Geolocator();

  Future<double> getDistance(LatLng first, LatLng second) async {
    final double distance = await _geolocator.distanceBetween(
        first.latitude, first.longitude, second.latitude, second.longitude);
    return distance;
  }

  Future<LocationModel> getPlacemarkFromAdress(String address) async {
    try {
      List<Placemark> placemarks = await _geolocator.placemarkFromAddress(address);
      // for (Placemark place in placemarks) {
      //   print(
      //       'Place: (${place.subThoroughfare}, ${place.subLocality}, ${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.subAdministrativeArea}, ${place.thoroughfare}, ${place.position.latitude}, ${place.position.longitude} )');
      // }
      final String name = placemarks[0].thoroughfare.isNotEmpty
          ? placemarks[0].thoroughfare
          : placemarks[0].name.isNotEmpty ? placemarks[0].name : placemarks[0].postalCode;

      return LocationModel(
        LatLng(placemarks[0].position.latitude, placemarks[0].position.longitude),
        name: name,
        locality: placemarks[0].locality,
      );
    } catch (_) {
      throw NoConnectionException();
    }
  }

  Future<LocationModel> getPlacemarkFromCoordinates(LatLng coords) async {
    final placemarks =
        await _geolocator.placemarkFromCoordinates(coords.latitude, coords.longitude);
    // for (Placemark place in placemarks) {
    //   print(
    //       'Place: (${place.subThoroughfare}, ${place.subLocality}, ${place.postalCode},${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.subAdministrativeArea}, ${place.thoroughfare}, ${place.position.latitude}, ${place.position.longitude} )');
    // }
    final String name = placemarks[0].thoroughfare.isNotEmpty
        ? placemarks[0].thoroughfare
        : placemarks[0].name.isNotEmpty ? placemarks[0].name : placemarks[0].postalCode;
    return LocationModel(coords, name: name, locality: placemarks[0].locality);
  }

  Stream<Position> getPositionStream() async* {
    const LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 5);
    yield* Geolocator().getPositionStream(locationOptions);
  }

  Future<LatLng> getCurrentPosition() async {
    Position p = await _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    return LatLng(p.latitude, p.longitude);
  }

  Future<LocationStatus> getLocationStatus() async {
    final status = await _geolocator.checkGeolocationPermissionStatus();
    final permission =
        status == GeolocationStatus.granted || status == GeolocationStatus.restricted;
    final enabled = await _geolocator.isLocationServiceEnabled();
    return LocationStatus(enabled, permission);
  }

  // Future<> requestLocationPermission() async {
  //   await _geolocator.permis
  // }

}
