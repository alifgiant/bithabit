import 'package:bithabit/src/service/notification/permission/permission.dart';
import 'package:bithabit/src/service/notification/scheduler/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

import '../../model/habit.dart';

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

  Future<void> cancelNotification(Habit habit) async {
    NotifScheduler.cancelNotification(plugin, habit);
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

  // Future<void> showNotification(int id) async {
  //   if (kIsWeb) return; // TODO: show not working status

  //   final isPermitted = await requestNotificationPermission();
  //   if (isPermitted != true) return;

  //   const notificationDetails = NotificationDetails(
  //     android: androidDetails,
  //     iOS: appleDetails,
  //     macOS: appleDetails,
  //   );
  //   await plugin.show(
  //     id,
  //     'BitHabit Reminder',
  //     'Start your exercise for today',
  //     notificationDetails,
  //     payload: 'item x',
  //   );
  // }

  /// [onDidReceiveLocalNotification] called when
  /// On Android:
  ///  - notification banner is tapped
  Future<void> onDidReceiveLocalNotification(
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
