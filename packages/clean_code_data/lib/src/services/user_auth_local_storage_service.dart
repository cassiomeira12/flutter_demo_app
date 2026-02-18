import 'package:core/core.dart';

class UserAuthLocalStorageServiceImpl implements UserAuthStorageService {
  final LocalStorageUseCase _localStorageUseCase;

  UserAuthLocalStorageServiceImpl({
    required LocalStorageUseCase localStorageUseCase,
  }) : _localStorageUseCase = localStorageUseCase;

  @override
  Future<void> saveCredentials({
    required String username,
    String? password,
  }) async {
    await _localStorageUseCase.set<String>(USERNAME, username);
    if (password == null) {
      await _localStorageUseCase.delete(PASSWORD);
      return;
    }
    await _localStorageUseCase.set<String>(PASSWORD, password);
  }

  @override
  Future<Map<String, String?>> getCredentials() async {
    final String? username = await _localStorageUseCase.get<String>(USERNAME);
    final String? password = await _localStorageUseCase.get<String>(PASSWORD);
    return {'username': username, 'password': password};
  }

  @override
  Future<void> clearCredentials() async {
    await _localStorageUseCase.delete(USERNAME);
    await _localStorageUseCase.delete(PASSWORD);
  }

  @override
  Future<void> saveSessionToken(String token) async {
    await _localStorageUseCase.set(SESSION_TOKEN, token);
  }

  @override
  Future<void> clearSessionToken() async {
    await _localStorageUseCase.delete(SESSION_TOKEN);
  }

  @override
  Future<String?> getSessionToken() async {
    return await _localStorageUseCase.get<String>(SESSION_TOKEN);
  }

  @override
  Future<void> saveUserData(String data) async {
    await _localStorageUseCase.set<String>(USER_DATA, data);
  }

  @override
  Future<void> clearUserData() async {
    await _localStorageUseCase.delete(USER_DATA);
  }

  @override
  Future<String?> getUserData() async {
    return await _localStorageUseCase.get<String>(USER_DATA);
  }
}
