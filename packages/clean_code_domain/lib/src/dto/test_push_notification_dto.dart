import 'package:core/core.dart';

class TestPushNotificationDto extends BaseUseCaseParam {
  final String? title;
  final String? body;
  final String? imageUrl;

  TestPushNotificationDto({
    this.title,
    this.body,
    this.imageUrl,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
    };
  }
}
