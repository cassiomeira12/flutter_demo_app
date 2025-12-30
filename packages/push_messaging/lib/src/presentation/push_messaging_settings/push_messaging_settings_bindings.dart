import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

import 'push_messaging_settings.dart';

class PushMessagingSettingsBindings extends Bindings {
  @override
  void dependencies() {
    AppBinding.put<TestPushNotificationUseCase>(
      TestPushNotificationUseCaseImpl(notificationService: AppBinding.find()),
    );

    AppBinding.put<PushMessagingSettingsController>(
      PushMessagingSettingsController(
        testPushNotificationUseCase: AppBinding.find(),
        checkPermissionUseCase: AppBinding.find(),
        requestPermissionUseCase: AppBinding.find(),
        appInfoEntity: AppBinding.find(),
        localStorageUseCase: AppBinding.find(),
        uploadInstallationUseCase: AppBinding.find(),
        messagingService: AppBinding.find(),
        pushNotificationsService: AppBinding.find(),
      ),
    );
  }
}
