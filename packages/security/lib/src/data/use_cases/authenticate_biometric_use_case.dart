import '../../domain/domain.dart';

class AuthenticateBiometricUseCaseImpl implements AuthenticateBiometricUseCase {
  final LocalAuthService _repository;

  AuthenticateBiometricUseCaseImpl({required LocalAuthService localAuthService})
    : _repository = localAuthService;

  @override
  Future<bool> call() {
    return _repository.authenticate();
  }
}
