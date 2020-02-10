import 'dart:async';
import 'package:latlong/latlong.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../core/Exceptions.dart';
import '../../data/models/search_location_model.dart';
import '../../data/repositories/geolocator_repository.dart';
import '../../data/repositories/search_location_repository.dart';
import './bloc.dart';

class SearchLocationBloc
    extends Bloc<SearchLocationEvent, SearchLocationState> {
  final SearchLocationRepository _searchHistoryRepository;
  final GeolocatorRepository _geolocatorRepository;

  SearchLocationModel selectedSearchLocation;
  bool origin;

  SearchLocationBloc(
      {@required SearchLocationRepository searchHistoryRepository,
      @required GeolocatorRepository geocodingRepository})
      : _searchHistoryRepository = searchHistoryRepository,
        _geolocatorRepository = geocodingRepository;

  @override
  SearchLocationState get initialState => UnitializedSearchState();

  @override
  Stream<SearchLocationState> mapEventToState(
    SearchLocationEvent event,
  ) async* {
    if (event is LoadHistoryRequestEvent) {
      yield* _mapLoadHistoryRequestToState();
    } else if (event is SearchRequestEvent) {
      yield* _mapSearchRequestToState(event.searchLocation);
    } else if (event is SearchUserLocationRequestEvent) {
      yield* _mapSearchUserLocationRequestEvent();
    } else if (event is CancelSearchRequestEvent) {
      yield* _mapCancelRequestToState();
    } else if (event is AcceptLocationEvent) {
      yield* _mapAcceptEventToState(event.origin);
    } else if (event is DismissedEvent) {
      yield* _mapDismissedToState();
    }
  }

  Stream<SearchLocationState> _mapLoadHistoryRequestToState() async* {
    try {
      final searchHistory = await _searchHistoryRepository.getSearchHistory();
      yield InitialSearchState(
        searchHistory: searchHistory,
      );
    } catch (_) {
      yield InitialSearchState(
        searchHistory: null,
      );
    }
  }

  Stream<SearchLocationState> _mapSearchRequestToState(
      SearchLocationModel searchLocation) async* {
    //ignore if inactive
    try {
      if (!(state is InactiveSearchState)) {
        if (searchLocation.hasCoordinates) {
          //either comes from map tap or search history
          if (searchLocation.title != null) {
            //comes from search history so it has both name and coordinates, don't need to update history
            yield ShowingLocationSearchState(searchLocation: searchLocation);
            selectedSearchLocation = searchLocation;
          } else {
            //comes from map tap so we need to get adress name and need to update history
            final String name = await _geolocatorRepository
                .getAdressFromCoordinates(searchLocation.coordinates);
            searchLocation.setTitle = name;
            yield ShowingLocationSearchState(searchLocation: searchLocation);
            _searchHistoryRepository.saveSearchHistory(searchLocation);
            selectedSearchLocation = searchLocation;
          }
        } else {
          //comes from manual search adress so we need to get coordinates and update history

          final LatLng coordinates = await _geolocatorRepository
              .getCoordinatesFromAdress(searchLocation.title);
          searchLocation.setCoordinates = coordinates;

          print('Name: ${searchLocation.title}');
          print('Coords: ${searchLocation.coordinates}');

          yield ShowingLocationSearchState(searchLocation: searchLocation);
          _searchHistoryRepository.saveSearchHistory(searchLocation);
          selectedSearchLocation = searchLocation;
        }
      }
    } on OutOfBoundsException catch (oob) {
      print('Bloc says: Out Of Bounds');
      yield ErrorSearchState(
        exception: oob,
      );
    } on NoConnectionException catch (nce) {
      yield ErrorSearchState(exception: nce);
    }
  }

  Stream<SearchLocationState> _mapSearchUserLocationRequestEvent() async* {
    SearchLocationModel searchLocation =
        await _geolocatorRepository.getCurrentLocation();
    yield ShowingLocationSearchState(searchLocation: searchLocation);
    selectedSearchLocation = searchLocation;
  }

  Stream<SearchLocationState> _mapCancelRequestToState() async* {
    yield InitialSearchState(searchHistory: null);
  }

  Stream<SearchLocationState> _mapAcceptEventToState(bool origin) async* {
    print('sure');
    print(origin);
    this.origin = origin;
    yield FinishSearchState();
  }

  Stream<SearchLocationState> _mapDismissedToState() async* {
    if (state is FinishSearchState)
      yield InactiveSearchState(
          selectedSearchLocation: selectedSearchLocation, origin: origin);
  }
}
