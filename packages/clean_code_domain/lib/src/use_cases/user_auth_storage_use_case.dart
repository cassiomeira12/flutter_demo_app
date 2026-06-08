import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

abstract class UserAuthStorageUseCase extends UseCase {
  Future<void> saveCredentials({required String username, String? password});

  Future<Map<String, String?>> getCredentials();

  Future<void> clearCredentials();

  Future<void> saveSessionToken(String token);

  Future<void> clearSessionToken();

  Future<String?> getSessionToken();

  Future<void> saveUserData(UserEntity user);

  Future<void> clearUserData();

  Future<UserEntity?> getUserData();
}

class UserAuthStorageUseCaseImpl implements UserAuthStorageUseCase {
  final UserAuthStorageService _userAuthStorageService;
  final EncryptUserPasswordUseCase _encryptUserPasswordUseCase;
  final SecurityEncryptUseCase _securityEncrypterUseCase;

  UserAuthStorageUseCaseImpl({
    required this._userAuthStorageService,
    required this._encryptUserPasswordUseCase,
    required this._securityEncrypterUseCase,
  });

  @override
  Future<void> saveCredentials({
    required String username,
    String? password,
  }) async {
    final String? passwordKey = await _encryptUserPasswordUseCase.decrypt();
    final String userNameEncrypted = await _securityEncrypterUseCase.encrypt(
      password: passwordKey!,
      data: username,
    );
    final String? passwordEncrypted = password == null
        ? null
        : await _securityEncrypterUseCase.encrypt(
            password: passwordKey,
            data: password,
          );
    return _userAuthStorageService.saveCredentials(
      username: userNameEncrypted,
      password: passwordEncrypted,
    );
  }

  @override
  Future<Map<String, String?>> getCredentials() async {
    final Map<String, String?> encrypted = await _userAuthStorageService
        .getCredentials();
    final String? passwordKey = await _encryptUserPasswordUseCase.decrypt();
    final Map<String, String?> credentials = {};
    for (final entry in encrypted.entries) {
      if (entry.value != null) {
        try {
          credentials[entry.key] = await _securityEncrypterUseCase.decrypt(
            password: passwordKey!,
            data: entry.value!,
          );
        } catch (_) {
          credentials[entry.key] = null;
        }
      }
    }
    return credentials;
  }

  @override
  Future<void> clearCredentials() async {
    return _userAuthStorageService.clearCredentials();
  }

  @override
  Future<void> saveSessionToken(String token) async {
    final String? passwordKey = await _encryptUserPasswordUseCase.decrypt();
    final String tokenEncrypted = await _securityEncrypterUseCase.encrypt(
      password: passwordKey!,
      data: token,
    );
    return _userAuthStorageService.saveSessionToken(tokenEncrypted);
  }

  @override
  Future<void> clearSessionToken() {
    return _userAuthStorageService.clearSessionToken();
  }

  @override
  Future<String?> getSessionToken() async {
    final String? tokenEncrypted = await _userAuthStorageService
        .getSessionToken();
    if (tokenEncrypted == null) return null;

    try {
      final String? passwordKey = await _encryptUserPasswordUseCase.decrypt();
      if (passwordKey == null) return null;

      final String token = await _securityEncrypterUseCase.decrypt(
        password: passwordKey,
        data: tokenEncrypted,
      );
      return token;
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      return null;
    }
  }

  @override
  Future<void> saveUserData(UserEntity user) {
    return _userAuthStorageService.saveUserData(user);
  }

  @override
  Future<void> clearUserData() {
    return _userAuthStorageService.clearUserData();
  }

  @override
  Future<UserEntity?> getUserData() {
    return _userAuthStorageService.getUserData();
  }
}
