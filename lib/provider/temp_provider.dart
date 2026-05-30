import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_1/data/api/location_service.dart';
import 'package:food_1/data/api/meal_time_service.dart';

// ── Meal context model ────────────────────────────────────────────────────────
class MealContext {
  final String category;
  final String label;
  final String greeting;
  final String emoji;

  const MealContext({
    required this.category,
    required this.label,
    required this.greeting,
    required this.emoji,
  });
}

// ── Time-based provider ───────────────────────────────────────────────────────
final mealContextProvider = Provider<MealContext>((ref) {
  final svc = MealTimeService.instance;
  return MealContext(
    category: svc.currentMealCategory,
    label: svc.mealLabel,
    greeting: svc.greeting,
    emoji: svc.mealEmoji,
  );
});

// ── Location-based area provider ──────────────────────────────────────────────
final locationAreaProvider = FutureProvider<String?>((ref) async {
  return LocationService.instance.getAreaForCurrentLocation();
});
