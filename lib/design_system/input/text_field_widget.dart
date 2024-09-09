// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../colors/app_color.dart';
import '../text/text_style.dart';

class TextFieldWidget extends StatefulWidget {
  final Key? customKey;
  final String? label;
  final TextStyle? labelStyle;
  final bool? enabled;
  final bool? readOnly;
  final String? hintText;
  final bool autoFocus;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final TextAlign textAlign;
  TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextStyle textStyle;
  final Color? textColor;
  final double? textSize;
  final TextStyle hintTextStyle;
  final Color? hintColor;
  final Widget? suffixIcon;
  final Color? cursorColor;
  final Widget? prefixIcon;
  final ValueChanged<String>? onSubmittedFunction;
  final FocusNode? focusNode;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapOutside;
  final int? maxLength;
  final ValueChanged<String>? onSearch;

  //
  final InputBorder? disabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;

  TextFieldWidget({
    super.key,
    this.customKey,
    this.label,
    this.labelStyle,
    this.enabled,
    this.readOnly,
    this.hintText,
    this.autoFocus = false,
    this.controller,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.textAlign = TextAlign.start,
    this.textCapitalization,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.textStyle = const TextStyle(), //.body3R(),
    this.textColor,
    this.textSize,
    this.hintTextStyle = const TextStyle(), //.body3R(),
    this.hintColor,
    this.suffixIcon,
    this.cursorColor,
    this.prefixIcon,
    this.onSubmittedFunction,
    this.focusNode,
    this.onTap,
    this.onTapOutside,
    this.maxLength,
    this.disabledBorder,
    this.focusedBorder,
    this.enabledBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.onSearch,
  }) {
    if (obscureText || keyboardType == TextInputType.emailAddress) {
      textCapitalization = TextCapitalization.none;
    }
  }

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool _showObscureText = false;
  late FocusNode _focusNode;
  Timer? _debounce;
  final int _delayTime = 1000;

  String textSearched = '';
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _showObscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_focusListener);
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_focusListener);
    _controller.removeListener(_onSearchChanged);
    _focusNode.dispose();
    _controller.dispose();
  }

  void _focusListener() {
    if (!_focusNode.hasFocus) {
      widget.onTapOutside?.call();
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    if (_focusNode.hasFocus) {
      _debounce = Timer(Duration(milliseconds: _delayTime), () {
        if (_controller.text != textSearched) {
          textSearched = _controller.text;
          widget.onSearch?.call(_controller.text);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              widget.label!,
              style: AppTextStyle.label(
                context,
                color:
                    widget.enabled ?? true ? null : Theme.of(context).hintColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        TextFormField(
          key: widget.customKey,
          readOnly: widget.readOnly ?? false,
          enabled: widget.enabled ?? true,
          focusNode: _focusNode,
          autofocus: widget.autoFocus,
          maxLength: widget.maxLength,
          controller: _controller,
          obscureText: _showObscureText,
          validator: widget.validator,
          onChanged: widget.onChanged,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.sentences,
          inputFormatters: widget.inputFormatters,
          textAlign: widget.textAlign,
          cursorColor: widget.cursorColor,
          style: AppTextStyle.field(
            context,
            color: widget.enabled ?? true
                ? widget.textColor
                : Theme.of(context).hintColor,
            overflow: TextOverflow.ellipsis,
          ),
          onFieldSubmitted: (String value) {
            FocusManager.instance.primaryFocus?.unfocus();
            widget.onSubmittedFunction?.call(value);
          },
          onTap: widget.onTap,
          decoration: InputDecoration(
            isDense: true,
            counterText: '',
            hintText: widget.hintText,
            filled: true,
            fillColor: AppColors.neutralGray,
            hintStyle: AppTextStyle.field(
              context,
              color: widget.hintColor ?? AppColors.neutralGray,
              overflow: TextOverflow.ellipsis,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: AppColors.neutralGray),
            ),
            enabledBorder: widget.enabledBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColors.neutralGray),
                ),
            focusedBorder: widget.focusedBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColors.neutral),
                ),
            disabledBorder: widget.disabledBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColors.neutral),
                ),
            errorStyle: AppTextStyle.footnote(
              context,
              color: AppColors.statusWarning,
            ),
            errorBorder: widget.errorBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColors.statusWarning),
                ),
            focusedErrorBorder: widget.focusedErrorBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: AppColors.statusWarning),
                ),
            prefixIcon: widget.prefixIcon,
            prefixIconConstraints: const BoxConstraints(),
            suffixIcon: widget.suffixIcon ??
                (widget.obscureText
                    ? IconButton(
                        focusNode: FocusNode(skipTraversal: true),
                        splashRadius: 15,
                        icon: Icon(
                          _showObscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: widget.textColor,
                        ),
                        onPressed: () => setState(
                          () => _showObscureText = !_showObscureText,
                        ),
                      )
                    : null),
            suffixIconConstraints: const BoxConstraints(),
          ),
          // onTapOutside: (_) {
          //   FocusManager.instance.primaryFocus?.unfocus();
          //   widget.onTapOutside?.call();
          // },
        ),
      ],
    );
  }
}
