import 'package:clean_code_domain/clean_code_domain.dart';

abstract class CreateUserUseCase {
  Future<UserEntity> call({
    required String name,
    required String email,
    required String username,
    required String password,
  });
}
