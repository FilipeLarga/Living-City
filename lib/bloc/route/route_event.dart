part of 'route_bloc.dart';

@immutable
abstract class RouteEvent {
  const RouteEvent();
}

class ShowLocation extends RouteEvent {
  const ShowLocation();
}

class CancelLocation extends RouteEvent {
  const CancelLocation();
}

class AcceptLocation extends RouteEvent {
  final LocationModel location;
  const AcceptLocation(this.location);
}
