abstract class CacheStorageUseCase {
  Future<String?> load(String key);
  Future<void> save(String key, String data);
}
