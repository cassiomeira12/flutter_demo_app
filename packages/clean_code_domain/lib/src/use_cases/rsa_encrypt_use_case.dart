import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

abstract class RsaEncryptUseCase extends UseCase {
  Future<void> generateKeys();

  Future<String> encrypt({required String publicKey, required String data});

  Future<String> decrypt({required String privateKey, required String data});
}

class RsaEncryptUseCaseImpl implements RsaEncryptUseCase {
  final RsaEncryptService _service;

  RsaEncryptUseCaseImpl({
    required RsaEncryptService rsaEncryptService,
  }) : _service = rsaEncryptService;

  @override
  Future<void> generateKeys() {
    return _service.generateKeys();
  }

  @override
  Future<String> encrypt({
    required String publicKey,
    required String data,
  }) {
    return _service.encrypt(publicKey: publicKey, data: data);
  }

  @override
  Future<String> decrypt({
    required String privateKey,
    required String data,
  }) async {
    return _service.decrypt(privateKey: privateKey, data: data);
  }
}
