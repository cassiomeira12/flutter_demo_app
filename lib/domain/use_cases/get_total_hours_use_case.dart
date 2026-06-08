import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class GetTotalHoursAppUseCase extends UseCase {
  Future<String> call({required int month, required int year});
}

class GetTotalHoursAppUseCaseImpl implements GetTotalHoursAppUseCase {
  final CheckPointService _service;

  GetTotalHoursAppUseCaseImpl({
    required CheckPointService checkPointService,
  }) : _service = checkPointService;

  @override
  Future<String> call({
    required int month,
    required int year,
  }) {
    return _service.totalHours(month: month, year: year);
  }
}
