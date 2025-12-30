import 'package:flutter_demo_app/domain/domain.dart';

abstract class GetCurrentPointsUseCase {
  Future<List<CheckDayPointEntity>> call({
    required int month,
    required int year,
  });
}
