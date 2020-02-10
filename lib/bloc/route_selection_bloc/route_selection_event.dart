import 'package:living_city/data/models/search_location_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RouteSelectionEvent {}

class InitializeRouteRequest extends RouteSelectionEvent {
  final SearchLocationModel location;
  final bool origin;

  InitializeRouteRequest({@required this.location, @required this.origin});
}

class LoopRouteRequest extends RouteSelectionEvent {
  final bool loop;

  LoopRouteRequest({@required this.loop});
}

class SwapRouteRequest extends RouteSelectionEvent {}

class NewStartLocation extends RouteSelectionEvent {
  final SearchLocationModel startLocation;

  NewStartLocation({@required this.startLocation});
}

class NewEndLocation extends RouteSelectionEvent {
  final SearchLocationModel endLocation;

  NewEndLocation({@required this.endLocation});
}
