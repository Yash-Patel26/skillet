import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../models/recipe.dart';
import '../repositories/recipe_repository.dart';

class NotificationsService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    const init = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _plugin.initialize(init);
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    await init();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return true;
    final granted = await android.requestNotificationsPermission();
    final exact = await android.requestExactAlarmsPermission();
    return (granted ?? false) || (exact ?? false);
  }

  Future<void> scheduleDailyMealReminders(RecipeRepository repo) async {
    await init();
    await _plugin.cancelAll();

    Future<Recipe?> firstFromCategory(String c) async {
      try {
        final list = await repo.byCategory(c);
        return list.isEmpty ? null : list.first;
      } catch (_) {
        return null;
      }
    }

    final breakfast = await firstFromCategory('Breakfast');
    final lunch = await firstFromCategory('Chicken');
    final dinner = await firstFromCategory('Beef');

    await _scheduleAt(
      id: 1,
      hour: 8,
      minute: 0,
      title: 'Breakfast time',
      body: breakfast == null
          ? 'Open Skillet to find a quick breakfast.'
          : 'Try ${breakfast.name} for breakfast today.',
      payload: breakfast?.id,
    );
    await _scheduleAt(
      id: 2,
      hour: 14,
      minute: 0,
      title: 'Lunch time',
      body: lunch == null
          ? 'Open Skillet for a lunch idea.'
          : 'Lunch idea: ${lunch.name}.',
      payload: lunch?.id,
    );
    await _scheduleAt(
      id: 3,
      hour: 20,
      minute: 0,
      title: 'Dinner time',
      body: dinner == null
          ? 'Open Skillet to plan dinner.'
          : 'Dinner inspiration: ${dinner.name}.',
      payload: dinner?.id,
    );
  }

  Future<void> _scheduleAt({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
    String? payload,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (when.isBefore(now)) when = when.add(const Duration(days: 1));

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'meals_channel',
        'Meal reminders',
        channelDescription: 'Daily breakfast / lunch / dinner ideas',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      when,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }
}
