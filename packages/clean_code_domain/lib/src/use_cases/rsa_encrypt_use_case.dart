abstract class RsaEncryptUseCase {
  Future<void> generateKeys();

  Future<String> encrypt({required String publicKey, required String data});

  Future<String> decrypt({required String privateKey, required String data});
}
