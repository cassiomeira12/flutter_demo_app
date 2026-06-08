import 'package:clean_code_domain/clean_code_domain.dart';

abstract class LoginService {
  Future<UserEntity> login({
    required String username,
    required String password,
  });
}
