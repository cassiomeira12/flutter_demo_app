import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class GetTotalHoursAppUseCase extends UseCase {
  Future<String> call({required int month, required int year});
}

class GetTotalHoursAppUseCaseImpl implements GetTotalHoursAppUseCase {
  final CheckPointService _checkPointService;

  GetTotalHoursAppUseCaseImpl({required this._checkPointService});

  @override
  Future<String> call({
    required int month,
    required int year,
  }) {
    return _checkPointService.totalHours(month: month, year: year);
  }
}
