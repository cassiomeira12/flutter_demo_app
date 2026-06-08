import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:security/src/domain/domain.dart';

class CheckBiometricsUseCase implements BaseUseCaseAsync {
  final LocalAuthService _service;

  CheckBiometricsUseCase({
    required LocalAuthService localAuthService,
  }) : _service = localAuthService;

  @override
  Future<bool> call() {
    return _service.isDeviceSupported();
  }
}
