import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';

class UserAuthSecureStorageImpl implements UserAuthStorageService {
  final SecureStorageUseCase _secureStorageUseCase;

  UserAuthSecureStorageImpl({required SecureStorageUseCase storageUseCase})
    : _secureStorageUseCase = storageUseCase;

  @override
  Future<void> saveCredentials({
    required String username,
    String? password,
  }) async {
    await _secureStorageUseCase.set<String>(USERNAME, username);
    if (password == null) {
      await _secureStorageUseCase.delete(PASSWORD);
      return;
    }
    await _secureStorageUseCase.set<String>(PASSWORD, password);
  }

  @override
  Future<Map<String, String?>> getCredentials() async {
    final String? username = await _secureStorageUseCase.get<String>(USERNAME);
    final String? password = await _secureStorageUseCase.get<String>(PASSWORD);
    return {'username': username, 'password': password};
  }

  @override
  Future<void> clearCredentials() async {
    await _secureStorageUseCase.delete(USERNAME);
    await _secureStorageUseCase.delete(PASSWORD);
  }

  @override
  Future<void> saveSessionToken(String token) async {
    await _secureStorageUseCase.set(SESSION_TOKEN, token);
  }

  @override
  Future<void> clearSessionToken() async {
    await _secureStorageUseCase.delete(SESSION_TOKEN);
  }

  @override
  Future<String?> getSessionToken() async {
    return await _secureStorageUseCase.get<String>(SESSION_TOKEN);
  }

  @override
  Future<void> saveUserData(String data) async {
    await _secureStorageUseCase.set<String>(USER_DATA, data);
  }

  @override
  Future<void> clearUserData() async {
    await _secureStorageUseCase.delete(USER_DATA);
  }

  @override
  Future<String?> getUserData() async {
    return await _secureStorageUseCase.get<String>(USER_DATA);
  }
}
