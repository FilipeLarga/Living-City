import 'package:living_city/data/models/trip_model.dart';

class TripProvider {
  Future<List<TripModel>> getTripHistory() async {
    return await Future.delayed(Duration(milliseconds: 3000), () {
      print('entrei aqui');
      return [
        TripModel(null, null, null, null, 75, 100, 500, 500),
        TripModel(null, null, null, null, 75, 100, 500, 500)
      ];
    });
  }
}
