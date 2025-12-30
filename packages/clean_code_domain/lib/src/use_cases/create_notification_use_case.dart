import 'package:clean_code_domain/clean_code_domain.dart';

abstract class CreateNotificationUseCase {
  Future<void> call({
    required String title,
    required String body,
    required String? imageUrl,
    required UserEntity user,
  });
}
