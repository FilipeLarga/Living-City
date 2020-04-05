import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:living_city/bloc/search_location_bloc/search_location_bloc.dart';
import 'package:living_city/bloc/search_location_bloc/search_location_state.dart';
import 'package:living_city/data/models/search_location_model.dart';
import 'package:living_city/data/repositories/geolocator_repository.dart';
import 'package:living_city/data/repositories/search_location_repository.dart';
import './bloc.dart';
import '../../core/Exceptions.dart';

class RouteSelectionBloc
    extends Bloc<RouteSelectionEvent, RouteSelectionState> {
  final SearchLocationBloc searchLocationBloc;
  final SearchHistoryRepository searchHistoryRepository;
  StreamSubscription searchLocationSubscription;
  final LocationRepository geolocatorRepository;
  List<LocationModel> searchHistory;

  RouteSelectionBloc(
      {@required this.searchHistoryRepository,
      @required this.searchLocationBloc,
      @required this.geolocatorRepository}) {
    searchLocationSubscription = searchLocationBloc.listen((state) {
      if (state is InactiveSearchState) {
        add(InitializeRouteRequest(
            location: state.selectedSearchLocation, origin: state.origin));
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
      yield* _mapInitializeRequestToState(event.location, event.origin);
    } else if (event is LoopRouteRequest) {
      yield* _mapLoopRequestToState(event.origin);
    } else if (event is SwapRouteRequest) {
      yield* _mapSwapRequestToState();
    } else if (event is NewStartLocation) {
      yield* _mapNewStartToState(event.startLocation);
    } else if (event is NewEndLocation) {
      yield* _mapNewEndToState(event.endLocation);
    } else if (event is ClearRouteRequest) {
      yield* _mapClearToState(event.origin);
    } else if (event is SelectOnMapRequest) {
      yield* _mapSelectOnMapToState(event.origin);
    } else if (event is CancelSelectOnMapRequest) {
      yield* _mapCancelSelectOnMapToState();
    } else if (event is SearchRequestEvent) {
      yield* _mapSearchRequestToState(event.searchLocation);
    } else if (event is ConfirmSelectOnMapRequest) {
      yield* _mapConfirmSelectOnMapToState();
    }
  }

  Stream<RouteSelectionState> _mapInitializeRequestToState(
      LocationModel location, bool origin) async* {
    searchHistory = await searchHistoryRepository.getSearchHistory();
    if (origin) {
      yield SelectingRouteState(
          startLocation: location, searchHistory: searchHistory);
    } else {
      yield SelectingRouteState(
          destinationLocation: location, searchHistory: searchHistory);
    }
  }

  Stream<RouteSelectionState> _mapLoopRequestToState(bool origin) async* {
    if (origin) {
      final LocationModel destinationLocation =
          (state as SelectingRouteState).destinationLocation;
      if (destinationLocation != null || destinationLocation.address != '') {
        yield SelectingRouteState(
            startLocation: destinationLocation,
            destinationLocation: destinationLocation,
            searchHistory: searchHistory);
      } else {
        //Just in case the user meant to loop the destination
        final LocationModel startLocation =
            (state as SelectingRouteState).startLocation;
        if (startLocation != null || startLocation.address != '') {
          yield SelectingRouteState(
              startLocation: startLocation,
              destinationLocation: startLocation,
              searchHistory: searchHistory);
        }
      }
    } else {
      final LocationModel startLocation =
          (state as SelectingRouteState).startLocation;
      if (startLocation != null || startLocation.address != '') {
        yield SelectingRouteState(
            startLocation: startLocation,
            destinationLocation: startLocation,
            searchHistory: searchHistory);
      } else {
        //Just in case the user meant to loop the origin
        final LocationModel destinationLocation =
            (state as SelectingRouteState).destinationLocation;
        if (destinationLocation != null || destinationLocation.address != '') {
          yield SelectingRouteState(
              startLocation: destinationLocation,
              destinationLocation: destinationLocation,
              searchHistory: searchHistory);
        }
      }
    }
    // if (loop) {
    //   if (originIsDominant) {
    //     final SearchLocationModel startLocation =
    //         (state as SelectingRouteState).startLocation;

    //     yield SelectingRouteState(
    //         startLocation: startLocation,
    //         destinationLocation: startLocation,
    //         searchHistory: searchHistory);
    //   } else {
    //     final SearchLocationModel destinationLocation =
    //         (state as SelectingRouteState).destinationLocation;

    //     yield SelectingRouteState(
    //         startLocation: destinationLocation,
    //         destinationLocation: destinationLocation,
    //         searchHistory: searchHistory);
    //   }
    // } else {
    //   if (originIsDominant) {
    //     final SearchLocationModel startLocation =
    //         (state as SelectingRouteState).startLocation;

    //     yield SelectingRouteState(
    //         startLocation: startLocation,
    //         searchHistory: searchHistory);
    //   } else {
    //     final SearchLocationModel destinationLocation =
    //         (state as SelectingRouteState).destinationLocation;

    //     yield SelectingRouteState(
    //         destinationLocation: destinationLocation,
    //         searchHistory: searchHistory);
    //   }
    // }
  }

  Stream<RouteSelectionState> _mapClearToState(bool origin) async* {
    if (origin) {
      yield SelectingRouteState(
          startLocation: null,
          destinationLocation:
              (state as SelectingRouteState).destinationLocation,
          searchHistory: searchHistory);
    } else {
      yield SelectingRouteState(
          startLocation: (state as SelectingRouteState).startLocation,
          destinationLocation: null,
          searchHistory: searchHistory);
    }
  }

  Stream<RouteSelectionState> _mapSelectOnMapToState(bool origin) async* {
    yield SelectingOnMapRouteState(origin: origin, selectingRouteState: state);
  }

  Stream<RouteSelectionState> _mapCancelSelectOnMapToState() async* {
    yield (state as SelectingOnMapRouteState).selectingRouteState;
  }

  Stream<RouteSelectionState> _mapConfirmSelectOnMapToState() async* {
    final SelectingOnMapRouteState currState = state;
    final SelectingRouteState prevState = currState.selectingRouteState;
    if (currState.origin) {
      //Origin is the one that needs to change
      yield SelectingRouteState(
          searchHistory: prevState.searchHistory,
          startLocation: currState.selectedLocation, //this changes
          destinationLocation: prevState.destinationLocation);
    } else {
      yield SelectingRouteState(
          searchHistory: prevState.searchHistory,
          startLocation: prevState.startLocation,
          destinationLocation: currState.selectedLocation); //this changes
    }
  }

  Stream<RouteSelectionState> _mapSwapRequestToState() async* {
    final LocationModel destinationLocation =
        (state as SelectingRouteState).startLocation;
    final LocationModel startLocation =
        (state as SelectingRouteState).destinationLocation;
    yield SelectingRouteState(
        startLocation: startLocation,
        destinationLocation: destinationLocation,
        searchHistory: searchHistory);
  }

  Stream<RouteSelectionState> _mapNewStartToState(
      LocationModel startLocation) async* {
    try {
      if (!startLocation.hasCoordinates) {
        //No coordinates means it comes from manual text
        final coordinates = await geolocatorRepository
            .getCoordinatesFromAdress(startLocation.address);
        startLocation.setCoordinates = coordinates;
      } else if (startLocation.address != null) {
        //No title means it comes from map tap
        final name = await geolocatorRepository
            .getAdressFromCoordinates(startLocation.coordinates);
        startLocation.setTitle = name;
      }

      final LocationModel destinationLocation =
          (state as SelectingRouteState).destinationLocation;
      yield SelectingRouteState(
          startLocation: startLocation,
          destinationLocation: destinationLocation,
          searchHistory: searchHistory);
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
      LocationModel destinationLocation) async* {
    try {
      if (!destinationLocation.hasCoordinates) {
        //No coordinates means it comes from manual text
        final coordinates = await geolocatorRepository
            .getCoordinatesFromAdress(destinationLocation.address);
        destinationLocation.setCoordinates = coordinates;
      } else if (destinationLocation.address != null) {
        //No title means it comes from map tap
        final name = await geolocatorRepository
            .getAdressFromCoordinates(destinationLocation.coordinates);
        destinationLocation.setTitle = name;
      }

      final LocationModel startLocation =
          (state as SelectingRouteState).startLocation;
      yield SelectingRouteState(
          startLocation: startLocation,
          destinationLocation: destinationLocation,
          searchHistory: searchHistory);
    } on OutOfBoundsException catch (oob) {
      print('Bloc says: Out Of Bounds');
      yield RouteErrorState(
        exception: oob,
      );
    } on NoConnectionException catch (nce) {
      yield RouteErrorState(exception: nce);
    }
  }

  Stream<RouteSelectionState> _mapSearchRequestToState(
      LocationModel searchLocation) async* {
    //ignore if inactive
    try {
      if (state is SelectingOnMapRouteState) {
        //comes from map tap so we need to get adress name and need to update history
        final String name = await geolocatorRepository
            .getAdressFromCoordinates(searchLocation.coordinates);
        searchLocation.setTitle = name;
        final SelectingOnMapRouteState previousState = state;
        yield SelectingOnMapRouteState(
            origin: previousState.origin,
            selectedLocation: searchLocation,
            selectingRouteState: previousState.selectingRouteState);
        searchHistoryRepository.saveSearchHistory(searchLocation);
      }
    } on OutOfBoundsException catch (oob) {
      print('Bloc says: Out Of Bounds');
      yield RouteErrorState(
        exception: oob,
      );
    } on NoConnectionException catch (nce) {
      print('Bloc says: No Connection');

      yield RouteErrorState(exception: nce);
    }
  }
}
