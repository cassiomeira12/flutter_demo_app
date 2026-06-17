import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

abstract class SecurityEncryptUseCase extends UseCase {
  Future<String> encrypt({required String password, required String data});

  Future<String> decrypt({required String password, required String data});
}

class SecurityEncryptUseCaseImpl implements SecurityEncryptUseCase {
  final SymmetricEncryptionService _symmetricEncryptionService;

  SecurityEncryptUseCaseImpl({required this._symmetricEncryptionService});

  @override
  Future<String> encrypt({
    required String password,
    required String data,
  }) async {
    final result = _symmetricEncryptionService.encrypt(
      password: password,
      data: data,
    );
    if (result is Error<String>) {
      throw result.error;
    }
    return (result as Success<String>).value!;
  }

  @override
  Future<String> decrypt({
    required String password,
    required String data,
  }) async {
    final result = _symmetricEncryptionService.decrypt(
      password: password,
      encryptedData: data,
    );
    if (result is Error<String>) {
      throw result.error;
    }
    return (result as Success<String>).value!;
  }
}
