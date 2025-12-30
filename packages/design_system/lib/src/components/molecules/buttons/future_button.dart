import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class FutureButton extends StatefulWidget {
  final String text;
  final Future<bool> Function()? onValidation;
  final Future<void> Function()? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool expandWidth;
  final ButtonSize size;

  const FutureButton({
    super.key,
    required this.text,
    this.onValidation,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.expandWidth = false,
    this.size = ButtonSize.large,
  });

  @override
  State<FutureButton> createState() => _FutureButtonState();
}

class _FutureButtonState extends State<FutureButton> {
  bool loading = false;

  TextSize get fontSize {
    switch (widget.size) {
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
        widget.backgroundColor ??
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
      height: widget.size.height,
      constraints: const BoxConstraints(
        maxWidth: ResponsiveSizeHelper.maxWidth,
      ),
      child: TextButton(
        onPressed: widget.onPressed != null
            ? () async {
                if (widget.onValidation != null) {
                  final bool validated = await widget.onValidation!.call();
                  if (!validated || !mounted) return;
                }
                if (!loading) {
                  setState(() => loading = true);
                  try {
                    HapticFeedback.mediumImpact();
                    await widget.onPressed?.call();
                  } finally {
                    if (mounted) {
                      setState(() => loading = false);
                    }
                  }
                }
              }
            : null,
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.all(
            AppColorScheme.of(
              context,
            ).scaffoldBackgroundInverter.withAlpha((255 * .25).toInt()),
          ),
          backgroundColor: WidgetStateProperty.all(
            widget.onPressed == null
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
          mainAxisSize: widget.expandWidth
              ? MainAxisSize.max
              : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: CircularLoadingWidget(
                    color: theme.textTheme.labelLarge?.color,
                  ),
                ),
              )
            else
              Flexible(
                child: TextWidget(
                  widget.text,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  style: AppTextStyle.button(
                    context,
                    fontSize: fontSize,
                    color: widget.onPressed == null
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
