import '../../models/point_of_interest_model.dart';
import '../../../core/example_data.dart' as example;

class PointsOfInterestRemoteProvider {
  Future<List<PointOfInterestModel>> getPointsOfInterest() async {
    // await Future.delayed(Duration(seconds: 0));
    return example.pois2;
  }
}
