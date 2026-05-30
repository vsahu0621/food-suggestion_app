import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_1/data/api/connectivity_service.dart';
import 'package:food_1/provider/temp_provider.dart';

import '../data/api/recipe_api_service.dart';
import '../data/model/recipe_model.dart';

import 'search_provider.dart';


// ── Search results ────────────────────────────────────────────────────────────
final recipeProvider = FutureProvider<List<RecipeModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  return RecipeApiService().fetchRecipes(query: query);
});

// ── Time-based suggestions ────────────────────────────────────────────────────
final timeSuggestionsProvider = FutureProvider<List<RecipeModel>>((ref) async {
  final ctx = ref.watch(mealContextProvider);
  return RecipeApiService().fetchByCategory(ctx.category);
});

// ── Location-based suggestions ────────────────────────────────────────────────
final locationSuggestionsProvider =
    FutureProvider<List<RecipeModel>>((ref) async {
  final areaAsync = ref.watch(locationAreaProvider);
  return areaAsync.when(
    data: (area) async {
      if (area == null) return <RecipeModel>[];
      return RecipeApiService().fetchByArea(area);
    },
    loading: () async => <RecipeModel>[],
    error: (_, __) async => <RecipeModel>[],
  );
});

// ── Connectivity stream ───────────────────────────────────────────────────────
final connectivityProvider = StreamProvider<bool>((ref) {
  return ConnectivityService.instance.onlineStream;
});
