import 'package:core/core.dart';

import 'users.dart';

abstract class UsersModule {
  static List<AppRouterPage> routes = [
    AppRouterPage(
      name: AppRouter.users.name,
      page: () => const UsersPage(),
      binding: UsersBindings(),
      children: [
        // ...NotificationsModule.routes,
        // ...AdminUserDetailsModule.routes,
        // ...PushNotificationsModule.routes,
      ],
    ),
  ];
}
