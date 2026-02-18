abstract class PushMessagingService {
  Future<void> init();

  Future<String?> getToken();

  Future<void> deleteToken();

  String getTokenType();

  Future<void> openNotificationOnStartApp();

  Future<void> subscribeTopic(List<String> topics);
  Future<void> unsubscribeTopic(List<String> topics);

  Future<void> subscribeUserTopic(String topic);
  Future<void> unsubscribeUserTopic(String topic);
}
