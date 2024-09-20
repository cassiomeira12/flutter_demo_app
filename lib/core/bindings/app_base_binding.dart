abstract class AppBaseBinding {
  T get<T>();

  T put<T>(
    T dependency, {
    bool permanent = false,
  });

  void lazyPut<T>(
    T Function() builder, {
    bool fenix = true,
  });

  Future<T> putAsync<T>(
    Future<T> Function() builder, {
    bool permanent = false,
  });

  Future<bool> delete<T>({bool force = false});

  Future<void> deleteAll({bool force = false});
}
