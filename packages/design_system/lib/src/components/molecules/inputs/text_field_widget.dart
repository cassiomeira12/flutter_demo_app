// ignore_for_file: must_be_immutable

import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class TextFieldWidget extends StatefulWidget {
  final Key? customKey;
  final String? label;
  final AppTextStyle? labelStyle;
  final bool enabled;
  final bool readOnly;
  final String? hintText;
  final bool autoFocus;
  final TextEditingController? controller;
  final bool obscureText;
  final bool enableClearTextSuffixIcon;
  final TextInputAction textInputAction;
  TextInputType? keyboardType;
  final TextAlign textAlign;
  TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final AppTextStyle? textStyle;
  final Color? textColor;
  final double? textSize;
  final AppTextStyle? hintTextStyle;
  final Color? hintColor;
  final Widget? suffixIcon;
  final Color? cursorColor;
  final Widget? prefixIcon;
  final ValueChanged<String>? onSubmittedFunction;
  final FocusNode? focusNode;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapOutside;
  final int? maxLength;
  final int maxLines;
  final ValueChanged<String>? onSearch;
  final FormFieldSetter<String>? onSaved;
  final List<String> Function(AutofillHints?)? autofillHints;

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
    this.enabled = true,
    this.readOnly = false,
    this.hintText,
    this.autoFocus = false,
    this.controller,
    this.obscureText = false,
    this.enableClearTextSuffixIcon = false,
    this.textInputAction = TextInputAction.next,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.textCapitalization,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.textStyle,
    this.textColor,
    this.textSize,
    this.hintTextStyle,
    this.hintColor,
    this.suffixIcon,
    this.cursorColor,
    this.prefixIcon,
    this.onSubmittedFunction,
    this.focusNode,
    this.onTap,
    this.onTapOutside,
    this.maxLength,
    this.maxLines = 1,
    this.disabledBorder,
    this.focusedBorder,
    this.enabledBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.onSearch,
    this.onSaved,
    this.autofillHints,
  }) {
    keyboardType ??= TextInputType.text;
    switch (keyboardType) {
      case TextInputType.name:
      case TextInputType.streetAddress:
        keyboardType = TextInputType.text;
        textCapitalization = TextCapitalization.words;
      case TextInputType.url:
      case TextInputType.emailAddress:
        textCapitalization = TextCapitalization.none;
      case TextInputType.multiline:
        textCapitalization = TextCapitalization.sentences;
      default:
    }
    if (obscureText) {
      textCapitalization ??= TextCapitalization.none;
      keyboardType = TextInputType.visiblePassword;
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

  late bool _hasInputText;

  @override
  void initState() {
    super.initState();
    _showObscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_focusListener);
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onSearchChanged);
    _hasInputText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_focusListener);
    _controller.removeListener(_onSearchChanged);
    _focusNode.dispose();
    // _controller.dispose();
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
    if (_hasInputText != _controller.text.isNotEmpty) {
      setState(() => _hasInputText = _controller.text.isNotEmpty);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelColor = theme.inputDecorationTheme.labelStyle?.color;
    final textColor = theme.inputDecorationTheme.labelStyle?.color;
    final hintColor =
        widget.hintColor ?? theme.inputDecorationTheme.hintStyle?.color;
    final iconColor = theme.inputDecorationTheme.suffixIconColor;
    return Container(
      constraints: const BoxConstraints(
        maxWidth: ResponsiveSizeHelper.maxWidth,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: TextWidget(
                widget.label!,
                style: AppTextStyle.label(
                  context,
                  color: widget.enabled
                      ? labelColor
                      : labelColor?.withAlpha((255 * .40).toInt()),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          TextFormField(
            key: widget.customKey,
            readOnly: widget.readOnly,
            enabled: widget.enabled,
            focusNode: _focusNode,
            autofocus: widget.autoFocus,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
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
            cursorColor:
                widget.cursorColor ??
                theme.inputDecorationTheme.labelStyle?.color,
            cursorHeight: kToolbarHeight * .3,
            autofillHints: widget.autofillHints?.call(null),
            style: AppTextStyle.field(
              context,
              color: widget.enabled
                  ? textColor
                  : textColor?.withAlpha((255 * .40).toInt()),
              overflow: TextOverflow.ellipsis,
            ),
            onFieldSubmitted: (String value) {
              if (widget.onSubmittedFunction != null) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
              widget.onSubmittedFunction?.call(value);
            },
            onSaved: widget.onSaved,
            onTap: widget.onTap,
            decoration: InputDecoration(
              counterText: '',
              hintText: widget.hintText,
              hintStyle: AppTextStyle.field(
                context,
                color: widget.enabled
                    ? hintColor
                    : hintColor?.withAlpha((255 * .40).toInt()),
                overflow: TextOverflow.ellipsis,
              ),
              enabledBorder: widget.enabledBorder,
              focusedBorder: widget.focusedBorder,
              disabledBorder: widget.disabledBorder,
              errorBorder: widget.errorBorder,
              focusedErrorBorder: widget.focusedErrorBorder,
              prefixIcon: widget.prefixIcon,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.suffixIcon != null) widget.suffixIcon!,
                  if (widget.readOnly != true &&
                      widget.enableClearTextSuffixIcon &&
                      _hasInputText)
                    IconButtonWidget(
                      key: const Key('clear_input_text_key'),
                      splashRadius: 15,
                      focusNode: FocusNode(skipTraversal: true),
                      icon: FlutterIcon(
                        Icons.clear,
                        color: widget.enabled
                            ? iconColor
                            : iconColor?.withAlpha((255 * .40).toInt()),
                      ),
                      onPressed: () {
                        _controller.clear();
                        _focusNode.requestFocus();
                      },
                    ),
                  if (widget.obscureText)
                    IconButtonWidget(
                      key: _showObscureText
                          ? const Key('password_visibility_off_key')
                          : const Key('password_visibility_on_key'),
                      splashRadius: 15,
                      focusNode: FocusNode(skipTraversal: true),
                      icon: FlutterIcon(
                        _showObscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: widget.enabled
                            ? iconColor
                            : iconColor?.withAlpha((255 * .40).toInt()),
                      ),
                      onPressed: () {
                        setState(() => _showObscureText = !_showObscureText);
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
