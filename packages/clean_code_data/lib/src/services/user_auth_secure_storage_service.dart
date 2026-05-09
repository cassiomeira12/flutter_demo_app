import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class UserAuthSecureStorageImpl implements UserAuthStorageService {
  final SecureStorageUseCase _secureStorageUseCase;

  UserAuthSecureStorageImpl({required SecureStorageUseCase storageUseCase})
    : _secureStorageUseCase = storageUseCase;

  @override
  Future<void> saveCredentials({
    required String username,
    String? password,
  }) async {
    try {
      await _secureStorageUseCase.set<String>(USERNAME, username);
      if (password == null) {
        await _secureStorageUseCase.delete(PASSWORD);
        return;
      }
      await _secureStorageUseCase.set<String>(PASSWORD, password);
    } on MissingPluginException {
      return;
    }
  }

  @override
  Future<Map<String, String?>> getCredentials() async {
    String? username;
    String? password;
    try {
      username = await _secureStorageUseCase.get<String>(USERNAME);
    } on MissingPluginException {
      //
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
    try {
      password = await _secureStorageUseCase.get<String>(PASSWORD);
    } on MissingPluginException {
      //
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
    return {'username': username, 'password': password};
  }

  @override
  Future<void> clearCredentials() async {
    try {
      await _secureStorageUseCase.delete(USERNAME);
      await _secureStorageUseCase.delete(PASSWORD);
    } on MissingPluginException {
      return;
    }
  }

  @override
  Future<void> saveSessionToken(String token) async {
    try {
      await _secureStorageUseCase.set(SESSION_TOKEN, token);
    } on MissingPluginException {
      return;
    }
  }

  @override
  Future<void> clearSessionToken() async {
    try {
      await _secureStorageUseCase.delete(SESSION_TOKEN);
    } on MissingPluginException {
      return;
    }
  }

  @override
  Future<String?> getSessionToken() async {
    try {
      return await _secureStorageUseCase.get<String>(SESSION_TOKEN);
    } on MissingPluginException {
      return null;
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      return null;
    }
  }

  @override
  Future<void> saveUserData(String data) async {
    try {
      await _secureStorageUseCase.set<String>(USER_DATA, data);
    } on MissingPluginException {
      return;
    }
  }

  @override
  Future<void> clearUserData() async {
    try {
      await _secureStorageUseCase.delete(USER_DATA);
    } on MissingPluginException {
      return;
    }
  }

  @override
  Future<String?> getUserData() async {
    try {
      return await _secureStorageUseCase.get<String>(USER_DATA);
    } on MissingPluginException {
      return null;
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      return null;
    }
  }
}
