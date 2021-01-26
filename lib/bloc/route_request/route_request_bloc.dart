import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:living_city/data/models/location_model.dart';
import 'package:meta/meta.dart';

import '../../data/models/trip_model.dart';
import '../../core/example_data.dart' as example;
import '../../data/models/trip_plan_model.dart';
import 'package:http/http.dart' as http;

part 'route_request_event.dart';
part 'route_request_state.dart';

class RouteRequestBloc extends Bloc<RouteRequestEvent, RouteRequestState> {
  final http.Client client;
  RouteRequestBloc(this.client) : super(RouteRequestInitial());
  LocationModel origin;
  LocationModel destination;

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
    origin = event.tripPlanModel.origin;
    destination = event.tripPlanModel.destination;
    var json = jsonDecode(example.cenario2);
    json['origin']['name'] = origin.name;
    json['destination']['name'] = destination.name;
    final route = TripModel.fromJson(json);
    yield RouteRequestLoaded(route);
    /* try {
      final response = await client.get('placeholder');
      print('status code:' + response.statusCode.toString());
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        //json['origin']['name'] = origin.name;
        //json['destination']['name'] = destination.name;
        final route = TripModel.fromJson(json);
        yield RouteRequestLoaded(route);
      } else {
        yield RouteRequestTripError();
      }
    } on Exception catch (e) {
      print('exception: ' + e.toString());
      yield RouteRequestConnectionError();
    } */
    // yield RouteRequestTripError();
    // yield RouteRequestLoaded(route);
  }

  @override
  Future<void> close() {
    client.close();
    return super.close();
  }
}
