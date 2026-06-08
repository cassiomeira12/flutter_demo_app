import 'package:clean_code_domain/clean_code_domain.dart';

abstract class LocalStorageUseCase extends UseCase {
  Future<T?> get<T>(String key);

  Future<bool> set<T>(String key, T value);

  Future<bool> delete(String key);

  Future<void> clearAll();

  Future<List<String>> getKeys();
}

class LocalStorageUseCaseImpl implements LocalStorageUseCase {
  final LocalStorageService _service;

  LocalStorageUseCaseImpl({
    required LocalStorageService localStorageService,
  }) : _service = localStorageService;

  @override
  Future<void> clearAll() {
    return _service.clearAll();
  }

  @override
  Future<bool> delete(String key) {
    return _service.delete(key);
  }

  @override
  Future<T?> get<T>(String key) {
    return _service.get<T>(key);
  }

  @override
  Future<bool> set<T>(String key, T value) {
    return _service.set<T>(key, value);
  }

  @override
  Future<List<String>> getKeys() {
    return _service.getKeys();
  }
}
