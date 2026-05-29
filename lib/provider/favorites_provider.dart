import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hive_flutter/hive_flutter.dart'; 
import '../data/model/recipe_model.dart';
import '../data/model/hive_recipe_model.dart';

// ── Box name constant — used here and in main.dart ────────────────────────────
const String kFavoritesBox = 'favorites';

// ── Converter helpers ─────────────────────────────────────────────────────────

HiveRecipeModel _toHive(RecipeModel r) => HiveRecipeModel(
      id: r.id,
      title: r.title,
      category: r.category,
      area: r.area,
      image: r.image,
      instructions: r.instructions,
      youtubeUrl: r.youtubeUrl,
      ingredients: r.ingredients,
      measures: r.measures,
    );

RecipeModel _fromHive(HiveRecipeModel h) => RecipeModel(
      id: h.id,
      title: h.title,
      category: h.category,
      area: h.area,
      image: h.image,
      instructions: h.instructions,
      youtubeUrl: h.youtubeUrl,
      ingredients: h.ingredients,
      measures: h.measures,
    );

// ── Notifier ──────────────────────────────────────────────────────────────────

class FavoritesNotifier extends StateNotifier<List<RecipeModel>> {
  FavoritesNotifier() : super([]) {
    _loadFromHive();
  }

  Box<HiveRecipeModel> get _box => Hive.box<HiveRecipeModel>(kFavoritesBox);

  // Load persisted favorites on startup
  void _loadFromHive() {
    final saved = _box.values.map(_fromHive).toList();
    state = saved;
  }

  // Returns true if recipe is currently favorited
  bool isFavorite(String id) => state.any((r) => r.id == id);

  // Toggle: add if not present, remove if present
  void toggleFavorite(RecipeModel recipe) {
    if (isFavorite(recipe.id)) {
      // Remove from Hive box and state
      _box.delete(recipe.id);
      state = state.where((r) => r.id != recipe.id).toList();
    } else {
      // Save to Hive using recipe.id as key, update state
      _box.put(recipe.id, _toHive(recipe));
      state = [...state, recipe];
    }
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<RecipeModel>>(
  (ref) => FavoritesNotifier(),
);

// ── Convenience: single-recipe isFavorite selector ───────────────────────────
// Use this in RecipeCard and RecipeDetailScreen to avoid rebuilding the whole list

final isFavoriteProvider = Provider.family<bool, String>((ref, id) {
  return ref.watch(favoritesProvider).any((r) => r.id == id);
});