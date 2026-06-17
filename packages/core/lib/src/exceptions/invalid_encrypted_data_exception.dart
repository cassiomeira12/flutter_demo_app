import 'package:core/core.dart';

class InvalidEncryptedDataException extends BaseException {
  InvalidEncryptedDataException({
    super.message = 'invalid_encrypted_data',
    super.throwReport = false,
  });
}
