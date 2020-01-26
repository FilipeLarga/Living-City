import 'package:living_city/data/models/user_preferences_model.dart';
import 'package:living_city/data/provider/user_preferences_provider.dart';

class UserPreferencesRepository {
  final UserPreferencesProvider _provider;

  UserPreferencesRepository(this._provider);

  Future<UserPreferencesModel> getUserPreferences() async {
    final UserPreferencesModel userPreferencesModel =
        await _provider.getUserPreferences();
    return userPreferencesModel;
  }

  void saveUserPreferences() {
    //TODO
  }
}
