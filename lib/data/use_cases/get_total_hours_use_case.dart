import 'package:flutter_demo_app/domain/domain.dart';

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
