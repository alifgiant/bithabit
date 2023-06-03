import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<bool?> requestNotificationPermission() async {
  final plugin = FlutterLocalNotificationsPlugin();
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
  throw UnsupportedError('platform not supported');
}
