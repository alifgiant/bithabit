import 'permission_stub.dart'
    if (dart.library.io) 'permission_io.dart'
    if (dart.library.js) 'permission_web.dart';

mixin NotifPermission {
  static Future<bool?> requestPermission() => requestNotificationPermission();
}
