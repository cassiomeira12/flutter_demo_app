import 'package:core/core.dart';

class AuthUserException extends BaseException {
  AuthUserException({
    super.message = 'invalid_username_password',
    super.throwReport = false,
  });
}
