import 'package:core/core.dart';

class PushNotificationsServiceFaker implements PushNotificationsService {
  @override
  Future<void> init() async {
    Log.success('$runtimeType init', throwsCrashlytics: false);
  }

  @override
  Future<void> openNotificationOnStartApp() async {
    Log.success(
      '$runtimeType openNotificationOnStartApp',
      throwsCrashlytics: false,
    );
  }

  @override
  Future<void> showNotification({
    required int id,
    required String? title,
    required String? body,
    dynamic payload,
    String? imageUrl,
  }) async {
    Log.success(
      '$runtimeType openNotificationOnStartApp',
      throwsCrashlytics: false,
    );
  }
}
