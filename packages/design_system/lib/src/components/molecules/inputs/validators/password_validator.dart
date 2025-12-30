import 'package:dependency/dependency.dart';

mixin PasswordValidator {
  String? passwordValidator(String? input) {
    if (input?.trim().isEmpty ?? true) {
      return 'password_input_empty_error'.tr;
    }
    return null;
  }
}
