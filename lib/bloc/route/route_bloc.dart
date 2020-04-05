import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:living_city/data/models/location_model.dart';
import 'package:living_city/data/repositories/location_repository.dart';
import 'package:meta/meta.dart';

part 'route_event.dart';
part 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final LocationRepository _locationRepository;
  RouteBloc(this._locationRepository);

  @override
  RouteState get initialState => RouteSearch();

  @override
  Stream<RouteState> mapEventToState(
    RouteEvent event,
  ) async* {
    if (event is ShowLocation) {
      yield* _mapShowLocationToState(event);
    } else if (event is CancelLocation) {
      yield RouteSearch();
    } else if (event is AcceptLocation) {
      yield* _mapAcceptLocationToState(event);
    }
  }

  Stream<RouteState> _mapShowLocationToState(ShowLocation event) async* {
    yield RouteLocation();
  }

  Stream<RouteState> _mapAcceptLocationToState(AcceptLocation event) async* {
    final LocationModel location = event.location;
    bool valid = await _validateLocation(location);
    if (valid) {
      await _saveLocation(location);
      yield RouteLocation();
    }
  }

  Future<bool> _validateLocation(LocationModel location) async {
    return true;
  }

  Future<void> _saveLocation(LocationModel location) async {
    await _locationRepository.saveLocation(location);
  }
}
