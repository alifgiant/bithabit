// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

Future<bool?> requestNotificationPermission() async {
  /// result is either "default", "granted" or "denied"
  final permission = await Notification.requestPermission();
  return permission == 'granted';
}
