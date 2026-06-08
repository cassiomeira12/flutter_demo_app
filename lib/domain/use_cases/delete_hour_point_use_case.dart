import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class DeleteHourPointUseCase
    extends BaseUseCaseAsyncParam<CheckDayPointEntity, CheckHourPointEntity> {}

class DeleteHourPointUseCaseImpl implements DeleteHourPointUseCase {
  final CheckPointService _service;

  DeleteHourPointUseCaseImpl({
    required CheckPointService checkPointService,
  }) : _service = checkPointService;

  @override
  Future<CheckDayPointEntity> call(CheckHourPointEntity checkHourPoint) {
    return _service.deleteHourPoint(checkHourPoint);
  }
}
