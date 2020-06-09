import '../../data/models/point_of_interest_model.dart';
import 'package:meta/meta.dart';

enum UserPreferencesUnit {
  km,
  miles,
}

UserPreferencesUnit _convertStringToUnit(String s) {
  switch (s) {
    case 'km':
      return UserPreferencesUnit.km;
      break;
    case 'miles':
      return UserPreferencesUnit.miles;
      break;
    default:
      return null;
  }
}

class UserPreferencesModel {
  final int travelDurationHours;
  final UserPreferencesUnit distanceUnit;
  final PointOfInterestModel pointsOfInterest;

  const UserPreferencesModel({
    @required this.travelDurationHours,
    @required this.distanceUnit,
    @required this.pointsOfInterest,
  });

  factory UserPreferencesModel.fromJSON(Map<String, dynamic> json) {
    return UserPreferencesModel(
      travelDurationHours: json['travelDurationHours'],
      distanceUnit: _convertStringToUnit(json['distanceUnit']),
      pointsOfInterest: json['pointsOfInterest'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'travelDurationHours': travelDurationHours,
      'distanceUnit': distanceUnit,
      'pointsOfInterest': pointsOfInterest,
    };
  }
}
