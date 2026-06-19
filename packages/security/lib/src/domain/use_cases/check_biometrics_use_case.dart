import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:security/src/domain/domain.dart';

class CheckBiometricsUseCase implements BaseUseCaseAsync {
  final LocalAuthService _localAuthService;

  CheckBiometricsUseCase({required this._localAuthService});

  @override
  Future<bool> call() {
    return _localAuthService.isDeviceSupported();
  }
}
