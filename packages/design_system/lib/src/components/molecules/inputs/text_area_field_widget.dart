// ignore_for_file: must_be_immutable

import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class TextAreaFieldWidget extends StatefulWidget {
  final Key? customKey;
  final String? label;
  final bool enabled;
  final bool readOnly;
  final String? hintText;
  final TextEditingController? controller;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int maxLength;
  final int maxLines;

  const TextAreaFieldWidget({
    super.key,
    this.customKey,
    this.label,
    this.enabled = true,
    this.readOnly = false,
    this.hintText,
    this.controller,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.maxLength = 25,
    this.maxLines = 3,
  });

  @override
  State<TextAreaFieldWidget> createState() => _TextAreaFieldWidgetState();
}

class _TextAreaFieldWidgetState extends State<TextAreaFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      customKey: widget.customKey,
      label: widget.label,
      hintText: widget.hintText,
      controller: widget.controller,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      validator: widget.validator,
      onChanged: widget.onChanged,
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: widget.inputFormatters,
      textAlign: widget.textAlign,
    );
  }
}
