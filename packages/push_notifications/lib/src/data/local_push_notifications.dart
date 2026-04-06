import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalPushNotifications implements PushNotificationsService {
  final String _appName;
  final String _androidNotificationChannel;
  final String _androidNotificationIcon;
  final RequestPermissionUseCase _requestPermissionUseCase;
  final OnClickedNotificationCallback _onClickedNotificationCallback;

  LocalPushNotifications({
    required String appName,
    required String androidNotificationChannel,
    required String androidNotificationIcon,
    required RequestPermissionUseCase requestPermissionUseCase,
    required OnClickedNotificationCallback onClickedNotificationCallback,
  }) : _appName = appName,
       _androidNotificationChannel = androidNotificationChannel,
       _androidNotificationIcon = androidNotificationIcon,
       _requestPermissionUseCase = requestPermissionUseCase,
       _onClickedNotificationCallback = onClickedNotificationCallback;

  final _notification = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  @override
  Future<void> init() async {
    if (_initialized) {
      Log.success('$runtimeType already initialized', throwsCrashlytics: false);
      return;
    }

    final androidSettings = AndroidInitializationSettings(
      _androidNotificationIcon,
    );

    const appleSettings = DarwinInitializationSettings();

    final settings = InitializationSettings(
      android: androidSettings,
      iOS: appleSettings,
      macOS: appleSettings,
    );

    if (Platform.isAndroid) {
      await _createAndroidNotificationChannel();
    }

    await _notification.initialize(
      settings,
      onDidReceiveNotificationResponse: (notification) async {
        Log.info(
          'id: ${notification.id} \n'
          'type: ${notification.notificationResponseType.name} \n'
          'actionId: ${notification.actionId} \n'
          'input: ${notification.input} \n'
          'payload: ${notification.payload} \n',
        );

        final Map<String, dynamic> payload = notification.payload == null
            ? {}
            : jsonDecode(notification.payload!);

        final messageId = payload['notificationId'] ?? payload['messageId'];

        AnalyticsMixin.eventTagging(
          'notification_opened_foreground',
          parameters: {'messageId': messageId},
        );

        Log.debug('notification_opened_foreground messageId: $messageId');

        final message = {
          'id': messageId ?? notification.id?.toString(),
          'data': payload,
        };

        _onClickedNotificationCallback.onClicked(message);
      },
    );

    Log.success('$runtimeType init successful', throwsCrashlytics: false);

    _initialized = true;
  }

  @override
  Future<void> openNotificationOnStartApp() async {
    if (!_initialized) return;

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

    // final Map<String, dynamic> payload = jsonDecode(response.payload ?? '');

    // final messageId = payload['notificationId'] ?? payload['messageId'];

    // AnalyticsMixin.eventTagging(
    //   'notification_opened_background',
    //   parameters: {'messageId': messageId},
    // );

    // Log.debug('notification_opened_background messageId: $messageId');

    // NotificationManager.instance.clickNotification(payload);
  }

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
    if (!_initialized) return;

    await _notification.show(
      id,
      title,
      body,
      await _createDetails(
        channelId: androidChannelId,
        priority: androidPriority,
        visibility: androidVisibility,
        imageUrl: imageUrl,
        tag: androidTag,
        sticky: androidSticky,
      ),
      payload: payload == null ? null : jsonEncode(payload),
    );
  }

  Future<void> _createAndroidNotificationChannel() async {
    try {
      final androidPlugin = _notification
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      androidPlugin?.createNotificationChannel(
        AndroidNotificationChannel(
          _androidNotificationChannel,
          _appName,
          importance: Importance.max,
        ),
      );
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
  }

  Future<NotificationDetails> _createDetails({
    String? channelId,
    String? priority,
    String? visibility,
    String? imageUrl,
    String? tag,
    bool? sticky,
  }) async {
    BigPictureStyleInformation? pictureStyleInformation;
    DarwinNotificationDetails? appleNotificationDetails;

    if (imageUrl != null) {
      // final bigPicture = ByteArrayAndroidBitmap(
      //   await _getByteArrayFromUrl(image),
      // );
      // pictureStyleInformation = BigPictureStyleInformation(
      //   bigPicture,
      //   largeIcon: bigPicture,
      // );
      // final String bigPicturePath = await _downloadAndSaveFile(
      //   imageUrl,
      //   'image.jpg',
      // );

      // iOSPlatformChannelSpecifics = IOSNotificationDetails(
      //   badgeNumber: 0,
      //   presentSound: true,
      //   presentAlert: true,
      //   presentBadge: true,
      //   attachments: <IOSNotificationAttachment>[
      //     IOSNotificationAttachment(bigPicturePath),
      //   ],
      // );
      // macOSPlatformChannelSpecifics = MacOSNotificationDetails(
      //   badgeNumber: 0,
      //   presentSound: true,
      //   presentAlert: true,
      //   presentBadge: true,
      //   attachments: <MacOSNotificationAttachment>[
      //     MacOSNotificationAttachment(bigPicturePath),
      //   ],
      // );
    }

    appleNotificationDetails = const DarwinNotificationDetails(
      badgeNumber: 0,
      presentSound: true,
      presentAlert: true,
      presentBadge: true,
      attachments: <DarwinNotificationAttachment>[
        // DarwinNotificationAttachment(bigPicturePath),
      ],
    );

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId ?? _androidNotificationChannel,
      _appName,
      ledOnMs: 1000,
      ledOffMs: 500,
      fullScreenIntent: true,
      importance: Importance.max,
      priority: Priority.values.firstWhere(
        (value) => value.name == (priority ?? 'high'),
      ),
      visibility: NotificationVisibility.values.firstWhere(
        (value) => value.name == (visibility ?? 'public'),
      ),
      styleInformation:
          pictureStyleInformation ?? const DefaultStyleInformation(true, true),
      tag: tag,
      autoCancel: !(sticky ?? false),
      // showProgress: true,
      // progress: 70,
      // maxProgress: 100,
      category: AndroidNotificationCategory.error,
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: appleNotificationDetails,
      macOS: appleNotificationDetails,
    );

    return platformChannelSpecifics;
  }
}
