import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:living_city/bloc/search_location_bloc/search_location_bloc.dart';
import 'package:living_city/bloc/search_location_bloc/search_location_state.dart';
import 'package:living_city/data/models/search_location_model.dart';
import 'package:living_city/data/repositories/geolocator_repository.dart';
import './bloc.dart';
import '../../core/Exceptions.dart';
import 'package:latlong/latlong.dart';

class RouteSelectionBloc
    extends Bloc<RouteSelectionEvent, RouteSelectionState> {
  final SearchLocationBloc searchLocationBloc;
  StreamSubscription searchLocationSubscription;
  final GeolocatorRepository geolocatorRepository;

  RouteSelectionBloc(
      {@required this.searchLocationBloc,
      @required this.geolocatorRepository}) {
    searchLocationSubscription = searchLocationBloc.listen((state) {
      if (state is InactiveSearchState) {
        add(InitializeRouteRequest(location: state.selectedSearchLocation));
      }
    });
  }

  @override
  Future<void> close() {
    searchLocationSubscription.cancel();
    return super.close();
  }

  @override
  RouteSelectionState get initialState => UnitializedRouteState();

  @override
  Stream<RouteSelectionState> mapEventToState(
    RouteSelectionEvent event,
  ) async* {
    if (event is InitializeRouteRequest) {
      yield* _mapInitializeRequestToState(event.location);
    } else if (event is LoopRouteRequest) {
      yield* _mapLoopRequestToState(event.loop);
    } else if (event is SwapRouteRequest) {
      yield* _mapSwapRequestToState();
    } else if (event is NewStartLocation) {
      yield* _mapNewStartToState(event.startLocation);
    } else if (event is NewEndLocation) {
      yield* _mapNewEndToState(event.endLocation);
    }
  }

  Stream<RouteSelectionState> _mapInitializeRequestToState(
      SearchLocationModel startLocation) async* {
    yield SelectingRouteState(loop: false, startLocation: startLocation);
  }

  Stream<RouteSelectionState> _mapLoopRequestToState(bool loop) async* {
    final SearchLocationModel startLocation =
        (state as SelectingRouteState).startLocation;

    if (loop) {
      //if loop is true both start and end show the start location

      yield SelectingRouteState(
          loop: loop,
          startLocation: startLocation,
          destinationLocation: startLocation);
    } else {
      //if loop is false the start and end are different
      final SearchLocationModel destinationLocation =
          (state as SelectingRouteState).destinationLocation;
      yield SelectingRouteState(
          loop: loop,
          startLocation: startLocation,
          destinationLocation: destinationLocation);
    }
  }

  Stream<RouteSelectionState> _mapSwapRequestToState() async* {
    final SearchLocationModel destinationLocation =
        (state as SelectingRouteState).startLocation;
    final SearchLocationModel startLocation =
        (state as SelectingRouteState).destinationLocation;
    final bool loop = (state as SelectingRouteState).loop;
    yield SelectingRouteState(
        loop: loop,
        startLocation: startLocation,
        destinationLocation: destinationLocation);
  }

  Stream<RouteSelectionState> _mapNewStartToState(
      SearchLocationModel startLocation) async* {
    try {
      if (!startLocation.hasCoordinates) {
        //No coordinates means it comes from manual text
        final coordinates = await geolocatorRepository
            .getCoordinatesFromAdress(startLocation.title);
        startLocation.setCoordinates = coordinates;
      } else if (startLocation.title != null) {
        //No title means it comes from map tap
        final name = await geolocatorRepository
            .getAdressFromCoordinates(startLocation.coordinates);
        startLocation.setTitle = name;
      }

      final SearchLocationModel destinationLocation =
          (state as SelectingRouteState).destinationLocation;
      final bool loop = (state as SelectingRouteState).loop;
      yield SelectingRouteState(
          loop: loop,
          startLocation: startLocation,
          destinationLocation: destinationLocation);
    } on OutOfBoundsException catch (oob) {
      print('Bloc says: Out Of Bounds');
      yield RouteErrorState(
        exception: oob,
      );
    } on NoConnectionException catch (nce) {
      yield RouteErrorState(exception: nce);
    }
  }

  Stream<RouteSelectionState> _mapNewEndToState(
      SearchLocationModel destinationLocation) async* {
    try {
      if (!destinationLocation.hasCoordinates) {
        //No coordinates means it comes from manual text
        final coordinates = await geolocatorRepository
            .getCoordinatesFromAdress(destinationLocation.title);
        destinationLocation.setCoordinates = coordinates;
      } else if (destinationLocation.title != null) {
        //No title means it comes from map tap
        final name = await geolocatorRepository
            .getAdressFromCoordinates(destinationLocation.coordinates);
        destinationLocation.setTitle = name;
      }

      final SearchLocationModel startLocation =
          (state as SelectingRouteState).startLocation;
      final bool loop = (state as SelectingRouteState).loop;
      yield SelectingRouteState(
          loop: loop,
          startLocation: startLocation,
          destinationLocation: destinationLocation);
    } on OutOfBoundsException catch (oob) {
      print('Bloc says: Out Of Bounds');
      yield RouteErrorState(
        exception: oob,
      );
    } on NoConnectionException catch (nce) {
      yield RouteErrorState(exception: nce);
    }
  }
}
