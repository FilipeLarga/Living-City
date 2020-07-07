import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:living_city/data/models/location_model.dart';
import 'package:living_city/data/models/point_of_interest_model.dart';
import 'package:living_city/data/repositories/location_repository.dart';
import 'package:living_city/data/repositories/points_of_interest_repository.dart';
import 'package:living_city/data/repositories/trip_repository.dart';
import 'package:meta/meta.dart';
import 'package:latlong/latlong.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository _locationRepository;
  final PointsOfInterestRepository _poiRepository;
  LocationBloc(this._locationRepository, this._poiRepository);

  @override
  LocationState get initialState => const LocationInactive();

  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* {
    if (event is ClearLocation) {
      yield const LocationInactive();
    } else if (event is LoadLocation) {
      yield* _mapLoadLocationToState(event);
    } else if (event is ShowPreLoadedLocation) {
      yield LocationLoaded(event.location);
    }
  }

  Stream<LocationState> _mapLoadLocationToState(LoadLocation event) async* {
    yield const LocationLoading();

    try {
      LocationModel locationResult;
      if (event.address != null && event.address.isNotEmpty) {
        final pois = await _poiRepository.getPointsOfInterest();
        for (PointOfInterestModel poi in pois) {
          if (event.address == poi.name) {
            locationResult = LocationModel(poi.coordinates, name: poi.name, locality: 'Lisbon');
            break;
          }
        }
        if (locationResult == null)
          locationResult = await _locationRepository.getLocationFromAddress(event.address);
      } else {
        locationResult = await _locationRepository.getLocationFromCoordinates(event.coordinates);
      }
      await _locationRepository.saveLocation(locationResult);
      yield LocationLoaded(locationResult);
    } catch (e) {
      print(e);
      yield LocationError(e);
    }
  }
}
