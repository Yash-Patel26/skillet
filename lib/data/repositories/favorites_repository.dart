import '../local/favorites_db.dart';
import '../models/recipe.dart';

class FavoritesRepository {
  final FavoritesDb _db;
  FavoritesRepository(this._db);

  Future<List<Recipe>> all() => _db.all();
  Future<bool> isSaved(String id) => _db.isSaved(id);
  Future<void> save(Recipe r) => _db.save(r);
  Future<void> remove(String id) => _db.remove(id);
  Future<void> toggle(Recipe r) async {
    if (await _db.isSaved(r.id)) {
      await _db.remove(r.id);
    } else {
      await _db.save(r);
    }
  }
}
