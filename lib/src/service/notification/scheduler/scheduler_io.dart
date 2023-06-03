// ignore: depend_on_referenced_packages
import 'package:bithabit/src/service/notification/permission/permission.dart';
import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

import '../../../model/habit.dart';
import '../../../model/habit_frequency.dart';
import '../../../model/habit_reminder.dart';

DateTime? _getReminderTime(
  HabitFrequency frequency,
  int selectedDay,
  HabitReminder reminder,
) {
  final today = DateTime.now().emptyHour().copyWith(
        hour: reminder.hour,
        minute: reminder.minute,
      );

  // for daily frequency, date is invalid for day bigger than 7 (sunday)
  final isDailyReminder = frequency.type == FrequencyType.daily;
  if (isDailyReminder && selectedDay > 7) return null;

  final startDay = isDailyReminder ? today.weekday : today.day;
  return today.subtract(Duration(days: startDay - selectedDay));
}

int _getNotificationId(int habitId, int selectedDay, int hour, int minute) {
  return '$habitId:$selectedDay:$hour:$minute'.hashCode;
}

Future<void> cancelNotification(
  FlutterLocalNotificationsPlugin plugin,
  Habit habit,
) async {
  final cancelEvent = List<Future<void>>.empty(growable: true);
  for (final selectedDay in habit.frequency.selected) {
    for (final reminder in habit.reminder) {
      final id = _getNotificationId(
        habit.id,
        selectedDay,
        reminder.hour,
        reminder.minute,
      );
      cancelEvent.add(plugin.cancel(id));
    }
  }
  await Future.wait(cancelEvent);
}

Future<void> scheduleNotification(
  FlutterLocalNotificationsPlugin plugin,
  Habit? oldHabit,
  Habit newHabit,
) async {
  if (oldHabit != null) cancelNotification(plugin, oldHabit);

  final isPermitted = await NotifPermission.requestPermission();
  if (isPermitted != true) return;

  final androidDetails = AndroidNotificationDetails(
    'BitHabit:Reminder',
    'Habit Reminder ',
    // TODO: [ticker] will be announced for accessibility, create dynamic
    ticker: 'Habit Reminder for ${newHabit.name}',
    channelDescription: "Let's achieve more by doing your habit on time",
    importance: Importance.max,
    priority: Priority.high,
    // TODO: add action on reminder
    // actions: const [
    //   AndroidNotificationAction('complete', 'Complete'),
    // ],
  );

  final appleDetails = DarwinNotificationDetails(
    categoryIdentifier: 'BitHabit:Reminder',
    threadIdentifier: newHabit.name,
    presentAlert: true,
    interruptionLevel: InterruptionLevel.timeSensitive,
  );

  final matchDateTime = newHabit.frequency.type.toMatcher();
  final createEvent = List<Future<void>>.empty(growable: true);
  for (final selectedDay in newHabit.frequency.selected) {
    for (final reminder in newHabit.reminder) {
      if (!reminder.enabled) continue; // if disabled don't schedule it

      final time = _getReminderTime(
        newHabit.frequency,
        selectedDay,
        reminder,
      );
      if (time == null) return;

      final id = _getNotificationId(
        newHabit.id,
        selectedDay,
        reminder.hour,
        reminder.minute,
      );

      final scheduleCreation = plugin.zonedSchedule(
        id,
        'BitHabit Reminder',
        'Start your ${newHabit.name} for today',
        tz.TZDateTime.from(time, tz.local),
        NotificationDetails(
          android: androidDetails,
          iOS: appleDetails,
          macOS: appleDetails,
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: newHabit.id.toString(),
        matchDateTimeComponents: matchDateTime, // when to repeat
      );
      createEvent.add(scheduleCreation);
    }
  }
  await Future.wait(createEvent);
}

extension on FrequencyType {
  DateTimeComponents toMatcher() {
    switch (this) {
      case FrequencyType.daily:
        return DateTimeComponents.dayOfWeekAndTime;
      case FrequencyType.monthly:
        return DateTimeComponents.dayOfMonthAndTime;
    }
  }
}
