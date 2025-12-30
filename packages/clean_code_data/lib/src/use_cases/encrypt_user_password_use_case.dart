import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class EncryptUserPasswordUseCaseImpl implements EncryptUserPasswordUseCase {
  final String _encryptKey;
  final SecurityEncryptUseCase _securityEncryptUseCase;
  final LocalStorageUseCase _localStorageUseCase;
  final GetAppInfoUseCase _getAppInfoUseCase;

  EncryptUserPasswordUseCaseImpl({
    required String encryptKey,
    required SecurityEncryptUseCase securityEncryptUseCase,
    required LocalStorageUseCase localStorageUseCase,
    required GetAppInfoUseCase getAppInfoUseCase,
  }) : _encryptKey = encryptKey,
       _securityEncryptUseCase = securityEncryptUseCase,
       _localStorageUseCase = localStorageUseCase,
       _getAppInfoUseCase = getAppInfoUseCase;

  Future<String> _generateKey() async {
    final appInfo = await _getAppInfoUseCase.call();
    final String packageName = appInfo.packageName;
    final String platformName = Platform.currentPlatform.name;
    final String key = '${packageName}_${platformName}_$_encryptKey';
    return key;
  }

  @override
  Future<void> encrypt({required String password}) async {
    final String key = await _generateKey();

    final String keyEncrypted = md5.convert(utf8.encode(key)).toString();

    final String passwordEncrypted = _securityEncryptUseCase.encrypt(
      password: _encryptKey,
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

    final String password = _securityEncryptUseCase.decrypt(
      password: _encryptKey,
      data: passwordEncrypted,
    );

    return password;
  }
}
