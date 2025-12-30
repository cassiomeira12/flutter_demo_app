abstract class EmergencyDataSource {
  Future<bool> isAvailable();

  Future<int> sendSOS({
    required int choice,
    required double latitude,
    required double longitude,
    required int accuracy,
  });

  Future<List<Map<String, dynamic>>> listHistory();

  Future<Map<String, dynamic>> changeSOSConfig({
    required bool onlyPolice,
    required bool onlySafetyContacts,
  });
}
