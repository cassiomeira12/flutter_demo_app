import 'package:clean_code_domain/clean_code_domain.dart';

abstract class SecurityEncryptUseCase extends UseCase {
  Future<String> encrypt({required String password, required String data});

  Future<String> decrypt({required String password, required String data});
}

class SecurityEncryptUseCaseImpl implements SecurityEncryptUseCase {
  final SecurityEncryptService _service;

  SecurityEncryptUseCaseImpl({
    required SecurityEncryptService securityEncryptService,
  }) : _service = securityEncryptService;

  @override
  Future<String> encrypt({
    required String password,
    required String data,
  }) {
    return _service.encrypt(password: password, data: data);
  }

  @override
  Future<String> decrypt({
    required String password,
    required String data,
  }) async {
    return _service.decrypt(password: password, data: data);
  }
}
