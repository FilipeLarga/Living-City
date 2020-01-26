import 'package:living_city/data/models/search_location_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RouteSelectionState {}

class UnitializedRouteState extends RouteSelectionState {}

class SelectingRouteState extends RouteSelectionState {
  final SearchLocationModel startLocation;
  final SearchLocationModel destinationLocation;
  final bool loop;

  SelectingRouteState(
      {this.startLocation, this.destinationLocation, @required this.loop});
}

class RouteErrorState extends RouteSelectionState {
  final Exception exception;

  RouteErrorState({this.exception});
}
