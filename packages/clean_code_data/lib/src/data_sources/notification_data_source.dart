import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';

abstract class NotificationDataSource
    implements CreateDataSource, ListDataSource {
  Future<int> countUnread(String userId);

  Future<void> readNotifications(String notificationId);

  Future<void> testPush(BaseUseCaseParam? param);
}
