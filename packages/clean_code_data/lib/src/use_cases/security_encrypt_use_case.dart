import 'package:clean_code_data/src/use_cases/use_cases.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart' hide Key;
import 'package:encrypt/encrypt.dart';

class SecurityEncryptUseCaseImpl implements SecurityEncryptUseCase {
  @override
  Future<String> encrypt({
    required String password,
    required String data,
  }) async {
    return await IsolateUseCase.isolate<String>(
      builder: () async {
        final Uint8List randomBytes = Uint8List.fromList(
          List<int>.generate(8, (i) {
            return Random.secure().nextInt(256);
          }),
        );
        final String ivEncoded = base64.encode(randomBytes);
        assert(ivEncoded.length == 12, 'ivEncoded must has length 12');
        final encryptedPassword = Uint8List.fromList(
          md5.convert(utf8.encode(password)).bytes,
        );
        final Encrypter encrypter = Encrypter(Salsa20(Key(encryptedPassword)));
        final String encryptedData = encrypter
            .encrypt(data, iv: IV(randomBytes))
            .base64;
        return '$ivEncoded$encryptedData';
      },
    );
  }

  @override
  Future<String> decrypt({
    required String password,
    required String data,
  }) async {
    assert(data.length >= 12, 'ivEncoded must has length 12 or greater');
    return await IsolateUseCase.isolate<String>(
      builder: () async {
        final String ivEncoded = data.substring(0, 12);
        final Uint8List randomBytes = base64.decode(ivEncoded);
        final String encryptedData = data.substring(12);
        final encryptedPassword = Uint8List.fromList(
          md5.convert(utf8.encode(password)).bytes,
        );
        final Encrypter encrypter = Encrypter(Salsa20(Key(encryptedPassword)));
        final String decryptedData = encrypter.decrypt64(
          encryptedData,
          iv: IV(randomBytes),
        );
        return decryptedData;
      },
    );
  }
}
