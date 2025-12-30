import 'package:core/core.dart';

class PushMessagingServiceFaker implements PushMessagingService {
  @override
  Future<void> init() async {
    Log.success('$runtimeType init', throwsCrashlytics: false);
  }

  @override
  Future<String?> getToken() async {
    Log.info('getToken');
    return null;
  }

  @override
  Future<void> openNotificationOnStartApp() async {
    Log.info('openNotificationOnStartApp');
  }

  @override
  Future<void> subscribeTopic(String topic) async {
    Log.info('subscribeTopic topic: $topic');
  }

  @override
  Future<void> unsubscribeTopic(String topic) async {
    Log.info('unsubscribeTopic topic: $topic');
  }
}
