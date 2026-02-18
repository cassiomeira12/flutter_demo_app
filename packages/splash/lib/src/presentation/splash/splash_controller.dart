import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class SplashController extends BaseController {
  final GetUserDataUseCase _getUserDataUseCase;
  final LocalStorageUseCase _localStorageUseCase;
  final UserAuthStorageUseCase _authStorageUseCase;
  final GetDeviceInfoUseCase _getDeviceInfoUseCase;
  final GetAppInfoUseCase _getAppInfoUseCase;
  final CheckPermissionUseCase _checkPermissionUseCase;
  final PushMessagingService _pushMessagingService;
  final PushNotificationsService _pushNotificationsService;
  final GetDeviceLocaleUseCase _getDeviceLocaleUseCase;
  final FirebaseInitializeService _firebaseInitializeService;
  final AppsFlyerService _appsFlyerService;
  final ThemeController _themeController;
  final AppSecurityManager _appSecurityManager;
  final GetInstallationAppUseCase _getInstallationAppUseCase;
  final UploadInstallationAppUseCase _uploadInstallationAppUseCase;
  final FeatureFlagLifecycleController _featureFlagLifecycleController;

  SplashController({
    required GetUserDataUseCase getUserDataUseCase,
    required LocalStorageUseCase localStorageUseCase,
    required UserAuthStorageUseCase authStorageUseCase,
    required GetDeviceInfoUseCase getDeviceInfoUseCase,
    required GetAppInfoUseCase getAppInfoUseCase,
    required CheckPermissionUseCase checkPermissionUseCase,
    required PushMessagingService pushMessagingService,
    required PushNotificationsService pushNotificationsService,
    required GetDeviceLocaleUseCase getDeviceLocaleUseCase,
    required FirebaseInitializeService firebaseInitializeService,
    required AppsFlyerService appsFlyerService,
    required ThemeController themeController,
    required AppSecurityManager appSecurityManager,
    required GetInstallationAppUseCase getInstallationAppUseCase,
    required UploadInstallationAppUseCase uploadInstallationAppUseCase,
    required FeatureFlagLifecycleController featureFlagLifecycleController,
  }) : _getUserDataUseCase = getUserDataUseCase,
       _localStorageUseCase = localStorageUseCase,
       _authStorageUseCase = authStorageUseCase,
       _getDeviceInfoUseCase = getDeviceInfoUseCase,
       _getAppInfoUseCase = getAppInfoUseCase,
       _checkPermissionUseCase = checkPermissionUseCase,
       _pushMessagingService = pushMessagingService,
       _pushNotificationsService = pushNotificationsService,
       _getDeviceLocaleUseCase = getDeviceLocaleUseCase,
       _firebaseInitializeService = firebaseInitializeService,
       _appsFlyerService = appsFlyerService,
       _themeController = themeController,
       _appSecurityManager = appSecurityManager,
       _getInstallationAppUseCase = getInstallationAppUseCase,
       _uploadInstallationAppUseCase = uploadInstallationAppUseCase,
       _featureFlagLifecycleController = featureFlagLifecycleController;

  late AppInfoEntity _appInfoEntity;

  @override
  void onInit() {
    super.onInit();
    BaseController.SPLASH_ALREADY_EXECUTED = true;
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    await _firebaseInitializeService.init();
    await CrashlyticsServiceManager.instance.init();

    await Future.wait([
      _themeController.init(),
      _appSecurityManager.init(),
      _appsFlyerService.init(),
      AnalyticsServiceManager.instance.init(),
      FeatureFlagServiceManager.instance.init(),
    ]);

    if (!Platform.isWeb) {
      final bool introDone = await _checkIntroDone();
      if (!introDone) {
        AppNavigator.backAllAndToNamed(AppRouter.intro);
        return;
      }
    }

    await _getDeviceLocaleUseCase.call().then(Get.updateLocale);

    _appInfoEntity = await _getAppInfoUseCase.call().then((appInfo) {
      AppBinding.lazyPut<AppInfoEntity>(() => appInfo);
      return appInfo;
    });

    if (Platform.isWeb || Platform.isMobile) {
      _initPushNotification();
    } else {
      Log.warning(
        'Push Notification not work on [${Platform.currentPlatform.name}]',
        throwsCrashlytics: false,
      );
    }

    final UserEntity? userAuthenticated = await _getUserAuthenticated();

    await _initFeatureFlagServices();
    await _checkUpdatedApp();

    if (Platform.isWeb) {
      AppNavigator.backAllAndToNamed(AppRouter.web);
    } else {
      _updateUserInstallation();
      if (userAuthenticated != null) {
        await _appSecurityManager.checkIfNeedBlockApp();
      }
      await _openNextPage(userAuthenticated: userAuthenticated);
    }
  }

  @override
  void onClose() {
    _updateFeatureFlags();
    super.onClose();
  }

  Future<void> _initPushNotification() async {
    late PermissionStatus permission;

    try {
      permission = await _checkPermissionUseCase.call(Permission.notification);
    } catch (_) {
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
        Log.error(error.toString(), error: error, stackTrace: stackTrace);
      }

      try {
        await _pushNotificationsService.init();
      } catch (error, stackTrace) {
        Log.error(error.toString(), error: error, stackTrace: stackTrace);
      }
    }

    if (Platform.isWeb) {
      _updateUserInstallation();
    }
  }

  Future<void> _checkUpdatedApp() async {
    final String versionName = _appInfoEntity.version;

    final String? currentVersionApp = await _localStorageUseCase.get<String>(
      CURRENT_APP_VERSION,
    );

    if (currentVersionApp == null) {
      _localStorageUseCase.set<String>(CURRENT_APP_VERSION, versionName);
      return;
    }

    if (versionName != currentVersionApp) {
      try {
        await _onUpdatedAppCallback(currentVersionApp);
      } catch (error, stackTrace) {
        Log.error(error.toString(), error: error, stackTrace: stackTrace);
      }
    }
  }

  Future<void> _openNextPage({required UserEntity? userAuthenticated}) async {
    if (userAuthenticated != null) {
      if (userAuthenticated.permissions.contains(UserPermissionsEnum.ADMIN)) {
        AppNavigator.backAllAndToNamed(AppRouter.admin);
      } else {
        AppNavigator.backAllAndToNamed(AppRouter.home);
      }
      return;
    }

    AppNavigator.backAllAndToNamed(AppRouter.login);
  }

  Future<UserEntity?> _getUserAuthenticated() async {
    try {
      final bool hasSession = await _createSessionBinding();
      if (hasSession) {
        final UserEntity user = await _getUserDataUseCase.call();
        setUserIdentifier(user.id, property: user.toMap());
        return user;
      }
      return null;
    } on InvalidTokenException {
      return null;
    }
  }

  Future<bool> _createSessionBinding() async {
    final String? token = await _authStorageUseCase.getSessionToken();
    AppBinding.put<SessionEntity>(SessionEntity(token: token), permanent: true);
    return token != null;
  }

  Future<bool> _checkIntroDone() async {
    final bool? introDone = await _localStorageUseCase.get<bool>(INTRO_DONE);
    return introDone ?? false;
  }

  Future<void> _initFeatureFlagServices() async {
    try {
      final DeviceInfoEntity deviceInfo = await _getDeviceInfoUseCase.call();

      final deviceTraits = DeviceTraits(
        brand: deviceInfo.brand,
        model: deviceInfo.model,
        osVersion: deviceInfo.osVersion,
        localeName: deviceInfo.localeName,
        platform: deviceInfo.platform,
        packageName: _appInfoEntity.packageName,
        version: _appInfoEntity.version,
        build: _appInfoEntity.build,
        isWeb: kIsWeb,
        debugMode: kDebugMode,
        deviceId: deviceInfo.deviceId ?? 'unknown',
      );

      await FeatureFlagServiceManager.instance.setTraits(deviceTraits);
    } catch (error, stackTrace) {
      Log.error(error.toString(), error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _updateFeatureFlags() async {
    try {
      await _featureFlagLifecycleController.updateFeatureFlags();

      Future.wait([
        _checkIfAppIsBlocked(),
        _checkNeedUpdateApp(),
      ]).then((List results) {
        final bool blockedApp = results[0];
        final bool needUpdateApp = results[1];

        if (!blockedApp) {
          _unsubscribeBlockedTopic();
        }

        if (needUpdateApp && !Platform.isWeb) {
          AppNavigator.toNamed(AppRouter.update);
        }
      });
    } catch (error, stackTrace) {
      Log.error('_updateFeatureFlags', error: error, stackTrace: stackTrace);
    }
  }

  Future<bool> _checkIfAppIsBlocked() async {
    final RemoteFlag? blockingAppFlag = await FeatureFlagServiceManager.instance
        .getFlag(RemoteFlagsEnum.blockingApp);
    if (blockingAppFlag?.isEnabled ?? false) {
      return blockingAppFlag?.value == 'true';
    }
    return false;
  }

  Future<bool> _checkNeedUpdateApp() async {
    final RemoteFlag? updateAppFlag = await FeatureFlagServiceManager.instance
        .getFlag(RemoteFlagsEnum.updateApp);
    if (updateAppFlag?.isEnabled ?? false) {
      return updateAppFlag?.value == 'true';
    }
    return false;
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
        Log.error(
          'BlockedApp unsubscribe topic',
          error: error,
          stackTrace: stackTrace,
        );
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
          _updateUserInstallation(tryAgain: false);
        }
        return;
      }

      Log.error(
        'Splash error uploadInstallation',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _onUpdatedAppCallback(String newVersion) async {
    await _localStorageUseCase.set<String>(CURRENT_APP_VERSION, newVersion);
    // execute something after app update
  }
}
