abstract class LocalDatabase<T> {
  Future<void> init({required String databaseName});

  Future<void> close();

  Future<int> add(T value);

  Future<void> addByKey(String key, T value);

  Future<T?> get(dynamic key);

  Future<void> update(dynamic key, T value);

  Future<void> delete(dynamic key);

  Future<void> deleteAll([Iterable<dynamic>? keys]);

  Future<Map<dynamic, T>> values();
}
