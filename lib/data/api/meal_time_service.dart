/// Returns contextual meal info based on current device time.
class MealTimeService {
  MealTimeService._();
  static final MealTimeService instance = MealTimeService._();

  /// Returns the MealDB category query string for the current time of day.
  /// Breakfast: 05:00–10:59 | Lunch: 11:00–15:59 | Dinner: 16:00–04:59
  String get currentMealCategory {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return 'Breakfast';
    if (hour >= 11 && hour < 16) return 'Chicken'; // MealDB has no "Lunch"
    return 'Beef'; // Evening default
  }

  /// Human-readable meal period label shown in the UI.
  String get mealLabel {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return 'Breakfast';
    if (hour >= 11 && hour < 16) return 'Lunch';
    return 'Dinner';
  }

  /// Greeting for the app bar.
  String get greeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning 🌅';
    if (hour >= 12 && hour < 17) return 'Good Afternoon ☀️';
    if (hour >= 17 && hour < 21) return 'Good Evening 🌇';
    return 'Good Night 🌙';
  }

  /// Emoji for the current meal period.
  String get mealEmoji {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return '🍳';
    if (hour >= 11 && hour < 16) return '🥗';
    return '🍽️';
  }
}
