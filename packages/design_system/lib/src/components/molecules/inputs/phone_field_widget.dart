// ignore_for_file: use_key_in_widget_constructors

import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class PhoneFieldWidget extends StatefulWidget {
  final String? label;

  final String? initialValue;
  final String? initialCountry;
  final String? searchText;
  final String? hintText;

  final bool enable;
  final TextInputType keyboardType;
  final TextAlign textAlign;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;

  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;

  final Color? hintColor;

  final InputBorder? disabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;

  const PhoneFieldWidget({
    super.key,
    this.label,
    this.initialValue,
    this.initialCountry,
    this.searchText,
    this.hintText,
    this.enable = true,
    this.keyboardType = TextInputType.phone,
    this.textAlign = TextAlign.left,
    this.controller,
    this.validator,
    this.inputFormatters,
    this.onChanged,
    this.onSaved,
    //
    this.hintColor,
    this.disabledBorder,
    this.focusedBorder,
    this.enabledBorder,
    this.errorBorder,
    this.focusedErrorBorder,
  });

  @override
  State<PhoneFieldWidget> createState() => _PhoneFieldWidgetState();
}

class _PhoneFieldWidgetState extends State<PhoneFieldWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  color: theme.inputDecorationTheme.labelStyle?.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          IntlPhoneField(
            // key: widget.keyName == null ? null : Key(widget.keyName!),
            enabled: widget.enable,
            keyboardType: widget.keyboardType,
            // maxLength: widget.maxLength,
            controller: widget.controller,
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            initialCountryCode: widget.initialCountry,
            initialValue: widget.initialValue,
            disableLengthCheck: true,
            showDropdownIcon: false,
            flagsButtonPadding: const EdgeInsets.only(left: 10),
            // searchText: widget.searchText ?? '',
            //dropdownTextStyle: fontField(context),
            //style: widget.fieldStyle ?? fontField(context),
            textAlign: widget.textAlign,
            textInputAction: TextInputAction.next,
            cursorColor: theme.tabBarTheme.indicatorColor,
            cursorHeight: kToolbarHeight * .3,
            languageCode: Get.locale?.toString() ?? 'en',
            style: AppTextStyle.field(
              context,
              color: theme.inputDecorationTheme.labelStyle?.color,
              overflow: TextOverflow.ellipsis,
            ),
            dropdownTextStyle: AppTextStyle.field(
              context,
              color: theme.tabBarTheme.indicatorColor,
              // color: widget.enabled ?? true
              //     ? widget.textColor
              //     : theme.hintColor,
              overflow: TextOverflow.ellipsis,
            ),
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              counterText: '',
              hintText: widget.hintText,
              fillColor: theme.canvasColor,
              hoverColor: theme.canvasColor,
              hintStyle: AppTextStyle.field(
                context,
                color:
                    widget.hintColor ??
                    theme.inputDecorationTheme.hintStyle?.color,
                overflow: TextOverflow.ellipsis,
              ),
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(5),
              //   borderSide: BorderSide(color: AppColors.neutralGray),
              // ),
              enabledBorder: widget.enabledBorder,
              focusedBorder: widget.focusedBorder,
              disabledBorder: widget.disabledBorder,
              errorBorder: widget.errorBorder,
              focusedErrorBorder: widget.focusedErrorBorder,
            ),
            onChanged: (phone) {
              widget.onChanged?.call(
                _formatNumber(phone.number, phone.countryCode),
              );
            },
            validator: (phone) {
              // if (phone?.number == null) {
              //   return "${widget.labelText ?? widget.hintText} ${'not_empty'.tr}";
              // }
              return widget.validator?.call(phone?.number);
            },
            onSaved: (phone) {
              widget.onSaved?.call(
                _formatNumber(phone?.number, phone?.countryCode),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatNumber(String? number, String? countryCode) {
    return (number?.trim().isEmpty ?? true) ||
            (countryCode?.trim().isEmpty ?? true)
        ? ''
        : '$countryCode $number';
  }
}
