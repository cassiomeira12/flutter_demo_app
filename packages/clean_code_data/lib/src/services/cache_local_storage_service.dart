import 'package:clean_code_domain/clean_code_domain.dart';

class CacheLocalStorageServiceImpl implements CacheStorageService {
  final LocalStorageUseCase _usecase;

  CacheLocalStorageServiceImpl({
    required LocalStorageUseCase localStorageUseCase,
  }) : _usecase = localStorageUseCase;

  @override
  Future<String?> load(String key) {
    return _usecase.get<String>(key);
  }

  @override
  Future<void> save(String key, String data) {
    return _usecase.set<String>(key, data);
  }
}
