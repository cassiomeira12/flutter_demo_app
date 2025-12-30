import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class PushMessagingSettingsController extends BaseController {
  final TestPushNotificationUseCase _testPushNotificationUseCase;
  final CheckPermissionUseCase _checkPermissionUseCase;
  final RequestPermissionUseCase _requestPermissionUseCase;
  final AppInfoEntity _appInfoEntity;
  final LocalStorageUseCase _localStorageUseCase;
  final UploadInstallationAppUseCase _uploadInstallationUeCase;
  final PushMessagingService _messagingService;
  final PushNotificationsService _pushNotificationsService;

  PushMessagingSettingsController({
    required TestPushNotificationUseCase testPushNotificationUseCase,
    required CheckPermissionUseCase checkPermissionUseCase,
    required RequestPermissionUseCase requestPermissionUseCase,
    required AppInfoEntity appInfoEntity,
    required LocalStorageUseCase localStorageUseCase,
    required UploadInstallationAppUseCase uploadInstallationUseCase,
    required PushMessagingService messagingService,
    required PushNotificationsService pushNotificationsService,
  }) : _testPushNotificationUseCase = testPushNotificationUseCase,
       _checkPermissionUseCase = checkPermissionUseCase,
       _requestPermissionUseCase = requestPermissionUseCase,
       _appInfoEntity = appInfoEntity,
       _localStorageUseCase = localStorageUseCase,
       _uploadInstallationUeCase = uploadInstallationUseCase,
       _messagingService = messagingService,
       _pushNotificationsService = pushNotificationsService;

  RxBool notificationsEnabled = RxBool(false);

  @override
  void onReady() {
    super.onReady();
    _checkNotificationsEnabled();
  }

  Future<void> _checkNotificationsEnabled() async {
    final bool? enabled = await _localStorageUseCase.get<bool>(
      NOTIFICATIONS_ENABLED,
    );
    if (enabled == false) {
      notificationsEnabled.value = false;
      return;
    }
    try {
      final permission = await _checkPermissionUseCase.call(
        Permission.notification,
      );
      notificationsEnabled.value = permission.isGranted;
    } catch (_) {
      notificationsEnabled.value = false;
    } finally {
      await _localStorageUseCase.set<bool>(
        NOTIFICATIONS_ENABLED,
        notificationsEnabled.value,
      );
    }
  }

  Future<bool?> toggleNotification(bool enabled) async {
    clickTagging(component: 'notifications_switch_key');

    notificationsEnabled.value = enabled;

    late PermissionStatus permission;
    try {
      permission = await _checkPermissionUseCase.call(Permission.notification);
    } catch (_) {
      permission = PermissionStatus.denied;
    }

    if (permission.isPermanentlyDenied) {
      permission = await _requestPermissionUseCase.call(
        Permission.notification,
        openSettings: true,
      );
      tagging(
        'notifications_request_permission_enabled',
        parameters: {'enabled': permission.isGranted},
      );
    }

    if (permission.isPermanentlyDenied) {
      notificationsEnabled.value = false;
      return null;
    }

    try {
      await _localStorageUseCase.set<bool>(NOTIFICATIONS_ENABLED, enabled);

      await _uploadInstallationUeCase.call();

      if (enabled) {
        await _enablePushNotificationServices();
      } else {
        await _disablePushNotificationServices();
      }

      tagging('notifications_enabled', parameters: {'enabled': enabled});

      return enabled;
    } catch (_) {
      notificationsEnabled.value = !enabled;
      await _localStorageUseCase.set<bool>(NOTIFICATIONS_ENABLED, !enabled);
      rethrow;
    }
  }

  Future<void> _enablePushNotificationServices() {
    return _initPushNotification();
  }

  Future<void> _disablePushNotificationServices() {
    return _unsubscribeDefaultFirebaseMessageTopics();
  }

  Future<void> _initPushNotification() async {
    late PermissionStatus permission;

    try {
      permission = await _checkPermissionUseCase.call(Permission.notification);
    } catch (_) {
      permission = PermissionStatus.denied;
    }

    if (permission.isGranted) {
      await _messagingService.init();
      await _pushNotificationsService.init();

      final String? token = await _messagingService.getToken();
      Log.debug('Firebase Messaging Token: $token');

      await _subscribeDefaultFirebaseMessageTopics();

      await _messagingService.openNotificationOnStartApp();
      await _pushNotificationsService.openNotificationOnStartApp();
    }
  }

  Future<void> _subscribeDefaultFirebaseMessageTopics() async {
    final List<String> defaultTopics = [];

    final String packageName = _appInfoEntity.packageName;
    final String versionName = _appInfoEntity.version;

    defaultTopics.add(packageName);
    defaultTopics.add('${packageName}_$versionName');

    for (final topic in defaultTopics) {
      final bool? subscribedTopic = await _localStorageUseCase.get<bool>(topic);
      if (subscribedTopic == null) {
        await _messagingService.subscribeTopic(topic);
        await _localStorageUseCase.set<bool>(topic, true);
      }
    }
  }

  Future<void> _unsubscribeDefaultFirebaseMessageTopics() async {
    final List<String> defaultTopics = [];

    final String packageName = _appInfoEntity.packageName;
    final String versionName = _appInfoEntity.version;

    defaultTopics.add(packageName);
    defaultTopics.add('${packageName}_$versionName');

    for (final topic in defaultTopics) {
      final bool? subscribedTopic = await _localStorageUseCase.get<bool>(topic);
      if (subscribedTopic != null) {
        await _messagingService.unsubscribeTopic(topic);
        await _localStorageUseCase.delete(topic);
      }
    }
  }

  Future<void> testPush() async {
    clickTagging(component: 'test_push_notification_key');
    await _testPushNotificationUseCase.call();
  }
}
