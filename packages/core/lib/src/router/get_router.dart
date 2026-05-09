import 'package:core/src/router/app_base_router.dart';
import 'package:dependency/dependency.dart';

class GetRouter implements AppBaseRouter {
  GetRouter._();

  static final instance = GetRouter._();

  @override
  String get currentRoute => Get.currentRoute;

  @override
  dynamic get arguments => Get.arguments;

  @override
  Future? to(Widget Function() page, {int? id}) async {
    return await Get.to(page, id: id);
  }

  @override
  Future<dynamic>? toNamed(
    String routeName, {
    int? id,
    bool preventDuplicates = true,
    Map<String, dynamic>? arguments,
  }) async {
    return await Get.toNamed(
      routeName,
      id: id,
      preventDuplicates: preventDuplicates,
      arguments: arguments,
    );
  }

  @override
  void back({int? id, dynamic result}) {
    return Get.back(id: id, result: result);
  }

  @override
  Future<dynamic>? backAndToNamed(
    String routeName, {
    int? id,
    Map<String, dynamic>? arguments,
  }) async {
    return await Get.offAndToNamed(routeName, id: id, arguments: arguments);
  }

  @override
  Future<dynamic>? backAllAndToNamed(
    String routeName, {
    int? id,
    Map<String, dynamic>? arguments,
  }) async {
    return await Get.offAllNamed(routeName, id: id, arguments: arguments);
  }

  @override
  Future<dynamic>? offNamedUntil(
    String routeName, {
    int? id,
    required String stopRoute,
  }) async {
    return await Get.offNamedUntil(routeName, id: id, (route) {
      return [stopRoute, '/'].contains(route.settings.name);
    });
  }
}
