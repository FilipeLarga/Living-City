import 'package:living_city/data/models/trip_model.dart';
import 'package:living_city/data/provider/trip_provider.dart';

class TripRepository {
  final TripProvider _tripProvider;

  const TripRepository(this._tripProvider);

  Future<List<TripModel>> getTripHistory() async {
    print('repository começar');
    var list = await _tripProvider.getTripHistory();
    print('repository finished: $list');
    return List<TripModel>.from(list);
  }
}
