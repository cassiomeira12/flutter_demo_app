import 'package:clean_code_domain/clean_code_domain.dart';
import 'package:login/src/domain/domain.dart';

abstract class RecoveryPasswordUseCase
    extends BaseUseCaseAsyncParam<void, String> {}

class RecoveryPasswordUseCaseImpl implements RecoveryPasswordUseCase {
  final RecoveryPasswordService _recoveryPasswordService;

  RecoveryPasswordUseCaseImpl({required this._recoveryPasswordService});

  @override
  Future<void> call(String email) {
    return _recoveryPasswordService.recoveryPassword(email);
  }
}
