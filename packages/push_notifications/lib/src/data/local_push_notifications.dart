import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalPushNotifications implements PushNotificationsService {
  final String _appName;
  final String _androidNotificationChannel;
  final String _androidNotificationIcon;

  LocalPushNotifications({
    required String appName,
    required String androidNotificationChannel,
    required String androidNotificationIcon,
  }) : _appName = appName,
       _androidNotificationChannel = androidNotificationChannel,
       _androidNotificationIcon = androidNotificationIcon;

  final _notification = FlutterLocalNotificationsPlugin();

  @override
  Future<void> init() async {
    try {
      final androidSettings = AndroidInitializationSettings(
        _androidNotificationIcon,
      );

      const darwinSettings = DarwinInitializationSettings();

      final settings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      );

      await _notification.initialize(
        settings,
        onDidReceiveNotificationResponse: (notification) async {
          Log.debug(
            'id: ${notification.id} \n'
            'type: ${notification.notificationResponseType.name} \n'
            'actionId: ${notification.actionId} \n'
            'input: ${notification.input} \n'
            'payload: ${notification.payload} \n',
          );

          final Map<String, dynamic> payload = jsonDecode(
            notification.payload ?? '',
          );

          final messageId = payload['notificationId'] ?? payload['messageId'];

          AnalyticsMixin.eventTagging(
            'notification_opened_foreground',
            parameters: {'messageId': messageId},
          );

          Log.debug('notification_opened_foreground messageId: $messageId');

          // NotificationManager.instance.clickNotification(
          //   jsonDecode(notification.payload!),
          // );
        },
      );

      Log.success('$runtimeType init successful', throwsCrashlytics: false);
    } catch (error, stackTrace) {
      Log.error(
        '$runtimeType init ERROR',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> openNotificationOnStartApp() async {
    final notification = await _notification.getNotificationAppLaunchDetails();
    final NotificationResponse? response = notification?.notificationResponse;
    if (response == null) return;
    Log.debug(
      'id: ${response.id} \n'
      'type: ${response.notificationResponseType.name} \n'
      'actionId: ${response.actionId} \n'
      'input: ${response.input} \n'
      'payload: ${response.payload} \n',
    );

    final Map<String, dynamic> payload = jsonDecode(response.payload ?? '');

    final messageId = payload['notificationId'] ?? payload['messageId'];

    AnalyticsMixin.eventTagging(
      'notification_opened_background',
      parameters: {'messageId': messageId},
    );

    Log.debug('notification_opened_background messageId: $messageId');

    // NotificationManager.instance.clickNotification(payload);
  }

  @override
  Future<void> showNotification({
    required int id,
    required String? title,
    required String? body,
    payload,
    String? imageUrl,
  }) async {
    await _notification.show(
      id,
      title,
      body,
      await _createDetails(imageUrl),
      payload: payload,
    );
  }

  Future<NotificationDetails> _createDetails(String? imageUrl) async {
    BigPictureStyleInformation? pictureStyleInformation;
    DarwinNotificationDetails? darwinNotificationDetails;

    darwinNotificationDetails = const DarwinNotificationDetails(
      badgeNumber: 0,
      presentSound: true,
      presentAlert: true,
      presentBadge: true,
      attachments: <DarwinNotificationAttachment>[],
    );

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _androidNotificationChannel,
      _appName,
      importance: Importance.max,
      priority: Priority.high,
      ledOnMs: 1000,
      ledOffMs: 500,
      ticker: 'ticker',
      visibility: NotificationVisibility.public,
      styleInformation:
          pictureStyleInformation ?? const DefaultStyleInformation(true, true),
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinNotificationDetails,
      macOS: darwinNotificationDetails,
    );

    return platformChannelSpecifics;
  }
}
