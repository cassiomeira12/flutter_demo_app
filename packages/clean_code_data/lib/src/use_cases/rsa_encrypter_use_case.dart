import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:dependency/dependency.dart';
import 'package:encrypt/encrypt.dart';

class RsaEncryptUseCaseImpl implements RsaEncryptUseCase {
  @override
  Future<void> generateKeys() async {
    //
  }

  @override
  String encrypt({required String publicKey, required String data}) {
    final parser = RSAKeyParser();
    final encrypt = Encrypter(
      RSA(
        publicKey: parser.parse(publicKey) as RSAPublicKey,
        encoding: RSAEncoding.OAEP,
      ),
    );
    final encrypted = encrypt.encrypt(data);
    return encrypted.base64;
  }

  @override
  String decrypt({required String privateKey, required String data}) {
    final parser = RSAKeyParser();
    final encrypt = Encrypter(
      RSA(
        privateKey: parser.parse(privateKey) as RSAPrivateKey,
        encoding: RSAEncoding.OAEP,
      ),
    );
    final decrypted = encrypt.decrypt64(data);
    return decrypted;
  }
}
