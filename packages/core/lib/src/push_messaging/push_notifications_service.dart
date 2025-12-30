abstract class PushMessagingService {
  Future<void> init();

  Future<String?> getToken();

  Future<void> openNotificationOnStartApp();

  Future<void> subscribeTopic(String topic);

  Future<void> unsubscribeTopic(String topic);
}
