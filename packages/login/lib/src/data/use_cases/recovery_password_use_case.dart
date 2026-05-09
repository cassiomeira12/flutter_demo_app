import 'package:login/src/domain/domain.dart';

class RecoveryPasswordUseCaseImpl implements RecoveryPasswordUseCase {
  final RecoveryPasswordService _service;

  RecoveryPasswordUseCaseImpl({
    required RecoveryPasswordService recoveryPasswordService,
  }) : _service = recoveryPasswordService;

  @override
  Future<void> call(String email) {
    return _service.recoveryPassword(email);
  }
}
