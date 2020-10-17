part of 'route_request_bloc.dart';

@immutable
abstract class RouteRequestState {}

class RouteRequestInitial extends RouteRequestState {}

class RouteRequestLoading extends RouteRequestState {}

abstract class RouteRequestError extends RouteRequestState {}

class RouteRequestConnectionError extends RouteRequestState {}

class RouteRequestTripError extends RouteRequestState {}

class RouteRequestLoaded extends RouteRequestState {
  final TripModel tripModel;
  RouteRequestLoaded(this.tripModel);
}
