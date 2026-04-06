import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
// import 'package:web/web.dart' as web;

class WebPushNotification implements PushNotificationsService {
  final RequestPermissionUseCase _requestPermissionUseCase;

  WebPushNotification({
    required RequestPermissionUseCase requestPermissionUseCase,
  }) : _requestPermissionUseCase = requestPermissionUseCase;

  @override
  Future<void> init() async {
    Log.success('$runtimeType init successful', throwsCrashlytics: false);
  }

  @override
  Future<void> openNotificationOnStartApp() async {}

  @override
  Future<PermissionStatus> requestPermission() {
    return _requestPermissionUseCase.call(Permission.notification);
  }

  @override
  Future<void> showNotification({
    required int id,
    required String? title,
    required String? body,
    required Map<String, dynamic>? payload,
    required String? imageUrl,
    required String? androidChannelId,
    required String? androidPriority,
    required String? androidVisibility,
    required String? androidTag,
    required bool? androidSticky,
  }) async {
    // web.ServiceWorkerRegistration().showNotification(
    //   title!,
    //   web.NotificationOptions(
    //     body: body ?? '',
    //     // icon: '/icons/Icon-192.png',
    //     // badge: '/icons/Icon-192.png',
    //   ),
    // );
    // web.Notification(
    //   title!,
    //   web.NotificationOptions(
    //     body: body ?? '',
    //     // icon: '/icons/Icon-192.png',
    //     // badge: '/icons/Icon-192.png',
    //   ),
    // );
  }
}
