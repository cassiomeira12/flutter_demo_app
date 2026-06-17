import 'package:clean_code_data/src/services/rsa_asymmetric_encryption_service.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:encrypt/encrypt.dart';

class RsaEncryptServiceImpl implements AsymmetricEncryptionService {
  @override
  RsaEncryptKey generateKeys() {
    return RsaAsymmetricEncryptionServiceImpl().generateKeys();
  }

  @override
  Result<String> encrypt({
    required String publicKey,
    required String data,
  }) {
    try {
      final parser = RSAKeyParser();
      final encrypt = Encrypter(
        RSA(
          publicKey: parser.parse(publicKey) as RSAPublicKey,
          encoding: RSAEncoding.OAEP,
        ),
      );
      final encrypted = encrypt.encrypt(data);
      return Result.success(encrypted.base64);
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      return Result.error(
        EncryptException(
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Result<String> decrypt({
    required String privateKey,
    required String encryptedData,
  }) {
    try {
      final parser = RSAKeyParser();
      final encrypt = Encrypter(
        RSA(
          privateKey: parser.parse(privateKey) as RSAPrivateKey,
          encoding: RSAEncoding.OAEP,
        ),
      );
      final decrypted = encrypt.decrypt64(encryptedData);
      return Result.success(decrypted);
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      return Result.error(
        EncryptException(
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
