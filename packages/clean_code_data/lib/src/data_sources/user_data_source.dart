abstract class UserDataSource {
  Future<Map<String, dynamic>> getUserData();

  Future<void> updateUserData({
    required String objectId,
    required Map<String, dynamic> data,
  });

  Future<void> deleteUser({required String reason});

  Future<Map<String, dynamic>> changePassword({
    required String username,
    required String currentPassword,
    required String newPassword,
  });
}
