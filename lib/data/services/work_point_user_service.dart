import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class WorkPointUserService implements UserService {
  @override
  Future<UserEntity> changePassword({
    required String username,
    required String currentPassword,
    required String newPassword,
  }) async {
    final userEntity = AppBinding.find<UserEntity>();
    return userEntity;
  }

  @override
  Future<void> deleteUser(String reason) async {}

  @override
  Future<UserEntity> getUserData() async {
    final userEntity = AppBinding.find<UserEntity>();
    return userEntity;
  }

  @override
  Future<UserEntity> update(
    String objectId, {
    required Map<String, dynamic> data,
  }) async {
    final userEntity = AppBinding.find<UserEntity>();
    return userEntity;
  }
}
