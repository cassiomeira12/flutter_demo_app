import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'admin.dart';
import 'widgets/drawer_admin_widget.dart';

class AdminPage extends AppView<AdminController> {
  const AdminPage({super.key});

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
              color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSizeHelper.width(10),
                vertical: ResponsiveSizeHelper.height(10),
              ),
              child: NavigatorRouterWidget(
                initialIndex: 0,
                pages: [
                  // ...UsersModule.routes,
                  // ...PushNotificationsModule.routes,
                  // ...WebVisitHistoryModule.routes,
                  // ...SettingsModule.routes,
                ],
                selectedIndex: controller.selectedIndex,
                changeTab: controller.changeTab,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
