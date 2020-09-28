import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/trip_model.dart';
import '../../core/example_data.dart' as example;
import '../../data/models/trip_plan_model.dart';

part 'route_request_event.dart';
part 'route_request_state.dart';

class RouteRequestBloc extends Bloc<RouteRequestEvent, RouteRequestState> {
  RouteRequestBloc() : super(RouteRequestInitial());

  @override
  Stream<RouteRequestState> mapEventToState(
    RouteRequestEvent event,
  ) async* {
    if (event is SendRouteRequest) {
      yield* _handleSendRequest(event);
    }
  }

  Stream<RouteRequestState> _handleSendRequest(SendRouteRequest event) async* {
    yield RouteRequestLoading();
    await Future.delayed(const Duration(milliseconds: 500));
    yield RouteRequestLoaded(example.trip);
  }
}
