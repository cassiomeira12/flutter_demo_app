import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class SplashController extends BaseController {
  final GetUserDataUseCase _getUserDataUseCase;
  final LocalStorageUseCase _localStorageUseCase;
  final UserAuthStorageUseCase _authStorageUseCase;
  final GetDeviceInfoUseCase _getDeviceInfoUseCase;
  final GetAppInfoUseCase _getAppInfoUseCase;
  final CheckPermissionUseCase _checkPermissionUseCase;
  final FeatureFlagService _featureFlagService;
  final PushMessagingService _pushMessagingService;
  final PushNotificationsService _pushNotificationsService;
  final GetDeviceLocaleUseCase _getDeviceLocaleUseCase;
  final FirebaseInitializeService _firebaseInitializeService;
  final AppsFlyerService _appsFlyerService;
  final ThemeController _themeController;
  final AppSecurityManager _appSecurityManager;

  SplashController({
    required GetUserDataUseCase getUserDataUseCase,
    required LocalStorageUseCase localStorageUseCase,
    required UserAuthStorageUseCase authStorageUseCase,
    required GetDeviceInfoUseCase getDeviceInfoUseCase,
    required GetAppInfoUseCase getAppInfoUseCase,
    required CheckPermissionUseCase checkPermissionUseCase,
    required FeatureFlagService featureFlagService,
    required PushMessagingService pushMessagingService,
    required PushNotificationsService pushNotificationsService,
    required GetDeviceLocaleUseCase getDeviceLocaleUseCase,
    required FirebaseInitializeService firebaseInitializeService,
    required AppsFlyerService appsFlyerService,
    required ThemeController themeController,
    required AppSecurityManager appSecurityManager,
  }) : _getUserDataUseCase = getUserDataUseCase,
       _localStorageUseCase = localStorageUseCase,
       _authStorageUseCase = authStorageUseCase,
       _getDeviceInfoUseCase = getDeviceInfoUseCase,
       _getAppInfoUseCase = getAppInfoUseCase,
       _checkPermissionUseCase = checkPermissionUseCase,
       _featureFlagService = featureFlagService,
       _pushMessagingService = pushMessagingService,
       _pushNotificationsService = pushNotificationsService,
       _getDeviceLocaleUseCase = getDeviceLocaleUseCase,
       _firebaseInitializeService = firebaseInitializeService,
       _appsFlyerService = appsFlyerService,
       _themeController = themeController,
       _appSecurityManager = appSecurityManager;

  late AppInfoEntity _appInfoEntity;

  @override
  void onInit() {
    super.onInit();
    BaseController.SPLASH_ALREADY_EXECUTED = true;
  }

  @override
  Future<void> onReady() async {
    await _themeController.init();
    await _appSecurityManager.init();

    await _firebaseInitializeService.init();
    await CrashlyticsServiceManager.instance.init();
    await _appsFlyerService.init();
    await AnalyticsServiceManager.instance.init();

    super.onReady();

    final bool introDone = await _checkIntroDone();
    if (introDone == false) {
      AppNavigator.backAllAndToNamed(AppRouter.intro);
      return;
    }

    _removeNativeSplashScreen();

    await _getDeviceLocaleUseCase.call().then(Get.updateLocale);

    _appInfoEntity = await _getAppInfoUseCase.call().then((appInfo) {
      AppBinding.lazyPut<AppInfoEntity>(() => appInfo);
      return appInfo;
    });

    if (Platform.isWeb || Platform.isMobile) {
      await _initPushNotification();
    } else {
      Log.warning(
        'Push Notification not work on [${Platform.currentPlatform.name}]',
        throwsCrashlytics: false,
      );
    }

    if (Platform.isWeb) {
      AppNavigator.backAllAndToNamed(AppRouter.web);
      return;
    }

    await _openNextPage();

    await _initRemoteConfig();

    await Future.wait([
      _checkIfAppIsBlocked(),
      _checkNeedUpdateApp(),
      _openUpdatedAppPage(),
    ]).then((List results) {
      final bool blockedApp = results[0];
      final bool needUpdateApp = results[1];
      final bool updatedApp = results[2];

      if (blockedApp) {
        AppNavigator.backAllAndToNamed(AppRouter.blocking);
        return;
      }

      _unsubscribeBlockedTopic();

      if (needUpdateApp) {
        _openUpdateAppPage();
        return;
      }

      if (updatedApp) {
        AppNavigator.toNamed(AppRouter.updated);
      }
    });
  }

  Future<void> _initPushNotification() async {
    late PermissionStatus permission;

    try {
      permission = await _checkPermissionUseCase.call(Permission.notification);
    } catch (_) {
      permission = PermissionStatus.denied;
    }

    Log.info('Push Notification Permissions: [$permission]');

    if (permission.isGranted) {
      await _pushMessagingService.init();
      await _pushNotificationsService.init();

      // final String? token = await _pushMessagingService.getToken();

      await _subscribeDefaultFirebaseMessageTopics();

      await _pushMessagingService.openNotificationOnStartApp();
      await _pushNotificationsService.openNotificationOnStartApp();

      // TODO remover depois
      // ['plc_geral', 'plc_t1', 'plc_not_t1', 'plc_t9', 'plc_not_t9'].forEach((
      //   topic,
      // ) {
      //   _pushMessagingService.subscribeTopic(topic);
      // });
    }
  }

  Future<void> _subscribeDefaultFirebaseMessageTopics() async {
    final List<String> defaultTopics = [];

    final String packageName = _appInfoEntity.packageName;
    final String versionName = _appInfoEntity.version;

    defaultTopics.add(packageName);
    defaultTopics.add('${packageName}_$versionName');

    final String? currentVersionApp = await _localStorageUseCase.get<String>(
      CURRENT_APP_VERSION,
    );
    if (currentVersionApp == null) {
      await _localStorageUseCase.set<String>(CURRENT_APP_VERSION, versionName);
    }

    for (final topic in defaultTopics) {
      final bool? subscribedTopic = await _localStorageUseCase.get<bool>(topic);
      if (subscribedTopic == null) {
        await _pushMessagingService.subscribeTopic(topic);
        await _localStorageUseCase.set<bool>(topic, true);
      }
    }
  }

  Future<void> _openNextPage() async {
    final bool isAuthenticated = await _isUserAuthenticated();

    // _removeNativeSplashScreen();

    if (isAuthenticated) {
      await _appSecurityManager.checkIfNeedBlockApp();
      AppNavigator.backAllAndToNamed(AppRouter.home);
      return;
    }

    AppNavigator.backAllAndToNamed(AppRouter.login);
  }

  Future<bool> _isUserAuthenticated() async {
    try {
      final bool hasSession = await _createSessionBinding();
      if (hasSession) {
        final UserEntity user = await _getUserDataUseCase.call();
        setUserIdentifier(user.id, property: user.toMap());
      }
      return hasSession;
    } on InvalidTokenException {
      return false;
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

  Future<void> _initRemoteConfig() async {
    try {
      final DeviceInfoEntity deviceInfo = await _getDeviceInfoUseCase.call();

      await _featureFlagService.init();

      _featureFlagService.setUserIdentifier(deviceInfo.deviceId);

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
      );

      await _featureFlagService.setTraits(deviceTraits);
    } catch (_) {}
  }

  Future<bool> _checkIfAppIsBlocked() async {
    final RemoteFlag? blockingAppFlag = await _featureFlagService.getFlag(
      RemoteFlagsEnum.blockingApp,
    );
    if (blockingAppFlag?.isEnabled ?? false) {
      return blockingAppFlag?.value == 'true';
    }
    return false;
  }

  Future<void> _unsubscribeBlockedTopic() async {
    final bool? blockedApp = await _localStorageUseCase.get<bool>(BLOCKED_APP);
    if (blockedApp ?? false) {
      await _localStorageUseCase.delete(BLOCKED_APP);
      final String packageName = _appInfoEntity.packageName;
      final String blockedAppTopic =
          '${packageName}_${RemoteFlagsEnum.blockingApp.name}';

      await _pushMessagingService.unsubscribeTopic(blockedAppTopic);
    }
  }

  Future<bool> _checkNeedUpdateApp() async {
    final RemoteFlag? updateAppFlag = await _featureFlagService.getFlag(
      RemoteFlagsEnum.updateApp,
    );
    if (updateAppFlag?.isEnabled ?? false) {
      return updateAppFlag?.value == 'true';
    }
    return false;
  }

  Future<void> _openUpdateAppPage() async {
    final RemoteFlag? requiredUpdateFlag = await _featureFlagService.getFlag(
      RemoteFlagsEnum.updateAppRequired,
    );

    final bool isEnabled = requiredUpdateFlag?.isEnabled ?? false;
    final bool requiredUpdate = requiredUpdateFlag?.value == 'true';

    if (isEnabled && requiredUpdate) {
      AppNavigator.backAllAndToNamed(AppRouter.update);
      return;
    }

    try {
      await _isUserAuthenticated();
      AppNavigator.toNamed(AppRouter.update);
    } catch (_) {
      await AppNavigator.toNamed(AppRouter.update);
      final bool introDone = await _checkIntroDone();
      AppNavigator.backAllAndToNamed(
        introDone ? AppRouter.login : AppRouter.intro,
      );
    }
  }

  Future<bool> _openUpdatedAppPage() async {
    final String currentVersion = CURRENT_APP_VERSION + _appInfoEntity.version;

    final bool? version = await _localStorageUseCase.get<bool>(currentVersion);
    if (version == null) {
      final RemoteFlag? updateAppDataFlag = await _featureFlagService.getFlag(
        RemoteFlagsEnum.updateAppData,
      );

      if (updateAppDataFlag == null || updateAppDataFlag.value == null) {
        return false;
      }

      final Map<String, dynamic> json = jsonDecode(updateAppDataFlag.value!);

      final String newVersion = json['new_version'];

      if (_appInfoEntity.version == newVersion) {
        await _localStorageUseCase.set<bool>(currentVersion, true);
        return true;
      }
    }

    return false;
  }

  void _removeNativeSplashScreen() {
    Future.delayed(
      const Duration(milliseconds: 500),
      FlutterNativeSplash.remove,
    );
  }
}
