import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Color? textColor;
  // TODO trocar para backgroundColor
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
    final buttonBackgroundColor =
        backgroundColor ??
        theme.textButtonTheme.style?.backgroundColor?.resolve({
          WidgetState.selected,
        });
    // final buttonDisabledBackgroundColor = theme
    //     .textButtonTheme
    //     .style
    //     ?.backgroundColor
    //     ?.resolve({WidgetState.disabled});
    final textColor = theme.textButtonTheme.style?.textStyle?.resolve({
      WidgetState.selected,
    })?.color;

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
          overlayColor: WidgetStateProperty.all(
            AppColorScheme.of(
              context,
            ).scaffoldBackgroundInverter.withAlpha((255 * .25).toInt()),
          ),
          backgroundColor: WidgetStateProperty.all(
            onPressed == null
                ? buttonBackgroundColor?.withAlpha((255 * .50).toInt())
                : buttonBackgroundColor,
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
