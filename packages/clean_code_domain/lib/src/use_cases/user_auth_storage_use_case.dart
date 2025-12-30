abstract class UserAuthStorageUseCase {
  Future<void> saveCredentials({required String username, String? password});

  Future<Map<String, String?>> getCredentials();

  Future<void> clearCredentials();

  Future<void> saveSessionToken(String token);

  Future<void> clearSessionToken();

  Future<String?> getSessionToken();

  Future<void> saveUserData(Map<String, dynamic> data);

  Future<void> clearUserData();

  Future<Map<String, dynamic>?> getUserData();
}
