import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api/meal_db_client.dart';
import '../data/api/weather_client.dart';
import '../data/local/favorites_db.dart';
import '../data/local/notifications_service.dart';
import '../data/local/prefs_store.dart';
import '../data/local/push_notifications_service.dart';
import '../data/models/user_prefs.dart';
import '../data/repositories/favorites_repository.dart';
import '../data/repositories/recipe_repository.dart';
import '../data/repositories/region_repository.dart';
import '../data/repositories/weather_repository.dart';

final sharedPrefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Override at app start'),
);

final prefsStoreProvider = Provider<PrefsStore>(
  (ref) => PrefsStore(ref.watch(sharedPrefsProvider)),
);

final mealDbClientProvider = Provider<MealDbClient>((ref) => MealDbClient());

final weatherClientProvider = Provider<WeatherClient>((ref) => WeatherClient());

final favoritesDbProvider = Provider<FavoritesDb>((ref) => FavoritesDb());

final notificationsServiceProvider =
    Provider<NotificationsService>((ref) => NotificationsService());

final pushNotificationsServiceProvider = Provider<PushNotificationsService>(
  (ref) => PushNotificationsService(ref.watch(notificationsServiceProvider)),
);

final recipeRepositoryProvider = Provider<RecipeRepository>(
  (ref) => RecipeRepository(
    ref.watch(mealDbClientProvider),
    ref.watch(favoritesDbProvider),
  ),
);

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => FavoritesRepository(ref.watch(favoritesDbProvider)),
);

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepository(
    ref.watch(weatherClientProvider),
    ref.watch(prefsStoreProvider),
  ),
);

final regionRepositoryProvider = Provider<RegionRepository>(
  (ref) => RegionRepository(ref.watch(prefsStoreProvider)),
);

class UserPrefsController extends StateNotifier<UserPrefs> {
  final PrefsStore _store;
  UserPrefsController(this._store) : super(_store.read());

  Future<void> update(UserPrefs next) async {
    state = next;
    await _store.write(next);
  }

  Future<void> setDiet(DietPref d) => update(state.copyWith(diet: d));
  Future<void> setSkill(SkillLevel s) => update(state.copyWith(skill: s));
  Future<void> setAllergies(List<String> a) =>
      update(state.copyWith(allergies: a));
  Future<void> setCuisines(List<String> c) =>
      update(state.copyWith(cuisines: c));
  Future<void> setPantry(List<String> p) => update(state.copyWith(pantry: p));
}

final userPrefsProvider =
    StateNotifierProvider<UserPrefsController, UserPrefs>((ref) {
  return UserPrefsController(ref.watch(prefsStoreProvider));
});

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  final v = ref.watch(prefsStoreProvider).themeMode;
  switch (v) {
    case 'dark':
      return ThemeMode.dark;
    case 'light':
      return ThemeMode.light;
    default:
      return ThemeMode.system;
  }
});

// null = follow system
final localeProvider = StateProvider<Locale?>((ref) {
  final code = ref.watch(prefsStoreProvider).localeCode;
  if (code == null || code.isEmpty) return null;
  return Locale(code);
});
