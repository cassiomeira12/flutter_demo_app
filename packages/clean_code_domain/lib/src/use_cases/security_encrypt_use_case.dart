abstract class SecurityEncryptUseCase {
  Future<String> encrypt({required String password, required String data});
  Future<String> decrypt({required String password, required String data});
}
