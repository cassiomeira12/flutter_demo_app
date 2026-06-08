import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class UpdateWorkDayUseCase extends UseCase {
  Future<CheckDayPointEntity> call({
    required int day,
    required int month,
    required int year,
    bool allowance = false,
    bool holiday = false,
    bool dayOff = false,
    required String info,
  });
}

class UpdateWorkDayUseCaseImpl implements UpdateWorkDayUseCase {
  final CheckPointService _service;

  UpdateWorkDayUseCaseImpl({
    required CheckPointService checkPointService,
  }) : _service = checkPointService;

  @override
  Future<CheckDayPointEntity> call({
    required int day,
    required int month,
    required int year,
    bool allowance = false,
    bool holiday = false,
    bool dayOff = false,
    required String info,
  }) {
    return _service.updateWorkDay(
      day: day,
      month: month,
      year: year,
      allowance: allowance,
      holiday: holiday,
      dayOff: dayOff,
      info: info,
    );
  }
}
