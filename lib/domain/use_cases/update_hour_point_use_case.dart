import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class UpdateHourPointUseCase extends UseCase {
  Future<CheckDayPointEntity> call({
    required CheckHourPointEntity checkHourPoint,
    required String time,
  });
}

class UpdateHourPointUseCaseImpl implements UpdateHourPointUseCase {
  final CheckPointService _service;

  UpdateHourPointUseCaseImpl({
    required CheckPointService checkPointService,
  }) : _service = checkPointService;

  @override
  Future<CheckDayPointEntity> call({
    required CheckHourPointEntity checkHourPoint,
    required String time,
  }) {
    return _service.updateHourPoint(checkHourPoint, time: time);
  }
}
