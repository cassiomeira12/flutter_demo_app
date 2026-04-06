import 'package:core/core.dart';

class TestPushNotificationUseCaseImpl implements TestPushNotificationUseCase {
  final NotificationService _service;

  TestPushNotificationUseCaseImpl({
    required NotificationService notificationService,
  }) : _service = notificationService;

  @override
  Future<Result<void>> call(TestPushNotificationDto? param) {
    return _service.testPush(param);
  }
}
