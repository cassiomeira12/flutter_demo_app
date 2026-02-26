abstract class CheckPointDataSource {
  Future<List<Map<String, dynamic>>> currentPoints({
    required int month,
    required int year,
  });

  Future<void> registerPoint();

  Future<String> totalHours({
    required int month,
    required int year,
  });

  Future<Map<String, dynamic>> updateWorkPoint(
    String objectId, {
    required String? time,
  });

  Future<Map<String, dynamic>> registerCustomPoint({
    required int day,
    required int month,
    required int year,
    required String? time,
  });

  Future<Map<String, dynamic>> updateWorkDay({
    required int day,
    required int month,
    required int year,
    bool allowance = false,
    bool holiday = false,
    bool dayOff = false,
    required String info,
  });
}
