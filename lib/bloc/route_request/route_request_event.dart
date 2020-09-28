part of 'route_request_bloc.dart';

@immutable
abstract class RouteRequestEvent {}

class SendRouteRequest extends RouteRequestEvent {
  final TripPlanModel tripPlanModel;
  SendRouteRequest(this.tripPlanModel);
}
