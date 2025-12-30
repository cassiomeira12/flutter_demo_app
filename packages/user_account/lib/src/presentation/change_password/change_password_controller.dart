import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class ChangePasswordController extends BaseController
    with PasswordValidator, ConfirmPasswordValidator {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordController({
    required ChangePasswordUseCase changePasswordUseCase,
  }) : _changePasswordUseCase = changePasswordUseCase;

  final UserEntity _user = AppBinding.find<UserEntity>();

  String? newPasswordValidator(String? input, {String? currentPassword}) {
    final String? invalid = passwordValidator(input);
    if (invalid != null) {
      return invalid;
    }
    if (input == currentPassword) {
      return 'new_password_not_be_equal_old_password'.tr;
    }
    return null;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final String username = _user.email;
    await _changePasswordUseCase.call(
      username: username,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
