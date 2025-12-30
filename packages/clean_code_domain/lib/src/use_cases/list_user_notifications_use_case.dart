import 'package:clean_code_domain/clean_code_domain.dart';

abstract class ListUserNotificationsUseCase {
  Future<List<NotificationEntity>> call(int page);
}
