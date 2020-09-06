part of 'search_history_bloc.dart';

@immutable
abstract class SearchHistoryState {
  const SearchHistoryState();
}

class SearchHistoryInitial extends SearchHistoryState {
  const SearchHistoryInitial();
}

class SearchHistoryLoading extends SearchHistoryState {
  const SearchHistoryLoading();
}

class SearchHistoryLoaded extends SearchHistoryState {
  final List<LocationModel> searchHistory;
  final LocationModel currentLocation;
  const SearchHistoryLoaded(this.searchHistory, this.currentLocation);
}

class SearchHistoryEmpty extends SearchHistoryState {
  final LocationModel currentLocation;
  const SearchHistoryEmpty(this.currentLocation);
}
