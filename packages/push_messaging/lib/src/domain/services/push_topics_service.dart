abstract class PushTopicsService {
  Future<void> subscribeTopic(List<String> topics);
  Future<void> unsubscribeTopic(List<String> topic);

  Future<void> subscribeUserTopic(String topic);
  Future<void> unsubscribeUserTopic(String topic);
}
