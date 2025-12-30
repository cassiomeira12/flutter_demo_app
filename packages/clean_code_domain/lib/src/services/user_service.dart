import 'package:clean_code_domain/clean_code_domain.dart';

abstract class UserService implements UpdateService<UserEntity> {
  Future<UserEntity> getUserData();

  Future<void> deleteUser(String reason);

  Future<UserEntity> changePassword({
    required String username,
    required String currentPassword,
    required String newPassword,
  });
}
