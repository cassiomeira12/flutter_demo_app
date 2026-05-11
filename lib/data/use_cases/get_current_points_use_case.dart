import 'package:flutter_demo_app/domain/domain.dart';

class GetCurrentPointsUseCaseImpl implements GetCurrentPointsUseCase {
  final CheckPointService _service;

  GetCurrentPointsUseCaseImpl({
    required CheckPointService checkPointService,
  }) : _service = checkPointService;

  @override
  Future<List<CheckDayPointEntity>> call({
    required int month,
    required int year,
  }) async {
    List<CheckDayPointEntity> results = await _service.currentPoints(
      month: month,
      year: year,
    );

    final today = DateTime.now();
    if (today.year == year && today.month == month) {
      results = results.where((item) => item.day <= today.day + 1).toList();
    }

    return results.reversed.toList();
  }
}
