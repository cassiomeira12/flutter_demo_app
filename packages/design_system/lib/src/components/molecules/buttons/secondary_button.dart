import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

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

  TextSize get fontSize {
    switch (size) {
      case ButtonSize.large:
        return TextSize.font_12;
      case ButtonSize.medium:
        return TextSize.font_10;
      case ButtonSize.small:
        return TextSize.font_8;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor =
        this.textColor ??
        theme.outlinedButtonTheme.style?.textStyle?.resolve({
          WidgetState.selected,
        })?.color;
    // final iconColor = theme.outlinedButtonTheme.style?.textStyle?.resolve({
    //   WidgetState.selected,
    // })?.color;

    return Container(
      height: size.height,
      constraints: const BoxConstraints(
        maxWidth: ResponsiveSizeHelper.maxWidth,
      ),
      child: TextButton(
        onPressed: onPressed == null
            ? null
            : () {
                onPressed!.call();
                HapticFeedback.lightImpact();
              },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            backgroundColor ?? theme.highlightColor,
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                color: AppColorScheme.of(
                  context,
                ).textColor.withAlpha((255 * .20).toInt()),
                style: onPressed == null ? BorderStyle.none : BorderStyle.solid,
                // strokeAlign: BorderSide.strokeAlignCenter,
              ),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: expandWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: icon == null
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            if (icon != null)
              Padding(padding: const EdgeInsets.only(right: 32), child: icon),
            Flexible(
              child: TextWidget(
                text ?? '',
                maxLines: 2,
                overflow: TextOverflow.fade,
                style: AppTextStyle.button(
                  context,
                  fontSize: fontSize,
                  color: onPressed == null
                      ? textColor?.withAlpha((255 * .50).toInt())
                      : textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
