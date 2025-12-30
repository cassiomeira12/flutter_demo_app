import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

class EncryptServerPublicKeyUseCaseImpl
    implements EncryptServerPublicKeyUseCase {
  final String _serverRSAPublicKeyBase64;
  final RsaEncryptUseCase _rsaEncrypterUseCase;

  EncryptServerPublicKeyUseCaseImpl({
    required String serverRSAPublicKeyBase64,
    required RsaEncryptUseCase rsaEncrypterUseCase,
  }) : _serverRSAPublicKeyBase64 = serverRSAPublicKeyBase64,
       _rsaEncrypterUseCase = rsaEncrypterUseCase;

  @override
  String call(String data) {
    final String key = _serverRSAPublicKeyBase64;
    if (key.isEmpty) return data;
    final String publicKey = utf8.decode(base64.decode(key));
    return _rsaEncrypterUseCase.encrypt(publicKey: publicKey, data: data);
  }
}
