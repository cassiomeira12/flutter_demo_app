import 'package:clean_code_domain/clean_code_domain.dart';

abstract class LocalStorageUseCase extends UseCase {
  Future<T?> get<T>(String key);

  Future<bool> set<T>(String key, T value);

  Future<bool> delete(String key);

  Future<void> clearAll();

  Future<List<String>> getKeys();
}

class LocalStorageUseCaseImpl implements LocalStorageUseCase {
  final LocalStorageService _localStorageService;

  LocalStorageUseCaseImpl({required this._localStorageService});

  @override
  Future<T?> get<T>(String key) {
    return _localStorageService.get<T>(key);
  }

  @override
  Future<bool> set<T>(String key, T value) {
    return _localStorageService.set<T>(key, value);
  }

  @override
  Future<bool> delete(String key) {
    return _localStorageService.delete(key);
  }

  @override
  Future<void> clearAll() {
    return _localStorageService.clearAll();
  }

  @override
  Future<List<String>> getKeys() {
    return _localStorageService.getKeys();
  }
}
