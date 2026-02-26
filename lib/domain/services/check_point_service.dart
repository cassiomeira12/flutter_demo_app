import 'package:flutter_demo_app/domain/domain.dart';

abstract class CheckPointService {
  Future<List<CheckDayPointEntity>> currentPoints({
    required int month,
    required int year,
  });

  Future<void> registerPoint();

  Future<String> totalHours({
    required int month,
    required int year,
  });

  Future<CheckDayPointEntity> updateWorkDay({
    required int day,
    required int month,
    required int year,
    bool allowance = false,
    bool holiday = false,
    bool dayOff = false,
    required String info,
  });

  Future<CheckDayPointEntity> updateHourPoint(
    CheckHourPointEntity checkHourPoint, {
    required String time,
  });

  Future<CheckDayPointEntity> deleteHourPoint(
    CheckHourPointEntity checkHourPoint,
  );

  Future<CheckDayPointEntity> registerCustomPoint({
    required int day,
    required int month,
    required int year,
    required String time,
  });
}
