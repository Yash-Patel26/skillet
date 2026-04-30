import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../data/models/recipe.dart';

class SearchQuery {
  final String text;
  final String? category;
  final String? area;
  final String? ingredient;
  const SearchQuery({this.text = '', this.category, this.area, this.ingredient});

  SearchQuery copyWith({
    String? text,
    String? category,
    String? area,
    String? ingredient,
    bool clearCategory = false,
    bool clearArea = false,
    bool clearIngredient = false,
  }) {
    return SearchQuery(
      text: text ?? this.text,
      category: clearCategory ? null : (category ?? this.category),
      area: clearArea ? null : (area ?? this.area),
      ingredient: clearIngredient ? null : (ingredient ?? this.ingredient),
    );
  }

  bool get isEmpty =>
      text.isEmpty && category == null && area == null && ingredient == null;
}

final searchQueryProvider =
    StateProvider<SearchQuery>((ref) => const SearchQuery());

final categoriesListProvider = FutureProvider<List<String>>((ref) async {
  return ref.read(recipeRepositoryProvider).categories();
});

final areasListProvider = FutureProvider<List<String>>((ref) async {
  return ref.read(recipeRepositoryProvider).areas();
});

final searchResultsProvider = FutureProvider<List<Recipe>>((ref) async {
  final q = ref.watch(searchQueryProvider);
  if (q.isEmpty) return [];
  final repo = ref.read(recipeRepositoryProvider);
  if (q.text.isNotEmpty) {
    return repo.search(q.text);
  }
  if (q.category != null) return repo.byCategory(q.category!);
  if (q.area != null) return repo.byArea(q.area!);
  if (q.ingredient != null) return repo.byIngredient(q.ingredient!);
  return [];
});
