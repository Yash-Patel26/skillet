import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/utils/context_helper.dart';
import '../../../data/models/recipe.dart';
import '../../../data/models/weather.dart';
import '../../../data/repositories/region_repository.dart';

// ticks every minute so dayPart re-evaluates
final nowProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(minutes: 1), (_) => DateTime.now());
});

final dayPartProvider = Provider<DayPart>((ref) {
  final now = ref.watch(nowProvider).valueOrNull ?? DateTime.now();
  return ContextHelper.dayPartFor(now);
});

final weatherProvider = FutureProvider<Weather?>((ref) async {
  try {
    return await ref.read(weatherRepositoryProvider).currentForUser();
  } catch (_) {
    return null;
  }
});

final regionProvider = FutureProvider<RegionInfo?>((ref) async {
  try {
    return await ref.read(regionRepositoryProvider).currentRegion();
  } catch (_) {
    return null;
  }
});

final regionFeedProvider = FutureProvider<List<Recipe>>((ref) async {
  final region = await ref.watch(regionProvider.future);
  if (region?.mealDbArea == null) return [];
  return ref.read(recipeRepositoryProvider).byArea(region!.mealDbArea!);
});

final dayPartFeedProvider = FutureProvider<List<Recipe>>((ref) async {
  final repo = ref.watch(recipeRepositoryProvider);
  final part = ref.watch(dayPartProvider);
  final cats = ContextHelper.categoriesForDayPart(part);
  for (final c in cats) {
    final list = await repo.byCategory(c);
    if (list.isNotEmpty) return list.take(10).toList();
  }
  return [];
});

final weatherFeedProvider = FutureProvider<List<Recipe>>((ref) async {
  final repo = ref.watch(recipeRepositoryProvider);
  final w = await ref.watch(weatherProvider.future);
  if (w == null) return [];
  final cats =
      ContextHelper.categoriesForWeather(tempC: w.tempC, precipMm: w.precipMm);
  for (final c in cats) {
    final list = await repo.byCategory(c);
    if (list.isNotEmpty) return list.take(10).toList();
  }
  return [];
});

final cuisineFeedProvider = FutureProvider<List<Recipe>>((ref) async {
  final repo = ref.watch(recipeRepositoryProvider);
  final prefs = ref.watch(userPrefsProvider);
  final cuisines = prefs.cuisines.isNotEmpty
      ? prefs.cuisines
      : <String>['Italian', 'Indian'];
  for (final c in cuisines) {
    final list = await repo.byArea(c);
    if (list.isNotEmpty) return list.take(10).toList();
  }
  return [];
});

final pantryFeedProvider = FutureProvider<List<Recipe>>((ref) async {
  final repo = ref.watch(recipeRepositoryProvider);
  final prefs = ref.watch(userPrefsProvider);
  if (prefs.pantry.isEmpty) return [];
  final results = await Future.wait(
    prefs.pantry.take(3).map((i) => repo.byIngredient(i)),
  );
  // rank by how many of the user's pantry ingredients each recipe matches
  final freq = <String, int>{};
  final byId = <String, Recipe>{};
  for (final list in results) {
    final seen = <String>{};
    for (final r in list) {
      if (!seen.add(r.id)) continue;
      freq[r.id] = (freq[r.id] ?? 0) + 1;
      byId[r.id] = r;
    }
  }
  final sorted = freq.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return sorted.take(10).map((e) => byId[e.key]!).toList();
});

final featuredProvider = FutureProvider<Recipe?>((ref) async {
  final repo = ref.watch(recipeRepositoryProvider);
  final list = await repo.randomMany(1);
  return list.isEmpty ? null : list.first;
});
