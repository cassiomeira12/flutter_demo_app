import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';

class LocalStorageServiceImpl implements LocalStorageService {
  final LocalStorage _localStorage;

  LocalStorageServiceImpl({required this._localStorage});

  @override
  Future<T?> get<T>(String key) {
    return _localStorage.get<T>(key);
  }

  @override
  Future<bool> set<T>(String key, T value) {
    return _localStorage.set<T>(key, value);
  }

  @override
  Future<bool> delete(String key) {
    return _localStorage.delete(key);
  }

  @override
  Future<void> clearAll() {
    return _localStorage.clearAll();
  }

  @override
  Future<List<String>> getKeys() {
    return _localStorage.getKeys();
  }
}
