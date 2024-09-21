abstract class AppBaseRouter {
  Future<T?> toNamed<T>(
    String routeName, {
    int? id,
    bool preventDuplicates = true,
  });

  void back<T>({int? id});

  Future<T?> backAndToNamed<T>(
    String routeName, {
    int? id,
    bool preventDuplicates = true,
  });

  Future<T?> backAllAndToNamed<T>(
    String routeName, {
    int? id,
    bool preventDuplicates = true,
  });

  Future<T?> backUntil<T>();
}
