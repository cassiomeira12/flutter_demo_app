import 'package:clean_code_data/clean_code_data.dart';
import 'package:dependency/dependency.dart';

class SharedPreferencesLocalStorageImpl implements LocalStorage {
  @override
  Future<T?> get<T>(String key) async {
    final pref = await SharedPreferences.getInstance();

    final value = pref.get(key);

    if (value != null) {
      if (T.toString().contains('Map')) {
        return jsonDecode(value.toString()) as T;
      }
    }

    return value as T?;
  }

  @override
  Future<bool> set<T>(String key, T value) async {
    final pref = await SharedPreferences.getInstance();

    if (value is int) {
      return await pref.setInt(key, value);
    }
    if (value is bool) {
      return await pref.setBool(key, value);
    }
    if (value is double) {
      return await pref.setDouble(key, value);
    }
    if (value is String) {
      return await pref.setString(key, value);
    }
    if (value is List<String>) {
      return await pref.setStringList(key, value);
    }
    if (value is Map) {
      return await pref.setString(key, jsonEncode(value));
    }

    throw Exception('${value.runtimeType} is not a Type acceptable');
  }

  @override
  Future<bool> delete(String key) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.remove(key);
  }

  @override
  Future<void> clearAll() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  @override
  Future<List<String>> getKeys() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getKeys().toList();
  }
}
