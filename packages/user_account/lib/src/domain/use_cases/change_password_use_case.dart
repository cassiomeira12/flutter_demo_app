import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

abstract class ChangePasswordUseCase extends UseCase {
  Future<void> call({
    required String username,
    required String currentPassword,
    required String newPassword,
  });
}

class ChangePasswordUseCaseImpl implements ChangePasswordUseCase {
  final UserService _userService;
  final UserAuthStorageUseCase _userAuthStorageUseCase;
  final EncryptUserPasswordUseCase _encryptUserPasswordUseCase;
  final EncryptServerPublicKeyUseCase _encryptServerPublicKeyUseCase;

  ChangePasswordUseCaseImpl({
    required this._userService,
    required this._userAuthStorageUseCase,
    required this._encryptUserPasswordUseCase,
    required this._encryptServerPublicKeyUseCase,
  });

  @override
  Future<void> call({
    required String username,
    required String currentPassword,
    required String newPassword,
  }) async {
    final encryptedCurrentPassword = _encryptServerPublicKeyUseCase.call(
      currentPassword,
    );
    final encryptedNewPassword = _encryptServerPublicKeyUseCase.call(
      newPassword,
    );

    final user = await _userService.changePassword(
      username: username,
      currentPassword: encryptedCurrentPassword,
      newPassword: encryptedNewPassword,
    );

    final String sessionToken = user.sessionToken!;
    final session = SessionEntity(token: sessionToken);

    AppBinding.putReplace<SessionEntity>(session);
    AppBinding.putReplace<UserEntity>(user);

    final Map<String, String?> oldCredentials = await _userAuthStorageUseCase
        .getCredentials();

    await _encryptUserPasswordUseCase.encrypt(password: newPassword);

    await _userAuthStorageUseCase.saveSessionToken(sessionToken);
    await _userAuthStorageUseCase.saveUserData(user);

    if (oldCredentials.isNotEmpty) {
      final bool hasPasswordSaved = oldCredentials['password'] != null;
      await _userAuthStorageUseCase.saveCredentials(
        username: username,
        password: hasPasswordSaved ? newPassword : null,
      );
    }

    await _userService.getUserData();
  }
}
