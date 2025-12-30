import 'package:core/core.dart';

abstract class CreateUserUseCase {
  Future<UserEntity> call({
    required String name,
    required String email,
    required String username,
    required String password,
  });
}
