import 'package:flutter_demo_app/domain/domain.dart';

abstract class RegisterCustomPointUseCase {
  Future<CheckDayPointEntity> call({
    required int day,
    required int month,
    required int year,
    required String time,
  });
}
