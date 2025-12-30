abstract class SafetyContactDataSource {
  Future<Map<String, dynamic>> create({
    required String name,
    required String phoneNumber,
    required bool sendMessage,
  });

  Future<List<Map<String, dynamic>>> list(int page);

  Future<bool> delete(String objectId);
}
