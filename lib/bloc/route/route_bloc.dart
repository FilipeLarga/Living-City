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
  RouteState get initialState => const RouteSearch();

  @override
  Stream<RouteState> mapEventToState(
    RouteEvent event,
  ) async* {
    if (event is ShowLocation) {
      yield* _mapShowLocationToState(event);
    } else if (event is CancelLocation) {
      yield const RouteSearch();
    } else if (event is AcceptLocation) {
      yield* _mapAcceptLocationToState(event);
    }
  }

  Stream<RouteState> _mapShowLocationToState(ShowLocation event) async* {
    yield const RouteLocation();
  }

  Stream<RouteState> _mapAcceptLocationToState(AcceptLocation event) async* {
    final LocationModel location = event.location;
    yield const RouteLocation();
  }
}
