import 'package:living_city/data/models/search_location_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RouteSelectionEvent {}

class InitializeRouteRequest extends RouteSelectionEvent {
  final LocationModel location;
  final bool origin;

  InitializeRouteRequest({@required this.location, @required this.origin});
}

class LoopRouteRequest extends RouteSelectionEvent {
  final bool origin;

  LoopRouteRequest({@required this.origin});
}

class SwapRouteRequest extends RouteSelectionEvent {}

class ClearRouteRequest extends RouteSelectionEvent {
  final bool origin;

  ClearRouteRequest({@required this.origin});
}

class NewStartLocation extends RouteSelectionEvent {
  final LocationModel startLocation;

  NewStartLocation({@required this.startLocation});
}

class NewEndLocation extends RouteSelectionEvent {
  final LocationModel endLocation;

  NewEndLocation({@required this.endLocation});
}

class SelectOnMapRequest extends RouteSelectionEvent {
  final bool origin;

  SelectOnMapRequest({@required this.origin});
}

class ConfirmSelectOnMapRequest extends RouteSelectionEvent {}

class SearchRequestEvent extends RouteSelectionEvent {
  final LocationModel searchLocation;
  SearchRequestEvent({@required this.searchLocation});
}

class CancelSelectOnMapRequest extends RouteSelectionEvent {
  CancelSelectOnMapRequest();
}