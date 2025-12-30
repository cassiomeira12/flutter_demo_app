abstract class PushNotificationsService {
  Future<void> init();

  Future<void> openNotificationOnStartApp();

  Future<void> showNotification({
    required int id,
    required String? title,
    required String? body,
    dynamic payload,
    String? imageUrl,
  });
}
