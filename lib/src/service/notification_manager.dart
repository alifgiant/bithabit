import 'dart:io';

import 'package:bithabit/src/utils/text/date_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

import '../model/habit.dart';
import '../model/habit_frequency.dart';
import '../model/habit_reminder.dart';

class NotificationManager {
  final plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // initialise the plugin. app_icon needs to be a added as a drawable
    // resource to the Android head project
    const settingsAndroid = AndroidInitializationSettings('ic_notification');
    final settingsDarwin = DarwinInitializationSettings(
      // request permissions at a later point in application
      // on iOS, set all of the above to false when initialising the plugin
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: [
        DarwinNotificationCategory(
          'BitHabit:Reminder',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('complete', 'Complete'),
            // DarwinNotificationAction.plain(
            //   'id_2',
            //   'Action 2',
            //   options: <DarwinNotificationActionOption>{
            //     DarwinNotificationActionOption.destructive,
            //   },
            // ),
            // DarwinNotificationAction.plain(
            //   'id_3',
            //   'Action 3',
            //   options: <DarwinNotificationActionOption>{
            //     DarwinNotificationActionOption.foreground,
            //   },
            // ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        ),
      ],
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final initializationSettings = InitializationSettings(
      android: settingsAndroid,
      iOS: settingsDarwin,
      macOS: settingsDarwin,
    );
    await plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    final initialNotif = await plugin.getNotificationAppLaunchDetails();
    final didNotificationLaunchApp = initialNotif?.didNotificationLaunchApp;
    final payload = initialNotif?.notificationResponse?.payload;
    print(
      'alifakbar:init => payload:$payload '
      'didNotificationLaunchApp:$didNotificationLaunchApp',
    );
  }

  /// [onDidReceiveNotificationResponse] called when
  /// On macOS:
  ///  - action button is tapped, either on foreground or background
  Future<void> onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    final String? payload = notificationResponse.payload;
    print(
      'alifakbar:onDidReceiveNotificationResponse => '
      'payload: $payload, action:${notificationResponse.actionId}',
    );
    // if (notificationResponse.payload != null) {
    //   debugPrint('notification payload: $payload');
    // }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  Future<bool?> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      return plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    } else if (Platform.isIOS) {
      return plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isMacOS) {
      return plugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
    return null;
  }

  DateTime? getReminderTime(
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

  int getNotificationId(int habitId, int selectedDay, int hour, int minute) {
    return '$habitId:$selectedDay:$hour:$minute'.hashCode;
  }

  Future<void> cancelNotification(Habit habit) async {
    final cancelEvent = List<Future<void>>.empty(growable: true);
    for (final selectedDay in habit.frequency.selected) {
      for (final reminder in habit.reminder) {
        final id = getNotificationId(
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

  Future<bool?> isNotificationEnabled() async {
    if (kIsWeb) return null; // TODO: show not working status
    return requestNotificationPermission();
  }

  Future<void> scheduleNotification(
    Habit? oldHabit,
    Habit newHabit,
  ) async {
    if (oldHabit != null) cancelNotification(oldHabit);

    final isPermitted = await isNotificationEnabled();
    if (isPermitted != true) return;

    final androidDetails = AndroidNotificationDetails(
      'BitHabit:Reminder',
      'Habit Reminder ',
      // TODO: [ticker] will be announced for accessibility, create dynamic
      ticker: 'Habit Reminder for ${newHabit.name}',
      channelDescription: "Let's achieve more by doing your habit on time",
      importance: Importance.max,
      priority: Priority.high,
      // TODO: handle actions on [notificationTapBackground]
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('id_1', 'Complete'),
      ],
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

        final time = getReminderTime(newHabit.frequency, selectedDay, reminder);
        if (time == null) return;
        final id = getNotificationId(
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

  /// [onDidReceiveLocalNotification] called when
  /// On Android:
  ///  - notification banner is tapped
  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    print('alifakbar:onDidReceiveLocalNotification => id:$id, title:$title');
    // display a dialog with the notification details, tap ok to go to another page
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title),
    //     content: Text(body),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('Ok'),
    //         onPressed: () async {
    //           Navigator.of(context, rootNavigator: true).pop();
    //           await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => SecondScreen(payload),
    //             ),
    //           );
    //         },
    //       )
    //     ],
    //   ),
    // );
  }
}

/// [notificationTapBackground] called when
/// On Android:
///  - action button is tapped, either on foreground or background
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  final String? payload = notificationResponse.payload;
  print(
    'alifakbar:notificationTapBackground => '
    'payload: $payload, action:${notificationResponse.actionId}',
  );
  // handle action
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
