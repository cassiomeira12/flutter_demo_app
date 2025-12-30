import 'package:clean_code_domain/clean_code_domain.dart';

class CacheStorageUseCaseImpl implements CacheStorageUseCase {
  final CacheStorageService _cacheStorageService;

  CacheStorageUseCaseImpl({required CacheStorageService cacheStorageService})
    : _cacheStorageService = cacheStorageService;

  @override
  Future<String?> load(String key) {
    return _cacheStorageService.load(key);
  }

  @override
  Future<void> save(String key, String data) {
    return _cacheStorageService.save(key, data);
  }
}
