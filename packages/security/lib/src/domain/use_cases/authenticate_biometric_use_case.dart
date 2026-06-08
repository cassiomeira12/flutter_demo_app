import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:security/src/domain/domain.dart';

class AuthenticateBiometricUseCase implements BaseUseCaseAsync {
  final LocalAuthService _service;

  AuthenticateBiometricUseCase({
    required LocalAuthService localAuthService,
  }) : _service = localAuthService;

  @override
  Future<bool> call() => _service.authenticate();
}
