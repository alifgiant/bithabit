import 'package:shared_preferences/shared_preferences.dart';

import 'cache.dart';

class PrefCache extends Cache {
  const PrefCache();

  @override
  Future<String?> getString(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  @override
  Future<bool> setString(String key, String value) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(key, value);
  }

  @override
  Future<bool> remove(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.remove(key);
  }
}
