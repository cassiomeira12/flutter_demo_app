import 'package:core/core.dart';
import 'package:core/src/router/app_base_router.dart';
import 'package:core/src/router/get_router.dart';
import 'package:dependency/dependency.dart';

abstract class AppNavigator {
  static final AppBaseRouter _router = GetRouter.instance;

  static final Map<int, Routing> nestedRouting = {};

  static String get currentRoute {
    final nestedId = BaseController.navigatorIndex.value;
    final navigatorRoute = AppRoutes.navigatorRoute();
    final currentRouteFromGet = _router.currentRoute;
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
    final currentRouteFromGet = _router.currentRoute;
    if (navigatorRoute?.name == currentRouteFromGet) {
      final currentNestedRoute =
          nestedRouting[nestedId]?.current ?? Navigator.defaultRouteName;
      if (currentNestedRoute != Navigator.defaultRouteName) {
        return nestedRouting[nestedId]?.args;
      }
    }
    return _router.arguments ?? nestedRouting[nestedId]?.args;
  }

  static Future<dynamic>? to(Widget Function() page) {
    return _router.to(page);
  }

  static Future<dynamic>? toNamed(
    AppRouter appRouter, {
    Map<String, dynamic>? arguments,
  }) {
    final nestedId = BaseController.navigatorIndex.value;
    final nextRoute = AppRoutes.findByRoute(appRouter.name, nestedId: nestedId);
    final isNestedNavigation = nestedId == nextRoute?.nestedKey;
    return _router.toNamed(
      appRouter.name,
      id: isNestedNavigation ? nextRoute?.nestedKey : null,
      preventDuplicates: false,
      arguments: arguments,
    );
  }

  static Future<void> back({dynamic result}) async {
    final nestedId = BaseController.navigatorIndex.value;
    final currentRouteGet = _router.currentRoute;
    final navigatorRoute = AppRoutes.navigatorRoute();
    final isNestedNavigation = currentRouteGet == navigatorRoute?.name;
    return _router.back(
      result: result,
      id: isNestedNavigation ? nestedId : null,
    );
  }

  static Future<dynamic>? backAndToNamed(
    AppRouter appRouter, {
    Map<String, dynamic>? arguments,
  }) async {
    final nestedId = BaseController.navigatorIndex.value;
    final currentRouteGet = _router.currentRoute;
    final navigatorRoute = AppRoutes.navigatorRoute();
    final isNestedNavigation = currentRouteGet == navigatorRoute?.name;
    return _router.backAndToNamed(
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

  static Future<dynamic>? backAllAndToNamed(
    AppRouter appRouter, {
    Map<String, dynamic>? arguments,
  }) async {
    final nestedId = BaseController.navigatorIndex.value;
    final nextRoute = AppRoutes.findByRoute(appRouter.name, nestedId: nestedId);
    return _router.backAllAndToNamed(
      appRouter.name,
      id: nextRoute?.nestedKey,
      arguments: arguments,
    );
  }
}
