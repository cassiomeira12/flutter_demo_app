import 'package:core/core.dart';

abstract class SymmetricEncryptionService {
  Result<String> encrypt({
    required String password,
    required String data,
  });

  Result<String> decrypt({
    required String password,
    required String encryptedData,
  });
}
