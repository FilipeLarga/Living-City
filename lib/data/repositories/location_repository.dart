import 'package:latlong/latlong.dart';
import 'package:living_city/data/models/location_model.dart';
import 'package:living_city/data/provider/search_history_provider.dart';
import '../provider/geocoding_provider.dart';

class LocationRepository {
  final GeolocatorProvider _geolocatorProvider;
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
    await Future.delayed(Duration(seconds: 1));
  }

  Future<LocationModel> getLocationFromAddress(String address) async {
    await Future.delayed(Duration(seconds: 1));
    LocationModel location = LocationModel(address, LatLng(38.4, 39.2));
    _searchHistoryProvider.insertSearch(location);
    return location;
  }
  // Future<LocationModel> getCurrentLocation() async {
  //   Position position = await _provider.getCurrentPosition();
  //   LatLng coordinates = _positionToLatLng(position);
  //   List<Placemark> placemarks =
  //       await _provider.getPlacemarkFromCoordinates(coordinates);
  //   return LocationModel(
  //       coordinates: _positionToLatLng(position), address: placemarks[0].name);
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
