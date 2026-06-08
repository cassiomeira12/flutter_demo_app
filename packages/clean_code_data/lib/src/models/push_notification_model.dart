import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class PushNotificationModel extends PushNotificationEntity {
  PushNotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.imageUrl,
    required super.data,
    required super.androidChannelId,
    required super.androidPriority,
    required super.androidVisibility,
    required super.androidTag,
    required super.androidSticky,
  });

  factory PushNotificationModel.fromMap(Map<String, dynamic> map) {
    try {
      return PushNotificationModel(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        body: map['body'] ?? '',
        imageUrl: map['imageUrl'],
        data: map['data'],
        androidChannelId: map['androidChannelId'],
        androidPriority: map['androidPriority'],
        androidVisibility: map['androidVisibility'],
        androidTag: map['androidTag'],
        androidSticky: map['androidSticky'],
      );
    } catch (error, stacktrace) {
      throw BaseException(
        error: error,
        stackTrace: stacktrace,
        complement: 'Json Data: $map',
      );
    }
  }
}
