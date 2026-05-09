import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final AppTextStyle? style;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final int? maxLines;

  const TextWidget(
    this.text, {
    super.key,
    this.style,
    this.overflow,
    this.maxLines,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: ResponsiveSizeHelper.maxWidth,
      ),
      child: Text(
        text,
        key: key,
        style: style ?? AppTextStyle.message(context),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
