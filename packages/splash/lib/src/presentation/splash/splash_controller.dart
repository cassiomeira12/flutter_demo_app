import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class SplashController extends BaseController {
  final GetUserLocalDataUseCase _getUserDataUseCase;
  final LocalStorageUseCase _localStorageUseCase;
  final SessionEntity _sessionEntity;
  final AppInfoEntity _appInfoEntity;
  final CheckPermissionUseCase _checkPermissionUseCase;
  final PushMessagingService _pushMessagingService;
  final PushNotificationsService _pushNotificationsService;
  final GetDeviceLocaleUseCase _getDeviceLocaleUseCase;
  final FirebaseInitializeService _firebaseInitializeService;
  final AppsFlyerService _appsFlyerService;
  final AppSecurityManager _appSecurityManager;
  final GetInstallationAppUseCase _getInstallationAppUseCase;
  final UploadInstallationAppUseCase _uploadInstallationAppUseCase;
  final FeatureFlagLifecycleController _featureFlagLifecycleController;

  SplashController({
    required this._getUserDataUseCase,
    required this._localStorageUseCase,
    required this._sessionEntity,
    required this._appInfoEntity,
    required this._checkPermissionUseCase,
    required this._pushMessagingService,
    required this._pushNotificationsService,
    required this._getDeviceLocaleUseCase,
    required this._firebaseInitializeService,
    required this._appsFlyerService,
    required this._appSecurityManager,
    required this._getInstallationAppUseCase,
    required this._uploadInstallationAppUseCase,
    required this._featureFlagLifecycleController,
  });

  @override
  void onInit() {
    super.onInit();
    BaseController.SPLASH_ALREADY_EXECUTED = true;
  }

  @override
  void onReady() {
    super.onReady();
    PerformanceMetricUseCase.call(
      name: 'splash-performance-tracking',
      builder: _initializeAppServices,
    );
  }

  Future<void> _initializeAppServices(TrackOperation splashTrack) async {
    await PerformanceMetricUseCase.call(
      name: 'splash-firebase-initialize-track',
      track: splashTrack,
      builder: (_) => _firebaseInitializeService.init(),
    );

    await PerformanceMetricUseCase.call(
      name: 'splash-feature-flag-initialize',
      track: splashTrack,
      builder: (_) => FeatureFlagServiceManager.instance.init(),
    );

    await PerformanceMetricUseCase.call(
      name: 'splash-crashlytics-initialize-track',
      track: splashTrack,
      builder: (_) => CrashlyticsServiceManager.instance.init(),
    );

    await PerformanceMetricUseCase.call(
      name: 'splash-services-initialize',
      track: splashTrack,
      builder: (track) {
        return Future.wait([
          PerformanceMetricUseCase.call(
            name: 'splash-services-app-security-manager-initialize',
            track: track,
            builder: (_) => _appSecurityManager.init(),
          ),
          PerformanceMetricUseCase.call(
            name: 'splash-services-appsflyer-initialize',
            track: track,
            builder: (_) => _appsFlyerService.init(),
          ),
          PerformanceMetricUseCase.call(
            name: 'splash-services-device-locale-initialize',
            track: track,
            builder: (_) =>
                _getDeviceLocaleUseCase.call().then(Get.updateLocale),
          ),
          PerformanceMetricUseCase.call(
            name: 'splash-services-analytics-initialize',
            track: track,
            builder: (_) => AnalyticsServiceManager.instance.init(),
          ),
        ]);
      },
    );

    if (!Platform.isWeb) {
      final bool introDone = await _checkIntroDone();
      if (!introDone) {
        return AppNavigator.backAllAndToNamed(AppRouter.intro);
      }
    }

    _initPushNotification();

    final UserEntity? user = await PerformanceMetricUseCase.call<UserEntity?>(
      name: 'splash-get-user-authenticated',
      track: splashTrack,
      builder: (_) => _getUserAuthenticated(),
    );

    setUserIdentifier(user?.id, property: user?.toMap());

    await PerformanceMetricUseCase.call(
      name: 'splash-check-updated-app',
      track: splashTrack,
      builder: (_) => _checkUpdatedApp(),
    );

    if (Platform.isWeb) {
      return AppNavigator.backAllAndToNamed(AppRouter.web);
    }

    if (user != null) {
      await _appSecurityManager.checkIfNeedBlockApp();
    }

    _openNextPage(userAuthenticated: user);
  }

  Future<void> _initPushNotification() async {
    if (Platform.isWeb || Platform.isMobile) {
      late PermissionStatus permission;

      try {
        permission = await _checkPermissionUseCase.call(
          Permission.notification,
        );
      } catch (error, stackTrace) {
        Log.error(error, stackTrace);
        permission = PermissionStatus.denied;
      }

      if (!permission.isGranted && Platform.isWeb) {
        permission = await _pushNotificationsService.requestPermission();
      }

      Log.info('Push Notification Permissions: [$permission]');

      if (permission.isGranted) {
        try {
          await _pushMessagingService.init();
          final String? token = await _pushMessagingService.getToken();
          Log.success(
            'Firebase Push Messaging TOKEN [$token]',
            throwsCrashlytics: false,
          );
        } catch (error, stackTrace) {
          Log.error(error, stackTrace);
        }

        try {
          await _pushNotificationsService.init();
        } catch (error, stackTrace) {
          Log.error(error, stackTrace);
        }
      }
    } else {
      Log.warning(
        'Push Notification not work on [${Platform.currentPlatform.name}]',
        throwsCrashlytics: false,
      );
    }

    await _updateUserInstallation();
    await _updateFeatureFlags();
  }

  Future<void> _checkUpdatedApp() async {
    final String versionName = _appInfoEntity.version;

    final String? currentVersionApp = await _localStorageUseCase.get<String>(
      CURRENT_APP_VERSION,
    );

    if (currentVersionApp == null) {
      await _localStorageUseCase.set<String>(CURRENT_APP_VERSION, versionName);
    } else if (versionName != currentVersionApp) {
      try {
        await _onUpdatedAppCallback(versionName);
      } catch (error, stackTrace) {
        Log.error(error, stackTrace);
      }
    }
  }

  Future<void> _openNextPage({required UserEntity? userAuthenticated}) async {
    if (userAuthenticated != null) {
      if (userAuthenticated.permissions.contains(UserPermissionsEnum.ADMIN)) {
        return AppNavigator.backAllAndToNamed(AppRouter.admin);
      }
      return AppNavigator.backAllAndToNamed(AppRouter.home);
    }

    return AppNavigator.backAllAndToNamed(AppRouter.login);
  }

  Future<UserEntity?> _getUserAuthenticated() async {
    try {
      if (_sessionEntity.isAuthenticated) {
        return await _getUserDataUseCase.call();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> _checkIntroDone() async {
    final bool? introDone = await _localStorageUseCase.get<bool>(INTRO_DONE);
    return introDone ?? false;
  }

  Future<void> _updateFeatureFlags() async {
    try {
      await _featureFlagLifecycleController.uploadDeviceTraits();
      await _featureFlagLifecycleController.updateFeatureFlags();

      final blockingAppFlag = await FeatureFlagServiceManager.instance
          .getFlag<bool>(RemoteFlagsEnum.blockingApp);
      final bool blockedApp =
          blockingAppFlag.isEnabled && blockingAppFlag.value == true;

      if (!blockedApp) {
        _unsubscribeBlockedTopic();
      }
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
  }

  Future<void> _unsubscribeBlockedTopic() async {
    final bool? blockedApp = await _localStorageUseCase.get<bool>(BLOCKED_APP);
    if (blockedApp ?? false) {
      final String packageName = _appInfoEntity.packageName;
      final String versionName = _appInfoEntity.version;
      final String blockedAppTopic =
          '${packageName}_${RemoteFlagsEnum.blockingApp.name}';
      final String blockedAppVersionTopic =
          '${packageName}_${versionName}_${RemoteFlagsEnum.blockingApp.name}';
      try {
        await _pushMessagingService.unsubscribeTopic([
          blockedAppTopic,
          blockedAppVersionTopic,
        ]);
        await _localStorageUseCase.delete(BLOCKED_APP);
      } catch (error, stackTrace) {
        Log.error(error, stackTrace);
      }
    }
  }

  Future<void> _updateUserInstallation({bool tryAgain = true}) async {
    try {
      final String? installation = await _localStorageUseCase.get<String>(
        APP_INSTALLATION,
      );
      if (installation == null) {
        final newInstallation = await _uploadInstallationAppUseCase.call();
        final data = jsonEncode(newInstallation.toMap());
        await _localStorageUseCase.set(APP_INSTALLATION, data);
      } else {
        final installationJson = jsonDecode(installation);
        final storageInstallation = InstallationModel.fromMap(installationJson);
        final currentInstallation = await _getInstallationAppUseCase.call();

        final sameInstallation = storageInstallation.equals(
          currentInstallation,
        );

        if (!sameInstallation) {
          final updated = await _uploadInstallationAppUseCase.call();
          final data = jsonEncode(updated.toMap());
          await _localStorageUseCase.set(APP_INSTALLATION, data);
        }
      }
    } catch (error, stackTrace) {
      if (stackTrace.toString().contains('InstallationModel.fromMap')) {
        await _localStorageUseCase.delete(APP_INSTALLATION);
        if (tryAgain) {
          return _updateUserInstallation(tryAgain: false);
        }
      }
      Log.error(error, stackTrace);
    }
  }

  Future<void> _onUpdatedAppCallback(String newVersion) async {
    await _localStorageUseCase.set<String>(CURRENT_APP_VERSION, newVersion);
    // execute something after app update
  }
}
