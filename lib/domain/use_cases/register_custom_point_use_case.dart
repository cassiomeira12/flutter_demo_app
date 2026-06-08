import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class RegisterCustomPointUseCase extends UseCase {
  Future<CheckDayPointEntity> call({
    required int day,
    required int month,
    required int year,
    required String time,
  });
}

class RegisterCustomPointUseCaseImpl implements RegisterCustomPointUseCase {
  final CheckPointService _service;

  RegisterCustomPointUseCaseImpl({
    required CheckPointService checkPointService,
  }) : _service = checkPointService;

  @override
  Future<CheckDayPointEntity> call({
    required int day,
    required int month,
    required int year,
    required String time,
  }) {
    return _service.registerCustomPoint(
      day: day,
      month: month,
      year: year,
      time: time,
    );
  }
}
