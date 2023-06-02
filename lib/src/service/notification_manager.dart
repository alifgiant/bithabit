import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  final plugin = FlutterLocalNotificationsPlugin();
  static const androidDetails = AndroidNotificationDetails(
    'BitHabit:Reminder',
    'Habit Reminder ',
    // TODO: [ticker] will be announced for accessibility, create dynamic
    ticker: 'Habit Reminder',
    channelDescription: "Let's achieve more by doing your habit on time",
    importance: Importance.max,
    priority: Priority.high,
    // TODO: handle actions on [notificationTapBackground]
    actions: <AndroidNotificationAction>[
      AndroidNotificationAction('id_1', 'Complete'),
    ],
  );

  static const appleDetails = DarwinNotificationDetails(
    categoryIdentifier: 'BitHabit:Reminder',
    // TODO: dynamic thread base on habit name
    threadIdentifier: 'habit-name',
    subtitle: "Let's achieve more by doing your habit on time",
    presentAlert: true,
  );

  Future<void> init() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // initialise the plugin. app_icon needs to be a added as a drawable
    // resource to the Android head project
    const initializationSettingsAndroid = AndroidInitializationSettings(
      'ic_notification',
    );
    final initializationSettingsDarwin = DarwinInitializationSettings(
      // request permissions at a later point in application
      // on iOS, set all of the above to false when initialising the plugin
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: [
        DarwinNotificationCategory(
          'BitHabit:Reminder',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('id_1', 'Action 1'),
            DarwinNotificationAction.plain(
              'id_2',
              'Action 2',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.destructive,
              },
            ),
            DarwinNotificationAction.plain(
              'id_3',
              'Action 3',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        ),
      ],
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
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

  Future<void> onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    final String? payload = notificationResponse.payload;
    print('alifakbar:onDidReceiveNotificationResponse => payload: $payload');
    // if (notificationResponse.payload != null) {
    //   debugPrint('notification payload: $payload');
    // }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  Future<bool?> requestNotificationPermission() async {
    if (kIsWeb) return true;
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

  Future<void> scheduleNotification(int id) async {
    if (kIsWeb) return; // TODO: show not working status

    final isPermitted = await requestNotificationPermission();
    if (isPermitted != true) return;

    final time = tz.TZDateTime(tz.local, 2023);

    await plugin.zonedSchedule(
      id,
      'Repeating BitHabit Reminder',
      'Start your exercise for today',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
        android: androidDetails,
        iOS: appleDetails,
        macOS: appleDetails,
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents:
          DateTimeComponents.dayOfWeekAndTime, // when to repeat
    );
  }

  // note: can't schedule specific time notif
  Future<void> _scheduleNotificationInterval(int id) async {
    if (kIsWeb) return; // TODO: show not working status

    final isPermitted = await requestNotificationPermission();
    if (isPermitted != true) return;
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: appleDetails,
      macOS: appleDetails,
    );
    await plugin.periodicallyShow(
      id,
      'Repeating BitHabit Reminder',
      'Start your exercise for today',
      RepeatInterval.everyMinute,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'item x',
    );
  }

  Future<void> showNotification(int id) async {
    if (kIsWeb) return; // TODO: show not working status

    final isPermitted = await requestNotificationPermission();
    if (isPermitted != true) return;

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: appleDetails,
      macOS: appleDetails,
    );
    await plugin.show(
      id,
      'BitHabit Reminder',
      'Start your exercise for today',
      notificationDetails,
      payload: 'item x',
    );
  }

  void cancelNotification(int notifId) async {
    // cancel the notification with id value of zero
    await plugin.cancel(notifId);
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
