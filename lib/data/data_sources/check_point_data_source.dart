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
}
