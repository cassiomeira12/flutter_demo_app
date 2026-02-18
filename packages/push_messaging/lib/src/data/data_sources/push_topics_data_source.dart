abstract class PushTopicsDataSource {
  Future<void> subscribeTopic(List<String> topics);
  Future<void> unsubscribeTopic(List<String> topics);

  Future<void> subscribeUserTopic(String topic);
  Future<void> unsubscribeUserTopic(String topic);
}
