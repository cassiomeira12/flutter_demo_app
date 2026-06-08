import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

abstract class EncryptUserPasswordUseCase extends UseCase {
  Future<void> encrypt({required String password});

  Future<String?> decrypt();
}

class EncryptUserPasswordUseCaseImpl implements EncryptUserPasswordUseCase {
  final SecurityEnvironmentEntity _securityEnv;
  final SecurityEncryptUseCase _securityEncryptUseCase;
  final LocalStorageUseCase _localStorageUseCase;
  final GetAppInfoUseCase _getAppInfoUseCase;

  EncryptUserPasswordUseCaseImpl({
    required this._securityEnv,
    required this._securityEncryptUseCase,
    required this._localStorageUseCase,
    required this._getAppInfoUseCase,
  });

  Future<String> _generateKey() async {
    final appInfo = await _getAppInfoUseCase.call();
    final String packageName = appInfo.packageName;
    final String platformName = Platform.currentPlatform.name;
    final String key =
        '${packageName}_${platformName}_${_securityEnv.encryptKey}';
    return key;
  }

  @override
  Future<void> encrypt({required String password}) async {
    final String key = await _generateKey();

    final String keyEncrypted = md5.convert(utf8.encode(key)).toString();

    final String passwordEncrypted = await _securityEncryptUseCase.encrypt(
      password: _securityEnv.encryptKey,
      data: password,
    );

    await _localStorageUseCase.set(keyEncrypted, passwordEncrypted);
  }

  @override
  Future<String?> decrypt() async {
    final String key = await _generateKey();

    final String keyEncrypted = md5.convert(utf8.encode(key)).toString();

    final String? passwordEncrypted = await _localStorageUseCase.get(
      keyEncrypted,
    );

    if (passwordEncrypted == null) return null;

    final String password = await _securityEncryptUseCase.decrypt(
      password: _securityEnv.encryptKey,
      data: passwordEncrypted,
    );

    return password;
  }
}
