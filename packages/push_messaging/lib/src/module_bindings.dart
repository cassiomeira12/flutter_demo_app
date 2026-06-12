import 'package:core/core.dart';
import 'package:push_messaging/src/data/data.dart';
import 'package:push_messaging/src/domain/domain.dart';
import 'package:push_messaging/src/infra/infra.dart';

class PushMessagingModuleBindings implements ModuleBinding {
  @override
  Future<void> injectDependencies() async {
    AppBinding.lazyPut<PushTopicsDataSource>(
      () => PushTopicsDataSourceImpl(
        http: AppBinding.find(),
      ),
    );

    AppBinding.lazyPut<PushTopicsService>(
      () => PushTopicsServiceImpl(
        pushTopicsDataSource: AppBinding.find(),
      ),
    );

    AppBinding.putReplace<PushMessagingService>(
      FirebasePushMessaging(
        checkPermissionUseCase: AppBinding.find(),
        requestPermissionUseCase: AppBinding.find(),
        onClickedNotificationCallback: AppBinding.find(),
        onReceivedNotificationCallback: AppBinding.find(),
        pushTopicService: AppBinding.find(),
        vapidKeyMessagingWeb: const String.fromEnvironment(
          'vapidKeyMessagingWeb',
        ),
      ),
    );
  }
}
