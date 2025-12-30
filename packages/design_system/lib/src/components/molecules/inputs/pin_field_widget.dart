import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class PinFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final int pinLength;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onCompleted;
  final bool autofocus;
  final FocusNode? focusNode;

  const PinFieldWidget({
    super.key,
    this.controller,
    required this.pinLength,
    this.validator,
    this.onCompleted,
    this.autofocus = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Pinput(
      controller: controller,
      length: pinLength,
      autofocus: autofocus,
      focusNode: focusNode,
      defaultPinTheme: PinTheme(
        width: ResponsiveSizeHelper.width(50),
        height: ResponsiveSizeHelper.width(50),
        textStyle: AppTextStyle.field(
          context,
          fontSize: TextSize.font_16,
          color: theme.tabBarTheme.indicatorColor,
          overflow: TextOverflow.ellipsis,
        ),
        decoration: BoxDecoration(
          color: theme.canvasColor,
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      focusedPinTheme: PinTheme(
        width: 56,
        height: 56,
        textStyle: AppTextStyle.field(
          context,
          fontSize: TextSize.font_16,
          color: theme.tabBarTheme.indicatorColor,
          overflow: TextOverflow.ellipsis,
        ),
        decoration: BoxDecoration(
          color: theme.canvasColor,
          border: Border.all(color: theme.cardColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      errorTextStyle: AppTextStyle.label(
        context,
        color: AppColors.statusWarning,
      ),
      validator: validator,
      onCompleted: onCompleted,
    );
  }
}
