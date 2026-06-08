import 'dart:developer' as developer;

import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/src/components/molecules/buttons/base_button.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Color? textColor;
  final Color? backgroundColor;
  final bool expandWidth;
  final ButtonSize size;

  const PrimaryButton({
    super.key,
    this.text,
    this.textColor,
    this.icon,
    this.onPressed,
    this.backgroundColor,
    this.expandWidth = false,
    this.size = ButtonSize.large,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor =
        this.backgroundColor ??
        theme.textButtonTheme.style?.backgroundColor?.resolve({
          WidgetState.selected,
        });
    final textColor =
        this.textColor ??
        theme.textButtonTheme.style?.textStyle?.resolve({
          WidgetState.selected,
        })?.color;
    developer.log('PrimaryButton $text', name: 'Rebuild');
    return BaseButton(
      text: text,
      icon: icon,
      onPressed: onPressed == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              onPressed?.call();
            },
      buttonStyle: ButtonStyle(
        overlayColor: WidgetStateProperty.all(
          AppColorScheme.of(
            context,
          ).scaffoldBackgroundInverter.withAlpha((255 * .25).toInt()),
        ),
        backgroundColor: WidgetStateProperty.all(
          onPressed == null
              ? backgroundColor?.withAlpha((255 * .50).toInt())
              : backgroundColor,
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(
              color: AppColors.transparent,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
        ),
      ),
      textColor: textColor,
      expandWidth: expandWidth,
      size: size,
    );
  }
}
