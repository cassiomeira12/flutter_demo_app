import 'package:flutter_demo_app/domain/domain.dart';

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
