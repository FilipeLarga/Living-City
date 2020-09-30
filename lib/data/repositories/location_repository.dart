import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:living_city/data/models/location_model.dart';
import 'package:living_city/data/provider/search_history_provider.dart';
import '../provider/location_provider.dart';

class LocationRepository {
  final LocationProvider _geolocatorProvider;
  final SearchHistoryProvider _searchHistoryProvider;

  const LocationRepository(
      this._geolocatorProvider, this._searchHistoryProvider);

  Future<List<LocationModel>> getSearchHistory() async {
    return await _searchHistoryProvider.getSearches();
  }

  Future<void> saveLocation(LocationModel location) async {
    return await _searchHistoryProvider.insertSearch(location);
  }

  Future<LocationModel> getLocationFromCoordinates(LatLng coordinates) async {
    //fake location for now
    return await _geolocatorProvider.getPlacemarkFromCoordinates(coordinates);
  }

  Future<LocationModel> getLocationFromAddress(String address) async {
    return await _geolocatorProvider.getPlacemarkFromAdress(address);
  }

  Future<LocationModel> getCurrentLocation() async {
    LatLng coordinates = await _geolocatorProvider.getCurrentPosition();
    LocationModel location =
        await _geolocatorProvider.getPlacemarkFromCoordinates(coordinates);
    return location;
  }

  Future<LocationStatus> getLocationStatus() async {
    return await _geolocatorProvider.getLocationStatus();
  }

  Stream<Position> getPositionStream() {
    return _geolocatorProvider.getPositionStream();
  }

  // Future<> requestLocationPermission() async {
  //   await _geolocatorProvider.requestLocationPermission();
  // }

  // Future<LatLng> getCoordinatesFromAdress(String name) async {
  //   try {
  //     final List<Placemark> places =
  //         await _provider.getPlacemarkFromAdress(name);
  //     for (Placemark place in places) {
  //       LatLng coordinates = _positionToLatLng(place.position);
  //       if (_isWithinBounds(coordinates)) {
  //         return coordinates;
  //       }
  //     }
  //     throw OutOfBoundsException();
  //   } on NoConnectionException catch (_) {
  //     throw NoConnectionException();
  //   }
  // }

  // Future<String> getAdressFromCoordinates(LatLng coordinates) async {
  //   try {
  //     final List<Placemark> places =
  //         await _provider.getPlacemarkFromCoordinates(coordinates);
  //     for (Placemark place in places) {
  //       LatLng coordinates = _positionToLatLng(place.position);
  //       if (_isWithinBounds(coordinates)) {
  //         if (!["", null, ''].contains(place.thoroughfare)) {
  //           //if it's not empty
  //           print('yes: ${place.thoroughfare}');
  //           return place.thoroughfare;
  //         } else {
  //           print('no thoroughfare');
  //           return place.postalCode;
  //         }
  //       }
  //     }
  //     throw OutOfBoundsException();
  //   } catch (_) {
  //     throw Exception();
  //   }
  // }

  // // Stream<Position> _getLocationStream() async* {
  // //   yield* _provider.getPosition();
  // // }

  // bool _isWithinBounds(LatLng coordinates) {
  //   bool latOk = coordinates.latitude >= swBound.latitude &&
  //       coordinates.latitude <= neBound.latitude;
  //   bool longOk = coordinates.longitude >= swBound.longitude &&
  //       coordinates.longitude <= neBound.longitude;
  //   return latOk && longOk;
  // }

  // LatLng _positionToLatLng(Position p) {
  //   return LatLng(p.latitude, p.longitude);
  // }
}

class LocationStatus {
  final bool enabled;
  final bool permission;

  LocationStatus(this.enabled, this.permission);
}
