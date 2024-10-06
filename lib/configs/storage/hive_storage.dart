import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class HiveStorage {
  final Box _box;

  HiveStorage(this._box);

  Future<void> saveData<T>(
      String key, T data, String Function(T importData) toJson) async {
    await _box.put(
      key,
      toJson(data),
    );
  }

  Future<T> getData<T>(String key, T Function(dynamic json) fromJson) async {
    final data = _box.get(key);
    if (data == null) {
      return null as T;
    }
    return fromJson(data);
  }

  Future<void> deleteData(String key) async {
    await _box.delete(key);
  }

  Future<void> clearData() async {
    await _box.clear();
  }

  Future<bool> isKeyExists(String key) async {
    return _box.containsKey(key);
  }
}
