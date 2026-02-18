import 'package:dependency/dependency.dart';

abstract class PushNotificationsService {
  Future<void> init();

  Future<void> openNotificationOnStartApp();

  Future<void> showNotification({
    required int id,
    required String? title,
    required String? body,
    required Map<String, dynamic>? payload,
    required String? imageUrl,
    required String? androidChannelId,
    required String? androidPriority,
    required String? androidVisibility,
    required String? androidTag,
    required bool? androidSticky,
  });

  Future<PermissionStatus> requestPermission();
}
