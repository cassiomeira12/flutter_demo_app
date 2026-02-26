import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:home/src/presentation/presentation.dart';

class HomePage extends AppView<HomeController> {
  const HomePage({super.key});

  static int initialIndex = 0;
  static List<NavigatorItem> navigatorItems = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: Platform.isWeb ? 'Home' : null,
      hideAppBar: !Platform.isWeb,
      controller: Platform.isWeb ? controller : null,
      body: NavigatorRouterWidget(
        initialIndex: HomePage.initialIndex,
        pages: navigatorItems.asMap().entries.map((entry) {
          return _findRouterPage(entry.key, entry.value);
        }).toList(),
        selectedIndex: controller.selectedIndex,
        changeTab: controller.changeTab,
        bottomItems: navigatorItems.map((item) => item.bottomItem!).toList(),
      ),
    );
  }

  AppRouterPage _findRouterPage(int index, NavigatorItem navigatorItem) {
    final router = AppRoutes.findByRoute(navigatorItem.routeName);
    if (router == null) {
      return AppRoutes.routes.values.first;
    }
    AppRoutes.routes.removeWhere((key, _) {
      return key.contains('nestedKey=$index');
    });
    final nestedRouteName = '${router.name}?nestedKey=$index';
    final routeUpdated = router.copyWith(
      nestedKey: index,
      name: nestedRouteName,
      arguments: navigatorItem.arguments,
    );
    return AppRoutes.routes[nestedRouteName] = routeUpdated;
  }
}
