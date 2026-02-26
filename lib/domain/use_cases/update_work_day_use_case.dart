import 'package:flutter_demo_app/domain/domain.dart';

abstract class UpdateWorkDayUseCase {
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
