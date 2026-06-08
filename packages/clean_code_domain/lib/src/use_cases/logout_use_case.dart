import 'package:clean_code_domain/clean_code_domain.dart';

abstract class LogoutUseCase extends BaseUseCaseAsync<void> {}

class LogoutUseCaseImpl implements LogoutUseCase {
  final LogoutService _service;

  LogoutUseCaseImpl({
    required LogoutService logoutService,
  }) : _service = logoutService;

  @override
  Future<void> call() async {
    await _service.logout();
  }
}
