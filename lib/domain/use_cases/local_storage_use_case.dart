abstract class ILocalStorageUseCase {
  Future<dynamic> get(String key);
  Future<bool> set(String key, dynamic value);
  Future<bool> delete(String key);
  Future<void> clearAll();
}
