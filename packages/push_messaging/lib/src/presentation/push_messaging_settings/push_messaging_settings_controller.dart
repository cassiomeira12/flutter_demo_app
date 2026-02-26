import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class PushMessagingSettingsController extends BaseController {
  final TestPushNotificationUseCase _testPushNotificationUseCase;
  final CheckPermissionUseCase _checkPermissionUseCase;
  final RequestPermissionUseCase _requestPermissionUseCase;
  final LocalStorageUseCase _localStorageUseCase;
  final UploadInstallationAppUseCase _uploadInstallationAppUseCase;
  final PushMessagingService _messagingService;
  final PushNotificationsService _pushNotificationsService;
  final ClipboardUseCase _clipboardUseCase;

  PushMessagingSettingsController({
    required TestPushNotificationUseCase testPushNotificationUseCase,
    required CheckPermissionUseCase checkPermissionUseCase,
    required RequestPermissionUseCase requestPermissionUseCase,
    required LocalStorageUseCase localStorageUseCase,
    required UploadInstallationAppUseCase uploadInstallationAppUseCase,
    required PushMessagingService messagingService,
    required PushNotificationsService pushNotificationsService,
    required ClipboardUseCase clipboardUseCase,
  }) : _testPushNotificationUseCase = testPushNotificationUseCase,
       _checkPermissionUseCase = checkPermissionUseCase,
       _requestPermissionUseCase = requestPermissionUseCase,
       _localStorageUseCase = localStorageUseCase,
       _uploadInstallationAppUseCase = uploadInstallationAppUseCase,
       _messagingService = messagingService,
       _pushNotificationsService = pushNotificationsService,
       _clipboardUseCase = clipboardUseCase;

  RxBool notificationsEnabled = RxBool(false);
  RxString pushToken = RxString('');

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
      if (permission.isGranted) {
        final String? token = await _messagingService.getToken();
        pushToken.value = token ?? '';
      }
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

    if (permission.isDenied || permission.isPermanentlyDenied) {
      permission = await _requestPermissionUseCase.call(
        Permission.notification,
        openSettings: permission.isPermanentlyDenied,
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

      if (enabled) {
        await _enablePushNotificationServices();
        _updateUserInstallation();
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

  Future<void> _updateUserInstallation() async {
    try {
      await _uploadInstallationAppUseCase.call();
    } catch (error, stackTrace) {
      Log.error(
        'Push Messaging Settings error uploadInstallation',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _enablePushNotificationServices() {
    return _initPushNotification();
  }

  Future<void> _disablePushNotificationServices() async {
    await _messagingService.deleteToken();
  }

  Future<void> _initPushNotification() async {
    late PermissionStatus permission;

    try {
      permission = await _checkPermissionUseCase.call(Permission.notification);
    } catch (_) {
      permission = PermissionStatus.denied;
    }

    if (Platform.isWeb) {
      permission = await _pushNotificationsService.requestPermission();
    }

    Log.info('Push Notification Permissions: [$permission]');

    if (permission.isGranted) {
      try {
        await _messagingService.init();
        final String? token = await _messagingService.getToken();
        pushToken.value = token ?? '';
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
  }

  Future<void> testPush() async {
    clickTagging(component: 'test_push_notification_key');
    await _testPushNotificationUseCase.call();
  }

  Future<void> copyToken() async {
    final String? token = await _messagingService.getToken();
    _clipboardUseCase.copy(token ?? '');
  }
}
