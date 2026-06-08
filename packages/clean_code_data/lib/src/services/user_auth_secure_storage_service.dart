import 'package:clean_code_data/clean_code_data.dart';
import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class UserAuthSecureStorageImpl implements UserAuthStorageService {
  final SecureStorageUseCase _secureStorageUsecase;
  final EncryptUserPasswordUseCase _encryptUserPasswordUseCase;
  final SecurityEncryptUseCase _securityEncrypterUseCase;

  UserAuthSecureStorageImpl({
    required this._secureStorageUsecase,
    required this._encryptUserPasswordUseCase,
    required this._securityEncrypterUseCase,
  });

  @override
  Future<void> saveCredentials({
    required String username,
    String? password,
  }) async {
    try {
      await _secureStorageUsecase.set<String>(USERNAME, username);
      if (password == null) {
        await _secureStorageUsecase.delete(PASSWORD);
        return;
      }
      await _secureStorageUsecase.set<String>(PASSWORD, password);
    } on MissingPluginException {
      return;
    }
  }

  @override
  Future<Map<String, String?>> getCredentials() async {
    String? username;
    String? password;
    try {
      username = await _secureStorageUsecase.get<String>(USERNAME);
    } on MissingPluginException {
      //
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
    }
    try {
      password = await _secureStorageUsecase.get<String>(PASSWORD);
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
      await _secureStorageUsecase.delete(USERNAME);
      await _secureStorageUsecase.delete(PASSWORD);
    } on MissingPluginException {
      return;
    }
  }

  @override
  Future<void> saveSessionToken(String token) async {
    try {
      await _secureStorageUsecase.set(SESSION_TOKEN, token);
    } on MissingPluginException {
      return;
    }
  }

  @override
  Future<void> clearSessionToken() async {
    try {
      await _secureStorageUsecase.delete(SESSION_TOKEN);
    } on MissingPluginException {
      return;
    }
  }

  @override
  Future<String?> getSessionToken() async {
    try {
      return await _secureStorageUsecase.get<String>(SESSION_TOKEN);
    } on MissingPluginException {
      return null;
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      return null;
    }
  }

  @override
  Future<void> saveUserData(UserEntity user) async {
    final String? passwordKey = await _encryptUserPasswordUseCase.decrypt();
    final String json = jsonEncode(user.toMap());
    final String jsonEncrypted = await _securityEncrypterUseCase.encrypt(
      password: passwordKey!,
      data: json,
    );

    try {
      await _secureStorageUsecase.set<String>(USER_DATA, jsonEncrypted);
    } on MissingPluginException {
      return;
    }
  }

  @override
  Future<void> clearUserData() async {
    try {
      await _secureStorageUsecase.delete(USER_DATA);
    } on MissingPluginException {
      return;
    }
  }

  @override
  Future<UserEntity?> getUserData() async {
    try {
      final String? jsonEncrypted = await _secureStorageUsecase.get<String>(
        USER_DATA,
      );
      if (jsonEncrypted == null) return null;

      try {
        final String? passwordKey = await _encryptUserPasswordUseCase.decrypt();
        if (passwordKey == null) return null;

        final String json = await _securityEncrypterUseCase.decrypt(
          password: passwordKey,
          data: jsonEncrypted,
        );

        final Map<String, dynamic> data = jsonDecode(json);

        return UserModel.fromMap(data);
      } catch (error, stackTrace) {
        Log.error(error, stackTrace);
        throw InvalidTokenException();
      }
    } on MissingPluginException {
      return null;
    } catch (error, stackTrace) {
      Log.error(error, stackTrace);
      return null;
    }
  }
}
