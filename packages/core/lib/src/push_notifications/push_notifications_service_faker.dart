import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

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
    Map<String, dynamic>? payload,
    String? imageUrl,
    String? androidChannelId,
    String? androidPriority,
    String? androidVisibility,
    String? androidTag,
    bool? androidSticky,
  }) async {
    Log.success(
      '$runtimeType openNotificationOnStartApp',
      throwsCrashlytics: false,
    );
  }

  @override
  Future<PermissionStatus> requestPermission() async {
    return PermissionStatus.denied;
  }
}
