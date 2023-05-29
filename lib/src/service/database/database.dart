import 'database_service.dart';
import 'service_stub.dart' 
  if (dart.library.io) 'isar/isar_service.dart' 
  if (dart.library.js) 'web_pref/web_pref_service.dart';

mixin Database {
  static DatabaseService create() => startService();
}
