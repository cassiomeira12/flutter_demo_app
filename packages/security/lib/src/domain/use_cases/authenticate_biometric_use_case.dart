import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:security/src/domain/domain.dart';

class AuthenticateBiometricUseCase implements BaseUseCaseAsync {
  final LocalAuthService _localAuthService;

  AuthenticateBiometricUseCase({required this._localAuthService});

  @override
  Future<bool> call() => _localAuthService.authenticate();
}
