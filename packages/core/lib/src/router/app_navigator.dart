import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

abstract class AppNavigator {
  static Map<int, Routing> nestedRouting = {};

  static String get currentRoute {
    final nestedId = BaseController.navigatorIndex.value;
    final navigatorRoute = AppRoutes.navigatorRoute();
    final currentRouteFromGet = Get.currentRoute;
    if (navigatorRoute?.name == currentRouteFromGet) {
      final currentNestedRoute =
          nestedRouting[nestedId]?.current ?? Navigator.defaultRouteName;
      if (currentNestedRoute != Navigator.defaultRouteName) {
        return currentNestedRoute;
      }
    }
    return currentRouteFromGet;
  }

  static dynamic get arguments {
    final nestedId = BaseController.navigatorIndex.value;
    final navigatorRoute = AppRoutes.navigatorRoute();
    final currentRouteFromGet = Get.currentRoute;
    if (navigatorRoute?.name == currentRouteFromGet) {
      final currentNestedRoute =
          nestedRouting[nestedId]?.current ?? Navigator.defaultRouteName;
      if (currentNestedRoute != Navigator.defaultRouteName) {
        return nestedRouting[nestedId]?.args;
      }
    }
    return Get.arguments ?? nestedRouting[nestedId]?.args;
  }

  static Future<dynamic>? to(Widget Function() page) {
    return Get.to(page);
  }

  static Future<dynamic>? toNamed(
    AppRouter appRouter, {
    Map<String, dynamic>? arguments,
  }) {
    final nestedId = BaseController.navigatorIndex.value;
    final nextRoute = AppRoutes.findByRoute(appRouter.name, nestedId: nestedId);
    final isNestedNavigation = nestedId == nextRoute?.nestedKey;
    return Get.toNamed(
      appRouter.name,
      id: isNestedNavigation ? nextRoute?.nestedKey : null,
      preventDuplicates: false,
      arguments: arguments,
    );
  }

  static Future<void> back({dynamic result}) async {
    final nestedId = BaseController.navigatorIndex.value;
    final currentRouteGet = Get.currentRoute;
    final navigatorRoute = AppRoutes.navigatorRoute();
    final isNestedNavigation = currentRouteGet == navigatorRoute?.name;
    Get.back(result: result, id: isNestedNavigation ? nestedId : null);
    await Future.delayed(const Duration(milliseconds: 100));
  }

  static Future<dynamic>? backAndToNamed<T>(
    AppRouter appRouter, {
    Map<String, dynamic>? arguments,
  }) async {
    final nestedId = BaseController.navigatorIndex.value;
    final currentRouteGet = Get.currentRoute;
    final navigatorRoute = AppRoutes.navigatorRoute();
    final isNestedNavigation = currentRouteGet == navigatorRoute?.name;
    Get.offAndToNamed(
      appRouter.name,
      id: isNestedNavigation ? nestedId : null,
      arguments: arguments,
    );
  }

  static String _removeParams(String input) {
    return input.replaceAll(RegExp(r'\?.*'), '');
  }

  static Future<dynamic>? backUntil(AppRouter appRouter) async {
    while (![appRouter.name].contains(_removeParams(currentRoute))) {
      await back();
    }
  }

  static Future<dynamic>? backAllAndToNamed<T>(
    AppRouter appRouter, {
    Map<String, dynamic>? arguments,
  }) async {
    final nestedId = BaseController.navigatorIndex.value;
    final nextRoute = AppRoutes.findByRoute(appRouter.name, nestedId: nestedId);
    return Get.offAllNamed(
      appRouter.name,
      id: nextRoute?.nestedKey,
      arguments: arguments,
    );
  }
}
