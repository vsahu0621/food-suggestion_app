import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // ── Initialise plugin ─────────────────────────────────────────────────────
  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(initSettings);

    // Request Android 13+ notification permission
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // ── Notification details helper ───────────────────────────────────────────
  NotificationDetails _details(String channelId, String channelName) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  // ── Schedule a daily notification at a given hour:minute ─────────────────
  Future<void> _scheduleDailyAt({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    // Build next occurrence of hour:minute
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If it's already past today's slot, schedule for tomorrow
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      _details('meal_reminders', 'Meal Reminders'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // repeat daily
    );
  }

  // ── Schedule all three meal-time notifications ────────────────────────────
  Future<void> scheduleMealTimeNotifications() async {
    await _scheduleDailyAt(
      id: 1,
      title: '🍳 Good Morning! Breakfast time',
      body: 'Check out today\'s breakfast suggestion in the app.',
      hour: 8,
      minute: 0,
    );

    await _scheduleDailyAt(
      id: 2,
      title: '🥗 Lunchtime!',
      body: 'Hungry? We\'ve picked a great lunch recipe for you.',
      hour: 13,
      minute: 0,
    );

    await _scheduleDailyAt(
      id: 3,
      title: '🍽️ Dinner ideas',
      body: 'Wind down with a delicious dinner recipe tonight.',
      hour: 19,
      minute: 0,
    );
  }

  // ── Cancel all scheduled notifications ───────────────────────────────────
  Future<void> cancelAll() async => _plugin.cancelAll();
}
