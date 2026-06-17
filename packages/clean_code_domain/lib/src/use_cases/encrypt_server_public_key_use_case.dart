import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';

abstract class EncryptServerPublicKeyUseCase
    extends BaseUseCaseSyncParam<String, String> {}

class EncryptServerPublicKeyUseCaseImpl
    implements EncryptServerPublicKeyUseCase {
  final SecurityEnvironmentEntity _securityEnv;
  final RsaEncryptUseCase _rsaEncrypterUseCase;

  EncryptServerPublicKeyUseCaseImpl({
    required this._securityEnv,
    required this._rsaEncrypterUseCase,
  });

  @override
  String call(String data) {
    final String key = _securityEnv.serverRSAPublicKeyBase64;
    if (key.isEmpty) return data;
    final String publicKey = utf8.decode(base64.decode(key));
    return _rsaEncrypterUseCase.encrypt(publicKey: publicKey, data: data);
  }
}
