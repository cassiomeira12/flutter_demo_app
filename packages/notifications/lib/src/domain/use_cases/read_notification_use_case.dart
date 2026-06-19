import 'package:clean_code_domain/clean_code_domain.dart';

abstract class ReadNotificationUseCase
    extends BaseUseCaseAsyncParam<void, NotificationEntity> {}

class ReadNotificationUseCaseImpl implements ReadNotificationUseCase {
  final NotificationService _notificationService;

  ReadNotificationUseCaseImpl({required this._notificationService});

  @override
  Future<void> call(NotificationEntity notification) {
    return _notificationService.readNotifications(notification);
  }
}
