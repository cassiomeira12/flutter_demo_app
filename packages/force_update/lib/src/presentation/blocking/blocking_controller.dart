import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class BlockingController extends LifecycleController {
  final LocalStorageUseCase _localStorageUseCase;
  final AppInfoEntity _appInfoEntity;
  final CheckPermissionUseCase _checkPermissionUseCase;
  final PushMessagingService _pushMessagingService;
  final FeatureFlagService _featureFlagService;
  final AppSecurityManager _appSecurityManager;

  BlockingController({
    required LocalStorageUseCase localStorageUseCase,
    required AppInfoEntity appInfoEntity,
    required CheckPermissionUseCase checkPermissionUseCase,
    required PushMessagingService pushMessagingService,
    required FeatureFlagService featureFlagService,
    required AppSecurityManager appSecurityManager,
  }) : _localStorageUseCase = localStorageUseCase,
       _appInfoEntity = appInfoEntity,
       _checkPermissionUseCase = checkPermissionUseCase,
       _pushMessagingService = pushMessagingService,
       _featureFlagService = featureFlagService,
       _appSecurityManager = appSecurityManager;

  final RxBool pushSubscribed = RxBool(false);

  @override
  void onReady() {
    super.onReady();
    _subscribePushNotification();
  }

  @override
  void onAppResumed() {
    _checkToUnlockApp();
  }

  Future<void> _checkToUnlockApp() async {
    try {
      final List<bool> results = await Future.wait([
        _checkIfAppIsBlocked(),
        _checkNeedUpdateApp(),
        _checkNeedUpdateRequiredApp(),
      ]);

      final bool isBlocked = results[0];
      final bool needUpdateApp = results[1];
      final bool needUpdateRequiredApp = results[2];

      if (isBlocked == false) {
        AppNavigator.back();

        if (needUpdateRequiredApp) {
          AppNavigator.backAllAndToNamed(AppRouter.update);
          return;
        }

        if (needUpdateApp) {
          AppNavigator.toNamed(AppRouter.update);
          return;
        }

        await _appSecurityManager.checkIfNeedBlockApp();
      }
    } catch (_) {}
  }

  Future<bool> _checkIfAppIsBlocked() async {
    final RemoteFlag? blockingAppFlag = await _featureFlagService.getFlag(
      RemoteFlagsEnum.blockingApp,
      reload: true,
    );
    if (blockingAppFlag?.isEnabled ?? false) {
      return blockingAppFlag?.value == 'true';
    }
    return false;
  }

  Future<bool> _checkNeedUpdateApp() async {
    final RemoteFlag? updateAppFlag = await _featureFlagService.getFlag(
      RemoteFlagsEnum.updateApp,
      reload: true,
    );
    if (updateAppFlag?.isEnabled ?? false) {
      return updateAppFlag?.value == 'true';
    }
    return false;
  }

  Future<bool> _checkNeedUpdateRequiredApp() async {
    final RemoteFlag? updateAppFlag = await _featureFlagService.getFlag(
      RemoteFlagsEnum.updateAppRequired,
      reload: true,
    );
    if (updateAppFlag?.isEnabled ?? false) {
      return updateAppFlag?.value == 'true';
    }
    return false;
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
      final String blockedAppTopic =
          '${packageName}_${RemoteFlagsEnum.blockingApp.name}';
      await _pushMessagingService.subscribeTopic(blockedAppTopic);
      await _localStorageUseCase.set<bool>(BLOCKED_APP, true);
      pushSubscribed.value = true;
    }
  }
}
