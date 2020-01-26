import 'package:living_city/data/models/search_location_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RouteSelectionEvent {}

class InitializeRouteRequest extends RouteSelectionEvent {
  final SearchLocationModel location;

  InitializeRouteRequest({@required this.location});
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
