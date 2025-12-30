abstract class EncryptUserPasswordUseCase {
  Future<void> encrypt({required String password});
  Future<String?> decrypt();
}
