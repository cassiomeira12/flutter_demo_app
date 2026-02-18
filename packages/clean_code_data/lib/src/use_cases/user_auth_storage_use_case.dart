import 'dart:convert';

import 'package:core/core.dart';

class UserAuthStorageUseCaseImpl implements UserAuthStorageUseCase {
  final UserAuthStorageService _userAuthStorageService;
  final EncryptUserPasswordUseCase _encryptUserPasswordUseCase;
  final SecurityEncryptUseCase _securityEncrypterUseCase;

  UserAuthStorageUseCaseImpl({
    required UserAuthStorageService userAuthStorageService,
    required EncryptUserPasswordUseCase encryptUserPasswordUseCase,
    required SecurityEncryptUseCase securityEncrypterUseCase,
  }) : _userAuthStorageService = userAuthStorageService,
       _encryptUserPasswordUseCase = encryptUserPasswordUseCase,
       _securityEncrypterUseCase = securityEncrypterUseCase;

  @override
  Future<void> saveCredentials({
    required String username,
    String? password,
  }) async {
    final String? passwordKey = await _encryptUserPasswordUseCase.decrypt();
    final String userNameEncrypted = _securityEncrypterUseCase.encrypt(
      password: passwordKey!,
      data: username,
    );
    final String? passwordEncrypted = password == null
        ? null
        : _securityEncrypterUseCase.encrypt(
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
          credentials[entry.key] = _securityEncrypterUseCase.decrypt(
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
    final String tokenEncrypted = _securityEncrypterUseCase.encrypt(
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
    if (tokenEncrypted != null) {
      try {
        final String? passwordKey = await _encryptUserPasswordUseCase.decrypt();
        if (passwordKey == null) return null;
        final String token = _securityEncrypterUseCase.decrypt(
          password: passwordKey,
          data: tokenEncrypted,
        );
        return token;
      } catch (error, stackTrace) {
        Log.error(error.toString(), error: error, stackTrace: stackTrace);
        return null;
      }
    }
    return tokenEncrypted;
  }

  @override
  Future<void> saveUserData(Map<String, dynamic> data) async {
    final String? passwordKey = await _encryptUserPasswordUseCase.decrypt();
    final String json = jsonEncode(data);
    final String jsonEncrypted = _securityEncrypterUseCase.encrypt(
      password: passwordKey!,
      data: json,
    );
    return _userAuthStorageService.saveUserData(jsonEncrypted);
  }

  @override
  Future<void> clearUserData() {
    return _userAuthStorageService.clearUserData();
  }

  @override
  Future<Map<String, dynamic>?> getUserData() async {
    final String? jsonEncrypted = await _userAuthStorageService.getUserData();
    if (jsonEncrypted != null) {
      final String? passwordKey = await _encryptUserPasswordUseCase.decrypt();
      if (passwordKey == null) return null;
      try {
        final String json = _securityEncrypterUseCase.decrypt(
          password: passwordKey,
          data: jsonEncrypted,
        );
        final Map<String, dynamic> data = jsonDecode(json);
        return data;
      } catch (error, stackTrace) {
        Log.error(error.toString(), error: error, stackTrace: stackTrace);
        throw InvalidTokenException();
      }
    }
    return null;
  }
}
