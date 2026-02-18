import 'package:core/core.dart';
import 'package:notifications/src/presentation/notifications/notifications.dart';

class NotificationsModuleRoutes implements ModuleRoutes {
  @override
  List<AppRouterPage> get pages => [
    AppRouterPage(
      name: AppRouter.notifications.name,
      page: NotificationsPage.new,
      binding: NotificationsBindings(),
      // children: [...NotificationsSettingsModule.routes],
    ),
    // AppRouterPage(
    //   name: AppRouter.pushNotifications.name,
    //   page: PushNotificationsPage.new,
    //   binding: PushNotificationsBindings(),
    //   children: [...NotificationsModule.routes],
    // ),
  ];
}
