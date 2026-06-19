import 'package:clean_code_domain/clean_code_domain.dart';

abstract class CountUnreadNotificationsUseCase
    extends BaseUseCaseAsyncParam<int, UserEntity> {}

class CountUnreadNotificationsUseCaseImpl
    implements CountUnreadNotificationsUseCase {
  final NotificationService _notificationService;

  CountUnreadNotificationsUseCaseImpl({required this._notificationService});

  @override
  Future<int> call(UserEntity user) {
    return _notificationService.countUnread(user);
  }
}
