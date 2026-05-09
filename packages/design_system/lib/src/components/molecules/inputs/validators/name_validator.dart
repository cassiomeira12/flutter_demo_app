import 'package:dependency/dependency.dart';

mixin NameValidator {
  String? nameValidator(String? input) {
    if (input?.trim().isEmpty ?? true) {
      return 'name_input_empty_error'.tr;
    }
    return null;
  }
}
