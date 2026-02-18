import 'package:admin/src/presentation/presentation.dart';
import 'package:core/core.dart';

class AdminModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.admin.name,
      page: AdminPage.new,
      binding: AdminBindings(),
      middlewares: [AuthMiddleware()],
    ),
    AppRouterPage(
      name: AppRouter.users.name,
      page: UsersPage.new,
      binding: UsersBindings(),
    ),
    AppRouterPage(
      name: AppRouter.usersDetails.name,
      page: AdminUserDetailsPage.new,
      binding: AdminUserDetailsBindings(),
      // children: [...ChangePasswordModule.routes, ...DeleteAccountModule.routes],
    ),
    // ...PushNotificationsModule.routes,
    AppRouterPage(
      name: AppRouter.webVisitHistory.name,
      page: WebVisitHistoryPage.new,
      binding: WebVisitHistoryBindings(),
    ),
    AppRouterPage(
      name: AppRouter.adminCrud.name,
      page: AdminCrudPage.new,
      binding: AdminCrudBindings(),
    ),
  ];
}
