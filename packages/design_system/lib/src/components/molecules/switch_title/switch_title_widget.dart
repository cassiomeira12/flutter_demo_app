import 'dart:developer' as developer;

import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class SwitchTitleWidget extends StatelessWidget {
  final bool initialValue;
  final String text;
  final ValueChanged<bool> onChanged;
  final Color? checkboxBorderColor;
  final Color? textColor;
  final AppTextStyle? textStyle;
  final MainAxisAlignment mainAxisAlignment;

  const SwitchTitleWidget({
    super.key,
    this.initialValue = false,
    required this.text,
    required this.onChanged,
    this.checkboxBorderColor,
    this.textColor,
    this.textStyle,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  });

  @override
  Widget build(BuildContext context) {
    developer.log('SwitchTitleWidget $text', name: 'Rebuild');
    return Container(
      constraints: const BoxConstraints(
        maxWidth: ResponsiveSizeHelper.maxWidth,
      ),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Flexible(child: TextWidget(text, style: textStyle)),
          SwitchWidget(
            key: const Key('switch_widget_key'),
            value: initialValue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
