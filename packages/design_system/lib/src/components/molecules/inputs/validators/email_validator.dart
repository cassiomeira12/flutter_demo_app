import 'package:dependency/dependency.dart';

mixin EmailValidator {
  String? emailValidator(String? input) {
    if (input?.trim().isEmpty ?? true) {
      return 'email_input_empty_error'.tr;
    }
    final emailRegex = RegExp(
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
    );
    if (emailRegex.hasMatch(input!)) return null;
    return 'email_input_invalid_error'.tr;
  }
}
