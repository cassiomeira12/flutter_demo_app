import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/src/components/molecules/buttons/base_button.dart';

class SecondaryButton extends StatelessWidget {
  final String? text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool expandWidth;
  final ButtonSize size;

  const SecondaryButton({
    super.key,
    this.text,
    this.onPressed,
    this.borderColor,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.expandWidth = false,
    this.size = ButtonSize.large,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = this.backgroundColor ?? theme.highlightColor;
    final textColor =
        this.textColor ??
        theme.outlinedButtonTheme.style?.textStyle?.resolve({
          WidgetState.selected,
        })?.color;

    return BaseButton(
      text: text,
      icon: icon,
      onPressed: onPressed == null
          ? null
          : () {
              onPressed?.call();
              HapticFeedback.lightImpact();
            },
      buttonStyle: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          onPressed == null
              ? backgroundColor.withAlpha((255 * .50).toInt())
              : backgroundColor,
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              color: AppColorScheme.of(
                context,
              ).textColor.withAlpha((255 * .20).toInt()),
              style: onPressed == null ? BorderStyle.none : BorderStyle.solid,
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
