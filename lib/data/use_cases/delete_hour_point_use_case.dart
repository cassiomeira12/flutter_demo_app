import 'package:flutter_demo_app/domain/domain.dart';

class DeleteHourPointUseCaseImpl implements DeleteHourPointUseCase {
  final CheckPointService _service;

  DeleteHourPointUseCaseImpl({
    required CheckPointService checkPointService,
  }) : _service = checkPointService;

  @override
  Future<CheckDayPointEntity> call({
    required CheckHourPointEntity checkHourPoint,
  }) {
    return _service.deleteHourPoint(checkHourPoint);
  }
}
