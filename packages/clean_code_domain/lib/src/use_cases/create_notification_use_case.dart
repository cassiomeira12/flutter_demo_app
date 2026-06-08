import 'package:clean_code_domain/clean_code_domain.dart';

abstract class CreateNotificationUseCase extends UseCase {
  Future<void> call({
    required String title,
    required String body,
    required String? imageUrl,
    required UserEntity user,
  });
}

class CreateNotificationUseCaseImpl implements CreateNotificationUseCase {
  final NotificationService _service;

  CreateNotificationUseCaseImpl({
    required NotificationService notificationService,
  }) : _service = notificationService;

  @override
  Future<void> call({
    required String title,
    required String body,
    required String? imageUrl,
    required UserEntity user,
  }) {
    final Map<String, dynamic> data = {
      'userId': user.id,
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
    };

    return _service.create(data);
  }
}
