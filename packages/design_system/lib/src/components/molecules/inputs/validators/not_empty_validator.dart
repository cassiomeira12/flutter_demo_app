import 'package:dependency/dependency.dart';

mixin NotEmptyValidator {
  String? notEmptyValidator(String? input) {
    if (input?.trim().isEmpty ?? true) {
      return 'Este campo não pode ser vazio'.tr;
    }
    return null;
  }
}
