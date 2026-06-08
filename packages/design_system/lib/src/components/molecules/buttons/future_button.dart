import 'dart:developer' as developer;

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
  final loading = ValueNotifier<bool>(false);

  TextSize get fontSize {
    switch (widget.size) {
      case ButtonSize.large:
        return TextSize.font_14;
      case ButtonSize.medium:
        return TextSize.font_12;
      case ButtonSize.small:
        return TextSize.font_10;
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
    final textColor =
        widget.textColor ??
        theme.textButtonTheme.style?.textStyle?.resolve({
          WidgetState.selected,
        })?.color;
    developer.log('FutureButton ${widget.text}', name: 'Rebuild');
    return Container(
      height: widget.size.height,
      constraints: const BoxConstraints(
        maxWidth: ResponsiveSizeHelper.maxWidth,
      ),
      child: TextButton(
        onPressed: widget.onPressed != null
            ? () async {
                if (widget.onValidation != null) {
                  HapticFeedback.lightImpact();
                  final bool validated = await widget.onValidation!.call();
                  if (!validated || !mounted) return;
                }
                if (!loading.value) {
                  loading.value = true;
                  try {
                    HapticFeedback.lightImpact();
                    await widget.onPressed?.call();
                  } finally {
                    if (mounted) {
                      loading.value = false;
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
            ValueListenableBuilder(
              valueListenable: loading,
              builder: (context, value, child) {
                if (value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: CircularLoadingWidget(
                        color: theme.textTheme.labelLarge?.color,
                      ),
                    ),
                  );
                }
                return child!;
              },
              child: Flexible(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: ResponsiveSizeHelper.width(10),
                  ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
