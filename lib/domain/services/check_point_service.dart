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
}
