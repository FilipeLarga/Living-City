import '../../data/models/search_location_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchLocationState {}

class UnitializedSearchState extends SearchLocationState {}

class InitialSearchState extends SearchLocationState {
  final List<LocationModel> searchHistory;

  InitialSearchState({@required this.searchHistory});
}

class ShowingLocationSearchState extends SearchLocationState {
  final LocationModel searchLocation;

  ShowingLocationSearchState({@required this.searchLocation});
}

class FinishSearchState extends SearchLocationState {}

class InactiveSearchState extends SearchLocationState {
  final LocationModel selectedSearchLocation;
  final bool origin;

  InactiveSearchState(
      {@required this.selectedSearchLocation, @required this.origin});
}

class ErrorSearchState extends SearchLocationState {
  final Exception exception;

  ErrorSearchState({this.exception});
}
