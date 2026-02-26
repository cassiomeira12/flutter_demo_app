import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

abstract class OnClickedNotificationCallback {
  Future<void> onClicked(Map<String, dynamic> map);
}

class OnClickedNotificationCallbackBase
    implements OnClickedNotificationCallback {
  @override
  Future<void> onClicked(Map<String, dynamic> map) async {
    final String? action = map['data']['action'];

    switch (action) {
      case 'test_push_notification':
        DialogWidget.show(
          Get.context!,
          title: 'Notificação recebida com sucesso!',
          message:
              'As configurações de notificações estão funcionando corretamente.',
        );
        return;
      case 'update-available':
        if (AppBinding.hasInstance<FeatureFlagLifecycleController>()) {
          AppBinding.find<FeatureFlagLifecycleController>().onAppForeground();
        }
        return;
      default:
    }
  }
}
