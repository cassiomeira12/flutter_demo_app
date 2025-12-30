abstract class CacheStorageService {
  Future<String?> load(String key);
  Future<void> save(String key, String data);
}
