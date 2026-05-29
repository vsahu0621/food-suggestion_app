import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_1/data/api/notification_service.dart';
import 'package:food_1/screen/home/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'data/model/hive_recipe_model.dart';
import 'provider/favorites_provider.dart';
import 'data/api/recipe_api_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Hive ──────────────────────────────────────────────────────────────────
  // Hive
  await Hive.initFlutter();
  Hive.registerAdapter(HiveRecipeModelAdapter());
  await Hive.openBox<HiveRecipeModel>(kFavoritesBox);
  await Hive.openBox<String>(kRecipeCacheBox);

  

  // ── Timezones ──────────────────────────────────────────────────────────────
  tz.initializeTimeZones();

  // ── Notifications ──────────────────────────────────────────────────────────
  await NotificationService.instance.init();
  await NotificationService.instance.scheduleMealTimeNotifications();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Recipe App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.orange,
        useMaterial3: true,
        cardTheme: CardThemeData(
          // ✅ shape removed (deprecated in M3)
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
