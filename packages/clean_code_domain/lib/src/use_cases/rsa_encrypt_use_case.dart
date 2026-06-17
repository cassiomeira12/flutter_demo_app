import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

abstract class RsaEncryptUseCase extends UseCase {
  RsaEncryptKey generateKeys();

  String encrypt({required String publicKey, required String data});

  String decrypt({required String privateKey, required String data});
}

class RsaEncryptUseCaseImpl implements RsaEncryptUseCase {
  final AsymmetricEncryptionService _asymmetricEncryptionService;

  RsaEncryptUseCaseImpl({required this._asymmetricEncryptionService});

  @override
  RsaEncryptKey generateKeys() => _asymmetricEncryptionService.generateKeys();

  @override
  String encrypt({
    required String publicKey,
    required String data,
  }) {
    final result = _asymmetricEncryptionService.encrypt(
      publicKey: publicKey,
      data: data,
    );
    if (result is Error<String>) {
      throw result.error;
    }
    return (result as Success<String>).value!;
  }

  @override
  String decrypt({
    required String privateKey,
    required String data,
  }) {
    final result = _asymmetricEncryptionService.decrypt(
      privateKey: privateKey,
      encryptedData: data,
    );
    if (result is Error<String>) {
      throw result.error;
    }
    return (result as Success<String>).value!;
  }
}
