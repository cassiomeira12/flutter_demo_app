import 'app_base_router.dart';
import 'get_router.dart';

extension AppNavigatorRouter on AppBaseRouter {
  static final AppBaseRouter _router = GetRouter.instance;

  static Future<T?> toNamed<T>(
    String routeName, {
    int? id,
    bool preventDuplicates = true,
  }) {
    return _router.toNamed(
      routeName,
      id: id,
      preventDuplicates: preventDuplicates,
    );
  }

  static Future<T?> backAndToNamed<T>(
    String routeName, {
    int? id,
    bool preventDuplicates = true,
  }) {
    return _router.backAndToNamed(
      routeName,
      id: id,
      preventDuplicates: preventDuplicates,
    );
  }

  static Future<T?> backAllAndToNamed<T>(
    String routeName, {
    int? id,
    bool preventDuplicates = true,
  }) {
    return _router.backAllAndToNamed(
      routeName,
      id: id,
      preventDuplicates: preventDuplicates,
    );
  }

  static void back<T>({int? id}) {
    return _router.back(id: id);
  }

  static Future<T?> backUntil<T>() {
    return _router.backUntil();
  }
}
