import 'package:core/core.dart';
import 'package:push_notifications/src/presentation/push_notifications/push_notifications.dart';

abstract class PushNotificationsModule {
  static List<AppRouterPage> routes = [
    AppRouterPage(
      name: AppRouter.pushNotifications.name,
      page: PushNotificationsPage.new,
      binding: PushNotificationsBindings(),
      children: [
        // ...NotificationsModule.routes,
      ],
    ),
  ];
}
