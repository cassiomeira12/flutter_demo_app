import 'package:flutter/material.dart';

import '../colors/app_color.dart';
import 'text_style.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final AppTextStyle? style;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final int maxLines;

  /// Creates a Design System's [Text].
  const TextWidget(
    this.text, {
    super.key,
    this.style,
    AppColor? color,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.left,
    this.maxLines = 1,
  });

  // : style = style != null
  //           ? style.copyWith(color: color ?? DSColors.neutralBlack)
  //           : DSTextStyle.body1,
  //       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      key: key,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
