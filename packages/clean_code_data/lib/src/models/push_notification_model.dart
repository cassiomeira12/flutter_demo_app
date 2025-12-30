import 'package:core/core.dart';

class PushNotificationModel extends PushNotificationEntity {
  PushNotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.image,
    required super.data,
  });

  factory PushNotificationModel.fromMap(Map<String, dynamic> map) {
    try {
      return PushNotificationModel(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        body: map['body'] ?? '',
        image: map['image'],
        data: map['data'],
      );
    } catch (error, stacktrace) {
      throw BaseException(
        error: error,
        stacktrace: stacktrace,
        complement: 'Json Data: $map',
      );
    }
  }
}
