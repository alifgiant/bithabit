// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../model/habit.dart';

Future<void> scheduleNotification(
  FlutterLocalNotificationsPlugin plugin,
  Habit? oldHabit,
  Habit newHabit,
) async {
  Notification(
    'BitHabit Reminder',
    body: 'Start your ${newHabit.name} for today '
        '(Demo Only, not actual scheduled reminder)',
    icon: 'assets/images/app-icon2.png',
  );
}

Future<void> cancelNotification(
  FlutterLocalNotificationsPlugin plugin,
  Habit habit,
) async {
  // do nothing
}
