import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/use_cases/use_cases.dart';

class LocalStorageUseCase implements ILocalStorageUseCase {
  @override
  Future<T?> get<T>(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.get(key) as T?;
  }

  @override
  Future<bool> set<T>(String key, T value) async {
    final pref = await SharedPreferences.getInstance();

    switch (value.runtimeType) {
      case const (int):
        return await pref.setInt(key, value as int);
      case const (bool):
        return await pref.setBool(key, value as bool);
      case const (double):
        return await pref.setDouble(key, value as double);
      case const (String):
        return await pref.setString(key, value as String);
      case const (List<String>):
        return await pref.setStringList(key, value as List<String>);
      default:
        throw '${value.runtimeType} is not a Type acceptable';
    }
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
}
