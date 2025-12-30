import 'package:core/core.dart';

abstract class LoginService {
  Future<UserEntity> login({
    required String username,
    required String password,
  });
}
