import 'package:core/core.dart';
import 'package:dependency/dependency.dart';

class BaseButton extends StatelessWidget {
  final String? text;
  final Widget? icon;
  final void Function()? onPressed;
  final ButtonStyle buttonStyle;
  final Color? textColor;
  final bool expandWidth;
  final ButtonSize size;

  const BaseButton({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    required this.buttonStyle,
    this.textColor,
    this.expandWidth = false,
    this.size = ButtonSize.large,
  });

  TextSize get fontSize {
    switch (size) {
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
    return Container(
      height: size.height,
      constraints: const BoxConstraints(
        maxWidth: ResponsiveSizeHelper.maxWidth,
      ),
      child: TextButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Row(
          mainAxisSize: expandWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: icon == null
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            if (icon != null)
              Padding(padding: const EdgeInsets.only(right: 32), child: icon),
            Flexible(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ResponsiveSizeHelper.width(10),
                ),
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
            ),
          ],
        ),
      ),
    );
  }
}
