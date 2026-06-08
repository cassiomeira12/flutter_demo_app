import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.objectId,
    required super.title,
    required super.body,
    required super.viewed,
    required super.imageUrl,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    try {
      return NotificationModel(
        objectId: map['objectId'] ?? '',
        title: map['title'] ?? '',
        body: map['body'] ?? '',
        viewed: map['viewed'] ?? false,
        imageUrl: map['imageUrl'] as String?,
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
