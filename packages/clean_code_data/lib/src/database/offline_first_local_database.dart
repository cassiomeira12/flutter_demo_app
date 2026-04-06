abstract class OfflineFirstLocalDatabase<T> {
  Future<void> init({required String databaseName});

  Future<int> add(T value);

  Future<void> addByKey(String key, T value);

  Future<T?> get(dynamic key);

  Future<void> update(dynamic key, T value);

  Future<void> delete(dynamic key);

  Future<void> deleteAll([Iterable<dynamic>? keys]);

  Future<void> removeOfflineData([Iterable<dynamic>? keys]);

  Future<void> removeOfflineDeletedData([Iterable<dynamic>? keys]);

  Future<Map<dynamic, T>> values();

  Future<Map<dynamic, T>> offlineValues();

  Future<List<String>> offlineDeletedValues();
}
