import 'package:clean_code_domain/clean_code_domain.dart';

abstract class NotificationService
    implements
        CreateService<NotificationEntity>,
        ListService<NotificationEntity> {
  Future<int> countUnread(UserEntity user);

  Future<void> readNotifications(NotificationEntity notification);

  Future<Result<void>> testPush(TestPushNotificationDto? param);
}
