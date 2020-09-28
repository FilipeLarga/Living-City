import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:living_city/data/repositories/location_repository.dart';
import 'package:meta/meta.dart';
import 'package:latlong/latlong.dart';

part 'user_location_event.dart';
part 'user_location_state.dart';

class UserLocationBloc extends Bloc<UserLocationEvent, UserLocationState> {
  final LocationRepository _locationRepository;

  bool initial;

  UserLocationBloc(this._locationRepository) : super(UserLocationInitial()) {
    _getInitialLocation();
    _locationRepository.getPositionStream().listen(_handleNewPosition);
  }

  @override
  Stream<UserLocationState> mapEventToState(
    UserLocationEvent event,
  ) async* {
    if (event is NewLocation) yield UserLocationLoaded(event.location);
  }

  void _handleNewPosition(Position event) {
    add(NewLocation(LatLng(event.latitude, event.longitude)));
    initial = false;
  }

  void _getInitialLocation() {
    _locationRepository.getCurrentLocation().then((value) {
      if (initial) {
        initial = false;
        add(NewLocation(value.coordinates));
      }
    });
  }
}
