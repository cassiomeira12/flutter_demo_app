import 'package:clean_code_domain/clean_code_domain.dart';

class ListUserNotificationsUseCaseImpl implements ListUserNotificationsUseCase {
  final NotificationService _service;

  ListUserNotificationsUseCaseImpl({
    required NotificationService notificationService,
  }) : _service = notificationService;

  @override
  Future<List<NotificationEntity>> call(int page) {
    return _service.list();
  }
}
