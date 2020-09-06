part of 'search_history_bloc.dart';

@immutable
abstract class SearchHistoryEvent {
  const SearchHistoryEvent();
}

class FetchHistory extends SearchHistoryEvent {
  const FetchHistory();
}
