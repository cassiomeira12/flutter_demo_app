abstract class ChangePasswordUseCase {
  Future<void> call({
    required String username,
    required String currentPassword,
    required String newPassword,
  });
}
