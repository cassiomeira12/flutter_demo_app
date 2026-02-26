import 'package:core/core.dart';

class ChangePasswordUseCaseImpl implements ChangePasswordUseCase {
  final UserService _service;
  final UserAuthStorageUseCase _authStorageUseCase;
  final EncryptUserPasswordUseCase _encryptUserPasswordUseCase;
  final EncryptServerPublicKeyUseCase _encryptServerUseCase;

  ChangePasswordUseCaseImpl({
    required UserService userService,
    required UserAuthStorageUseCase userAuthStorageUseCase,
    required EncryptUserPasswordUseCase encryptUserPasswordUseCase,
    required EncryptServerPublicKeyUseCase encryptServerPublicKeyUseCase,
  }) : _service = userService,
       _authStorageUseCase = userAuthStorageUseCase,
       _encryptUserPasswordUseCase = encryptUserPasswordUseCase,
       _encryptServerUseCase = encryptServerPublicKeyUseCase;

  @override
  Future<void> call({
    required String username,
    required String currentPassword,
    required String newPassword,
  }) async {
    final encryptedCurrentPassword = await _encryptServerUseCase.call(
      currentPassword,
    );
    final encryptedNewPassword = await _encryptServerUseCase.call(newPassword);

    final user = await _service.changePassword(
      username: username,
      currentPassword: encryptedCurrentPassword,
      newPassword: encryptedNewPassword,
    );

    final String sessionToken = user.sessionToken!;
    final session = SessionEntity(token: sessionToken);

    await AppBinding.replace<SessionEntity>(session);
    await AppBinding.replace<UserEntity>(user);

    final Map<String, String?> oldCredentials = await _authStorageUseCase
        .getCredentials();

    await _encryptUserPasswordUseCase.encrypt(password: newPassword);

    await _authStorageUseCase.saveSessionToken(sessionToken);
    await _authStorageUseCase.saveUserData(user.toMap());

    if (oldCredentials.isNotEmpty) {
      final bool hasPasswordSaved = oldCredentials['password'] != null;
      await _authStorageUseCase.saveCredentials(
        username: username,
        password: hasPasswordSaved ? newPassword : null,
      );
    }

    await _service.getUserData();
  }
}
