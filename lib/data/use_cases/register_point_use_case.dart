import 'package:flutter_demo_app/domain/domain.dart';

class RegisterPointUseCaseImpl implements RegisterPointUseCase {
  final CheckPointService _service;

  RegisterPointUseCaseImpl({
    required CheckPointService checkPointService,
  }) : _service = checkPointService;

  @override
  Future<void> call() {
    return _service.registerPoint();
  }
}
