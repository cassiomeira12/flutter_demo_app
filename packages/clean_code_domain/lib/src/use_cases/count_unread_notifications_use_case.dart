import 'package:clean_code_domain/clean_code_domain.dart';

abstract class CountUnreadNotificationsUseCase
    extends BaseUseCaseAsyncParam<int, UserEntity> {}

class CountUnreadNotificationsUseCaseImpl
    implements CountUnreadNotificationsUseCase {
  final NotificationService _service;

  CountUnreadNotificationsUseCaseImpl({
    required NotificationService notificationService,
  }) : _service = notificationService;

  @override
  Future<int> call(UserEntity user) {
    return _service.countUnread(user);
  }
}
