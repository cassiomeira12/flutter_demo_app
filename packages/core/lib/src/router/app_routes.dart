import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

abstract class AppRoutes {
  static Map<String, AppRouterPage> routes = {};

  static void addRoutes(List<AppRouterPage> list) {
    routes.addAll(
      list.asMap().map((_, route) {
        return MapEntry(route.name, route);
      }),
    );
  }

  static AppRouterPage? navigatorRoute() {
    return routes.values.toList().firstWhereOrNull((page) => page.navigator);
  }

  static AppRouterPage get currentRouterPage {
    final currentRoute = AppNavigator.currentRoute;
    return findByRoute(currentRoute)!;
  }

  static AppRouterPage? findByRoute(String route, {int? nestedId}) {
    final int? currentNestedId =
        nestedId ?? BaseController.navigatorIndex.value;

    if (currentNestedId == null) {
      return routes[route];
    }

    final String nestedRoute = AppNavigator.currentRoute;
    AppRouterPage? nestedRouter = routes[nestedRoute];
    if (nestedRouter != null) {
      if (nestedRouter.children.isEmpty) {
        final baseRouter = routes.values.toList().firstWhereOrNull(
          (page) => page.name == route,
        );
        return baseRouter;
      }
    }

    nestedRouter = routes.values.toList().firstWhereOrNull(
      (page) => page.nestedKey == currentNestedId,
    );
    if (nestedRouter != null) {
      final nestedPage = nestedRouter.children.firstWhereOrNull(
        (page) => page.name == route,
      );
      if (nestedPage != null) {
        final nestedRouterPage = nestedPage as AppRouterPage;
        return nestedRouterPage.copyWith(nestedKey: nestedId);
      }
    }

    return routes[route];
  }
}
