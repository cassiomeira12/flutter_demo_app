import 'package:security/src/domain/domain.dart';

class AuthenticateBiometricUseCaseImpl implements AuthenticateBiometricUseCase {
  final LocalAuthService _service;

  AuthenticateBiometricUseCaseImpl({required LocalAuthService localAuthService})
    : _service = localAuthService;

  @override
  Future<bool> call() => _service.authenticate();
}
