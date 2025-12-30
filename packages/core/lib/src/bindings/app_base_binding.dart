abstract class AppBaseBinding {
  bool hasInstance<T>({String? tag});

  T find<T>({String? tag});

  T put<T>(
    T dependency, {
    String? tag,
    bool permanent = false,
  });

  void create<T>(
    T Function() builder, {
    String? tag,
    bool permanent = false,
  });

  void lazyPut<T>(
    T Function() builder, {
    String? tag,
    bool fenix = true,
  });

  Future<T> putAsync<T>(
    Future<T> Function() builder, {
    String? tag,
    bool permanent = false,
  });

  Future<bool> delete<T>({String? tag, bool force = false});

  Future<void> replace<T>(T dependency, {String? tag});

  Future<void> deleteAll({bool force = false});
}
