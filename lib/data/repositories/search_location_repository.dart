import '../../data/models/search_location_model.dart';
import '../../data/provider/search_location_provider.dart';

class SearchLocationRepository {
  final SearchLocationProvider _provider;

  SearchLocationRepository(this._provider);

  Future<List<SearchLocationModel>> getSearchHistory() async {
    final List<SearchLocationModel> searchHistory =
        await _provider.getSearchHistory();
    return searchHistory;
  }

  void saveSearchHistory(SearchLocationModel searchHistoryModel) {
    //TODO
  }
}
