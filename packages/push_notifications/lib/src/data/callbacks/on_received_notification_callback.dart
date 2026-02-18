import 'package:core/core.dart';

class LocalPushOnReceivedNotificationCallback
    implements OnReceivedNotificationCallback {
  @override
  Future<void> onReceived(Map<String, dynamic> map) async {
    // Firebase Messaging shows foreground push on its own
    if (Platform.appleDevice) return;

    final pushNotificationService = AppBinding.find<PushNotificationsService>();
    final int id = map['androidTag'] == null
        ? DateTime.now().millisecond
        : int.tryParse(map['androidTag']) ?? DateTime.now().millisecond;

    try {
      await pushNotificationService.showNotification(
        id: id,
        title: map['notification']['title'],
        body: map['notification']['body'],
        payload: map['data'],
        imageUrl: map['imageUrl'],
        androidChannelId: map['androidChannelId'],
        androidPriority: map['androidPriority'],
        androidVisibility: map['androidVisibility'],
        androidTag: map['androidTag'],
        androidSticky: map['androidSticky'],
      );
    } catch (error, stackTrace) {
      Log.error(error.toString(), error: error, stackTrace: stackTrace);
    }
  }
}
