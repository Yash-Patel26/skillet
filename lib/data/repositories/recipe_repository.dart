import '../../core/errors/failures.dart';
import '../api/meal_db_client.dart';
import '../local/favorites_db.dart';
import '../models/recipe.dart';
import '../models/user_prefs.dart';

class RecipeRepository {
  final MealDbClient _api;
  final FavoritesDb _cache;
  RecipeRepository(this._api, this._cache);

  Future<List<Recipe>> search(String query) => _api.searchByName(query);

  Future<Recipe?> details(String id) async {
    try {
      final r = await _api.lookupById(id);
      if (r != null) await _cache.cacheRecipe(r);
      return r;
    } on Failure {
      return _cache.cachedRecipe(id);
    }
  }

  Future<List<Recipe>> byCategory(String category) =>
      _cachingFeed('cat:$category', () => _api.filterByCategory(category));

  Future<List<Recipe>> byArea(String area) =>
      _cachingFeed('area:$area', () => _api.filterByArea(area));

  Future<List<Recipe>> byIngredient(String ingredient) => _cachingFeed(
        'ing:${ingredient.toLowerCase()}',
        () => _api.filterByIngredient(ingredient),
      );

  Future<List<String>> categories() => _api.categories();
  Future<List<String>> areas() => _api.areas();

  Future<List<Recipe>> randomMany(int count) async {
    final futures = List.generate(count, (_) => _api.random());
    final results = await Future.wait(futures);
    return results.whereType<Recipe>().toList();
  }

  Future<List<Recipe>> _cachingFeed(
    String key,
    Future<List<Recipe>> Function() fetch,
  ) async {
    try {
      final list = await fetch();
      // Don't overwrite a good cache with an empty network result.
      if (list.isNotEmpty) await _cache.cacheFeed(key, list);
      return list;
    } on Failure {
      return _cache.cachedFeed(key);
    }
  }

  List<Recipe> applyPrefs(List<Recipe> recipes, UserPrefs prefs) {
    return recipes.where((r) {
      if (prefs.diet == DietPref.vegetarian || prefs.diet == DietPref.vegan) {
        final cat = r.category?.toLowerCase() ?? '';
        final tags = r.tags.map((e) => e.toLowerCase()).toList();
        final isVeg = cat == 'vegetarian' ||
            cat == 'vegan' ||
            tags.contains('vegetarian') ||
            tags.contains('vegan');
        if (!isVeg && cat.isNotEmpty) return false;
      }
      if (prefs.diet == DietPref.nonVeg) {
        final cat = r.category?.toLowerCase() ?? '';
        if (cat == 'vegetarian' || cat == 'vegan') return false;
      }
      if (prefs.allergies.isNotEmpty && r.ingredients.isNotEmpty) {
        final ing = r.ingredients.map((e) => e.name.toLowerCase()).toList();
        for (final a in prefs.allergies) {
          if (ing.any((i) => i.contains(a.toLowerCase()))) return false;
        }
      }
      return true;
    }).toList();
  }
}
