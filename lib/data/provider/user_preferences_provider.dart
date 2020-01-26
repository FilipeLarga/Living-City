import 'package:living_city/data/models/user_preferences_model.dart';

class UserPreferencesProvider {
  Future<UserPreferencesModel> getUserPreferences() async {
    return UserPreferencesModel.fromJSON(null);
  }
}
