import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class GetCurrentPointsUseCase extends UseCase {
  Future<List<CheckDayPointEntity>> call({
    required int month,
    required int year,
  });
}

class GetCurrentPointsUseCaseImpl implements GetCurrentPointsUseCase {
  final CheckPointService _checkPointService;

  GetCurrentPointsUseCaseImpl({required this._checkPointService});

  @override
  Future<List<CheckDayPointEntity>> call({
    required int month,
    required int year,
  }) async {
    List<CheckDayPointEntity> results = await _checkPointService.currentPoints(
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
