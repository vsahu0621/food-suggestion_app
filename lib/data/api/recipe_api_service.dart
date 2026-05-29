import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../model/recipe_model.dart';

/// Key for the Hive cache box opened in main.dart.
const String kRecipeCacheBox = 'recipe_cache';

class RecipeApiService {
  Box<String> get _cache => Hive.box<String>(kRecipeCacheBox);

  // ── Fetch by free-text search ─────────────────────────────────────────────
  Future<List<RecipeModel>> fetchRecipes({String query = 'chicken'}) async {
    final url = 'https://www.themealdb.com/api/json/v1/1/search.php?s=$query';
    return _fetchAndCache(url, cacheKey: 'search_$query');
  }

  // ── Fetch by category (used for time-based suggestions) ───────────────────
  Future<List<RecipeModel>> fetchByCategory(String category) async {
    // MealDB filter endpoint returns limited fields; we fetch full detail below
    final filterUrl =
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category';
    return _fetchAndCache(filterUrl, cacheKey: 'category_$category');
  }

  // ── Fetch by area (used for location-based suggestions) ───────────────────
  Future<List<RecipeModel>> fetchByArea(String area) async {
    final url = 'https://www.themealdb.com/api/json/v1/1/filter.php?a=$area';
    return _fetchAndCache(url, cacheKey: 'area_$area');
  }

  // ── Core fetch + cache logic ──────────────────────────────────────────────
  Future<List<RecipeModel>> _fetchAndCache(
    String url, {
    required String cacheKey,
  }) async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Persist raw JSON for offline use
        _cache.put(cacheKey, response.body);
        return _parse(response.body);
      }
    } catch (_) {
      // Network error — fall through to cache
    }

    // ── Offline fallback ──────────────────────────────────────────────────
    final cached = _cache.get(cacheKey);
    if (cached != null) return _parse(cached);

    return []; // nothing available
  }

  // ── Parse MealDB JSON into RecipeModel list ───────────────────────────────
  List<RecipeModel> _parse(String body) {
    final data = jsonDecode(body);
    if (data['meals'] == null) return [];
    final List meals = data['meals'];
    return meals.map((e) => RecipeModel.fromJson(e)).toList();
  }
}
