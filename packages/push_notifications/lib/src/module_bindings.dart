import 'package:core/core.dart';
import 'package:push_notifications/src/data/data.dart';

class PushNotificationsModuleBindings implements ModuleBinding {
  @override
  void injectDependencies() {
    AppBinding.replace<PushNotificationsService>(
      LocalPushNotifications(
        appName: const String.fromEnvironment('app_name'),
        androidNotificationChannel: const String.fromEnvironment(
          'android_notification_channel',
        ),
        androidNotificationIcon: const String.fromEnvironment(
          'android_notification_icon',
        ),
      ),
    );
  }
}
