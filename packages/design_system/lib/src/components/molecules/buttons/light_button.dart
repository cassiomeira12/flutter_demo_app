import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class LightButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppTextStyle? textStyle;

  const LightButton({
    super.key,
    required this.text,
    this.onPressed,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color;

    return Container(
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
          backgroundColor: WidgetStateProperty.all(AppColors.transparent),
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
        child: TextWidget(
          text,
          style:
              textStyle ??
              AppTextStyle.button(
                context,
                color: onPressed == null
                    ? textColor?.withAlpha((255 * .50).toInt())
                    : textColor,
              ),
        ),
      ),
    );
  }
}
