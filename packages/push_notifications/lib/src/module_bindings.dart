import 'package:core/core.dart';
import 'package:push_notifications/src/data/data.dart';

class PushNotificationsModuleBindings implements ModuleBinding {
  @override
  Future<void> injectDependencies() async {
    await AppBinding.replace<OnReceivedNotificationCallback>(
      LocalPushOnReceivedNotificationCallback(),
    );

    if (Platform.isWeb) {
      return await AppBinding.replace<PushNotificationsService>(
        WebPushNotification(
          requestPermissionUseCase: AppBinding.find(),
        ),
      );
    }

    await AppBinding.replace<PushNotificationsService>(
      LocalPushNotifications(
        appName: const String.fromEnvironment('app_name'),
        androidNotificationChannel: const String.fromEnvironment(
          'android_notification_channel',
        ),
        androidNotificationIcon: const String.fromEnvironment(
          'android_notification_icon',
        ),
        requestPermissionUseCase: AppBinding.find(),
        onClickedNotificationCallback: AppBinding.find(),
      ),
    );
  }
}
