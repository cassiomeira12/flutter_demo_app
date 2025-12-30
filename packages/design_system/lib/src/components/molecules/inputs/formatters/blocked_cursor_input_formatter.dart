import 'package:flutter/services.dart';

class BlockedCursorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newValueReplaced = newValue.text;
    if (newValueReplaced.length > 1) {
      String value = newValueReplaced.substring(
        0,
        newValueReplaced.length - 1,
      );
      value += '-${newValueReplaced[newValueReplaced.length - 1]}';
      return newValue.copyWith(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
    return newValue.copyWith(
      text: newValueReplaced,
      selection: TextSelection.collapsed(offset: newValueReplaced.length),
    );
  }
}
