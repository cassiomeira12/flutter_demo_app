import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class UserAuthLocalStorageServiceImpl implements UserAuthStorageService {
  final LocalStorageUseCase _localStorageUseCase;

  UserAuthLocalStorageServiceImpl({required this._localStorageUseCase});

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
  Future<void> saveUserData(UserEntity user) async {
    final userJson = user.toMap();
    final data = jsonEncode(userJson);
    await _localStorageUseCase.set<String>(USER_DATA, data);
  }

  @override
  Future<void> clearUserData() async {
    await _localStorageUseCase.delete(USER_DATA);
  }

  @override
  Future<UserEntity?> getUserData() async {
    final String? data = await _localStorageUseCase.get<String>(USER_DATA);
    if (data == null) return null;
    final userJson = jsonDecode(data);
    return UserModel.fromMap(userJson);
  }
}
