abstract class UserAuthStorageService {
  Future<void> saveCredentials({required String username, String? password});

  Future<Map<String, String?>> getCredentials();

  Future<void> clearCredentials();

  Future<void> saveSessionToken(String token);

  Future<void> clearSessionToken();

  Future<String?> getSessionToken();

  Future<void> saveUserData(String data);

  Future<void> clearUserData();

  Future<String?> getUserData();
}
