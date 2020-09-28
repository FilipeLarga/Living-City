import 'package:living_city/data/models/point_of_interest_model.dart';

import '../provider/points_of_interest_providers.dart/points_of_interest_remote_provider.dart';
import '../provider/points_of_interest_providers.dart/points_of_interest_local_provider.dart';

class PointsOfInterestRepository {
  final PointsOfInterestRemoteProvider _pointsOfInterestRemoteProvider;
  final PointsOfInterestLocalProvider _pointsOfInterestLocalProvider;

  PointsOfInterestRepository(this._pointsOfInterestLocalProvider,
      this._pointsOfInterestRemoteProvider);

  Future<List<PointOfInterestModel>> getPointsOfInterest() async {
    try {
      final pois = await _pointsOfInterestRemoteProvider.getPointsOfInterest();
      _storePointsOfInterest(pois);
      return pois;
    } catch (e) {
      final pois = await _pointsOfInterestLocalProvider.getPointsOfInterest();
      return pois;
    }
  }

  Future<List<PointOfInterestModel>> getLocalPointsOfInterest() async {
    final pois = await _pointsOfInterestLocalProvider.getPointsOfInterest();
    return pois;
  }

  Future<void> _storePointsOfInterest(List<PointOfInterestModel> pois) async {
    await _pointsOfInterestLocalProvider.removeAll();
    await _pointsOfInterestLocalProvider.insertPointsOfInterest(pois);
  }
}
