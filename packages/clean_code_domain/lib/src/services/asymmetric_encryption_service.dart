import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

abstract class AsymmetricEncryptionService {
  RsaEncryptKey generateKeys();

  Result<String> encrypt({
    required String publicKey,
    required String data,
  });

  Result<String> decrypt({
    required String privateKey,
    required String encryptedData,
  });
}
