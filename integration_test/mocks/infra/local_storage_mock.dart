import 'package:clean_code_data/clean_code_data.dart';

class LocalStorageMock implements LocalStorage {
  final Map<String, dynamic> _storage = {};

  LocalStorageMock({
    Map<String, dynamic> storage = const {},
  }) {
    _storage.addAll(storage);
  }

  @override
  Future<void> clearAll() async {
    _storage.clear();
  }

  @override
  Future<bool> delete(String key) async {
    _storage.remove(key);
    return _storage[key] == null;
  }

  @override
  Future<T?> get<T>(String key) async {
    return _storage[key] as T?;
  }

  @override
  Future<List<String>> getKeys() async {
    return _storage.keys.toList();
  }

  @override
  Future<bool> set<T>(String key, T value) async {
    _storage[key] = value;
    return _storage[key] == value;
  }
}
