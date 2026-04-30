import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../models/user_prefs.dart';

class PrefsStore {
  final SharedPreferences _sp;
  PrefsStore(this._sp);

  bool get onboardingDone => _sp.getBool(AppConstants.prefsOnboardingDone) ?? false;
  Future<void> setOnboardingDone(bool v) =>
      _sp.setBool(AppConstants.prefsOnboardingDone, v);

  UserPrefs read() {
    return UserPrefs(
      diet: DietPrefX.fromKey(_sp.getString(AppConstants.prefsDiet)),
      allergies: _sp.getStringList(AppConstants.prefsAllergies) ?? const [],
      cuisines: _sp.getStringList(AppConstants.prefsCuisines) ?? const [],
      skill: SkillLevelX.fromKey(_sp.getString(AppConstants.prefsSkill)),
      pantry: _sp.getStringList(AppConstants.prefsPantry) ?? const [],
    );
  }

  Future<void> write(UserPrefs p) async {
    await _sp.setString(AppConstants.prefsDiet, p.diet.name);
    await _sp.setStringList(AppConstants.prefsAllergies, p.allergies);
    await _sp.setStringList(AppConstants.prefsCuisines, p.cuisines);
    await _sp.setString(AppConstants.prefsSkill, p.skill.name);
    await _sp.setStringList(AppConstants.prefsPantry, p.pantry);
  }

  String? get themeMode => _sp.getString(AppConstants.prefsThemeMode);
  Future<void> setThemeMode(String mode) =>
      _sp.setString(AppConstants.prefsThemeMode, mode);

  String? get localeCode => _sp.getString(AppConstants.prefsLocale);
  Future<void> setLocaleCode(String code) =>
      _sp.setString(AppConstants.prefsLocale, code);

  ({double? lat, double? lon}) get lastLocation => (
        lat: _sp.getDouble(AppConstants.prefsLastLat),
        lon: _sp.getDouble(AppConstants.prefsLastLon),
      );

  Future<void> setLastLocation(double lat, double lon) async {
    await _sp.setDouble(AppConstants.prefsLastLat, lat);
    await _sp.setDouble(AppConstants.prefsLastLon, lon);
  }
}
