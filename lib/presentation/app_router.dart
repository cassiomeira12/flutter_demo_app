import '../core/core.dart';

enum AppRouter {
  splash('/'),
  login('/login'),
  recoveryPassword('/recoveryPassword'),
  signup('/signup'),
  home('/home'),
  emergency('/emergency'),
  contacts('/contacts'),
  settings('/settings'),
  about('/about');

  const AppRouter(this._name);

  final String _name;

  String get name => _name;

  static Future<T?> toNamed<T>(
    AppRouter route, {
    int? id,
  }) async {
    return AppNavigatorRouter.toNamed(
      route.name,
      id: id,
    );
  }

  static Future<T?> backAndToNamed<T>(
    AppRouter route, {
    int? id,
  }) async {
    return AppNavigatorRouter.backAndToNamed(
      route.name,
      id: id,
    );
  }

  static Future<T?> backAllAndToNamed<T>(
    AppRouter route, {
    int? id,
  }) async {
    return AppNavigatorRouter.backAllAndToNamed(
      route.name,
      id: id,
    );
  }

  static void back<T>(
    AppRouter route, {
    int? id,
  }) async {
    return AppNavigatorRouter.back(id: id);
  }

  static Future<T?> backUntil<T>(
    AppRouter route, {
    int? id,
  }) async {
    return AppNavigatorRouter.backUntil();
  }
}
