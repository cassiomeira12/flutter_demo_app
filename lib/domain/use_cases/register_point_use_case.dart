import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class RegisterPointUseCase extends BaseUseCaseAsync<void> {}

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
