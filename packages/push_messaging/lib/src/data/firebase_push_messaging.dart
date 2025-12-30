import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebasePushMessaging implements PushMessagingService {
  final OnClickedNotificationCallback? _onClickedNotificationCallback;
  final OnReceivedNotificationCallback? _onReceivedNotificationCallback;

  FirebasePushMessaging({
    required OnClickedNotificationCallback? onClickedNotificationCallback,
    required OnReceivedNotificationCallback? onReceivedNotificationCallback,
  }) : _onClickedNotificationCallback = onClickedNotificationCallback,
       _onReceivedNotificationCallback = onReceivedNotificationCallback;

  @override
  Future<void> init() async {
    NotificationSettings permission = await _requestPermission();

    if (permission.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }

    if (Platform.isMobile) {
      FirebaseMessaging.onBackgroundMessage(notificationBackgroundHandler);
    }

    openNotificationOnStartApp();
    openNotificationWhenAppRunning();
    receiveNotificationWhenAppRunning();

    getToken();

    Log.success('$runtimeType init successful', throwsCrashlytics: false);
  }

  @override
  Future<String?> getToken() async {
    NotificationSettings permission = await _requestPermission();

    if (permission.authorizationStatus != AuthorizationStatus.authorized) {
      return null;
    }

    // debugPrint(
    //   'iOS Firebase Notification permissions [${notificationAuthorized ? 'ok' : 'error'}]',
    // );

    try {
      String? token = await FirebaseMessaging.instance.getToken();
      Log.success(
        'Firebase Push Messaging TOKEN [$token]',
        throwsCrashlytics: false,
      );
      // onUpdateToken?.call(token);
      return token;
    } catch (error, stackTrace) {
      Log.error(
        'Firebase Push Messaging TOKEN',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Future<void> openNotificationOnStartApp() async {
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) async {
      if (Platform.isIOS && message?.messageId != null) {
        var prefs = await SharedPreferences.getInstance();
        var result = prefs.getBool(message!.messageId!);
        prefs.remove(message.messageId!);
        if (result ?? false) {
          return;
        }
      }

      if (message?.notification != null) {
        RemoteNotification notification = message!.notification!;
        String? image;
        if (notification.android != null) {
          image = notification.android!.imageUrl;
        }
        if (notification.apple != null) {
          image = notification.apple!.imageUrl;
        }

        dynamic data = message.data;

        image ??= data['image'];

        PushNotificationEntity pushNotification = PushNotificationEntity(
          id: message.messageId,
          title: notification.title ?? '',
          body: notification.body ?? '',
          image: image,
          data: message.data,
        );

        if (data['click_action'] != null) {
          dynamic action = data['click_action'];
          pushNotification = pushNotification.copyWith(
            data: jsonDecode(action),
          );
        }

        final messageId = message.messageId;

        AnalyticsMixin.eventTagging(
          'notification_opened_background',
          parameters: {'messageId': messageId},
        );

        Log.debug('notification_opened_background messageId: $messageId');

        _onClickedNotificationCallback?.onClicked(pushNotification.toMap());
      }
    });
  }

  void openNotificationWhenAppRunning() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (Platform.isIOS && message.messageId != null) {
        var prefs = await SharedPreferences.getInstance();
        prefs.setBool(message.messageId!, true);
      }

      RemoteNotification notification = message.notification!;
      String? image;
      if (notification.android != null) {
        image = notification.android!.imageUrl;
      }
      if (notification.apple != null) {
        image = notification.apple!.imageUrl;
      }

      dynamic data = message.data;

      image ??= data['image'];

      PushNotificationEntity pushNotification = PushNotificationEntity(
        id: message.messageId,
        title: notification.title ?? '',
        body: notification.body ?? '',
        image: image,
        data: message.data,
      );

      if (data['click_action'] != null) {
        dynamic action = data['click_action'];
        pushNotification = pushNotification.copyWith(data: jsonDecode(action));
      }

      final messageId = message.messageId;

      AnalyticsMixin.eventTagging(
        'notification_opened_foreground',
        parameters: {'messageId': messageId},
      );

      Log.debug('notification_opened_foreground messageId: $messageId');

      _onClickedNotificationCallback?.onClicked(pushNotification.toMap());
    });
  }

  void receiveNotificationWhenAppRunning() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification!;
      var prefs = await SharedPreferences.getInstance();
      var alreadyReceive = prefs.get(
        'receive-notification-${message.messageId!}',
      );
      if (alreadyReceive == null) {
        prefs.setBool('receive-notification-${message.messageId!}', true);
        String? image;
        if (notification.android != null) {
          image = notification.android!.imageUrl;
        }
        if (notification.apple != null) {
          image = notification.apple!.imageUrl;
        }

        dynamic data = message.data;

        image ??= data['image'];

        PushNotificationEntity pushNotification = PushNotificationEntity(
          id: message.messageId,
          title: notification.title ?? '',
          body: notification.body ?? '',
          image: image,
          data: message.data,
        );

        if (Platform.isAndroid) {
          //_pushNotification(notificationModel.toMap());
        }

        if (data['click_action'] != null) {
          dynamic action = data['click_action'];
          pushNotification = pushNotification.copyWith(
            data: jsonDecode(action),
          );
        }

        final messageId = message.messageId;

        AnalyticsMixin.eventTagging(
          'notification_received_foreground',
          parameters: {'messageId': messageId},
        );

        Log.debug('notification_received_foreground messageId: $messageId');

        _onReceivedNotificationCallback?.onReceived(pushNotification.toMap());
      }
    });
  }

  @override
  Future<void> subscribeTopic(String topic) async {
    Log.debug('Push Messaging Subscribe Topic [$topic]');
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  @override
  Future<void> unsubscribeTopic(String topic) async {
    Log.debug('Push Messaging Unsubscribe Topic [$topic]');
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  Future<NotificationSettings> _requestPermission() async {
    NotificationSettings result;
    if (Platform.isMacOS || Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
      result = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        sound: true,
      );
    } else {
      result = await FirebaseMessaging.instance.requestPermission(
        announcement: true,
        carPlay: true,
        criticalAlert: true,
      );
    }
    return result;
  }
}

@pragma('vm:entry-point')
Future<void> notificationBackgroundHandler(RemoteMessage notification) async {
  // await Firebase.initializeApp();

  print('PushMessagingService ${notification.toMap()}');

  // if (notification.messageId == null) return;

  // await AnalyticsServiceManager.instance.init();

  // AnalyticsServiceManager.instance.logEvent(
  //   name: 'notification_receive_background',
  //   parameters: {
  //     'messageId':
  //         notification.data['notificationId'] ?? notification.messageId,
  //   },
  // );
}
