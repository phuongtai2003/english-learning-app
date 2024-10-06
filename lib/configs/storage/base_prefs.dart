import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class BasePrefs {
  SharedPreferences? _prefs;
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  T getValueForKey<T>(String key) {
    return _prefs?.get(key) as T;
  }

  Future<bool> setValueForKey(String key, dynamic value) {
    if (value is int) {
      return _prefs!.setInt(key, value);
    }

    if (value is String) {
      return _prefs!.setString(key, value);
    }

    if (value is List<String>) {
      return _prefs!.setStringList(key, value);
    }

    if (value is bool) {
      return _prefs!.setBool(key, value);
    }

    if (value is double) {
      return _prefs!.setDouble(key, value);
    }

    final jsonValue = jsonEncode(value);
    return _prefs!.setString(key, jsonValue);
  }

  Future<void> remove({required String key}) async {
    await _prefs!.remove(key);
  }
}
