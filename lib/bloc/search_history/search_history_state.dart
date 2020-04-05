part of 'search_history_bloc.dart';

@immutable
abstract class SearchHistoryState {
  const SearchHistoryState();
}

class SearchHistoryLoading extends SearchHistoryState {
  const SearchHistoryLoading();
}

class SearchHistoryLoaded extends SearchHistoryState {
  final List<LocationModel> searchHistory;
  const SearchHistoryLoaded(this.searchHistory);
}

class SearchHistoryEmpty extends SearchHistoryState {
  const SearchHistoryEmpty();
}
