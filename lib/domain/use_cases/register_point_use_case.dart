import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:flutter_demo_app/domain/domain.dart';

abstract class RegisterPointUseCase extends BaseUseCaseAsync {}

class RegisterPointUseCaseImpl implements RegisterPointUseCase {
  final CheckPointService _checkPointService;

  RegisterPointUseCaseImpl({required this._checkPointService});

  @override
  Future<void> call() {
    return _checkPointService.registerPoint();
  }
}
