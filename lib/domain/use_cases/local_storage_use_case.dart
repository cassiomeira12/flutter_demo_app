abstract class ILocalStorageUseCase {
  Future<T?> get<T>(String key);
  Future<bool> set<T>(String key, T value);
  Future<bool> delete(String key);
  Future<void> clearAll();
}
