import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

abstract class LoginUseCase extends UseCase {
  Future<UserEntity> call({
    required String username,
    required String password,
  });
}

class LoginUseCaseImpl implements LoginUseCase {
  final LoginService _loginService;
  final UserAuthStorageUseCase _authStorageUseCase;
  final UserService _userService;
  final EncryptUserPasswordUseCase _encryptUserPasswordUseCase;
  final SecurityEncryptUseCase _securityEncrypterUseCase;
  final DeviceInfoEntity _deviceInfoEntity;
  final LocalStorageUseCase _localStorageUseCase;

  LoginUseCaseImpl({
    required this._loginService,
    required this._authStorageUseCase,
    required this._userService,
    required this._encryptUserPasswordUseCase,
    required this._securityEncrypterUseCase,
    required this._deviceInfoEntity,
    required this._localStorageUseCase,
  });

  @override
  Future<UserEntity> call({
    required String username,
    required String password,
  }) async {
    final user = await _loginService.login(
      username: username,
      password: password,
    );

    final String sessionToken = user.sessionToken!;
    final session = SessionEntity(token: sessionToken);

    await AppBinding.replace<SessionEntity>(session);
    AppBinding.put<UserEntity>(user, permanent: true);

    try {
      await _encryptUserPasswordUseCase.encrypt(password: password);

      await _authStorageUseCase.saveSessionToken(sessionToken);
      await _authStorageUseCase.saveUserData(user);

      await _userService.getUserData();

      await _savePasswordEncrypted(userId: user.id, password: password);

      return user;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _savePasswordEncrypted({
    required String userId,
    required String password,
  }) async {
    final deviceId = _deviceInfoEntity.deviceId;

    final String key = '$userId$deviceId';

    final String keyEncrypted = md5.convert(utf8.encode(key)).toString();

    final String passwordEncrypted = await _securityEncrypterUseCase.encrypt(
      password: keyEncrypted,
      data: password,
    );

    await _localStorageUseCase.set(keyEncrypted, passwordEncrypted);
  }
}
