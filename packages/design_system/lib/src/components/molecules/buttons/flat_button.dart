import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class FlatButton extends StatelessWidget {
  final String? text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Color? textColor;
  final Color? color;
  final bool expandWidth;
  final ButtonSize size;

  const FlatButton({
    super.key,
    this.text,
    this.textColor,
    this.icon,
    this.onPressed,
    this.color,
    this.expandWidth = false,
    this.size = ButtonSize.large,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      constraints: const BoxConstraints(
        maxWidth: ResponsiveSizeHelper.maxWidth,
      ),
      child: ElevatedButton(
        onPressed: onPressed == null
            ? null
            : () {
                onPressed!.call();
                HapticFeedback.lightImpact();
              },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            color ??
                Theme.of(context).appBarTheme.backgroundColor ??
                Theme.of(context).primaryColor,
          ),
          elevation: WidgetStateProperty.all<double?>(1),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(),
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
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ResponsiveSizeHelper.width(10),
                ),
                child: TextWidget(
                  text ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  style: AppTextStyle.button(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
