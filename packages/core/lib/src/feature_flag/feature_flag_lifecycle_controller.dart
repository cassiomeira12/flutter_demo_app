import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class FeatureFlagLifecycleController extends LifecycleController {
  final AppInfoEntity _appInfoEntity;
  final DeviceInfoEntity _deviceInfo;
  final LocalStorageUseCase _localStorage;

  FeatureFlagLifecycleController({
    required this._appInfoEntity,
    required DeviceInfoEntity deviceInfoEntity,
    required LocalStorageUseCase localStorageUseCase,
  }) : _deviceInfo = deviceInfoEntity,
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
      _onUpdatedAppChanged,
      onDone: () {
        _updateAppSubscription?.pause();
      },
      onError: (Object error) {
        _updateAppSubscription?.cancel();
        Log.error(error, null, msg: 'UpdateAppSubscription');
      },
    );

    _updateAppRequiredSubscription = updateAppRequiredStream.listen(
      _onUpdatedRequiredChanged,
      onDone: () {
        _updateAppRequiredSubscription?.pause();
      },
      onError: (Object error) {
        _updateAppRequiredSubscription?.cancel();
        Log.error(error, null, msg: 'UpdateAppRequiredSubscription');
      },
    );

    _blockingAppSubscription = blockingAppStream.listen(
      _onBlockingAppChanged,
      onDone: () {
        _blockingAppSubscription?.pause();
      },
      onError: (Object error) {
        _blockingAppSubscription?.cancel();
        Log.error(error, null, msg: 'BlockingAppSubscription');
      },
    );
  }

  @override
  void onClose() {
    _updateAppSubscription?.cancel();
    _updateAppRequiredSubscription?.cancel();
    _blockingAppSubscription?.cancel();

    _updateAppStream.close();
    _updateAppRequiredStream.close();
    _blockingAppStream.close();
    super.onClose();
  }

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
      final deviceTraits = DeviceTraits(
        brand: _deviceInfo.brand,
        model: _deviceInfo.model,
        osVersion: _deviceInfo.osVersion,
        localeName: _deviceInfo.localeName,
        platform: _deviceInfo.platform,
        packageName: _appInfoEntity.packageName,
        version: _appInfoEntity.version,
        build: _appInfoEntity.build,
        isWeb: kIsWeb,
        environment: kReleaseMode
            ? 'release'
            : kProfileMode
            ? 'profile'
            : 'debug',
        deviceId: _deviceInfo.deviceId ?? 'unknown',
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
              break;
            case RemoteFlagsEnum.sentryConfig:
              CrashlyticsServiceManager.instance.updateInitSettings();
          }
        }
      });
    } catch (_) {}
  }

  Future<bool> _getFeatureFlagValue(RemoteFlagsEnum flag) async {
    final featureFlag = await FeatureFlagServiceManager.instance.getFlag(flag);
    if (featureFlag.isEnabled) {
      return featureFlag.value?.toString() == 'true';
    }
    return false;
  }

  Future<void> _onUpdatedAppChanged(bool updateApp) async {
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

  void _onUpdatedRequiredChanged(bool updateRequired) {
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

  void _onBlockingAppChanged(bool blockingApp) {
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
