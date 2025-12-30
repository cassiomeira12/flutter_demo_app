import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'notifications.dart';

class NotificationsBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<ListUserNotificationsUseCase>(
      ListUserNotificationsUseCaseImpl(notificationService: AppBinding.find()),
    );

    AppBinding.put<ReadNotificationUseCase>(
      ReadNotificationUseCaseImpl(notificationService: AppBinding.find()),
    );

    AppBinding.put<NotificationsController>(
      NotificationsController(
        listUserNotifications: AppBinding.find(),
        readNotificationUseCase: AppBinding.find(),
      ),
    );
  }
}
