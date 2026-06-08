abstract class AppBaseBinding {
  bool hasInstance<T extends Object>({String? tag});

  T find<T extends Object>({String? tag});

  T put<T extends Object>(
    T dependency, {
    String? tag,
    bool permanent = false,
  });

  void create<T extends Object>(
    T Function() builder, {
    String? tag,
    bool permanent = false,
  });

  void lazyPut<T extends Object>(
    T Function() builder, {
    String? tag,
    bool fenix = true,
  });

  Future<T> putAsync<T extends Object>(
    Future<T> Function() builder, {
    String? tag,
    bool permanent = false,
  });

  Future<bool> delete<T extends Object>({String? tag, bool force = false});

  Future<void> replace<T extends Object>(T dependency, {String? tag});

  Future<void> deleteAll({bool force = false});

  void reset();

  void testMode(bool isTest);
}
