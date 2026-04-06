import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class FeatureFlagLifecycleController extends LifecycleController {
  final AppInfoEntity _appInfoEntity;
  final GetDeviceInfoUseCase _getDeviceInfoUseCase;
  final LocalStorageUseCase _localStorage;

  FeatureFlagLifecycleController({
    required AppInfoEntity appInfoEntity,
    required GetDeviceInfoUseCase getDeviceInfoUseCase,
    required LocalStorageUseCase localStorageUseCase,
  }) : _appInfoEntity = appInfoEntity,
       _getDeviceInfoUseCase = getDeviceInfoUseCase,
       _localStorage = localStorageUseCase;

  final _updateAppStream = StreamController<bool>.broadcast();
  final _updateAppRequiredStream = StreamController<bool>.broadcast();
  final _blockingAppStream = StreamController<bool>.broadcast();

  Stream<bool> get updateAppStream => _updateAppStream.stream;
  Stream<bool> get updateAppRequiredStream => _updateAppRequiredStream.stream;
  Stream<bool> get blockingAppStream => _blockingAppStream.stream;

  StreamSubscription<bool>? _updateAppSubscription;
  StreamSubscription<bool>? _updateAppRequiredSubscription;
  StreamSubscription<bool>? _blockingAppSubscription;

  @override
  void onInit() {
    super.onInit();
    _updateAppSubscription = updateAppStream.listen(
      _listenUpdateApp,
      onDone: () {
        _updateAppSubscription?.pause();
      },
      onError: (error, stackTrace) {
        _updateAppSubscription?.cancel();
        Log.error(error, stackTrace, msg: 'UpdateAppSubscription');
      },
    );

    _updateAppRequiredSubscription = updateAppRequiredStream.listen(
      _listenAppRequired,
      onDone: () {
        _updateAppRequiredSubscription?.pause();
      },
      onError: (error, stackTrace) {
        _updateAppRequiredSubscription?.cancel();
        Log.error(error, stackTrace, msg: 'UpdateAppRequiredSubscription');
      },
    );

    _blockingAppSubscription = blockingAppStream.listen(
      _listenBlockingApp,
      onDone: () {
        _blockingAppSubscription?.pause();
      },
      onError: (error, stackTrace) {
        _blockingAppSubscription?.cancel();
        Log.error(error, stackTrace, msg: 'BlockingAppSubscription');
      },
    );
  }

  @override
  void onReady() {}

  @override
  void onAppForeground() {
    updateFeatureFlags(reload: true);
  }

  @override
  void onAppTerminate() {
    _updateAppSubscription?.cancel();
    _updateAppRequiredSubscription?.cancel();
    _blockingAppSubscription?.cancel();

    _updateAppStream.close();
    _updateAppRequiredStream.close();
    _blockingAppStream.close();
  }

  Future<void> uploadDeviceTraits() async {
    try {
      final DeviceInfoEntity deviceInfo = await _getDeviceInfoUseCase.call();

      final deviceTraits = DeviceTraits(
        brand: deviceInfo.brand,
        model: deviceInfo.model,
        osVersion: deviceInfo.osVersion,
        localeName: deviceInfo.localeName,
        platform: deviceInfo.platform,
        packageName: _appInfoEntity.packageName,
        version: _appInfoEntity.versionOnly,
        build: _appInfoEntity.build,
        isWeb: kIsWeb,
        environment: kReleaseMode
            ? 'release'
            : kProfileMode
            ? 'profile'
            : 'debug',
        deviceId: deviceInfo.deviceId ?? 'unknown',
      );

      await FeatureFlagServiceManager.instance.setTraits(deviceTraits);
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
  }

  Future<void> updateFeatureFlags({bool reload = false}) async {
    if (reload) {
      try {
        await FeatureFlagServiceManager.instance.getFlag(
          RemoteFlagsEnum.values.first,
          reload: reload,
        );
      } catch (_) {}
    }

    try {
      await Future.wait(RemoteFlagsEnum.values.map(_getFeatureFlagValue)).then((
        results,
      ) {
        for (int i = 0; i < RemoteFlagsEnum.values.length; i++) {
          switch (RemoteFlagsEnum.values[i]) {
            case RemoteFlagsEnum.updateApp:
              if (!_updateAppStream.isClosed) {
                _updateAppStream.add(results[i]);
              }
            case RemoteFlagsEnum.updateAppRequired:
              if (!_updateAppRequiredStream.isClosed) {
                _updateAppRequiredStream.add(results[i]);
              }
            case RemoteFlagsEnum.blockingApp:
              if (!_blockingAppStream.isClosed) {
                _blockingAppStream.add(results[i]);
              }
            case RemoteFlagsEnum.downloadAppleStore:
            case RemoteFlagsEnum.downloadAndroidStore:
          }
        }
      });
    } catch (_) {}
  }

  Future<bool> _getFeatureFlagValue(RemoteFlagsEnum flag) async {
    final RemoteFlag? featureFlag = await FeatureFlagServiceManager.instance
        .getFlag(flag);
    if (featureFlag?.isEnabled ?? false) {
      return featureFlag?.value == 'true';
    }
    return false;
  }

  Future<void> _listenUpdateApp(bool updateApp) async {
    if (Platform.isWeb) return;

    if (updateApp) {
      if (AppNavigator.currentRoute != AppRouter.update.name) {
        final String? lastOpened = await _localStorage.get<String>(
          LAST_OPENED_UPDATE_PAGE,
        );
        final now = DateTime.timestamp();
        if (lastOpened == null ||
            now.difference(DateTime.parse(lastOpened)).inHours > 24) {
          AppNavigator.toNamed(AppRouter.update);
          _localStorage.set<String>(LAST_OPENED_UPDATE_PAGE, now.toString());
        }
      }
    } else {
      if (AppNavigator.currentRoute == AppRouter.update.name) {
        AppNavigator.back();
      }
    }
  }

  void _listenAppRequired(bool updateRequired) {
    if (Platform.isWeb) return;

    if (updateRequired) {
      if (AppNavigator.currentRoute != AppRouter.forceUpdate.name) {
        AppNavigator.backAllAndToNamed(AppRouter.forceUpdate);
      }
    } else {
      if (AppNavigator.currentRoute == AppRouter.forceUpdate.name) {
        AppNavigator.backAllAndToNamed(AppRouter.splash);
      }
    }
  }

  void _listenBlockingApp(bool blockingApp) {
    if (blockingApp) {
      if (AppNavigator.currentRoute != AppRouter.blocking.name) {
        AppNavigator.backAllAndToNamed(AppRouter.blocking);
      }
    } else {
      if (AppNavigator.currentRoute == AppRouter.blocking.name) {
        AppNavigator.backAllAndToNamed(AppRouter.splash);
      }
    }
  }
}
