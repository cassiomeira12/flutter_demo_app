abstract class RsaEncryptUseCase {
  Future<void> generateKeys();

  String encrypt({required String publicKey, required String data});

  String decrypt({required String privateKey, required String data});
}
