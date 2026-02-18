import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class FeatureFlagLifecycleController extends LifecycleController {
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
    _updateAppSubscription = updateAppStream.listen((bool updateApp) {
      if (!updateApp) {
        if (AppNavigator.currentRoute == AppRouter.update.name) {
          AppNavigator.back();
        }
      }
    });
    _updateAppRequiredSubscription = updateAppRequiredStream.listen((
      bool updateRequired,
    ) {
      if (updateRequired) {
        if (!Platform.isWeb &&
            AppNavigator.currentRoute != AppRouter.forceUpdate.name) {
          AppNavigator.backAllAndToNamed(AppRouter.forceUpdate);
        }
      } else {
        if (AppNavigator.currentRoute == AppRouter.forceUpdate.name) {
          AppNavigator.backAllAndToNamed(AppRouter.splash);
        }
      }
    });
    _blockingAppSubscription = blockingAppStream.listen((bool blockingApp) {
      if (blockingApp) {
        if (AppNavigator.currentRoute != AppRouter.blocking.name) {
          AppNavigator.backAllAndToNamed(AppRouter.blocking);
        }
      } else {
        if (AppNavigator.currentRoute == AppRouter.blocking.name) {
          AppNavigator.backAllAndToNamed(AppRouter.splash);
        }
      }
    });
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
}
