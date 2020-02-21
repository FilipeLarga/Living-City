import 'package:living_city/data/models/search_location_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RouteSelectionState {}

class UnitializedRouteState extends RouteSelectionState {}

class SelectingRouteState extends RouteSelectionState {
  final SearchLocationModel startLocation;
  final SearchLocationModel destinationLocation;
  final List<SearchLocationModel> searchHistory;

  SelectingRouteState({
    @required this.searchHistory,
    this.startLocation,
    this.destinationLocation,
  });
}

class SelectingOnMapRouteState extends RouteSelectionState {
  final SearchLocationModel selectedLocation;
  final SelectingRouteState selectingRouteState;
  final bool origin;

  SelectingOnMapRouteState({
    @required this.origin,
    @required this.selectingRouteState,
    this.selectedLocation,
  });
}

class RouteErrorState extends RouteSelectionState {
  final Exception exception;

  RouteErrorState({this.exception});
}
