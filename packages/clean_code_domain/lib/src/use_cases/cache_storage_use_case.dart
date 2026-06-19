import 'package:clean_code_domain/clean_code_domain.dart';

abstract class CacheStorageUseCase extends UseCase {
  Future<String?> load(String key);
  Future<void> save(String key, String data);
}

class CacheStorageUseCaseImpl implements CacheStorageUseCase {
  final CacheStorageService _cacheStorageService;

  CacheStorageUseCaseImpl({required this._cacheStorageService});

  @override
  Future<String?> load(String key) {
    return _cacheStorageService.load(key);
  }

  @override
  Future<void> save(String key, String data) {
    return _cacheStorageService.save(key, data);
  }
}
