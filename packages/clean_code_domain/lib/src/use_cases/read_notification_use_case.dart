import 'package:clean_code_domain/clean_code_domain.dart';

abstract class ReadNotificationUseCase {
  Future<void> call(NotificationEntity notification);
}
