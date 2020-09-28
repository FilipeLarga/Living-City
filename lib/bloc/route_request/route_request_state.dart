part of 'route_request_bloc.dart';

@immutable
abstract class RouteRequestState {}

class RouteRequestInitial extends RouteRequestState {}

class RouteRequestLoading extends RouteRequestState {}

class RouteRequestError extends RouteRequestState {}

class RouteRequestLoaded extends RouteRequestState {
  final TripModel tripModel;
  RouteRequestLoaded(this.tripModel);
}
