import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:login/src/domain/domain.dart';

class RecoveryPasswordController extends BaseController {
  final RecoveryPasswordUseCase _recoveryPasswordUseCase;

  RecoveryPasswordController({
    required RecoveryPasswordUseCase recoveryPasswordUseCase,
  }) : _recoveryPasswordUseCase = recoveryPasswordUseCase;

  Future<void> recoveryPassword({required String email}) async {
    clickTagging(component: 'recovery_password_button_key');
    await _recoveryPasswordUseCase(email);
  }

  String? emailValidator(String? input) {
    if (input?.trim().isEmpty ?? true) {
      return 'username_input_empty_error'.tr;
    }
    return null;
  }
}
