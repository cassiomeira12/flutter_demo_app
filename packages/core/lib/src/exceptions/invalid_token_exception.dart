import 'package:core/core.dart';

class InvalidTokenException extends BaseException {
  InvalidTokenException({
    super.message = 'invalid_session_token',
    super.throwReport = false,
  });
}
