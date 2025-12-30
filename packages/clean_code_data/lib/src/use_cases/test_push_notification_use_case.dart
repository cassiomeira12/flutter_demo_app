import 'package:clean_code_domain/clean_code_domain.dart';

class TestPushNotificationUseCaseImpl implements TestPushNotificationUseCase {
  final NotificationService _service;

  TestPushNotificationUseCaseImpl({
    required NotificationService notificationService,
  }) : _service = notificationService;

  @override
  Future<void> call({String? title, String? body, String? imageUrl}) {
    return _service.testPush(title: title, body: body, imageUrl: imageUrl);
  }
}
