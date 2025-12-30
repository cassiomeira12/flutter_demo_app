import 'package:core/core.dart';
import 'package:push_messaging/src/data/data.dart';

class PushMessagingModuleBindings implements ModuleBinding {
  @override
  void injectDependencies() {
    AppBinding.replace<PushMessagingService>(
      FirebasePushMessaging(
        onClickedNotificationCallback: null,
        onReceivedNotificationCallback: null,
      ),
    );
  }
}
