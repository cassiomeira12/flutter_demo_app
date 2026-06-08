import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

abstract class SecureStorageUseCase extends UseCase {
  Future<T?> get<T>(String key);

  Future<bool> set<T>(String key, T value);

  Future<bool> delete(String key);

  Future<void> clearAll();
}

class SecureStorageUseCaseImpl implements SecureStorageUseCase {
  final SecureStorageService _service;

  SecureStorageUseCaseImpl({
    required SecureStorageService secureStorageService,
  }) : _service = secureStorageService;

  @override
  Future<T?> get<T>(String key) {
    return _service.get<T>(key);
  }

  @override
  Future<bool> set<T>(String key, T value) {
    return _service.set<T>(key, value);
  }

  @override
  Future<bool> delete(String key) {
    return _service.delete(key);
  }

  @override
  Future<void> clearAll() {
    return _service.clearAll();
  }
}
