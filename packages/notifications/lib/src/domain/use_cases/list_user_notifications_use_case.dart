import 'package:clean_code_domain/clean_code_domain.dart';

abstract class ListUserNotificationsUseCase
    extends BaseUseCaseAsyncParam<List<NotificationEntity>, int> {}

class ListUserNotificationsUseCaseImpl implements ListUserNotificationsUseCase {
  final NotificationService _notificationService;

  ListUserNotificationsUseCaseImpl({required this._notificationService});

  @override
  Future<List<NotificationEntity>> call(int page) {
    return _notificationService.list();
  }
}
