import 'package:core/core.dart';

class EncryptException extends BaseException {
  EncryptException({
    super.message = 'encrypt_exception',
    super.throwReport = false,
    super.error,
    super.stackTrace,
  });
}
