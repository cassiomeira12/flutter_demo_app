import 'package:clean_code_domain/clean_code_domain.dart';

abstract class LogoutUseCase extends BaseUseCaseAsync<void> {}

class LogoutUseCaseImpl implements LogoutUseCase {
  final LogoutService _logoutService;

  LogoutUseCaseImpl({required this._logoutService});

  @override
  Future<void> call() {
    return _logoutService.logout();
  }
}
