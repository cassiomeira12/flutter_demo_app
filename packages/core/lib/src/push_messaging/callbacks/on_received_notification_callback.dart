import 'package:core/core.dart';

abstract class OnReceivedNotificationCallback {
  Future<void> onReceived(Map<String, dynamic> map);
}

class OnReceivedNotificationCallbackFaker
    implements OnReceivedNotificationCallback {
  @override
  Future<void> onReceived(Map<String, dynamic> map) async {
    Log.info('$runtimeType \n $map');
  }
}
