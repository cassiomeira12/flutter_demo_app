import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/use_cases/use_cases.dart';

class LocalStorageUseCase implements ILocalStorageUseCase {
  @override
  Future<void> clearAll() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  @override
  Future<bool> delete(String key) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.remove(key);
  }

  @override
  Future<dynamic> get(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.get(key);
  }

  @override
  Future<bool> set(String key, dynamic value) async {
    final pref = await SharedPreferences.getInstance();
    switch (value.runtimeType.toString()) {
      case 'bool':
        return await pref.setBool(key, value as bool);
      case 'double':
        return await pref.setDouble(key, value as double);
      case 'int':
        return await pref.setInt(key, value as int);
      case 'String':
        return await pref.setString(key, value as String);
      case 'List<String>':
        return await pref.setStringList(key, value as List<String>);
      default:
        throw Exception('type not accepted');
    }
  }
}
