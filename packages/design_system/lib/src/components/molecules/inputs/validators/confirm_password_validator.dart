import 'package:dependency/dependency.dart';

mixin ConfirmPasswordValidator {
  String? confirmPasswordValidator(String? input, {String? password}) {
    if (input?.trim().isEmpty ?? true) {
      return 'password_input_empty_error'.tr;
    }
    if (input != password) {
      return 'password_not_equals_error'.tr;
    }
    return null;
  }
}
