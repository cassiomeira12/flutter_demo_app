import 'package:core/core.dart';

abstract class LoginUseCase {
  Future<UserEntity> call({required String username, required String password});
}
