import 'package:flutter_demo_app/domain/domain.dart';

abstract class DeleteHourPointUseCase {
  Future<CheckDayPointEntity> call({
    required CheckHourPointEntity checkHourPoint,
  });
}
