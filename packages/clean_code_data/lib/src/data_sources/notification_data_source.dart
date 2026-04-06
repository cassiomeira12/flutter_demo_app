import 'package:core/core.dart';

abstract class NotificationDataSource
    implements CreateDataSource, ListDataSource {
  Future<int> countUnread(String userId);

  Future<void> readNotifications(String notificationId);

  Future<void> testPush(BaseUseCaseParam? param);
}
