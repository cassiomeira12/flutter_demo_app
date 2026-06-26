import 'package:core/core.dart';

class PushMessagingServiceFaker implements PushMessagingService {
  @override
  Future<void> init() async {
    Log.success('$runtimeType init', throwsCrashlytics: false);
  }

  @override
  Future<String?> getToken() async {
    Log.info('getToken null');
    return null;
  }

  @override
  Future<void> deleteToken() async {
    Log.info('deleteToken');
  }

  @override
  String getTokenType() => 'FAKER';

  @override
  Future<void> openNotificationOnStartApp() async {
    Log.info('openNotificationOnStartApp');
  }

  @override
  Future<void> subscribeTopic(List<String> topics) async {
    Log.info('subscribeTopic topics: $topics');
  }

  @override
  Future<void> unsubscribeTopic(List<String> topics) async {
    Log.info('unsubscribeTopic topics: $topics');
  }

  @override
  Future<void> subscribeUserTopic(String topic) async {
    Log.info('subscribeUserTopic topic: $topic');
  }

  @override
  Future<void> unsubscribeUserTopic(String topic) async {
    Log.info('unsubscribeUserTopic topic: $topic');
  }
}
