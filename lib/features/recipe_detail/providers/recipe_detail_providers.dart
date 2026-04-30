import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../data/models/recipe.dart';

final recipeByIdProvider =
    FutureProvider.family<Recipe?, String>((ref, id) async {
  return ref.read(recipeRepositoryProvider).details(id);
});

final isFavoriteProvider =
    FutureProvider.family<bool, String>((ref, id) async {
  return ref.read(favoritesRepositoryProvider).isSaved(id);
});

class FavoriteToggle {
  final Ref ref;
  FavoriteToggle(this.ref);

  Future<void> toggle(Recipe r) async {
    await ref.read(favoritesRepositoryProvider).toggle(r);
    ref.invalidate(isFavoriteProvider(r.id));
    ref.invalidate(allFavoritesProvider);
  }
}

final favoriteToggleProvider = Provider<FavoriteToggle>(FavoriteToggle.new);

final allFavoritesProvider = FutureProvider<List<Recipe>>((ref) async {
  return ref.read(favoritesRepositoryProvider).all();
});
