import 'package:core/core.dart';
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:login/src/domain/domain.dart';

class RecoveryPasswordController extends BaseController with EmailValidator {
  final RecoveryPasswordUseCase _recoveryPasswordUseCase;

  RecoveryPasswordController({required this._recoveryPasswordUseCase});

  Future<void> recoveryPassword({required String email}) async {
    clickTagging(component: 'recovery_password_button_key');
    await _recoveryPasswordUseCase.call(email);
  }
}
