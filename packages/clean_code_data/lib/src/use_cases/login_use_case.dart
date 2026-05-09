import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class LoginUseCaseImpl implements LoginUseCase {
  final LoginService _loginService;
  final UserAuthStorageUseCase _authStorageUseCase;
  final UserService _userService;
  final EncryptUserPasswordUseCase _encryptUserPasswordUseCase;
  final SecurityEncryptUseCase _securityEncrypterUseCase;
  final DeviceInfoEntity _deviceInfo;
  final LocalStorageUseCase _localStorageUseCase;

  LoginUseCaseImpl({
    required LoginService loginService,
    required UserAuthStorageUseCase authStorageUseCase,
    required UserService userService,
    required EncryptUserPasswordUseCase encryptUserPasswordUseCase,
    required SecurityEncryptUseCase securityEncrypterUseCase,
    required DeviceInfoEntity deviceInfoEntity,
    required LocalStorageUseCase localStorageUseCase,
  }) : _loginService = loginService,
       _authStorageUseCase = authStorageUseCase,
       _userService = userService,
       _encryptUserPasswordUseCase = encryptUserPasswordUseCase,
       _securityEncrypterUseCase = securityEncrypterUseCase,
       _deviceInfo = deviceInfoEntity,
       _localStorageUseCase = localStorageUseCase;

  @override
  Future<UserModel> call({
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
      await _authStorageUseCase.saveUserData(user.toMap());

      await _userService.getUserData();

      await _savePasswordEncrypted(userId: user.id, password: password);

      return user as UserModel;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace);
      throw BaseException(error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _savePasswordEncrypted({
    required String userId,
    required String password,
  }) async {
    final deviceId = _deviceInfo.deviceId;

    final String key = '$userId$deviceId';

    final String keyEncrypted = md5.convert(utf8.encode(key)).toString();

    final String passwordEncrypted = await _securityEncrypterUseCase.encrypt(
      password: keyEncrypted,
      data: password,
    );

    await _localStorageUseCase.set(keyEncrypted, passwordEncrypted);
  }
}
