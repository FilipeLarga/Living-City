import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:living_city/data/models/location_model.dart';
import 'package:living_city/data/repositories/location_repository.dart';
import 'package:meta/meta.dart';
import 'package:latlong/latlong.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository _locationRepository;
  LocationBloc(this._locationRepository);

  @override
  LocationState get initialState => const LocationInactive();

  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* {
    if (event is ResetLocation) {
      yield const LocationInactive();
    } else if (event is LoadLocation) {
      yield* _mapLoadLocationToState(event);
    }
  }

  Stream<LocationState> _mapLoadLocationToState(LoadLocation event) async* {
    yield const LocationLoading();
    try {
      LocationModel locationResult;
      if (event.address != null && event.address.isNotEmpty) {
        locationResult =
            await _locationRepository.getLocationFromAddress(event.address);
      } else {
        locationResult = await _locationRepository
            .getLocationFromCoordinates(event.coordinates);
      }
      await _locationRepository.saveLocation(locationResult);
      yield LocationLoaded(locationResult);
    } catch (e) {
      yield LocationError(e);
    }
  }
}
