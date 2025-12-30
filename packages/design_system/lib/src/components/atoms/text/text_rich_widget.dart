import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class TextRichWidget extends StatelessWidget {
  final String? text;
  final AppTextStyle? style;
  final void Function()? onTap;
  final List<TextRichWidget>? children;

  const TextRichWidget({
    super.key,
    this.text,
    this.style,
    this.onTap,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      key: key,
      TextSpan(
        text: text,
        style: style ?? AppTextStyle.message(context),
        children: children?.map((item) {
          return TextSpan(
            text: item.text,
            style: item.style ?? AppTextStyle.message(context),
            mouseCursor: item.onTap == null ? null : SystemMouseCursors.click,
            recognizer: item.onTap == null ? null : TapGestureRecognizer()
              ?..onTap = item.onTap,
          );
        }).toList(),
        recognizer: onTap == null ? null : TapGestureRecognizer()
          ?..onTap = onTap,
      ),
    );
  }
}
