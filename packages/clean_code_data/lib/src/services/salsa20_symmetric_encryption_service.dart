import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class Salsa20SymmetricEncryptionServiceImpl
    implements SymmetricEncryptionService {
  @override
  Result<String> encrypt({
    required String password,
    required String data,
  }) {
    try {
      final random = Random.secure();
      final randomBytes = Uint8List.fromList(
        List.generate(8, (_) => random.nextInt(256)),
      );
      final ivEncoded = base64.encode(randomBytes);
      if (ivEncoded.length != 12) {
        return Result.error(EncryptException());
      }
      final keyBytes = Uint8List.fromList(
        md5.convert(utf8.encode(password)).bytes,
      );
      final dataBytes = utf8.encode(data);

      final cipher = Salsa20Engine();
      cipher.init(
        true,
        ParametersWithIV<KeyParameter>(
          KeyParameter(keyBytes),
          randomBytes,
        ),
      );

      final output = Uint8List(dataBytes.length);
      cipher.processBytes(dataBytes, 0, dataBytes.length, output, 0);

      final encryptedData = base64.encode(output);
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
      final ivEncoded = encryptedData.substring(0, 12);
      final randomBytes = base64.decode(ivEncoded);
      final encryptedContentData = encryptedData.substring(12);
      final encryptedBytes = base64.decode(encryptedContentData);
      final keyBytes = Uint8List.fromList(
        md5.convert(utf8.encode(password)).bytes,
      );

      final cipher = Salsa20Engine();
      cipher.init(
        false,
        ParametersWithIV<KeyParameter>(
          KeyParameter(keyBytes),
          randomBytes,
        ),
      );

      final output = Uint8List(encryptedBytes.length);
      cipher.processBytes(
        encryptedBytes,
        0,
        encryptedBytes.length,
        output,
        0,
      );

      final decryptedData = utf8.decode(
        output,
        allowMalformed: true,
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
