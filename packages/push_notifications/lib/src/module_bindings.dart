import 'package:core/core.dart';
import 'package:push_notifications/src/data/data.dart';

class PushNotificationsModuleBindings implements ModuleBinding {
  @override
  Future<void> injectDependencies() async {
    AppBinding.putReplace<OnReceivedNotificationCallback>(
      LocalPushOnReceivedNotificationCallback(),
    );

    if (Platform.isWeb) {
      return AppBinding.putReplace<PushNotificationsService>(
        WebPushNotification(
          requestPermissionUseCase: AppBinding.find(),
        ),
      );
    }

    AppBinding.putReplace<PushNotificationsService>(
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
