import '../../data/models/search_location_model.dart';

class SearchLocationProvider {
  Future<List<SearchLocationModel>> getSearchHistory() async {
    await Future.delayed(Duration(seconds: 0));
    return [
      SearchLocationModel(title: 'Avenida das Forças Armadas'),
      SearchLocationModel(title: 'Rua Alexandre Ferrreira'),
      SearchLocationModel(title: 'hi'),
      SearchLocationModel(title: 'hi'),
      SearchLocationModel(title: 'hi')
    ];
  }
}
