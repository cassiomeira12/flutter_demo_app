import 'package:dependency/dependency.dart';

mixin UrlValidator {
  String? urlValidator(String? input) {
    if (input?.trim().isEmpty ?? true) {
      return null;
    }
    final emailRegex = RegExp(
      r'^(https?:\/\/)'
      '((localhost)|'
      r'((\d{1,3}\.){3}\d{1,3})|'
      r'(([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}))'
      r'(:\d{1,5})?'
      r'(\/[^\s]*)?$',
      caseSensitive: false,
    );
    if (emailRegex.hasMatch(input!)) return null;
    return 'url_input_invalid_error'.tr;
  }
}
