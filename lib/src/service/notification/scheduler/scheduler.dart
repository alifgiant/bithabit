import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../model/habit.dart';
import 'scheduler_stub.dart'
    if (dart.library.io) 'scheduler_io.dart'
    if (dart.library.js) 'scheduler_web.dart';

mixin NotifScheduler {
  static Future<void> schedule(
    FlutterLocalNotificationsPlugin plugin,
    Habit? oldHabit,
    Habit newHabit,
  ) {
    return scheduleNotification(plugin, oldHabit, newHabit);
  }

  static Future<void> cancelNotification(
    FlutterLocalNotificationsPlugin plugin,
    Habit habit,
  ) {
    return cancelNotification(plugin, habit);
  }
}
