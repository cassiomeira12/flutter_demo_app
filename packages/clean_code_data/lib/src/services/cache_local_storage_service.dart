import 'package:clean_code_domain/clean_code_domain.dart';

class CacheLocalStorageServiceImpl implements CacheStorageService {
  final LocalStorageUseCase _localStorageUseCase;

  CacheLocalStorageServiceImpl({
    required LocalStorageUseCase localStorageUseCase,
  }) : _localStorageUseCase = localStorageUseCase;

  @override
  Future<String?> load(String key) {
    return _localStorageUseCase.get<String>(key);
  }

  @override
  Future<void> save(String key, String data) {
    return _localStorageUseCase.set<String>(key, data);
  }
}
