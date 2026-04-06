import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class LoginUseCaseImpl implements LoginUseCase {
  final LoginService _loginService;
  final UserAuthStorageUseCase _authStorageUseCase;
  final UserService _userService;
  final EncryptUserPasswordUseCase _encryptUserPasswordUseCase;
  final EncryptServerPublicKeyUseCase _encryptServerUseCase;
  final SecurityEncryptUseCase _securityEncrypterUseCase;
  final GetDeviceInfoUseCase _getDeviceInfoUseCase;
  final LocalStorageUseCase _localStorageUseCase;

  LoginUseCaseImpl({
    required LoginService loginService,
    required UserAuthStorageUseCase authStorageUseCase,
    required UserService userService,
    required EncryptUserPasswordUseCase encryptUserPasswordUseCase,
    required EncryptServerPublicKeyUseCase encryptServerPublicKeyUseCase,
    required SecurityEncryptUseCase securityEncrypterUseCase,
    required GetDeviceInfoUseCase getDeviceInfoUseCase,
    required LocalStorageUseCase localStorageUseCase,
  }) : _loginService = loginService,
       _authStorageUseCase = authStorageUseCase,
       _userService = userService,
       _encryptUserPasswordUseCase = encryptUserPasswordUseCase,
       _encryptServerUseCase = encryptServerPublicKeyUseCase,
       _securityEncrypterUseCase = securityEncrypterUseCase,
       _getDeviceInfoUseCase = getDeviceInfoUseCase,
       _localStorageUseCase = localStorageUseCase;

  @override
  Future<UserModel> call({
    required String username,
    required String password,
  }) async {
    final encryptedPassword = await _encryptServerUseCase.call(password);

    final user =
        await _loginService.login(
              username: username,
              password: encryptedPassword,
            )
            as UserModel;

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
    final deviceInfo = await _getDeviceInfoUseCase.call();
    final deviceId = deviceInfo.deviceId;

    final String key = '$userId$deviceId';

    final String keyEncrypted = md5.convert(utf8.encode(key)).toString();

    final String passwordEncrypted = await _securityEncrypterUseCase.encrypt(
      password: keyEncrypted,
      data: password,
    );

    await _localStorageUseCase.set(keyEncrypted, passwordEncrypted);
  }
}
