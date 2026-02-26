import 'package:flutter_demo_app/domain/domain.dart';

abstract class UpdateHourPointUseCase {
  Future<CheckDayPointEntity> call({
    required CheckHourPointEntity checkHourPoint,
    required String time,
  });
}
