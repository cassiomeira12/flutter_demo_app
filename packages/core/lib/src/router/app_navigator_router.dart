import 'package:core/src/router/app_base_router.dart';
import 'package:core/src/router/get_router.dart';
import 'package:dependency/dependency.dart';

extension AppNavigatorRouter on AppBaseRouter {
  static final AppBaseRouter _router = GetRouter.instance;

  static Future<dynamic>? to(Widget Function() page, {int? id}) async {
    return _router.to(page, id: id);
  }

  static Future<dynamic>? toNamed(
    String routeName, {
    int? id,
    bool preventDuplicates = true,
    Map<String, dynamic>? arguments,
  }) {
    return _router.toNamed(
      routeName,
      id: id,
      preventDuplicates: preventDuplicates,
      arguments: arguments,
    );
  }

  static void back({int? id, dynamic result}) {
    return _router.back(id: id, result: result);
  }

  static Future<dynamic>? backAndToNamed(
    String routeName, {
    int? id,
    Map<String, dynamic>? arguments,
  }) {
    return _router.backAndToNamed(routeName, id: id, arguments: arguments);
  }

  static Future<dynamic>? backAllAndToNamed(
    String routeName, {
    int? id,
    Map<String, dynamic>? arguments,
  }) {
    return _router.backAllAndToNamed(routeName, id: id, arguments: arguments);
  }

  static Future<dynamic>? offNamedUntil(
    String routeName, {
    int? id,
    required String stopRoute,
  }) {
    return _router.offNamedUntil(routeName, id: id, stopRoute: stopRoute);
  }
}
