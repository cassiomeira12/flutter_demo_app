// ignore_for_file: unreachable_from_main

import 'package:analytics/analytics.dart';
import 'package:core/core.dart';
import 'package:crashlytics/crashlytics.dart';
import 'package:dependency/dependency.dart';
import 'package:firebase_initialize/firebase_initialize.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_messaging/src/domain/domain.dart';

class FirebasePushMessaging implements PushMessagingService {
  final CheckPermissionUseCase _checkPermissionUseCase;
  final RequestPermissionUseCase _requestPermissionUseCase;
  final OnClickedNotificationCallback _onClickedNotificationCallback;
  final OnReceivedNotificationCallback _onReceivedNotificationCallback;
  final PushTopicsService _pushTopicsService;
  final String _vapidKeyMessagingWeb;

  FirebasePushMessaging({
    required CheckPermissionUseCase checkPermissionUseCase,
    required RequestPermissionUseCase requestPermissionUseCase,
    required OnClickedNotificationCallback onClickedNotificationCallback,
    required OnReceivedNotificationCallback onReceivedNotificationCallback,
    required PushTopicsService pushTopicService,
    required String vapidKeyMessagingWeb,
  }) : _checkPermissionUseCase = checkPermissionUseCase,
       _requestPermissionUseCase = requestPermissionUseCase,
       _onClickedNotificationCallback = onClickedNotificationCallback,
       _onReceivedNotificationCallback = onReceivedNotificationCallback,
       _pushTopicsService = pushTopicService,
       _vapidKeyMessagingWeb = vapidKeyMessagingWeb;

  bool _initialized = false;

  @override
  Future<void> init() async {
    final PermissionStatus permission = await _requestPermissionUseCase.call(
      Permission.notification,
    );

    if (permission != PermissionStatus.granted) {
      Log.warning(
        '$runtimeType init ERROR \n'
        'Notification Permission $permission',
        throwsCrashlytics: false,
      );
      return;
    }

    if (_initialized) {
      Log.success('$runtimeType already initialized', throwsCrashlytics: false);
      return;
    }

    if (Platform.appleDevice) {
      _enableApplePushOnForeground();
    }

    if (Platform.isMobile) {
      FirebaseMessaging.onBackgroundMessage(notificationBackgroundHandler);
    }

    openNotificationOnStartApp();
    openNotificationWhenAppRunning();
    receiveNotificationWhenAppRunning();

    Log.success('$runtimeType init successful', throwsCrashlytics: false);
    _initialized = true;
  }

  @override
  Future<String?> getToken() async {
    if (!_initialized) return null;

    final PermissionStatus permission = await _checkPermissionUseCase.call(
      Permission.notification,
    );

    if (permission != PermissionStatus.granted) {
      return null;
    }

    String? vapidKey;
    if (Platform.isWeb) {
      vapidKey = _vapidKeyMessagingWeb;
    }

    try {
      return await FirebaseMessaging.instance.getToken(
        vapidKey: vapidKey,
      );
    } catch (error, stackTrace) {
      Log.error(error, stackTrace, msg: 'Firebase Push Messaging TOKEN');
      return null;
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (error, stackTrace) {
      Log.error(error, stackTrace, msg: 'Firebase Push Messaging Delete TOKEN');
    }
  }

  @override
  String getTokenType() => 'FCM';

  @override
  Future<void> openNotificationOnStartApp() async {
    if (!_initialized) return;
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) async {
      if (message?.notification != null) {
        final pushNotification = _parsePushNotification(message!);

        final messageId = message.messageId;

        AnalyticsMixin.eventTagging(
          'notification_opened_background',
          parameters: {'messageId': messageId},
        );

        Log.debug('notification_opened_background messageId: $messageId');

        _onClickedNotificationCallback.onClicked(pushNotification.toMap());
      }
    });
  }

  void openNotificationWhenAppRunning() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        final pushNotification = _parsePushNotification(message);
        final messageId = message.messageId;

        AnalyticsMixin.eventTagging(
          'notification_opened_foreground',
          parameters: {'messageId': messageId},
        );

        Log.debug(
          'notification_opened_foreground messageId: $messageId \n'
          'data: ${pushNotification.toMap()}',
        );

        _onClickedNotificationCallback.onClicked(pushNotification.toMap());
      }
    });
  }

  void receiveNotificationWhenAppRunning() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        final pushNotification = _parsePushNotification(message);
        final messageId = message.messageId;

        AnalyticsMixin.eventTagging(
          'notification_received_foreground',
          parameters: {'messageId': messageId},
        );

        Log.debug(
          'notification_received_foreground \n'
          'data: ${pushNotification.toMap()}',
        );

        _onReceivedNotificationCallback.onReceived(pushNotification.toMap());
      }
    });
  }

  PushNotificationEntity _parsePushNotification(RemoteMessage message) {
    final RemoteNotification notification = message.notification!;

    String? imageUrl;
    String? androidChannelId;
    String? androidPriority;
    String? androidVisibility;
    String? androidTag;
    bool? androidSticky;

    final AndroidNotification? androidNotification = notification.android;
    if (androidNotification != null) {
      imageUrl = androidNotification.imageUrl;
      androidChannelId = androidNotification.channelId;
      switch (androidNotification.priority) {
        case AndroidNotificationPriority.minimumPriority:
          androidPriority = 'min';
        case AndroidNotificationPriority.lowPriority:
          androidPriority = 'low';
        case AndroidNotificationPriority.defaultPriority:
          androidPriority = 'defaultPriority';
        case AndroidNotificationPriority.highPriority:
          androidPriority = 'high';
        case AndroidNotificationPriority.maximumPriority:
          androidPriority = 'max';
      }
      androidVisibility = androidNotification.visibility.name;
      androidTag = androidNotification.tag;
    }

    final AppleNotification? appleNotification = notification.apple;
    if (appleNotification != null) {
      imageUrl = appleNotification.imageUrl;
    }

    final Map<String, dynamic> data = message.data;

    data['messageId'] = message.messageId;

    imageUrl ??= data['image'];
    androidSticky = data['sticky'] == null
        ? null
        : bool.tryParse(data['sticky']);

    PushNotificationEntity pushNotification = PushNotificationEntity(
      id: message.messageId,
      title: notification.title ?? '',
      body: notification.body ?? '',
      imageUrl: imageUrl,
      data: data,
      androidChannelId: androidChannelId,
      androidPriority: androidPriority,
      androidVisibility: androidVisibility,
      androidTag: androidTag,
      androidSticky: androidSticky,
    );

    if (data['click_action'] != null) {
      final dynamic action = data['click_action'];
      pushNotification = pushNotification.copyWith(data: jsonDecode(action));
    }

    return pushNotification;
  }

  Future<void> _enableApplePushOnForeground() async {
    try {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
  }

  @override
  Future<void> subscribeTopic(List<String> topics) async {
    Log.debug('Push Messaging Subscribe Topics $topics');
    await _pushTopicsService.subscribeTopic(topics);
  }

  @override
  Future<void> unsubscribeTopic(List<String> topics) async {
    Log.debug('Push Messaging Unsubscribe Topics $topics');
    await _pushTopicsService.unsubscribeTopic(topics);
  }

  @override
  Future<void> subscribeUserTopic(String topic) async {
    Log.debug('Push Messaging Subscribe User Topic [$topic]');
    await _pushTopicsService.subscribeUserTopic(topic);
  }

  @override
  Future<void> unsubscribeUserTopic(String topic) async {
    Log.debug('Push Messaging Unsubscribe User Topic [$topic]');
    await _pushTopicsService.subscribeUserTopic(topic);
  }
}

@pragma('vm:entry-point')
Future<void> notificationBackgroundHandler(RemoteMessage message) async {
  if (message.messageId == null) return;

  if (!AppBinding.hasInstance<FirebaseInitializeService>()) {
    AppBinding.put<FirebaseInitializeService>(
      FirebaseInitializeServiceFaker(),
      permanent: true,
    );

    await CrashlyticsModuleBindings().injectDependencies();
    await FirebaseInitializeModuleBindings().injectDependencies();
    await AnalyticsModuleBindings().injectDependencies();

    await CrashlyticsServiceManager.instance.init();
    await AppBinding.find<FirebaseInitializeService>().init();
    await AnalyticsServiceManager.instance.init();
  }

  AnalyticsServiceManager.instance.logEvent(
    name: 'notification_receive_background',
    parameters: {
      'messageId': message.data['notificationId'] ?? message.messageId,
    },
  );

  Log.debug(
    'notification_receive_background messageId: ${message.messageId} \n'
    'data: ${message.toMap()}',
  );
}
