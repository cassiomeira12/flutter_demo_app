import 'package:clean_code_domain/clean_code_domain.dart';

class ReadNotificationUseCaseImpl implements ReadNotificationUseCase {
  final NotificationService _service;

  ReadNotificationUseCaseImpl({
    required NotificationService notificationService,
  }) : _service = notificationService;

  @override
  Future<void> call(NotificationEntity notification) {
    return _service.readNotifications(notification);
  }
}
