import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  final plugin = FlutterLocalNotificationsPlugin();

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
          'demoCategory',
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
      'onDidReceiveNotificationResponse => payload:$payload '
      'didNotificationLaunchApp:$didNotificationLaunchApp',
    );
  }

  void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    final String? payload = notificationResponse.payload;
    print('onDidReceiveNotificationResponse => payload: $payload');
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

  Future<void> scheduleNotification() async {
    await plugin.zonedSchedule(
      0,
      'scheduled title',
      'scheduled body',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
        ),
        iOS: DarwinNotificationDetails(
          threadIdentifier: 'habit-name',
          presentAlert: true,
          categoryIdentifier: 'demoCategory',
          subtitle: 'your channel description',
        ),
        macOS: DarwinNotificationDetails(
          threadIdentifier: 'habit-name',
          presentAlert: true,
          categoryIdentifier: 'demoCategory',
          subtitle: 'your channel description',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents:
          DateTimeComponents.dayOfWeekAndTime, // when to repeat
    );
  }

  Future<void> scheduleNotificationInterval() async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'repeating channel id',
        'repeating channel name',
        channelDescription: 'repeating description',
      ),
      iOS: DarwinNotificationDetails(
        threadIdentifier: 'habit-name',
        presentAlert: true,
        categoryIdentifier: 'demoCategory',
        subtitle: 'your channel description',
      ),
      macOS: DarwinNotificationDetails(
        threadIdentifier: 'habit-name',
        presentAlert: true,
        categoryIdentifier: 'demoCategory',
        subtitle: 'your channel description',
      ),
    );
    await plugin.periodicallyShow(
      0,
      'repeating title',
      'repeating body',
      RepeatInterval.daily,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      // androidAllowWhileIdle: true,
    );
  }

  Future<void> showNotification() async {
    final isPermitted = await requestNotificationPermission();
    if (isPermitted != true) return;

    const androidNotificationDetails = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const ios = DarwinNotificationDetails(
      presentAlert: true,
      threadIdentifier: 'habit-name',
      categoryIdentifier: 'demoCategory',
      subtitle: 'your channel description',
    );
    const notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: ios,
      macOS: ios,
    );
    await plugin.show(
      0,
      'plain title',
      'plain body',
      notificationDetails,
      payload: 'item x',
    );
  }

  void cancelNotification(int notifId) async {
    // cancel the notification with id value of zero
    await plugin.cancel(notifId);
  }

  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
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

  Future<void> _showNotificationWithActions() async {
    const androidNotificationDetails = AndroidNotificationDetails(
      '...',
      '...',
      channelDescription: '...',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('id_1', 'Action 1'),
        AndroidNotificationAction('id_2', 'Action 2'),
        AndroidNotificationAction('id_3', 'Action 3'),
      ],
    );

    const notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await plugin.show(
      0,
      '...',
      '...',
      notificationDetails,
    );
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  final String? payload = notificationResponse.payload;
  print('onDidReceiveNotificationResponse => payload: $payload');
  // handle action
}
