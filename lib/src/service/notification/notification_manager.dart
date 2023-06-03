import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

import '../../../firebase_setup.dart';
import '../../model/habit.dart';
import '../analytic_service.dart';
import 'permission/permission.dart';
import 'scheduler/scheduler.dart';

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
      // TODO: add action on reminder
      // notificationCategories: [
      //   DarwinNotificationCategory(
      //     'BitHabit:Reminder',
      //     actions: <DarwinNotificationAction>[
      //       DarwinNotificationAction.plain('complete', 'Complete'),
      //     ],
      //     options: <DarwinNotificationCategoryOption>{
      //       DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      //     },
      //   ),
      // ],
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

    /// this section called when
    /// on Android:
    ///  - app open and notif banner click while on background (app killed)
    /// On iOS:
    ///  - app open
    /// On macOS:
    ///  - app open
    final initialNotif = await plugin.getNotificationAppLaunchDetails();
    if (initialNotif == null) return;

    final notificationResponse = initialNotif.notificationResponse;
    if (notificationResponse == null) return;

    final didNotificationLaunchApp = initialNotif.didNotificationLaunchApp;
    if (!didNotificationLaunchApp) return;

    final notifId = notificationResponse.id;
    final payload = notificationResponse.payload;
    final action = notificationResponse.actionId;
    // print(
    //   'alifakbar:init => payload:$payload '
    //   'didNotificationLaunchApp:$didNotificationLaunchApp',
    // );

    Analytic.get().logNotificationClick(notifId, payload, action);
  }

  Future<bool?> isNotificationEnabled() async {
    return NotifPermission.requestPermission();
  }

  Future<void> scheduleNotification(
    Habit? oldHabit,
    Habit newHabit,
  ) async {
    return NotifScheduler.schedule(plugin, oldHabit, newHabit);
  }

  Future<void> cancelNotification(Habit habit) async {
    NotifScheduler.cancelNotification(plugin, habit);
  }

  /// [onDidReceiveNotificationResponse] called when
  /// on Android:
  ///  - notification banner is tapped while on foreground / background (app not killed)
  /// On iOS:
  ///  - notification banner is tapped while on foreground / background (app not killed)
  /// On macOS:
  ///  - //
  Future<void> onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    final notifId = notificationResponse.id;
    final payload = notificationResponse.payload;
    final action = notificationResponse.actionId;

    Analytic.get().logNotificationClick(notifId, payload, action);

    // print(
    //   'alifakbar:onDidReceiveNotificationResponse => '
    //   'payload: $payload, action:${notificationResponse.actionId}',
    // );
  }

  /// [onDidReceiveLocalNotification] called when
  /// On Android:
  ///  - never trigger
  /// On iOS:
  ///  - notification banner is tapped on foreground
  /// On macOS:
  ///  - //
  Future<void> onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    // print('alifakbar:onDidReceiveLocalNotification => id:$id, title:$title');
    Analytic.get().logNotificationClick(id, payload, null);
  }
}

/// [notificationTapBackground] is triggered on isolate, will be called when
/// On Android:
///  - action button is tapped, either on foreground or background
/// On iOS:
///  - action button is tapped, either on foreground or background
/// On macOS:
///  - //
@pragma('vm:entry-point')
Future<void> notificationTapBackground(
  NotificationResponse notificationResponse,
) async {
  final notifId = notificationResponse.id;
  final payload = notificationResponse.payload;
  final action = notificationResponse.actionId;

  // TODO: handle actions
  // print(
  //   'alifakbar:notificationTapBackground => '
  //   'payload: $payload, action:${notificationResponse.actionId}',
  // );

  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseSetup().start();

  Analytic.get().logNotificationClick(notifId, payload, action);
}
