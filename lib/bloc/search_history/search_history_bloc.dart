import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:living_city/data/models/location_model.dart';
import 'package:living_city/data/repositories/location_repository.dart';
import 'package:meta/meta.dart';

part 'search_history_event.dart';
part 'search_history_state.dart';

class SearchHistoryBloc extends Bloc<SearchHistoryEvent, SearchHistoryState> {
  final LocationRepository _locationRepository;

  SearchHistoryBloc(this._locationRepository);
  @override
  SearchHistoryState get initialState => SearchHistoryLoading();

  @override
  Stream<SearchHistoryState> mapEventToState(
    SearchHistoryEvent event,
  ) async* {
    yield* _getSearchHistory();
  }

  Stream<SearchHistoryState> _getSearchHistory() async* {
    final List<LocationModel> searchHistory =
        await _locationRepository.getSearchHistory();
    if (searchHistory == null || searchHistory.isEmpty) {
      yield SearchHistoryEmpty();
    } else {
      yield SearchHistoryLoaded(searchHistory);
    }
  }
}
