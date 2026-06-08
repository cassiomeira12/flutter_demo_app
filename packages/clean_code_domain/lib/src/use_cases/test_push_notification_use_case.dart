import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

abstract class TestPushNotificationUseCase
    extends BaseUseCaseAsyncParam<Result<void>, TestPushNotificationDto?> {}

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
