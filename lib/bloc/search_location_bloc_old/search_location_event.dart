import 'package:living_city/data/models/search_location_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchLocationEvent {}

class LoadHistoryRequestEvent extends SearchLocationEvent {}

class CancelSearchRequestEvent extends SearchLocationEvent {}

class SearchRequestEvent extends SearchLocationEvent {
  final LocationModel searchLocation;
  SearchRequestEvent({@required this.searchLocation});
}

class SearchUserLocationRequestEvent extends SearchLocationEvent {}

class AcceptLocationEvent extends SearchLocationEvent {
  final bool origin;

  AcceptLocationEvent({@required this.origin});
}

class DismissedEvent extends SearchLocationEvent {}
// class ClearRequestSearchHistoryEvent extends SearchHistoryEvent {}
