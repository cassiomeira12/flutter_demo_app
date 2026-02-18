import 'package:admin/src/presentation/admin/widgets/widgets.dart';
import 'package:admin/src/presentation/presentation.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class AdminPage extends AppView<AdminController> {
  const AdminPage({super.key});

  static List<NavigatorItem> navigatorItems = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (MediaQuery.of(context).size.width > 750) const DrawerAdminWidget(),
        Expanded(
          child: ScaffoldWidget(
            controller: controller,
            drawer: MediaQuery.of(context).size.width > 750
                ? null
                : const DrawerAdminWidget(),
            title: 'Admin',
            showNotificationsIcon: true,
            body: Container(
              color: Theme.of(
                context,
              ).bottomNavigationBarTheme.backgroundColor,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSizeHelper.width(10),
                vertical: ResponsiveSizeHelper.height(10),
              ),
              child: SafeArea(
                child: NavigatorRouterWidget(
                  initialIndex: 0,
                  pages:
                      [
                        NavigatorItem(routeName: AppRouter.users.name),
                        NavigatorItem(
                          routeName: AppRouter.webVisitHistory.name,
                        ),
                        NavigatorItem(routeName: AppRouter.settings.name),
                      ].asMap().entries.map((entry) {
                        return _findRouterPage(entry.key, entry.value);
                      }).toList(),
                  selectedIndex: controller.selectedIndex,
                  changeTab: controller.changeTab,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  AppRouterPage _findRouterPage(int index, NavigatorItem navigatorItem) {
    final router = AppRoutes.findByRoute(navigatorItem.routeName);
    if (router == null) {
      return AppRoutes.routes.values.first;
    }
    final nestedRouteName = '${router.name}?nestedKey=$index';
    final routeUpdated = router.copyWith(
      nestedKey: index,
      name: nestedRouteName,
      arguments: navigatorItem.arguments,
    );
    return AppRoutes.routes[nestedRouteName] = routeUpdated;
  }
}
