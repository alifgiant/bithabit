// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../model/habit.dart';

Future<void> scheduleNotification(
  FlutterLocalNotificationsPlugin plugin,
  Habit? oldHabit,
  Habit newHabit,
) async {}

Future<void> cancelNotification(
  FlutterLocalNotificationsPlugin plugin,
  Habit habit,
) async {}
