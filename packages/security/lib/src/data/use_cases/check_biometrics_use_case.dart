import 'package:security/src/domain/domain.dart';

class CheckBiometricsUseCaseImpl implements CheckBiometricsUseCase {
  final LocalAuthService _service;

  CheckBiometricsUseCaseImpl({required LocalAuthService localAuthService})
    : _service = localAuthService;

  @override
  Future<bool> call() {
    return _service.isDeviceSupported();
  }
}
