import 'package:clean_code_data/clean_code_data.dart';

abstract class NotificationDataSource
    implements CreateDataSource, ListDataSource {
  Future<int> countUnread(String userId);

  Future<void> readNotifications(String notificationId);

  Future<void> testPush({String? title, String? body, String? imageUrl});
}
