import 'dart:developer' as developer;

import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class CheckboxTitleWidget extends StatelessWidget {
  final Key? customKey;
  final bool initialValue;
  final String text;
  final ValueChanged<bool> onChanged;
  final Color? checkboxBorderColor;
  final Color? textColor;
  final AppTextStyle? textStyle;
  final MainAxisAlignment mainAxisAlignment;
  final bool fullWidget;

  const CheckboxTitleWidget({
    super.key,
    this.customKey,
    this.initialValue = false,
    required this.text,
    required this.onChanged,
    this.checkboxBorderColor,
    this.textColor,
    this.textStyle,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.fullWidget = true,
  });

  @override
  Widget build(BuildContext context) {
    developer.log('CheckBoxTitleWidget $text', name: 'Rebuild');
    return Container(
      constraints: const BoxConstraints(
        maxWidth: ResponsiveSizeHelper.maxWidth,
      ),
      child: Row(
        mainAxisSize: fullWidget ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          CheckboxWidget(
            key: customKey ?? const Key('checkbox_widget_key'),
            value: initialValue,
            onChanged: onChanged,
            borderColor: checkboxBorderColor,
          ),
          const SpacerWidget(),
          Flexible(child: TextWidget(text, style: textStyle)),
        ],
      ),
    );
  }
}
