import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../models/recipe.dart';

class MealDbClient {
  final Dio _dio;
  MealDbClient([Dio? dio])
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: AppConstants.mealDbBaseUrl,
              connectTimeout: const Duration(seconds: 12),
              receiveTimeout: const Duration(seconds: 12),
            ));

  Future<List<Recipe>> searchByName(String query) async {
    final res = await _safeGet('/search.php', {'s': query});
    final meals = res['meals'] as List?;
    if (meals == null) return [];
    return meals
        .cast<Map<String, dynamic>>()
        .map(Recipe.fromMealDbFull)
        .toList();
  }

  Future<List<Recipe>> filterByCategory(String category) async {
    final res = await _safeGet('/filter.php', {'c': category});
    final meals = res['meals'] as List?;
    if (meals == null) return [];
    return meals
        .cast<Map<String, dynamic>>()
        .map(Recipe.fromMealDbLite)
        .toList();
  }

  Future<List<Recipe>> filterByArea(String area) async {
    final res = await _safeGet('/filter.php', {'a': area});
    final meals = res['meals'] as List?;
    if (meals == null) return [];
    return meals
        .cast<Map<String, dynamic>>()
        .map(Recipe.fromMealDbLite)
        .toList();
  }

  Future<List<Recipe>> filterByIngredient(String ingredient) async {
    final res = await _safeGet('/filter.php', {'i': ingredient});
    final meals = res['meals'] as List?;
    if (meals == null) return [];
    return meals
        .cast<Map<String, dynamic>>()
        .map(Recipe.fromMealDbLite)
        .toList();
  }

  Future<Recipe?> lookupById(String id) async {
    final res = await _safeGet('/lookup.php', {'i': id});
    final meals = res['meals'] as List?;
    if (meals == null || meals.isEmpty) return null;
    return Recipe.fromMealDbFull(meals.first as Map<String, dynamic>);
  }

  Future<Recipe?> random() async {
    final res = await _safeGet('/random.php', {});
    final meals = res['meals'] as List?;
    if (meals == null || meals.isEmpty) return null;
    return Recipe.fromMealDbFull(meals.first as Map<String, dynamic>);
  }

  Future<List<String>> categories() async {
    final res = await _safeGet('/list.php', {'c': 'list'});
    final meals = res['meals'] as List?;
    if (meals == null) return [];
    return meals
        .map((e) => (e as Map<String, dynamic>)['strCategory']?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }

  Future<List<String>> areas() async {
    final res = await _safeGet('/list.php', {'a': 'list'});
    final meals = res['meals'] as List?;
    if (meals == null) return [];
    return meals
        .map((e) => (e as Map<String, dynamic>)['strArea']?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }

  Future<Map<String, dynamic>> _safeGet(
      String path, Map<String, dynamic> qp) async {
    try {
      final r = await _dio.get(path, queryParameters: qp);
      if (r.data is Map<String, dynamic>) {
        return r.data as Map<String, dynamic>;
      }
      return {};
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkFailure();
      }
      throw const ApiFailure();
    }
  }
}
