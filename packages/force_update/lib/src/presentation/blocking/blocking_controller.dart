import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class BlockingController extends BaseController {
  final LocalStorageUseCase _localStorageUseCase;
  final AppInfoEntity _appInfoEntity;
  final CheckPermissionUseCase _checkPermissionUseCase;
  final PushMessagingService _pushMessagingService;

  BlockingController({
    required LocalStorageUseCase localStorageUseCase,
    required AppInfoEntity appInfoEntity,
    required CheckPermissionUseCase checkPermissionUseCase,
    required PushMessagingService pushMessagingService,
  }) : _localStorageUseCase = localStorageUseCase,
       _appInfoEntity = appInfoEntity,
       _checkPermissionUseCase = checkPermissionUseCase,
       _pushMessagingService = pushMessagingService;

  final RxBool pushSubscribed = RxBool(false);

  @override
  void onReady() {
    super.onReady();
    _subscribePushNotification();
  }

  Future<void> _subscribePushNotification() async {
    try {
      final permission = await _checkPermissionUseCase.call(
        Permission.notification,
      );
      if (!permission.isGranted) return;
    } catch (_) {
      return;
    }

    final bool? blockedApp = await _localStorageUseCase.get<bool>(BLOCKED_APP);
    if (blockedApp == null) {
      final String packageName = _appInfoEntity.packageName;
      final String versionName = _appInfoEntity.version;
      final String blockedAppTopic =
          '${packageName}_${RemoteFlagsEnum.blockingApp.name}';
      final String blockedAppVersionTopic =
          '${packageName}_${versionName}_${RemoteFlagsEnum.blockingApp.name}';
      try {
        await _pushMessagingService.subscribeTopic([
          blockedAppTopic,
          blockedAppVersionTopic,
        ]);
        await _localStorageUseCase.set<bool>(BLOCKED_APP, true);
        pushSubscribed.value = true;
      } catch (error, stackTrace) {
        Log.error(
          'BlockedApp subscribe topic',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }
}
