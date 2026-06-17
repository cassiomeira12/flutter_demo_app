import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart' hide Key;
import 'package:encrypt/encrypt.dart';

class SecurityEncryptServiceImpl implements SymmetricEncryptionService {
  @override
  Result<String> encrypt({
    required String password,
    required String data,
  }) {
    try {
      final Uint8List randomBytes = Uint8List.fromList(
        List<int>.generate(8, (i) {
          return Random.secure().nextInt(256);
        }),
      );
      final String ivEncoded = base64.encode(randomBytes);
      if (ivEncoded.length != 12) {
        return Result.error(InvalidEncryptedDataException());
      }
      final encryptedPassword = Uint8List.fromList(
        md5.convert(utf8.encode(password)).bytes,
      );
      final Encrypter encrypter = Encrypter(Salsa20(Key(encryptedPassword)));
      final String encryptedData = encrypter
          .encrypt(data, iv: IV(randomBytes))
          .base64;
      return Result.success('$ivEncoded$encryptedData');
    } catch (error, stackTrace) {
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
    required String password,
    required String encryptedData,
  }) {
    if (encryptedData.length < 12) {
      return Result.error(InvalidEncryptedDataException());
    }
    try {
      final String ivEncoded = encryptedData.substring(0, 12);
      final Uint8List randomBytes = base64.decode(ivEncoded);
      final String data = encryptedData.substring(12);
      final encryptedPassword = Uint8List.fromList(
        md5.convert(utf8.encode(password)).bytes,
      );
      final Encrypter encrypter = Encrypter(Salsa20(Key(encryptedPassword)));
      final String decryptedData = encrypter.decrypt64(
        data,
        iv: IV(randomBytes),
      );
      return Result.success(decryptedData);
    } catch (error, stackTrace) {
      return Result.error(
        EncryptException(
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
