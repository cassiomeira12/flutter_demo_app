import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_infra/clean_code_infra.dart';
import 'package:dependency/dependency.dart';

class HiveLocalStorage with DatabaseParserMixin implements LocalStorage {
  final String _databaseName = 'local_storage';
  final LocalDatabase<String> _database = HiveLocalDatabase<String>();

  @override
  Future<T?> get<T>(String key) async {
    await _database.init(databaseName: _databaseName);
    final String? value = await _database.get(key);
    if (value == null) return null;
    return decodeValue<T>(value);
  }

  @override
  Future<List<String>> getKeys() async {
    await _database.init(databaseName: _databaseName);
    final values = await _database.values();
    return values.keys.map((key) => key.toString()).toList();
  }

  @override
  Future<bool> set<T>(String key, T value) async {
    await _database.init(databaseName: _databaseName);
    await _database.update(key, encodeValue<T>(value));
    return await _database.get(key) != null;
  }

  @override
  Future<bool> delete(String key) async {
    await _database.init(databaseName: _databaseName);
    await _database.delete(key);
    return await _database.get(key) == null;
  }

  @override
  Future<void> clearAll() async {
    await _database.init(databaseName: _databaseName);
    await _database.deleteAll();
  }
}
